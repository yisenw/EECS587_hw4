main: main.cu
	nvcc -o cudaa main.cu -std=c++11 -O3
