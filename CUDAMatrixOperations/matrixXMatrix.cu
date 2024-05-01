#include "matrixXMatrix.h"
#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <math.h>

__global__ void functionX(float* dA, float* dB, float* dC, int vectorSize)
{
    int i = blockDim.x * blockIdx.x + threadIdx.x;
    if (i < vectorSize*vectorSize) {
        int k = i / vectorSize;
        int n = i % vectorSize;
        float sum = 0.0f;
        for (int j = 0; j < vectorSize; j++) {
        sum += dA[k * vectorSize + j] * dB[j * vectorSize + n];
        }
        dC[i] = sum;
    }


}
