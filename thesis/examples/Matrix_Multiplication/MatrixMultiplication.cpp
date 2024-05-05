#include "common.h"

#include <iostream>
#include <sycl/sycl.hpp>

using namespace sycl;

template <typename T> class MatMulKernel;

template <typename T, const char* KernelName>
class VecMulBench
{
protected:    
  std::vector<T> input1;
  std::vector<T> input2;
  std::vector<T> output;
  BenchmarkArgs args;

  PrefetchedBuffer<T, 2> input1_buf;
  PrefetchedBuffer<T, 2> input2_buf;
  PrefetchedBuffer<T, 2> output_buf;

public:
  VecMulBench(const BenchmarkArgs &_args) : args(_args) {}
  
  std::string HCF_FILE = "matmul.hcf";
  std::string KERNEL_NAME = KernelName;  
  
  void setup() {
    // host memory intilization
    input1.resize(256 * 256);
    input2.resize(256 * 256);
    output.resize(256 * 256);

    for (size_t i =0; i < 256; i++) {
        for (size_t j =0; j < 256; j++) {
            input1[i * 256 + j] = static_cast<T>(i);
            input2[i * 256 + j] = static_cast<T>(i);
            output[i * 256 + j] = static_cast<T>(0);
        }
    }

    input1_buf.initialize(args.device_queue, input1.data(), range<2>(256, 256));
    input2_buf.initialize(args.device_queue, input2.data(), range<2>(256, 256));
    output_buf.initialize(args.device_queue, output.data(), range<2>(256, 256));
  }

  void run(std::vector<event>& events) {
    events.push_back(args.device_queue.submit(
        [&](handler& cgh) {
          
      auto in1 = input1_buf.template get_access<access::mode::read>(cgh);
      auto in2 = input2_buf.template get_access<access::mode::read>(cgh);
      auto out = output_buf.template get_access<access::mode::read_write>(cgh);

      range<1> ndrange {256};

      hipsycl::common::kernelinfo::KernelInfo info_{HCF_FILE, KERNEL_NAME};
      size_t local_size = 16;
      size_t global_size = 256;

      if(kernel_type_thorin){

        cgh.enqueue_parallel_object_kernel<class MatMulKernel<T>>(
                nd_range<2>{
                range<2>(global_size, global_size), range<2>(local_size, local_size)}, 
                info_, 
                [global_size, in1, in2, out](nd_item<2> item) { });

      } else {

        cgh.parallel_for<class MatMulKernel<T>>(nd_range<2>{
                range<2>(global_size, global_size), range<2>(local_size, local_size)}, 
                [=](nd_item<2> item) {
                    
                    auto sum = 0;
                    const size_t i = item.get_global_id(0);
                    const size_t j = item.get_global_id(1);
                
                    for(size_t k = 0; k < global_size; ++k) {
                        const auto a_ik = in1[{i, k}];
                        const auto b_kj = in2[{k, j}];
                        sum += a_ik * b_kj;
                    }
                    out[{i, j}] = sum;
            });
      }
      
      
    }));

  }

  bool verify(VerificationSetting &ver) {
    //Triggers writeback
    output_buf.reset();

    bool pass = true;
    for(size_t i=ver.begin[0]; i<ver.begin[0]+ver.range[0]; i++){
        auto expected = input1[i] * input2[i];
        if(expected != output[i]){
            pass = false;
            break;
        }
      }    
    return pass;
  }
  
  static std::string getBenchmarkName() {
    std::stringstream name;
    if(kernel_type_thorin)
      name << "Thorin_MatrixMultiplication_";
    else
      name << "MatrixMultiplication_";
    name << ReadableTypename<T>::name;
    return name.str();
  }
};

int main(int argc, char** argv)
{
  BenchmarkApp app(argc, argv);
  static const char mat_mul_int[] = "MatMul_int";
  static const char mat_add_long_long[] = "MatMul_long_long";
  static const char mat_add_float[] = "MatMul_float";
  static const char mat_add_double[] = "MatMul_double";

  app.run<VecMulBench<int, mat_mul_int>>();
  app.run<VecMulBench<long long, mat_add_long_long>>();  
  app.run<VecMulBench<float, mat_add_float>>();
  app.run<VecMulBench<double, mat_add_double>>();
  return 0;
}
