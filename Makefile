main: main.cu
	nvcc -o cudaa main.cu -std=c++11 -O3

clean:
	rm out* time* sl* cudaa* sel