#include "common.h"

#include <iostream>
#include <sycl/sycl.hpp>
#include <cmath>
#include <ctime>

using namespace sycl;

template <typename T> class MatrixFusedAddKernel;
template <typename T> class MatrixAddAddKernel_with_intermediate;
template <typename T, const char* KernelName>
class MatrixFusedAddMultiplyBench
{
protected:
  std::vector<T> mat_a;
  std::vector<T> mat_b;
  std::vector<T> mat_c;
  std::vector<T> mat_i;
  std::vector<T> mat_res;
  BenchmarkArgs args;

  PrefetchedBuffer<T, 2> mat_a_buf;
  PrefetchedBuffer<T, 2> mat_b_buf;
  PrefetchedBuffer<T, 2> mat_c_buf;
  PrefetchedBuffer<T, 2> mat_i_buf;
  PrefetchedBuffer<T, 2> mat_res_buf;

public:
  MatrixFusedAddMultiplyBench(const BenchmarkArgs &_args) : args(_args) {}
  
  static constexpr int matrix_size = 1024;   
  const int local_size = 32;
  int global_size = ((matrix_size + local_size - 1) / local_size) * local_size;
  
  std::string HCF_FILE = "matrix_fused_add_multiply.hcf";
  hipsycl::common::kernelinfo::KernelInfo info{HCF_FILE, KernelName};

  void setup() {
    // host memory intilization
    mat_a.resize(matrix_size * matrix_size);
    mat_b.resize(matrix_size * matrix_size);
    mat_c.resize(matrix_size * matrix_size);
    mat_i.resize(matrix_size * matrix_size);
    mat_res.resize(matrix_size * matrix_size);

    // Initialize matrices with random values
    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_real_distribution<T> dis(0.0, 100.0);

    for(size_t i = 0; i < matrix_size; ++i) {
        for(size_t j = 0; j < matrix_size; ++j) {
            mat_a[i * matrix_size + j] = dis(gen);
            mat_b[i * matrix_size + j] = dis(gen);
            mat_c[i * matrix_size + j] = dis(gen);
        }
    }

    mat_a_buf.initialize(args.device_queue, mat_a.data(), range<2>(matrix_size, matrix_size));
    mat_b_buf.initialize(args.device_queue, mat_b.data(), range<2>(matrix_size, matrix_size));
    mat_c_buf.initialize(args.device_queue, mat_c.data(), range<2>(matrix_size, matrix_size));
    mat_i_buf.initialize(args.device_queue, mat_i.data(), range<2>(matrix_size, matrix_size));
    mat_res_buf.initialize(args.device_queue, mat_res.data(), range<2>(matrix_size, matrix_size));
  }

  void run(std::vector<event>& events) {
    events.push_back(args.device_queue.submit(
        [&](handler& cgh) {
            
            auto a = mat_a_buf.template get_access<access_mode::read>(cgh);
            auto b = mat_b_buf.template get_access<access_mode::read>(cgh);
            auto c = mat_c_buf.template get_access<access_mode::read>(cgh);
            auto r = mat_res_buf.template get_access<access_mode::read_write>(cgh);
            int mat_size = matrix_size;
            if(kernel_type_thorin){

               if(!strcmp(KernelName, "MatrixFusedAddKernel")){

                  cgh.enqueue_parallel_object_kernel<class MatrixFusedAddKernel<T>>(
                    nd_range<2>{
                    range<2>(global_size, global_size), range<2>(local_size, local_size)}, 
                    info, 
                    [mat_size, a, b, c, r](nd_item<2> item) noexcept { });

               } else if (!strcmp(KernelName, "MatrixAddAddKernel_with_intermediate")){

                  auto i = mat_i_buf.template get_access<access_mode::read_write>(cgh);

                  cgh.enqueue_parallel_object_kernel<class MatrixAddAddKernel_with_intermediate<T>>(
                    nd_range<2>{
                    range<2>(global_size, global_size), range<2>(local_size, local_size)}, 
                    info, 
                    [mat_size, a, b, c, i, r](nd_item<2> item) noexcept { });

               }
               
            
            } else {

              cgh.parallel_for<class MatrixFusedAddKernel<T>>(
                nd_range<2>{range<2>(global_size, global_size), range<2>(local_size, local_size)},
                [=](nd_item<2> item) {
                    int x = item.get_global_id(0);
                    int y = item.get_global_id(1);
                    
                    if (x < matrix_size && y < matrix_size)
                      r[x][y] = a[x][y] + b[x][y] + c[x][y];
             });

            }
    }));

  }

  bool verify(VerificationSetting &ver) {
    //Triggers writeback
    mat_res_buf.reset();
    
    // Verify the results
    bool verification_passed = true;
    for(size_t i = 0; i < matrix_size; ++i) {
        for(size_t j = 0; j < matrix_size; ++j) {
            T expected_value = 0;
            expected_value = mat_a[i * matrix_size + j] + mat_b[i * matrix_size + j] + mat_c[i * matrix_size + j];
            T kernel_value = mat_res[i * matrix_size + j];
            if(std::abs(kernel_value - expected_value) > 1e-6) {
                verification_passed = false;
                break;
            }
        }
    }
    return verification_passed;
  }
  
  static std::string getBenchmarkName() {
    std::stringstream name;
    if(kernel_type_thorin)
      name << "Thorin_";
    else
      name << "Acpp_";
    name << KernelName <<ReadableTypename<T>::name;
    return name.str();
  }
};

int main(int argc, char** argv)
{
  BenchmarkApp app(argc, argv);

  if(kernel_type_thorin){
    static const char SeqkernelName[] = "MatrixAddAddKernel_with_intermediate";
    app.run<MatrixFusedAddMultiplyBench<double, SeqkernelName>>();
  }

  static const char FusedkernelName[] = "MatrixFusedAddKernel";
  app.run<MatrixFusedAddMultiplyBench<double, FusedkernelName>>();

  return 0;
}
