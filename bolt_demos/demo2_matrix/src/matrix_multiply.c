#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>

#define MATRIX_SIZE 512

// Naive matrix multiplication - poor cache locality
void naive_matrix_multiply(double **A, double **B, double **C, int n) {
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            C[i][j] = 0.0;
            for (int k = 0; k < n; k++) {
                C[i][j] += A[i][k] * B[k][j];
            }
        }
    }
}

// Cache-optimized matrix multiplication
void optimized_matrix_multiply(double **A, double **B, double **C, int n) {
    // Initialize result matrix
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            C[i][j] = 0.0;
        }
    }
    
    // Blocked multiplication for better cache locality
    int block_size = 64;
    for (int ii = 0; ii < n; ii += block_size) {
        for (int jj = 0; jj < n; jj += block_size) {
            for (int kk = 0; kk < n; kk += block_size) {
                for (int i = ii; i < ii + block_size && i < n; i++) {
                    for (int j = jj; j < jj + block_size && j < n; j++) {
                        for (int k = kk; k < kk + block_size && k < n; k++) {
                            C[i][j] += A[i][k] * B[k][j];
                        }
                    }
                }
            }
        }
    }
}

double** allocate_matrix(int n) {
    double **matrix = malloc(n * sizeof(double*));
    for (int i = 0; i < n; i++) {
        matrix[i] = malloc(n * sizeof(double));
    }
    return matrix;
}

void free_matrix(double **matrix, int n) {
    for (int i = 0; i < n; i++) {
        free(matrix[i]);
    }
    free(matrix);
}

void initialize_matrix(double **matrix, int n) {
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            matrix[i][j] = (double)(rand() % 100) / 10.0;
        }
    }
}

int main() {
    srand(42); // Fixed seed for reproducible results
    
    printf("Matrix multiplication benchmark (size: %dx%d)\n", MATRIX_SIZE, MATRIX_SIZE);
    
    double **A = allocate_matrix(MATRIX_SIZE);
    double **B = allocate_matrix(MATRIX_SIZE);
    double **C = allocate_matrix(MATRIX_SIZE);
    
    initialize_matrix(A, MATRIX_SIZE);
    initialize_matrix(B, MATRIX_SIZE);
    
    // Naive version
    clock_t start = clock();
    naive_matrix_multiply(A, B, C, MATRIX_SIZE);
    clock_t end = clock();
    double naive_time = ((double)(end - start)) / CLOCKS_PER_SEC;
    
    printf("Naive multiplication time: %f seconds\n", naive_time);
    
    // Optimized version
    start = clock();
    optimized_matrix_multiply(A, B, C, MATRIX_SIZE);
    end = clock();
    double optimized_time = ((double)(end - start)) / CLOCKS_PER_SEC;
    
    printf("Optimized multiplication time: %f seconds\n", optimized_time);
    printf("Speedup: %.2fx\n", naive_time / optimized_time);
    
    free_matrix(A, MATRIX_SIZE);
    free_matrix(B, MATRIX_SIZE);
    free_matrix(C, MATRIX_SIZE);
    
    return 0;
} 