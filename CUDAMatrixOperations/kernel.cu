#include "kernel.h"
#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <math.h>

__global__ void function(float* dA, float* dB, float* dC, int vectorSize)
{
    int i = blockDim.x * blockIdx.x + threadIdx.x;
    if (i < vectorSize*vectorSize) {
        int n = i % vectorSize;
        float sum = 0.0f;
        for (int j = 0; j < vectorSize; j++) {
        sum += dA[n * vectorSize + j] * dB[j * vectorSize + n];
        }
        dC[i] = sum;
    }


}