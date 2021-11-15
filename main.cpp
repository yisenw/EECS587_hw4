//
//  main.cpp
//  ser
//
//  Created by Yang Du on 11/5/21.
//

#include <iostream>
#include <chrono>
#include <math.h>
#include <stdio.h>
#include <chrono>
#include <cmath>
using namespace std;

int main(int argc, char *argv[]) {
    // insert code here...
    auto start = high_resolution_clock::now();
    long long n = atoi(argv[1]);
    int t = atoi(argv[2]);  
    double A[n][n];
    double B[n][n];
    for (int i = 0; i < n; ++i) {
        for (int j = 0; j < n; ++j) {
            A[i][j] = sin(i*i+j) * sin(i*i+j) + cos(i-j);
        }
    }
    for (int tao = 0; tao < t; ++tao) {
        for (int i = 0; i < n; ++i) {
            for (int j = 0; j < n; ++j) {
                if (i==0||i==n-1||j==0||j==n-1) B[i][j]=A[i][j];
                else {
                    auto t1 = max(min(A[i-1][j],A[i+1][j]),min(A[i][j-1],A[i][j+1]));
                    auto t2 = min(max(A[i-1][j],A[i+1][j]),max(A[i][j-1],A[i][j+1]));
                    B[i][j] = max(min(t1,t2),min(A[i][j],max(t1,t2)));
                }
            }
        }
        for (int i = 0; i < n; ++i) {
            for (int j = 0; j < n; ++j) {
                A[i][j] = B[i][j];
            }
        }
    }
    cout << A[19][37] << "\n";
    cout << A[n/3][n/3] << "\n";
    double s = 0;
    for (int i = 0; i < n; ++i) {
        for (int j = 0; j < n; ++j) {
            s+=A[i][j];
        }
    }
    cout << s << "\n";
    
    auto end = high_resolution_clock::now();
    auto duration = duration_cast<seconds>(end - start);
    cout << duration << endl;
    return 0;
}

