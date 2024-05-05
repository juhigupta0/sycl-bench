#include "common.h"

#include <iostream>
#include <sycl/sycl.hpp>
#include <cmath>
#include <ctime>

using namespace sycl;

template <typename T> class LinearRegressionKernel;

template <typename T, const char* KernelName>
class MeanSquareErrorBench
{
protected:    
  std::vector<T> input1;
  std::vector<T> input2;
  std::vector<T> alpha;
  std::vector<T> beta;
  std::vector<T> output;
  std::vector<T> expected_output;
  BenchmarkArgs args;

  PrefetchedBuffer<T, 2> input1_buf;
  PrefetchedBuffer<T, 2> input2_buf;
  PrefetchedBuffer<T, 2> alpha_buf;
  PrefetchedBuffer<T, 2> beta_buf;
  PrefetchedBuffer<T, 2> output_buf;

public:
  MeanSquareErrorBench(const BenchmarkArgs &_args) : args(_args) {}
  
  std::string HCF_FILE = "mean_square_error.hcf";
  std::string KERNEL_NAME = KernelName;
  
  static constexpr int matrix_size = 512;
  
  void setup() {
    // host memory intilization
    input1.resize(matrix_size * matrix_size);
    input2.resize(matrix_size * matrix_size);
    alpha.resize(matrix_size * matrix_size);
    beta.resize(matrix_size * matrix_size);
    output.resize(matrix_size * matrix_size);
    expected_output.resize(matrix_size * matrix_size);

    for (int i = 0; i < matrix_size; i++) {
        for (int j = 0; j < matrix_size; j++) {
            int index = i * matrix_size + j;
            input1[index] = static_cast<T>(rand()) / static_cast<T>(RAND_MAX);
            input2[index] = static_cast<T>(rand()) / static_cast<T>(RAND_MAX);
            alpha[index] = static_cast<T>(rand()) / static_cast<T>(RAND_MAX);
            beta[index] = static_cast<T>(rand()) / static_cast<T>(RAND_MAX);
            // output[index] = 0.0;
            expected_output[index] = 0.0;
        }
    }

    input1_buf.initialize(args.device_queue, input1.data(), range<2>(matrix_size, matrix_size));
    input2_buf.initialize(args.device_queue, input2.data(), range<2>(matrix_size, matrix_size));
    alpha_buf.initialize(args.device_queue, alpha.data(), range<2>(matrix_size, matrix_size));
    beta_buf.initialize(args.device_queue, beta.data(), range<2>(matrix_size, matrix_size));
    output_buf.initialize(args.device_queue, output.data(), range<2>(matrix_size, matrix_size));
  }

  void run(std::vector<event>& events) {
    events.push_back(args.device_queue.submit(
        [&](handler& cgh) {
            
            auto in1 = input1_buf.template get_access<access_mode::read>(cgh);
            auto in2 = input2_buf.template get_access<access_mode::read>(cgh);
            auto alp = alpha_buf.template get_access<access_mode::read>(cgh);
            auto bet = beta_buf.template get_access<access_mode::read>(cgh);
            auto out = output_buf.template get_access<access_mode::discard_write>(cgh);

            hipsycl::common::kernelinfo::KernelInfo info_{HCF_FILE, KERNEL_NAME};
      
            // Define local range size
            range<2> local_range(16, 16);
            
            // Ensure the global range is a multiple of the local range
            range<2> global_range(
                (matrix_size + local_range[0] - 1) / local_range[0] * local_range[0],
                (matrix_size + local_range[1] - 1) / local_range[1] * local_range[1]
            );
            
            int dim = matrix_size;
            if(kernel_type_thorin){

              cgh.enqueue_parallel_object_kernel<class LinearRegressionKernel<T>>(
                          nd_range<2>(global_range, local_range),
                          info_, 
                          [dim, alp, in1, bet, in2, out](nd_item<2> item) { });

            } else {

              cgh.parallel_for<class LinearRegressionKernel<T>>(
                nd_range<2>(global_range, local_range),
                [=](nd_item<2> item) {
                    int i = item.get_global_id(0);
                    int j = item.get_global_id(1);

                    float accumulator = 0.0;
                    if (i < matrix_size && j < matrix_size) {

                        for (int k = 0; k < matrix_size; k++) {
                            accumulator += alp[i][k] * in1[k][j];
                        }
                        float error = accumulator + bet[i][j] - in2[i][j];
                        out[i][j] = error*error;
                    }
                });

            }
    }));

  }

  bool verify(VerificationSetting &ver) {
    //Triggers writeback
    output_buf.reset();
    
    bool pass = true;
    const float epsilon = 0.000001;
    const int length = matrix_size * matrix_size ;
    float error = 0.0f;
    float ref = 0.0f;

    for (size_t i = 0; i < matrix_size; i++) {
        for (size_t j = 0; j < matrix_size; j++) {
            float accumulator = 0.0;
            for (size_t k = 0; k < matrix_size; k++) {
                accumulator += alpha[i * matrix_size + k] * input1[k * matrix_size + j];
            }
            float e = accumulator + beta[i * matrix_size + j] - input2[i * matrix_size + j];
            expected_output[i * matrix_size + j] = e*e;
        }
    }


    for (size_t i = 0; i < length; ++i) {
        float diff = expected_output[i] - output[i];
        error += diff * diff;
        ref += expected_output[i] * expected_output[i];
    }

    float normRef = std::sqrt(ref);
    if (std::fabs(ref) < 1e-7f) {
        return 0;
    }

    // std::cout << "error = " << error << "  epsilon = " << epsilon << std::endl;

    float normError = std::sqrt(error);
    error = normError / normRef;

    if (error > epsilon) {
        pass = false;
    }
            
    return pass;
  }
  
  static std::string getBenchmarkName() {
    std::stringstream name;
    if(kernel_type_thorin)
      name << "Thorin_MeanSquareErrorKernel_";
    else
      name << "MeanSquareError_";
    name << ReadableTypename<T>::name;
    return name.str();
  }
};

int main(int argc, char** argv)
{
  BenchmarkApp app(argc, argv);

  static const char kernelName[] = "MeanSquareErrorKernel";
  app.run<MeanSquareErrorBench<float, kernelName>>();

  return 0;
}
