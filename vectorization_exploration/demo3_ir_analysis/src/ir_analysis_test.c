#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define SIZE 1000

// Test case 1: Simple vectorizable loop
void simple_vectorizable(float* a, float* b, float* c, int n) {
    for (int i = 0; i < n; i++) {
        c[i] = a[i] + b[i];
    }
}

// Test case 2: Loop with potential vectorization issues
void complex_loop(float* a, float* b, float* c, int n) {
    for (int i = 0; i < n; i++) {
        if (a[i] > 0.0f) {
            c[i] = a[i] * b[i] + 1.0f;
        } else {
            c[i] = a[i] - b[i];
        }
    }
}

// Test case 3: Reduction loop
float reduction_loop(float* a, int n) {
    float sum = 0.0f;
    for (int i = 0; i < n; i++) {
        sum += a[i];
    }
    return sum;
}

// Function declaration
float some_function(int x);

// Test case 4: Loop with function call
void loop_with_function(float* a, float* b, float* c, int n) {
    for (int i = 0; i < n; i++) {
        c[i] = a[i] + b[i] + some_function(i);
    }
}

float some_function(int x) {
    return (float)(x % 10);
}

// Test case 5: Nested loops
void nested_loops(float* a, float* b, float* c, int n) {
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            c[i * n + j] = a[i] * b[j];
        }
    }
}

// Test case 6: Loop with dependencies
void loop_with_dependencies(float* a, float* b, int n) {
    for (int i = 1; i < n; i++) {
        a[i] = a[i] + b[i] + a[i-1];
    }
}

// Test case 7: Mixed data types
void mixed_types(int* a, float* b, float* c, int n) {
    for (int i = 0; i < n; i++) {
        c[i] = (float)a[i] + b[i];
    }
}

// Test case 8: Strided access
void strided_access(float* a, float* b, float* c, int n) {
    for (int i = 0; i < n - 1; i += 2) {
        c[i] = a[i] + b[i];
        c[i+1] = a[i+1] + b[i+1];
    }
    // Handle odd-sized arrays
    if (n % 2 == 1) {
        c[n-1] = a[n-1] + b[n-1];
    }
}

int main() {
    printf("IR Level Vectorization Analysis Test\n");
    printf("====================================\n\n");
    
    // Allocate test arrays
    float* a = malloc(SIZE * sizeof(float));
    float* b = malloc(SIZE * sizeof(float));
    float* c = malloc(SIZE * sizeof(float));
    int* ia = malloc(SIZE * sizeof(int));
    
    // Check memory allocation
    if (!a || !b || !c || !ia) {
        printf("Memory allocation failed!\n");
        return 1;
    }
    
    // Initialize arrays
    for (int i = 0; i < SIZE; i++) {
        a[i] = (float)i;
        b[i] = (float)(i * 2);
        ia[i] = i;
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
    
    // Test Case 4: Function call in loop
    printf("\nTest Case 4: Loop with function call\n");
    start = clock();
    for (int iter = 0; iter < 500; iter++) {
        loop_with_function(a, b, c, SIZE);
    }
    end = clock();
    printf("Time: %f seconds (500 iterations)\n", 
           ((double)(end - start)) / CLOCKS_PER_SEC);
    
    // Test Case 5: Nested loops
    printf("\nTest Case 5: Nested loops\n");
    start = clock();
    for (int iter = 0; iter < 10; iter++) {
        nested_loops(a, b, c, 100); // Smaller size for nested loops
    }
    end = clock();
    printf("Time: %f seconds (10 iterations)\n", 
           ((double)(end - start)) / CLOCKS_PER_SEC);
    
    // Test Case 6: Dependencies
    printf("\nTest Case 6: Loop with dependencies\n");
    start = clock();
    for (int iter = 0; iter < 1000; iter++) {
        loop_with_dependencies(a, b, SIZE);
    }
    end = clock();
    printf("Time: %f seconds (1000 iterations)\n", 
           ((double)(end - start)) / CLOCKS_PER_SEC);
    
    // Test Case 7: Mixed types
    printf("\nTest Case 7: Mixed data types\n");
    start = clock();
    for (int iter = 0; iter < 1000; iter++) {
        mixed_types(ia, b, c, SIZE);
    }
    end = clock();
    printf("Time: %f seconds (1000 iterations)\n", 
           ((double)(end - start)) / CLOCKS_PER_SEC);
    
    // Test Case 8: Strided access
    printf("\nTest Case 8: Strided memory access\n");
    start = clock();
    for (int iter = 0; iter < 1000; iter++) {
        strided_access(a, b, c, SIZE);
    }
    end = clock();
    printf("Time: %f seconds (1000 iterations)\n", 
           ((double)(end - start)) / CLOCKS_PER_SEC);
    
    // Cleanup
    free(a);
    free(b);
    free(c);
    free(ia);
    
    printf("\nIR analysis test completed.\n");
    return 0;
} 