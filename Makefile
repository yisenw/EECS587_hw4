main: main.cpp
	nvcc -o main main.cu -std=c++11 -O3
