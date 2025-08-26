#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>

#define SIZE 1000000
#define MATRIX_SIZE 512

int some_function(int x);

// Case 1: Simple loop that should vectorize well
void simple_vectorizable_loop(int* a, int* b, int* c, int n) {
    for (int i = 0; i < n; i++) {
        c[i] = a[i] + b[i];
    }
}

// Case 2: Loop with function call - hard to vectorize
void loop_with_function_call(int* a, int* b, int* c, int n) {
    for (int i = 0; i < n; i++) {
        c[i] = a[i] + b[i] + some_function(i);
    }
}

int some_function(int x) {
    return x % 10; // Simple function that could be inlined
}

// Case 3: Non-contiguous memory access - poor vectorization
void non_contiguous_access(int* a, int* b, int* c, int n) {
    for (int i = 0; i < n; i += 2) {
        c[i] = a[i] + b[i];
        c[i+1] = a[i+1] + b[i+1];
    }
}

// Case 4: Complex loop dependencies - prevents vectorization
void loop_with_dependencies(int* a, int* b, int* c, int n) {
    for (int i = 1; i < n; i++) {
        c[i] = a[i] + b[i] + c[i-1]; // Read-after-write dependency
    }
}

// Case 5: Mixed data types - suboptimal vectorization
void mixed_data_types(float* a, int* b, float* c, int n) {
    for (int i = 0; i < n; i++) {
        c[i] = a[i] + (float)b[i];
    }
}

// Case 6: Irregular loop bounds - hard to vectorize
void irregular_bounds(int* a, int* b, int* c, int n) {
    for (int i = 0; i < n; i++) {
        if (i % 3 == 0) {
            c[i] = a[i] + b[i];
        } else {
            c[i] = a[i] - b[i];
        }
    }
}

// Case 7: Matrix multiplication - complex vectorization
void matrix_multiply_naive(double** A, double** B, double** C, int n) {
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            C[i][j] = 0.0;
            for (int k = 0; k < n; k++) {
                C[i][j] += A[i][k] * B[k][j];
            }
        }
    }
}

// Case 8: Reduction loop - should vectorize well
void reduction_loop(int* a, int n) {
    int sum = 0;
    for (int i = 0; i < n; i++) {
        sum += a[i];
    }
    printf("Sum: %d\n", sum);
}

// Case 9: Loop with conditional - partial vectorization
void conditional_loop(int* a, int* b, int* c, int n) {
    for (int i = 0; i < n; i++) {
        if (a[i] > 0) {
            c[i] = a[i] + b[i];
        } else {
            c[i] = a[i] - b[i];
        }
    }
}

// Case 10: Loop with pointer arithmetic - complex analysis
void pointer_arithmetic_loop(int* a, int* b, int* c, int n) {
    int* pa = a;
    int* pb = b;
    int* pc = c;
    for (int i = 0; i < n; i++) {
        *pc++ = *pa++ + *pb++;
    }
}



int main() {
    printf("Vectorization Analysis Test Program\n");
    printf("===================================\n\n");
    
    // Allocate test arrays
    int* a = malloc(SIZE * sizeof(int));
    int* b = malloc(SIZE * sizeof(int));
    int* c = malloc(SIZE * sizeof(int));
    float* fa = malloc(SIZE * sizeof(float));
    float* fc = malloc(SIZE * sizeof(float));
    
    // Initialize arrays
    for (int i = 0; i < SIZE; i++) {
        a[i] = i;
        b[i] = i * 2;
        fa[i] = (float)i;
    }
    
    // Test Case 1: Simple vectorizable loop
    printf("Test Case 1: Simple vectorizable loop\n");
    clock_t start = clock();
    for (int i = 0; i < 100; i++) {
        simple_vectorizable_loop(a, b, c, SIZE);
    }
    clock_t end = clock();
    printf("Simple loop: %f seconds (100 iterations)\n", 
           ((double)(end - start)) / CLOCKS_PER_SEC);
    
    // Test Case 2: Loop with function call
    printf("\nTest Case 2: Loop with function call\n");
    start = clock();
    for (int i = 0; i < 50; i++) {
        loop_with_function_call(a, b, c, SIZE);
    }
    end = clock();
    printf("Function call loop: %f seconds (50 iterations)\n", 
           ((double)(end - start)) / CLOCKS_PER_SEC);
    
    // Test Case 3: Non-contiguous access
    printf("\nTest Case 3: Non-contiguous memory access\n");
    start = clock();
    for (int i = 0; i < 100; i++) {
        non_contiguous_access(a, b, c, SIZE);
    }
    end = clock();
    printf("Non-contiguous access: %f seconds (100 iterations)\n", 
           ((double)(end - start)) / CLOCKS_PER_SEC);
    
    // Test Case 4: Loop dependencies
    printf("\nTest Case 4: Loop with dependencies\n");
    start = clock();
    for (int i = 0; i < 50; i++) {
        loop_with_dependencies(a, b, c, SIZE);
    }
    end = clock();
    printf("Dependency loop: %f seconds (50 iterations)\n", 
           ((double)(end - start)) / CLOCKS_PER_SEC);
    
    // Test Case 5: Mixed data types
    printf("\nTest Case 5: Mixed data types\n");
    start = clock();
    for (int i = 0; i < 100; i++) {
        mixed_data_types(fa, b, fc, SIZE);
    }
    end = clock();
    printf("Mixed types: %f seconds (100 iterations)\n", 
           ((double)(end - start)) / CLOCKS_PER_SEC);
    
    // Test Case 6: Irregular bounds
    printf("\nTest Case 6: Irregular loop bounds\n");
    start = clock();
    for (int i = 0; i < 50; i++) {
        irregular_bounds(a, b, c, SIZE);
    }
    end = clock();
    printf("Irregular bounds: %f seconds (50 iterations)\n", 
           ((double)(end - start)) / CLOCKS_PER_SEC);
    
    // Test Case 7: Matrix multiplication
    printf("\nTest Case 7: Matrix multiplication\n");
    double** A = malloc(MATRIX_SIZE * sizeof(double*));
    double** B = malloc(MATRIX_SIZE * sizeof(double*));
    double** C = malloc(MATRIX_SIZE * sizeof(double*));
    for (int i = 0; i < MATRIX_SIZE; i++) {
        A[i] = malloc(MATRIX_SIZE * sizeof(double));
        B[i] = malloc(MATRIX_SIZE * sizeof(double));
        C[i] = malloc(MATRIX_SIZE * sizeof(double));
        for (int j = 0; j < MATRIX_SIZE; j++) {
            A[i][j] = (double)(i + j);
            B[i][j] = (double)(i * j);
        }
    }
    start = clock();
    for (int i = 0; i < 10; i++) {
        matrix_multiply_naive(A, B, C, MATRIX_SIZE);
    }
    end = clock();
    printf("Matrix multiply: %f seconds (10 iterations)\n", 
           ((double)(end - start)) / CLOCKS_PER_SEC);
    
    // Test Case 8: Reduction loop
    printf("\nTest Case 8: Reduction loop\n");
    start = clock();
    for (int i = 0; i < 100; i++) {
        reduction_loop(a, SIZE);
    }
    end = clock();
    printf("Reduction: %f seconds (100 iterations)\n", 
           ((double)(end - start)) / CLOCKS_PER_SEC);
    
    // Test Case 9: Conditional loop
    printf("\nTest Case 9: Conditional loop\n");
    start = clock();
    for (int i = 0; i < 50; i++) {
        conditional_loop(a, b, c, SIZE);
    }
    end = clock();
    printf("Conditional: %f seconds (50 iterations)\n", 
           ((double)(end - start)) / CLOCKS_PER_SEC);
    
    // Test Case 10: Pointer arithmetic
    printf("\nTest Case 10: Pointer arithmetic\n");
    start = clock();
    for (int i = 0; i < 100; i++) {
        pointer_arithmetic_loop(a, b, c, SIZE);
    }
    end = clock();
    printf("Pointer arithmetic: %f seconds (100 iterations)\n", 
           ((double)(end - start)) / CLOCKS_PER_SEC);
    
    // Cleanup
    free(a);
    free(b);
    free(c);
    free(fa);
    free(fc);
    
    for (int i = 0; i < MATRIX_SIZE; i++) {
        free(A[i]);
        free(B[i]);
        free(C[i]);
    }
    free(A);
    free(B);
    free(C);
    
    printf("\nBenchmark completed.\n");
    return 0;
} 