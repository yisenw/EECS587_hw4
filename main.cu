#include <stdio.h>
#include <iostream>
#include <math.h>
#include <stdlib.h>
#include <string.h>

using namespace std;
static const long long n = 1000;
int t;


__global__ void MatrixUpdate(double* A, double* B)
{
	long long idx = blockIdx.x * blockDim.x + threadIdx.x;
	if (idx < n*n) {
		long long i = idx / n;
		long long j = idx % n;
		if (i == 0 || i == n-1 || j == 0 || j == n-1) B[idx] = A[idx];
		else 
		{
			auto t1 = max(min(A[idx-1],A[idx+1]),min(A[idx-n],A[idx+n]));
			auto t2 = min(max(A[idx-1],A[idx+1]),max(A[idx-n],A[idx+n]));
			B[idx] = max(min(t1,t2),min(A[idx],max(t1,t2)));
		}
	}
}

__global__ void MatrixVerify1(double* A, double* C)
{
	long long idx = blockIdx.x * blockDim.x + threadIdx.x;
	if (idx == 0) {
		C[2] = A[19*n+37];
		C[1] = A[(n/3)*n+(n/3)];
	}
}

__global__ void MatrixSum(double* A, double* C, long long * D)
{
	long long idx = blockIdx.x * blockDim.x + threadIdx.x;
	if (idx < n*n) {
		if (idx % (2 * D[0]) == 0 && idx + D[0] < n*n) {
			A[idx] += A[idx+D[0]];
		}
	}
}

__global__ void MatrixVerify2(double* A, double* C)
{
	long long idx = blockIdx.x * blockDim.x + threadIdx.x;
	if (idx == 0) {
		C[0] = A[0];
	}
}



int main(int argc, char *argv[])
{
    t = atoi(argv[1]);    
	double* d_A;
	double* d_B;
    double* d_final;
	double* d_C;
	long long* d_D;
	auto size = n * n * sizeof(double);
	cudaMalloc(&d_A, size);
	cudaMalloc(&d_B, size);
	cudaMalloc(&d_C, 3 * sizeof(double));
	cudaMalloc(&d_D, sizeof(long long));
	double h_A[n * n];
	double h_C[3];
	for (long long k = 0; k < n * n; k++)
	{
		double i = (double) (k / n);
		double j = (double) (k % n);
		h_A[k] = sin(i*i+j) * sin(i*i+j) + cos(i-j);
	}
	
	cudaEvent_t start, stop;
	float ttime;
	cudaEventCreate(&start);
	cudaEventCreate(&stop);
	cudaEventRecord(start, 0);
	cudaEventSynchronize(start);
	cudaMemcpy(d_A, h_A, size, cudaMemcpyHostToDevice);
	for (int i = 0; i < t/2; ++i){
		MatrixUpdate<<< (n*n+255)/256, 256 >>>(d_A, d_B);
		cudaDeviceSynchronize();
		MatrixUpdate<<< (n*n+255)/256, 256 >>>(d_B, d_A);
		cudaDeviceSynchronize();
	}

    if (t % 2 == 1) {
        MatrixUpdate<<< (n*n+255)/256, 256 >>>(d_A, d_B);
		cudaDeviceSynchronize();
        d_final = d_B;
    }
    else d_final = d_A;

	MatrixVerify1<<< (n*n+255)/256, 256 >>>(d_final, d_C);
	cudaDeviceSynchronize();
	long long st = 1;
	while (st <= n*n)
	{
		cudaMemcpy(d_D, &st, sizeof(long long), cudaMemcpyHostToDevice);
		MatrixSum<<< (n*n+255)/256, 256 >>>(d_final, d_C, d_D);
		cudaDeviceSynchronize();
		st *= 2;
	}
	MatrixVerify2<<< (n*n+255)/256, 256 >>>(d_final, d_C);
	cudaDeviceSynchronize();
	cudaMemcpy(h_C, d_C, 3 * sizeof(double), cudaMemcpyDeviceToHost);
	cudaEventRecord(stop, 0);
	cudaEventSynchronize(stop);
	cudaEventElapsedTime(&ttime, start, stop);
	cout << "sum: " << (long long) h_C[0] << "\n";
	cout << "A[n/3, n/3] = " << h_C[1] << "\n";
	cout << "A[19, 37] = " << h_C[2] << "\n";
	cout << "Time " << ttime << " ms";
	cudaFree(d_A); cudaFree(d_B); cudaFree(d_C);
	return 0;
}
