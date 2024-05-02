#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "matrixXMatrix.h"
#include "matrixExponentiation.h"
#include <chrono>


int matrixMultiplication();
int matrixExponention(int exponent);

int main()
{
	return matrixExponention(5);
	//return matrixMultiplication();

}
int matrixExponention(int exponent) {

	float timerValueGPU, timerValueCPU;
	cudaEvent_t start, stop;
	cudaEventCreate(&start);
	cudaEventCreate(&stop);

	double* hA;
	double* dA;

	double* hB;
	double* dB;

	double* hC;
	double* dC;

	int  N_thread = 1000;
	int vectorSize = N_thread * 1;
	int matrixSize = vectorSize * vectorSize;
	int N_blocks;
	int i;
	int j;
	unsigned int matrixMem_size = sizeof(double) * matrixSize;

	hA = (double*)malloc(matrixMem_size);
	hB = (double*)malloc(matrixMem_size);
	hC = (double*)malloc(matrixMem_size);

	
	cudaError_t err;

	err = cudaMalloc((void**)&dA, matrixMem_size);
	if (err != cudaSuccess) {
		fprintf(stderr, "Cannot allocate GPU memory: %s\n", cudaGetErrorString(err));
		return 1;
	}

	err = cudaMalloc((void**)&dB, matrixMem_size);
	if (err != cudaSuccess) {
		fprintf(stderr, "Cannot allocate GPU memory: %s\n", cudaGetErrorString(err));
		return 1;
	}

	err = cudaMalloc((void**)&dC, matrixMem_size);
	if (err != cudaSuccess) {
		fprintf(stderr, "Cannot allocate GPU memory: %s\n", cudaGetErrorString(err));
		return 1;
	}

	for (i = 0; i < vectorSize; i++) {
		for (int j = 0; j < vectorSize; j++) {
			hA[i * vectorSize + j] = j+1;
			//printf("A[%d,%d] = %.5f\n", i, j, hA[i * vectorSize + j]);
			hB[i * vectorSize + j] = j+1;
			//printf("B[%d,%d] = %.5f\n", i, j, hB[i * vectorSize + j]);
			hC[i * vectorSize + j] = 0.0f;
		}
	}


	printf("\n");

	N_blocks = matrixSize / N_thread;
	cudaEventRecord(start, 0);

	cudaMemcpy(dA, hA, matrixMem_size, cudaMemcpyHostToDevice);
	cudaMemcpy(dB, hB, matrixMem_size, cudaMemcpyHostToDevice);

	

	matrixExponentiation (dA, dB, dC, exponent, vectorSize);
	cudaError_t error = cudaGetLastError();
	if (error != cudaSuccess) {
		fprintf(stderr, "CUDA error: %s\n", cudaGetErrorString(error));
		return 1;
	}
	

	err = cudaMemcpy(hC, dC, matrixMem_size, cudaMemcpyDeviceToHost);
	if (err != cudaSuccess) {
		fprintf(stderr, "Cannot copy data device/host : %s\n", cudaGetErrorString(err));
		return 1;
	}

	cudaDeviceSynchronize();
	cudaEventRecord(stop, 0);
	cudaEventSynchronize(stop);
	cudaEventElapsedTime(&timerValueGPU, start, stop);
	printf("\n GPU calculation time: %f ms\n", timerValueGPU);



	for (i = 0; i < vectorSize; i++) {
		for (int j = 0; j < vectorSize; j++) {
			printf("C[%d,%d] = %.5f\n", i, j, hC[i * vectorSize + j]);

		}
	}



	free(hA);
	free(hB);
	free(hC);

	cudaFree(dA);
	cudaFree(dB);
	cudaFree(dC);

}

int matrixMultiplication() {
	double* hA;
	double* dA;

	double* hB;
	double* dB;

	double* hC;
	double* dC;

	int  N_thread = 2;
	int vectorSize = N_thread * 1;
	int matrixSize = vectorSize * vectorSize;
	int N_blocks;
	int i;
	int j;
	unsigned int matrixMem_size = sizeof(double) * matrixSize;

	hA = (double*)malloc(matrixMem_size);
	hB = (double*)malloc(matrixMem_size);
	hC = (double*)malloc(matrixMem_size);

	cudaError_t err;

	err = cudaMalloc((void**)&dA, matrixMem_size);
	if (err != cudaSuccess) {
		fprintf(stderr, "Cannot allocate GPU memory: %s\n", cudaGetErrorString(err));
		return 1;
	}

	err = cudaMalloc((void**)&dB, matrixMem_size);
	if (err != cudaSuccess) {
		fprintf(stderr, "Cannot allocate GPU memory: %s\n", cudaGetErrorString(err));
		return 1;
	}

	err = cudaMalloc((void**)&dC, matrixMem_size);
	if (err != cudaSuccess) {
		fprintf(stderr, "Cannot allocate GPU memory: %s\n", cudaGetErrorString(err));
		return 1;
	}

	//hA[0] = 1;
	//hA[1] = 2;
	//hA[2] = 0;
	//hA[3] = 3;
	//hB[0] = 2;
	//hB[1] = 1;
	//hB[2] = 5;
	//hB[3] = 7;

	for (i = 0; i < vectorSize; i++) {
		for (int j = 0; j < vectorSize; j++) {
			hA[i * vectorSize + j] = j+1;
			//printf("A[%d,%d] = %.5f\n", i, j, hA[i * vectorSize + j]);
			hB[i * vectorSize + j] = j+1;
			//printf("B[%d,%d] = %.5f\n", i, j, hB[i * vectorSize + j]);
			hC[i * vectorSize + j] = 0.0f;

		}
	}

	printf("\n");

	N_blocks = matrixSize / N_thread;

	cudaMemcpy(dA, hA, matrixMem_size, cudaMemcpyHostToDevice);
	cudaMemcpy(dB, hB, matrixMem_size, cudaMemcpyHostToDevice);

	functionX << < N_blocks, N_thread >> > (dA, dB, dC, vectorSize);

	cudaMemcpy(hC, dC, matrixMem_size, cudaMemcpyDeviceToHost);

	for (i = 0; i < vectorSize; i++) {
		for (int j = 0; j < vectorSize; j++) {
			printf("C[%d,%d] = %.5f\n", i, j, hC[i * vectorSize + j]);

		}
	}

	free(hA);
	free(hB);
	free(hC);

	cudaFree(dA);
	cudaFree(dB);
	cudaFree(dC);

	return 0;
}
