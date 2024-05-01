#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include "matrixXMatrix.h"
#include "matrixExponentiation.h"


int matrixMultiplication();
int matrixExponention(int exponent);

int main()
{
	return matrixExponention(4);
	//return matrixMultiplication();

}
int matrixExponention(int exponent) {
	float* hA;
	float* dA;

	float* hB;
	float* dB;

	float* hC;
	float* dC;

	int  N_thread = 3;
	int vectorSize = N_thread * 1;
	int matrixSize = vectorSize * vectorSize;
	int N_blocks;
	int i;
	int j;
	unsigned int matrixMem_size = sizeof(float) * matrixSize;

	hA = (float*)malloc(matrixMem_size);
	hB = (float*)malloc(matrixMem_size);
	hC = (float*)malloc(matrixMem_size);

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
			hA[i * vectorSize + j] = j+2;
			printf("A[%d,%d] = %.5f\n", i, j, hA[i * vectorSize + j]);
			hB[i * vectorSize + j] = j+2;
			printf("B[%d,%d] = %.5f\n", i, j, hB[i * vectorSize + j]);
			hC[i * vectorSize + j] = 0.0f;
		}
	}


	printf("\n");

	N_blocks = matrixSize / N_thread;

	cudaMemcpy(dA, hA, matrixMem_size, cudaMemcpyHostToDevice);
	cudaMemcpy(dB, hB, matrixMem_size, cudaMemcpyHostToDevice);

	matrixExponentiation (dA, dB, dC, exponent, vectorSize);

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

}

int matrixMultiplication() {
	float* hA;
	float* dA;

	float* hB;
	float* dB;

	float* hC;
	float* dC;

	int  N_thread = 2;
	int vectorSize = N_thread * 1;
	int matrixSize = vectorSize * vectorSize;
	int N_blocks;
	int i;
	int j;
	unsigned int matrixMem_size = sizeof(float) * matrixSize;

	hA = (float*)malloc(matrixMem_size);
	hB = (float*)malloc(matrixMem_size);
	hC = (float*)malloc(matrixMem_size);

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
