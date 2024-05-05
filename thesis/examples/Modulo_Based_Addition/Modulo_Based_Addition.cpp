#include "common.h"

#include <iostream>
#include <sycl/sycl.hpp>

using namespace sycl;

#if defined(SYCL_BENCH_ENABLE_PROFILING_THORIN)
  std::vector<double> resultsSeconds;
#endif

template <typename T>
class Modulo_Addition
{
protected:    
  std::vector<T> host_buf;
  std::vector<T> check_buf;
  BenchmarkArgs args;

  PrefetchedBuffer<T, 1> buf;

  size_t local_size = 256;
  size_t global_size = 1024;

public:
  Modulo_Addition(const BenchmarkArgs &_args) : args(_args) {}
  
  std::string HCF_FILE = "modulo_based_addition.hcf";
  hipsycl::common::kernelinfo::KernelInfo info_{HCF_FILE, "Modulo_Based_Addition"}; 

  void setup() {
    // host memory intilization
    for(size_t i = 0; i < global_size; ++i)
    {
      host_buf.push_back(static_cast<int>(i));
    }

    buf.initialize(args.device_queue, host_buf.data(), host_buf.size());

    check_buf = {1, 513, 1025, 1537};
    
  }

  void run(std::vector<event>& events) {
    events.push_back(args.device_queue.submit(
        [&](handler& cgh) {
      auto acc = buf.template get_access<access::mode::read_write>(cgh);
      accessor<int, 1, access_mode::read_write, access::target::local> scratch(local_size, cgh);

      if(kernel_type_thorin){

        cgh.enqueue_parallel_object_kernel<class Modulo_Based_Addition>(
                  nd_range<1>{global_size, local_size},
                  info_, 
                  [scratch, acc](nd_item<1> item) { });

      } else {

        cgh.parallel_for<class Modulo_Based_Addition>(
            nd_range<1>{global_size, local_size},
            [=](nd_item<1> item) noexcept {
              const auto lid = item.get_local_id(0);
              const auto group_size = item.get_local_range(0);

              scratch[lid] = acc[item.get_global_id()];
              item.barrier();
              const auto load = scratch[(lid + 1) % group_size];
              item.barrier();
              scratch[lid] += load;

              if(lid == 0)
                acc[item.get_global_id()] = scratch[lid];
            });

      }      
    }));

  }

  bool verify(VerificationSetting &ver) {
    
    buf.reset();
    bool pass = true;
    
    for(size_t i = 0; i < global_size / local_size; ++i){
        if (host_buf[i * local_size] != check_buf[i]){
          pass = false;
          break;
        }
    }

    return pass;
  
  }
  
  static std::string getBenchmarkName() {
    std::stringstream name;
    if(kernel_type_thorin)
      name << "Thorin_Modulo_Based_Addition_";
    else
      name << "Modulo_Based_Addition_";
    name << ReadableTypename<T>::name;
    return name.str();
  }
};

int main(int argc, char** argv)
{

  BenchmarkApp app(argc, argv);
  app.run<Modulo_Addition<int>>();

  return 0;
}
