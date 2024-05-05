#include "common.h"

#include <iostream>
#include <sycl/sycl.hpp>

using namespace sycl;
#if defined(SYCL_BENCH_ENABLE_PROFILING_THORIN)
  std::vector<double> resultsSeconds;
#endif
template <typename T> class VecAddKernel;

template <typename T, const char* KernelName>
class VecAddBench
{
protected:    
  std::vector<T> input1;
  std::vector<T> input2;
  std::vector<T> output;
  BenchmarkArgs args;

  PrefetchedBuffer<T, 1> input1_buf;
  PrefetchedBuffer<T, 1> input2_buf;
  PrefetchedBuffer<T, 1> output_buf;

public:
  VecAddBench(const BenchmarkArgs &_args) : args(_args) {}
  
  std::string HCF_FILE = "vector_addition.hcf";
  std::string KERNEL_NAME = KernelName;  
  
  void setup() {
    // host memory intilization
    input1.resize(args.problem_size);
    input2.resize(args.problem_size);
    output.resize(args.problem_size);

    for (size_t i =0; i < args.problem_size; i++) {
      input1[i] = static_cast<T>(i);
      input2[i] = static_cast<T>(i);
      output[i] = static_cast<T>(0);
    }

    input1_buf.initialize(args.device_queue, input1.data(), range<1>(args.problem_size));
    input2_buf.initialize(args.device_queue, input2.data(), range<1>(args.problem_size));
    output_buf.initialize(args.device_queue, output.data(), range<1>(args.problem_size));
  }

  void run(std::vector<event>& events) {
    events.push_back(args.device_queue.submit(
        [&](handler& cgh) {
          
      auto in1 = input1_buf.template get_access<access::mode::read>(cgh);
      auto in2 = input2_buf.template get_access<access::mode::read>(cgh);
      auto out = output_buf.template get_access<access::mode::read_write>(cgh);

      range<1> ndrange {args.problem_size};

      hipsycl::common::kernelinfo::KernelInfo info_{HCF_FILE, KERNEL_NAME};
      size_t local_size = args.local_size;
      size_t global_size = args.problem_size;
      
      if(kernel_type_thorin){

        cgh.enqueue_parallel_object_kernel<class VecAddKernel<T>>(
                    nd_range<1>{global_size, local_size},
                    info_, 
                    [in1, in2, out](nd_item<1> item) { });

      } else {

        cgh.parallel_for<class vector_addition>(
               nd_range<1>{global_size, local_size}, [=](nd_item<1> item) {
                id<1> index = item.get_global_id();
                out[index] = in1[index] + in2[index];
        });

      }

    }));

  }

  bool verify(VerificationSetting &ver) {
    //Triggers writeback
    output_buf.reset();

    bool pass = true;
    for(size_t i=ver.begin[0]; i<ver.begin[0]+ver.range[0]; i++){
        auto expected = input1[i] + input2[i];
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
      name << "Thorin_VectorAddition_";
    else
      name << "VectorAddition_";
    name << ReadableTypename<T>::name;
    return name.str();
  }
};

int main(int argc, char** argv)
{
  BenchmarkApp app(argc, argv);
  static const char vec_add_int[] = "Vector_Add_int";
  static const char vec_add_long_long[] = "Vector_Add_long_long";
  static const char vec_add_float[] = "Vector_Add_float";
  static const char vec_add_double[] = "Vector_Add_double";

  app.run<VecAddBench<int, vec_add_int>>();
  app.run<VecAddBench<long long, vec_add_long_long>>();  
  app.run<VecAddBench<float, vec_add_float>>();
  app.run<VecAddBench<double, vec_add_double>>();

  return 0;
}
