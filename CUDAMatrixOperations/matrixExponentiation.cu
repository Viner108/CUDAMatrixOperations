#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <math.h>
#include "matrixXMatrix.h"

 void matrixExponentiation(double* dA, double* dB, double* dC, int exponent, int vectorSize)
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