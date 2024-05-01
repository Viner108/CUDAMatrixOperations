#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <math.h>
#include "matrixXMatrix.h"

 void matrixExponentiation(float* dA, float* dB, float* dC, int exponent, int vectorSize)
{
	for (int i = 1; i < exponent; i++)
	{
		if (i == 1)
		{
			functionX << < vectorSize, vectorSize >> > (dA, dA, dC, vectorSize);
		}
		else {
			functionX << < vectorSize, vectorSize >> > (dC, dA, dC, vectorSize);
		}

	}	
}