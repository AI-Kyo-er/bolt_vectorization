#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define SIZE 100

// Simple vectorizable loop
void simple_vectorizable(float* a, float* b, float* c, int n) {
    for (int i = 0; i < n; i++) {
        c[i] = a[i] + b[i];
    }
}

// Complex loop with conditionals
void complex_loop(float* a, float* b, float* c, int n) {
    for (int i = 0; i < n; i++) {
        if (a[i] > 0.0f) {
            c[i] = a[i] * b[i] + 1.0f;
        } else {
            c[i] = a[i] - b[i];
        }
    }
}

// Reduction loop
float reduction_loop(float* a, int n) {
    float sum = 0.0f;
    for (int i = 0; i < n; i++) {
        sum += a[i];
    }
    return sum;
}

int main() {
    printf("Simple IR Level Vectorization Analysis Test\n");
    printf("==========================================\n\n");
    
    // Allocate test arrays
    float* a = malloc(SIZE * sizeof(float));
    float* b = malloc(SIZE * sizeof(float));
    float* c = malloc(SIZE * sizeof(float));
    
    if (!a || !b || !c) {
        printf("Memory allocation failed!\n");
        return 1;
    }
    
    // Initialize arrays
    for (int i = 0; i < SIZE; i++) {
        a[i] = (float)i;
        b[i] = (float)(i * 2);
    }
    
    // Test Case 1: Simple vectorizable
    printf("Test Case 1: Simple vectorizable loop\n");
    clock_t start = clock();
    for (int iter = 0; iter < 1000; iter++) {
        simple_vectorizable(a, b, c, SIZE);
    }
    clock_t end = clock();
    printf("Time: %f seconds (1000 iterations)\n", 
           ((double)(end - start)) / CLOCKS_PER_SEC);
    
    // Test Case 2: Complex loop
    printf("\nTest Case 2: Complex loop with conditionals\n");
    start = clock();
    for (int iter = 0; iter < 1000; iter++) {
        complex_loop(a, b, c, SIZE);
    }
    end = clock();
    printf("Time: %f seconds (1000 iterations)\n", 
           ((double)(end - start)) / CLOCKS_PER_SEC);
    
    // Test Case 3: Reduction
    printf("\nTest Case 3: Reduction loop\n");
    start = clock();
    float sum = 0.0f;
    for (int iter = 0; iter < 1000; iter++) {
        sum = reduction_loop(a, SIZE);
    }
    end = clock();
    printf("Time: %f seconds (1000 iterations), Sum: %f\n", 
           ((double)(end - start)) / CLOCKS_PER_SEC, sum);
    
    // Cleanup
    free(a);
    free(b);
    free(c);
    
    printf("\nSimple IR analysis test completed.\n");
    return 0;
} 