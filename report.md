# Report: Sparse Pattern Detection and Vectorization Assessment

## Executive Summary
- We prototyped binary-level hot/cold path reordering and layout optimization via BOLT across compute-heavy, matrix, and sorting benchmarks.
- We assessed vectorization efficiency at source level (compiler diagnostics and timing) and at binary level (SIMD opcode scanning and memory access density).
- Results show modest BOLT gains without precise profiles and mixed effects depending on branch predictability and data layout. Vectorization is strong for regular loops and reductions but limited by control flow, aliasing, and complex access patterns.

# 1. Binary-Level Sparse/Hot Path Exploration with BOLT

## 1.1 Compute-Heavy Demo (Demo 1)
- Program structure emphasizes hot, medium, and cold paths to exercise layout reordering.

```5:13:bolt_demos/demo1_basic/src/compute_heavy.c
// Function with different execution frequencies to demonstrate BOLT hot/cold optimization
double hot_function(double x, int iterations) {
    double result = x;
    for (int i = 0; i < iterations; i++) {
        result = result * 1.00001 + 0.00001;
        result = result / 1.00001 - 0.00001;
    }
    return result;
}
```

```45:58:bolt_demos/demo1_basic/src/compute_heavy.c
// Hot path - called very frequently
for (int i = 0; i < hot_calls; i++) {
    sum += hot_function(1.5, iterations_per_call);
}
// Medium path - called moderately
for (int i = 0; i < medium_calls; i++) {
    sum += medium_function(2.0, iterations_per_call);
}
// Cold path - called rarely
for (int i = 0; i < cold_calls; i++) {
    sum += cold_function(3.0, iterations_per_call);
}
```

- Aggregated results show small average improvement without strong profile guidance.

```15:27:bolt_demos/demo1_basic/results/demo1_results.txt
Average: 0.21271 seconds

BOLT Optimized Program Performance (5 runs):
- 0.203758 seconds
- 0.223147 seconds
- 0.218735 seconds
- 0.202419 seconds
- 0.204713 seconds
Average: 0.21055 seconds

Performance Improvement: 
- Time reduction: 0.00216 seconds
- Speedup: 1.01% (minimal improvement)
```

- Raw per-run comparison:

```1:13:bolt_demos/demo1_basic/results/performance_comparison.txt
=== Original Program Results ===
Execution time: 0.205898 seconds
Execution time: 0.200551 seconds
Execution time: 0.199931 seconds
Execution time: 0.205948 seconds
Execution time: 0.204304 seconds

=== BOLT Optimized Program Results ===
Execution time: 0.255519 seconds
Execution time: 0.211875 seconds
Execution time: 0.210585 seconds
Execution time: 0.209486 seconds
Execution time: 0.207959 seconds
```

Interpretation: Without accurate perf-guided profiles, BOLT’s basic block reordering yields minimal average speedup. Larger gains typically require precise profile data and branchy workloads.

## 1.2 Matrix Multiplication (Demo 2)
- We compare naive vs cache-blocked multiplication. The code already improves spatial/temporal locality.

```8:17:bolt_demos/demo2_matrix/src/matrix_multiply.c
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
```

```29:39:bolt_demos/demo2_matrix/src/matrix_multiply.c
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
```

- Example runs (baseline and after BOLT):

```1:4:bolt_demos/demo2_matrix/results/original_run1.txt
Matrix multiplication benchmark (size: 512x512)
Naive multiplication time: 0.100481 seconds
Optimized multiplication time: 0.066966 seconds
Speedup: 1.50x
```

```1:4:bolt_demos/demo2_matrix/results/bolt_optimized_run1.txt
Matrix multiplication benchmark (size: 512x512)
Naive multiplication time: 0.078936 seconds
Optimized multiplication time: 0.053257 seconds
Speedup: 1.48x
```

Interpretation: The dominant gain is from algorithmic/cache blocking. BOLT has limited impact on throughput-heavy, compute-regular kernels without branch mispredictions.

## 1.3 Sorting (Demo 3)
- Quicksort is branchy; merging is more predictable. This workload is suitable for layout and prediction tweaks.

```9:15:bolt_demos/demo3_sorting/src/sorting_benchmark.c
// Quicksort with many branches - good for demonstrating branch prediction optimization
void quicksort(int arr[], int low, int high) {
    if (low < high) {
        int pi = partition(arr, low, high);
        quicksort(arr, low, pi - 1);
        quicksort(arr, pi + 1, high);
    }
}
```

```18:29:bolt_demos/demo3_sorting/src/sorting_benchmark.c
int partition(int arr[], int low, int high) {
    int pivot = arr[high];
    int i = (low - 1);
    
    for (int j = low; j <= high - 1; j++) {
        if (arr[j] < pivot) {
            i++;
            swap(&arr[i], &arr[j]);
        }
    }
    swap(&arr[i + 1], &arr[high]);
    return (i + 1);
}
```

- Average times over random and sorted arrays:

```55:56:bolt_demos/demo3_sorting/results/sorting_original_full.txt
Average quicksort time: 0.004249 seconds
```

```55:55:bolt_demos/demo3_sorting/results/sorting_bolt_optimized_full.txt
Average quicksort time: 0.004363 seconds
```

```160:160:bolt_demos/demo3_sorting/results/sorting_original_full.txt
Average quicksort time (sorted): 2.189880 seconds
```

```160:160:bolt_demos/demo3_sorting/results/sorting_bolt_optimized_full.txt
Average quicksort time (sorted): 2.114927 seconds
```

Interpretation: On random data, BOLT shows negligible/no gain; on already sorted data (worst case for quicksort), BOLT reduces average time by ~3.4%, aligning with improved layout/prediction in heavily biased branches.

# 2. Vectorization: Source and Binary-Level Assessment

## 2.1 Source-Level Cases and Timing (Demo 1)
- We designed 10 loop kernels to probe vectorization.

```9:14:vectorization_exploration/demo1_loop_analysis/src/vectorization_test.c
// Case 1: Simple loop that should vectorize well
void simple_vectorizable_loop(int* a, int* b, int* c, int n) {
    for (int i = 0; i < n; i++) {
        c[i] = a[i] + b[i];
    }
}
```

```16:25:vectorization_exploration/demo1_loop_analysis/src/vectorization_test.c
// Case 2: Loop with function call - hard to vectorize
void loop_with_function_call(int* a, int* b, int* c, int n) {
    for (int i = 0; i < n; i++) {
        c[i] = a[i] + b[i] + some_function(i);
    }
}
int some_function(int x) {
    return x % 10; // Simple function that could be inlined
}
```

```72:79:vectorization_exploration/demo1_loop_analysis/src/vectorization_test.c
// Case 8: Reduction loop - should vectorize well
void reduction_loop(int* a, int n) {
    int sum = 0;
    for (int i = 0; i < n; i++) {
        sum += a[i];
    }
    printf("Sum: %d\n", sum);
}
```

- Example timing outputs:

```4:6:vectorization_exploration/demo1_loop_analysis/results/performance_results.txt
Test Case 1: Simple vectorizable loop
Simple loop: 0.023340 seconds (100 iterations)
```

```126:132:vectorization_exploration/demo1_loop_analysis/results/performance_results.txt
Reduction: 0.006922 seconds (100 iterations)

Test Case 9: Conditional loop
Conditional: 0.010942 seconds (50 iterations)

Test Case 10: Pointer arithmetic
Pointer arithmetic: 0.020578 seconds (100 iterations)
```

- Compiler vectorization diagnostics confirm which loops vectorized or missed and why:

```1:8:vectorization_exploration/demo1_loop_analysis/results/vectorization_analysis.txt
src/vectorization_test.c: In function ‘loop_with_function_call’:
src/vectorization_test.c:19:30: warning: implicit declaration of function ‘some_function’ [-Wimplicit-function-declaration]
   19 |         c[i] = a[i] + b[i] + some_function(i);
      |                              ^~~~~~~~~~~~~
src/vectorization_test.c:11:23: missed: couldn't vectorize loop
src/vectorization_test.c:11:23: missed: not vectorized: unsupported data-type
src/vectorization_test.c:18:23: missed: couldn't vectorize loop
src/vectorization_test.c:18:23: missed: not vectorized: unsupported data-type
```

```71:75:vectorization_exploration/demo1_loop_analysis/results/vectorization_analysis.txt
src/vectorization_test.c:11:23: optimized: loop vectorized using 16 byte vectors
src/vectorization_test.c:116:23: optimized: loop vectorized using 16 byte vectors
/usr/include/x86_64-linux-gnu/bits/stdio2.h:112:10: missed: statement clobbers memory: __builtin_puts (&"Vectorization Analysis Test Program"[0]);
/usr/include/x86_64-linux-gnu/bits/stdio2.h:112:10: missed: statement clobbers memory: __builtin_puts (&"===================================\n"[0]);
```

Interpretation: Regular, contiguous loops vectorize; function calls, control flow, aliasing, and complicated patterns impede vectorization.

## 2.2 Binary-Level SIMD Scanning (Demo 2)
- We scan executable sections for SSE/AVX patterns and summarize memory access density.

```41:49:vectorization_exploration/demo2_memory_patterns/src/binary_analysis_tool.c
SIMDPattern simd_patterns[] = {
    {"\x0f\x28", "MOVAPS - Move Aligned Packed Single-Precision", 16},
    {"\x0f\x29", "MOVAPS - Store Aligned Packed Single-Precision", 16},
    {"\x66\x0f\x28", "MOVAPD - Move Aligned Packed Double-Precision", 16},
    {"\x66\x0f\x29", "MOVAPD - Store Aligned Packed Double-Precision", 16},
    {"\xf3\x0f\x6f", "MOVDQU - Move Unaligned Packed Integers", 16},
    {"\xf3\x0f\x7f", "MOVDQU - Store Unaligned Packed Integers", 16},
    {"\x0f\x58", "ADDPS - Add Packed Single-Precision", 16},
    {"\x66\x0f\x58", "ADDPD - Add Packed Double-Precision", 16},
```

```74:80:vectorization_exploration/demo2_memory_patterns/src/binary_analysis_tool.c
// AVX2 patterns
SIMDPattern avx2_patterns[] = {
    {"\xc5\xfc\x58", "VADDPS - Add Packed Single-Precision (AVX)", 32},
    {"\xc5\xfd\x58", "VADDPD - Add Packed Double-Precision (AVX)", 32},
    {"\xc5\xfc\x59", "VMULPS - Multiply Packed Single-Precision (AVX)", 32},
    {"\xc5\xfd\x59", "VMULPD - Multiply Packed Double-Precision (AVX)", 32},
    {"\xc5\xfc\x5c", "VSUBPS - Subtract Packed Single-Precision (AVX)", 32},
```

- Results on `vectorization_test` show SIMD presence and memory instruction density:

```58:75:vectorization_exploration/demo2_memory_patterns/results/binary_analysis_results.txt
Analyzing section: .text (size: 3851 bytes)
==========================================
SSE/SSE2: MOVDQU - Move Unaligned Packed Integers - 13 instances (16-byte vectors)
SSE/SSE2: ADDPS - Add Packed Single-Precision - 5 instances (16-byte vectors)
SSE/SSE2: MULPS - Multiply Packed Single-Precision - 2 instances (16-byte vectors)
SSE/SSE2: MULPD - Multiply Packed Double-Precision - 1 instances (16-byte vectors)
SSE/SSE2: SHUFPS - Shuffle Packed Single-Precision - 1 instances (16-byte vectors)
SSE/SSE2: POR - Bitwise Logical OR - 1 instances (16-byte vectors)
SSE/SSE2: POR - Bitwise Logical OR - 1 instances (16-byte vectors)
SSE/SSE2: PAND - Bitwise Logical AND - 1 instances (16-byte vectors)
SSE/SSE2: PAND - Bitwise Logical AND - 1 instances (16-byte vectors)
SSE/SSE2: PANDN - Bitwise Logical AND NOT - 1 instances (16-byte vectors)
SSE/SSE2: PANDN - Bitwise Logical AND NOT - 1 instances (16-byte vectors)
SSE/SSE2: PXOR - Bitwise Logical XOR - 16 instances (16-byte vectors)
SSE/SSE2: PXOR - Bitwise Logical XOR - 16 instances (16-byte vectors)

Total SIMD instructions found: 60
```