#include "common.h"

#include <iostream>
#include <sycl/sycl.hpp>

using namespace sycl;

class DGEMM_MatMulBlocked
{
protected:    
  
  BenchmarkArgs args;
  std::vector<double> initA;
  std::vector<double> initB;
  std::vector<double> initC;
  
  PrefetchedBuffer<double, 2> initA_buf;
  PrefetchedBuffer<double, 2> initB_buf;
  PrefetchedBuffer<double, 2> initC_buf;

  static constexpr size_t problem_size = 256;
  static constexpr size_t Ndim = 256;
  static constexpr size_t Mdim = 256;
  static constexpr size_t Pdim = 256;
  static constexpr size_t Bsize = 16;

public:
  DGEMM_MatMulBlocked(const BenchmarkArgs &_args) : args(_args) {}
  
  std::string HCF_FILE = "dgemm_matmul_blocked.hcf";
  hipsycl::common::kernelinfo::KernelInfo info_{HCF_FILE, "DGEMM_MatMulBlocked"}; 

  void setup() {
    // host memory intilization
    initA.resize(Ndim * Pdim);
    initB.resize(Pdim * Mdim);
    initC.resize(Ndim * Mdim);

    // Initialize matrix A to the identity
    for(size_t i = 0; i < Ndim; ++i) {
      for(size_t j = 0; j < Pdim; ++j) {
        initA[i * Pdim + j] = i == j;
          }
    }
      // Initialize matrix B to the identity
    for(size_t i = 0; i < Pdim; ++i) {
      for(size_t j = 0; j < Mdim; ++j) {
              initB[i * Mdim + j] = i == j;
          }
    }
      // Initialize matrix C to the zero
    for(size_t i = 0; i < Ndim; ++i) {
      for(size_t j = 0; j < Mdim; ++j) {
              initC[i * Mdim + j] = 0;
          }
    }

    initA_buf.initialize(args.device_queue, initA.data(), range<2>(Ndim, Pdim));
    initB_buf.initialize(args.device_queue, initB.data(), range<2>(Pdim, Mdim));
    initC_buf.initialize(args.device_queue, initC.data(), range<2>(Ndim, Mdim));
  }

  void run(std::vector<event>& events) {
    events.push_back(args.device_queue.submit(
        [&](handler& cgh) {
          
      auto in1 = initA_buf.template get_access<access::mode::read>(cgh);
      auto in2 = initB_buf.template get_access<access::mode::read>(cgh);
      auto out = initC_buf.template get_access<access::mode::read_write>(cgh);

      // Use local memory address space for local memory
      accessor<double, 2, access_mode::read_write, access::target::local> Awrk({Bsize, Bsize}, cgh);
      accessor<double, 2, access_mode::read_write, access::target::local> Bwrk({Bsize, Bsize}, cgh);

      if(kernel_type_thorin){

        cgh.enqueue_parallel_object_kernel<class Thorin_Matmul_blocked_kernel>(
                  nd_range<2>{{Ndim, Mdim}, {Bsize, Bsize}},
                  info_, 
                  [Awrk, in1, Bwrk, in2, out](nd_item<2> idx) { });

      } else {

        cgh.parallel_for<class SYCL_Matmul_blocked_kernel>(
                  nd_range<2>{{Ndim, Mdim}, {Bsize, Bsize}}, 
                  [=](nd_item<2> idx) {
                // This work-item will compute C(i,j)
                const size_t i = idx.get_global_id(0);
                const size_t j = idx.get_global_id(1);

                // Element C(i,j) is in block C(Iblk, Jblk)
                const size_t Iblk = idx.get_group(0);
                const size_t Jblk = idx.get_group(1);

                // C(i,j) is element C(iloc, jloc) of block C(Iblk, Jblk)
                const size_t iloc = idx.get_local_id(0);
                const size_t jloc = idx.get_local_id(1);

                // Number of blocks
                const size_t Nblk = Ndim / Bsize;
                const size_t Mblk = Mdim / Bsize;
                const size_t Pblk = Pdim / Bsize;
                // size_t Kblk = 3;

                for (size_t Kblk = 0; Kblk < Pblk; ++Kblk) {
                    // Copy A and B into local memory
                    Awrk[iloc][jloc] = in1[Iblk * Bsize + iloc][Kblk * Bsize + jloc];
                    Bwrk[iloc][jloc] = in2[Kblk * Bsize + iloc][Jblk * Bsize + jloc];

                    // Compute matmul for block
                     for (size_t kloc = 0; kloc < Bsize; ++kloc) {
                         out[i][j] += Awrk[iloc][kloc] * Bwrk[kloc][jloc];
                     }
                }
            });        
      }
    }));

  }

  bool verify(VerificationSetting &ver) {
    //Triggers writeback
    initC_buf.reset();
    bool pass = true;
 
    for (size_t i = 0; i < problem_size; ++i) {
        for (size_t j = 0; j < problem_size; ++j) {
            auto kernel_value = initC[i * Mdim + j];
            auto host_value = (i == j) ? 1.0 : 0.0;

            if (kernel_value != host_value) {
                pass = false;
                break;
            }
        }
    }    
    return pass;
  }
  
  static std::string getBenchmarkName() {
    std::stringstream name;
    if(kernel_type_thorin)
      name << "Thorin_DGEMM_MatMulBlocked_";
    else
      name << "DGEMM_MatMulBlocked_";    
    return name.str();
  }
};

int main(int argc, char** argv)
{
  BenchmarkApp app(argc, argv);
  app.run<DGEMM_MatMulBlocked>();

  return 0;
}
