#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>

#define SIZE 1000

// Example 1: Data-dependent branching (control flow in loop)
void data_dependent_branch(float* a, float* b, float* c, int n) {
    for (int i = 0; i < n; i++) {
        if (a[i] > 0.5f) {
            c[i] = a[i] * b[i] + 1.0f;
        } else {
            c[i] = a[i] - b[i] * 0.5f;
        }
    }
}

// Example 2: Loop-carried dependency (true dependency across iterations)  
void loop_carried_dependency(float* a, float* b, int n) {
    for (int i = 1; i < n; i++) {
        a[i] = a[i] + b[i] + a[i-1] * 0.3f;  // depends on previous iteration
    }
}

// Example 3: Indirect memory access (gather/scatter pattern)
void indirect_access(float* a, float* b, int* indices, int n) {
    for (int i = 0; i < n; i++) {
        a[i] = b[indices[i]];  // indirect indexing, unpredictable access pattern
    }
}

// Example 4: Function call in loop (side effects)
float expensive_function(float x) {
    return x * x + 2.0f * x + 1.0f;  // might have side effects
}

void loop_with_function_call(float* a, float* b, int n) {
    for (int i = 0; i < n; i++) {
        b[i] = expensive_function(a[i]);
    }
}

// Example 5: Non-unit stride access
void non_unit_stride(float* a, float* b, int n) {
    for (int i = 0; i < n; i += 3) {  // non-unit stride
        b[i] = a[i] * 2.0f;
        if (i + 1 < n) b[i+1] = a[i+1] * 2.0f;
        if (i + 2 < n) b[i+2] = a[i+2] * 2.0f;
    }
}

// Example 6: Potential pointer aliasing
void potential_aliasing(float* a, float* b, float* c, int n) {
    // Compiler cannot prove a, b, c don't overlap
    for (int i = 0; i < n; i++) {
        c[i] = a[i] + b[i];
    }
}

// Example 7: Mixed data types with complex conversion
void mixed_types_complex(int* ia, short* sa, float* fa, double* da, int n) {
    for (int i = 0; i < n; i++) {
        da[i] = (double)ia[i] + (double)sa[i] + (double)fa[i];  // multiple type conversions
    }
}

// Example 8: Variable loop bound (unknown trip count)
void variable_loop_bound(float* a, float* b, int n, int threshold) {
    for (int i = 0; i < n && a[i] < threshold; i++) {  // early exit condition
        b[i] = a[i] * 2.0f;
    }
}

// Example 9: Complex reduction with non-associative operation
void complex_reduction(float* a, int n, float* result) {
    float sum = 0.0f;
    for (int i = 0; i < n; i++) {
        if (a[i] > 0.0f) {
            sum += a[i] / (1.0f + sum);  // non-associative, depends on order
        }
    }
    *result = sum;
}

// Example 10: Sparse matrix-like pattern (CSR simulation)
void sparse_matrix_pattern(float* values, int* col_indices, int* row_ptr, 
                          float* x, float* y, int num_rows) {
    for (int i = 0; i < num_rows; i++) {
        float sum = 0.0f;
        for (int j = row_ptr[i]; j < row_ptr[i+1]; j++) {
            sum += values[j] * x[col_indices[j]];  // indirect access + varying inner loop length
        }
        y[i] = sum;
    }
}

// Benchmark and test functions
void initialize_arrays(float* a, float* b, float* c, int* indices, int n) {
    srand(42);
    for (int i = 0; i < n; i++) {
        a[i] = (float)rand() / RAND_MAX;
        b[i] = (float)rand() / RAND_MAX;
        c[i] = 0.0f;
        indices[i] = rand() % n;
    }
}

double get_time_diff(struct timespec start, struct timespec end) {
    return (end.tv_sec - start.tv_sec) + (end.tv_nsec - start.tv_nsec) / 1e9;
}

int main() {
    printf("Testing vectorization failure examples\n");
    printf("=======================================\n\n");
    
    // Allocate test arrays
    float* a = aligned_alloc(64, SIZE * sizeof(float));
    float* b = aligned_alloc(64, SIZE * sizeof(float));
    float* c = aligned_alloc(64, SIZE * sizeof(float));
    int* indices = aligned_alloc(64, SIZE * sizeof(int));
    
    if (!a || !b || !c || !indices) {
        printf("Memory allocation failed!\n");
        return 1;
    }
    
    initialize_arrays(a, b, c, indices, SIZE);
    
    struct timespec start, end;
    const int iterations = 10000;
    
    // Test 1: Data-dependent branching
    printf("Test 1: Data-dependent branching\n");
    clock_gettime(CLOCK_MONOTONIC, &start);
    for (int iter = 0; iter < iterations; iter++) {
        data_dependent_branch(a, b, c, SIZE);
    }
    clock_gettime(CLOCK_MONOTONIC, &end);
    printf("Time: %.6f seconds (%d iterations)\n\n", 
           get_time_diff(start, end), iterations);
    
    // Test 2: Loop-carried dependency
    printf("Test 2: Loop-carried dependency\n");
    memcpy(c, a, SIZE * sizeof(float));  // reset array
    clock_gettime(CLOCK_MONOTONIC, &start);
    for (int iter = 0; iter < iterations; iter++) {
        loop_carried_dependency(c, b, SIZE);
        memcpy(c, a, SIZE * sizeof(float));  // reset for next iteration
    }
    clock_gettime(CLOCK_MONOTONIC, &end);
    printf("Time: %.6f seconds (%d iterations)\n\n", 
           get_time_diff(start, end), iterations);
    
    // Test 3: Indirect access
    printf("Test 3: Indirect memory access\n");
    clock_gettime(CLOCK_MONOTONIC, &start);
    for (int iter = 0; iter < iterations; iter++) {
        indirect_access(c, a, indices, SIZE);
    }
    clock_gettime(CLOCK_MONOTONIC, &end);
    printf("Time: %.6f seconds (%d iterations)\n\n", 
           get_time_diff(start, end), iterations);
    
    // Test 4: Function call in loop
    printf("Test 4: Function call in loop\n");
    clock_gettime(CLOCK_MONOTONIC, &start);
    for (int iter = 0; iter < iterations; iter++) {
        loop_with_function_call(a, c, SIZE);
    }
    clock_gettime(CLOCK_MONOTONIC, &end);
    printf("Time: %.6f seconds (%d iterations)\n\n", 
           get_time_diff(start, end), iterations);
    
    // Test 5: Non-unit stride
    printf("Test 5: Non-unit stride access\n");
    clock_gettime(CLOCK_MONOTONIC, &start);
    for (int iter = 0; iter < iterations; iter++) {
        non_unit_stride(a, c, SIZE);
    }
    clock_gettime(CLOCK_MONOTONIC, &end);
    printf("Time: %.6f seconds (%d iterations)\n\n", 
           get_time_diff(start, end), iterations);
    
    // Clean up
    free(a);
    free(b);
    free(c);
    free(indices);
    
    printf("All tests completed.\n");
    return 0;
} 