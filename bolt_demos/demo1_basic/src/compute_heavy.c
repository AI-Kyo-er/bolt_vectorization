#include <stdio.h>
#include <stdlib.h>
#include <time.h>

// Function with different execution frequencies to demonstrate BOLT hot/cold optimization
double hot_function(double x, int iterations) {
    double result = x;
    for (int i = 0; i < iterations; i++) {
        result = result * 1.00001 + 0.00001;
        result = result / 1.00001 - 0.00001;
    }
    return result;
}

double cold_function(double x, int iterations) {
    double result = x;
    for (int i = 0; i < iterations; i++) {
        result = result * result * 0.9999;
        if (result > 1000000) result = 1.0;
    }
    return result;
}

double medium_function(double x, int iterations) {
    double result = x;
    for (int i = 0; i < iterations; i++) {
        result += x * 0.1;
        result -= x * 0.05;
    }
    return result;
}

int main() {
    const int hot_calls = 1000000;
    const int medium_calls = 100000;
    const int cold_calls = 1000;
    const int iterations_per_call = 100;
    
    printf("Starting compute-heavy benchmark...\n");
    
    clock_t start = clock();
    
    double sum = 0.0;
    
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
    
    clock_t end = clock();
    double cpu_time_used = ((double) (end - start)) / CLOCKS_PER_SEC;
    
    printf("Computation completed. Sum: %f\n", sum);
    printf("Execution time: %f seconds\n", cpu_time_used);
    
    return 0;
} 