#include <memory>
#include <string>
#include <fstream>
#include <random>
#include <iostream>
#include <cstddef>

#include <llvm/Bitcode/BitcodeWriter.h>
#include <llvm/IRReader/IRReader.h>
#include <llvm/Support/SourceMgr.h>

#include <sycl/sycl.hpp>
#include "hipSYCL/compiler/sscp/TargetSeparationPass.hpp"
#include "hipSYCL/compiler/sscp/IRConstantReplacer.hpp"
#include "hipSYCL/compiler/sscp/KernelOutliningPass.hpp"
#include "hipSYCL/compiler/sscp/HostKernelNameExtractionPass.hpp"
#include "hipSYCL/compiler/sscp/AggregateArgumentExpansionPass.hpp"
#include "hipSYCL/compiler/CompilationState.hpp"
#include "hipSYCL/common/hcf_container.hpp"

using namespace sycl;
using namespace llvm;

template<class IntT>
IntT generateRandomNumber() {
  static std::mutex M;
  static std::random_device Dev;
  static std::mt19937 Rng{Dev()};
  static std::uniform_int_distribution<IntT> dist;

  std::lock_guard<std::mutex> lock {M};
  return dist(Rng);
}

std::string createHCF(std::size_t HcfObjectId,
                      const std::vector<std::string>& ExportedSymbols,
                      const std::vector<std::string>& ImportedSymbols,
                      std::string IRFilePath) {
                          
  llvm::LLVMContext CTX;
  SMDiagnostic Err;

  llvm::ErrorOr<std::unique_ptr<llvm::Module>> ModuleOrErr = llvm::parseIRFile(IRFilePath, Err, CTX);
  if (auto Err = ModuleOrErr.getError()) {
      std::cerr << "Failed to parse IR file: " << IRFilePath << "\n";
      return "Problem with IR code";
  }
  
  llvm::Module& DeviceModule = *ModuleOrErr.get();
  
  hipsycl::common::hcf_container HcfObject;

  HcfObject.root_node()->set("object-id", std::to_string(HcfObjectId));
  HcfObject.root_node()->set("generator", "hipSYCL SSCP");

  auto *DeviceImagesNodes = HcfObject.root_node()->add_subnode("images");
  auto* LLVMIRNode = DeviceImagesNodes->add_subnode("llvm-ir.global");
  LLVMIRNode->set("variant", "global-module");
  LLVMIRNode->set("format", "llvm-ir");

  std::string ModuleContent;
  llvm::raw_string_ostream OutputStream{ModuleContent};
  llvm::WriteBitcodeToFile(DeviceModule, OutputStream);
  HcfObject.attach_binary_content(LLVMIRNode, ModuleContent);

  for(const auto& ES : ExportedSymbols) {
    HIPSYCL_DEBUG_INFO << "HCF generation: Image exports symbol: " << ES << "\n";
  }
  for(const auto& IS : ImportedSymbols) {
    HIPSYCL_DEBUG_INFO << "HCF generation: Image imports symbol: " << IS << "\n";
  }
  
  LLVMIRNode->set_as_list("exported-symbols", ExportedSymbols);
  LLVMIRNode->set_as_list("imported-symbols", ImportedSymbols);
  auto* KernelsNode = HcfObject.root_node()->add_subnode("kernels");

  for (llvm::Module::iterator func = DeviceModule.begin(), e = DeviceModule.end(); func != e; ++func) {
    
    std::string funcName = func->getName().str();
    Function* F = &*func;
  
    // Extract the input parameters
    std::vector<Type*> paramTypes = F->getFunctionType()->params();

    auto* K = KernelsNode->add_subnode(funcName);
    K->set_as_list("image-providers", {std::string{"llvm-ir.global"}});
    auto* ParamsNode = K->add_subnode("parameters");
    
    const DataLayout& DL = DeviceModule.getDataLayout();

    for(std::size_t i = 0; i < paramTypes.size(); ++i) {
      auto* P = ParamsNode->add_subnode(std::to_string(i));
      Type* argType = paramTypes[i];

      // Get the bit size of the parameter type
      auto BitSize = DL.getTypeSizeInBits(argType);
      assert(BitSize % CHAR_BIT == 0);
      // Calculate the byte size
      auto ByteSize = BitSize / CHAR_BIT;
      P->set("byte-offset", std::to_string(ByteSize*i));
      P->set("byte-size", std::to_string(ByteSize));
      P->set("original-index", std::to_string(0));

      std::string TypeDescription;
      if (argType->isIntegerTy()) {
        TypeDescription = "integer";
      } else if (argType->isFloatingPointTy()) {
        TypeDescription = "floating-point";
      } else if (argType->isPointerTy()) {
        if(F->hasParamAttribute(i, llvm::Attribute::ByVal)) {
          TypeDescription = "other-by-value";
        } else {
          TypeDescription = "pointer";
        }
      } else {
        TypeDescription = "other-by-value";
      }

      P->set("type", TypeDescription);
    }
  }      
  return HcfObject.serialize();
}

int main(int argc, char* argv[]) {
    if(argc < 2) {
        std::cout << "Usage: " << argv[0] << " <LLVM IR file>" << std::endl;
        return 1;
    }

    std::string IRFilePath = argv[1];
    // Check if the provided IR file path has the .ll extension
    if(IRFilePath.size() > 3 && IRFilePath.substr(IRFilePath.size() - 3) == ".ll") {
        // Create the output filename by replacing ".ll" with ".hcf"
        std::string Filename = IRFilePath.substr(0, IRFilePath.size() - 3) + ".hcf";

        size_t HcfObjectId = generateRandomNumber<size_t>();
        std::vector<std::string> ExportedSymbols, ImportedSymbols;

        std::string HcfString = createHCF(HcfObjectId, ExportedSymbols, ImportedSymbols, IRFilePath);
        std::ofstream OutputFile(Filename, std::ios::trunc | std::ios::binary);

        if (OutputFile.is_open()) {
            OutputFile.write(HcfString.c_str(), HcfString.size());
            OutputFile.close();
            std::cout << "Output written to: " << Filename << std::endl;
        } else {
            std::cerr << "Failed to open file for writing: " << Filename << std::endl;
            return 2;
        }
    } else {
        std::cerr << "The file " << IRFilePath << " does not have a .ll extension." << std::endl;
        return 3;
    }

    return 0;
}