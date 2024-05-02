#include "cuda_runtime.h"
#ifndef KERNEL_H
#define KERNEL_H


__global__ void functionX(double* dA, double* dB, double* dC, int size);


#endif // KERNEL_H