#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>

#define ARRAY_SIZE 100000
#define NUM_RUNS 50

// Quicksort with many branches - good for demonstrating branch prediction optimization
void quicksort(int arr[], int low, int high) {
    if (low < high) {
        int pi = partition(arr, low, high);
        quicksort(arr, low, pi - 1);
        quicksort(arr, pi + 1, high);
    }
}

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

void swap(int* a, int* b) {
    int t = *a;
    *a = *b;
    *b = t;
}

// Merge sort - more predictable branches
void merge_sort(int arr[], int l, int r) {
    if (l < r) {
        int m = l + (r - l) / 2;
        merge_sort(arr, l, m);
        merge_sort(arr, m + 1, r);
        merge(arr, l, m, r);
    }
}

void merge(int arr[], int l, int m, int r) {
    int i, j, k;
    int n1 = m - l + 1;
    int n2 = r - m;
    
    int L[n1], R[n2];
    
    for (i = 0; i < n1; i++)
        L[i] = arr[l + i];
    for (j = 0; j < n2; j++)
        R[j] = arr[m + 1 + j];
    
    i = 0;
    j = 0;
    k = l;
    while (i < n1 && j < n2) {
        if (L[i] <= R[j]) {
            arr[k] = L[i];
            i++;
        } else {
            arr[k] = R[j];
            j++;
        }
        k++;
    }
    
    while (i < n1) {
        arr[k] = L[i];
        i++;
        k++;
    }
    
    while (j < n2) {
        arr[k] = R[j];
        j++;
        k++;
    }
}

// Bubble sort with many predictable branches
void bubble_sort(int arr[], int n) {
    for (int i = 0; i < n - 1; i++) {
        for (int j = 0; j < n - i - 1; j++) {
            if (arr[j] > arr[j + 1]) {
                swap(&arr[j], &arr[j + 1]);
            }
        }
    }
}

void generate_random_array(int arr[], int size) {
    for (int i = 0; i < size; i++) {
        arr[i] = rand() % 10000;
    }
}

void generate_sorted_array(int arr[], int size) {
    for (int i = 0; i < size; i++) {
        arr[i] = i;
    }
}

void generate_reverse_sorted_array(int arr[], int size) {
    for (int i = 0; i < size; i++) {
        arr[i] = size - i;
    }
}

double benchmark_sort(void (*sort_func)(int[], int), int arr[], int size, const char* name) {
    clock_t start = clock();
    
    if (sort_func == (void (*)(int[], int))quicksort) {
        quicksort(arr, 0, size - 1);
    } else if (sort_func == (void (*)(int[], int))merge_sort) {
        merge_sort(arr, 0, size - 1);
    } else {
        sort_func(arr, size);
    }
    
    clock_t end = clock();
    double time_taken = ((double)(end - start)) / CLOCKS_PER_SEC;
    
    printf("%s time: %f seconds\n", name, time_taken);
    return time_taken;
}

int main() {
    srand(42);
    
    printf("Sorting benchmark (array size: %d)\n", ARRAY_SIZE);
    printf("Running %d iterations for each test...\n\n", NUM_RUNS);
    
    int *original_array = malloc(ARRAY_SIZE * sizeof(int));
    int *test_array = malloc(ARRAY_SIZE * sizeof(int));
    
    // Test with random data
    printf("=== Random Data Test ===\n");
    generate_random_array(original_array, ARRAY_SIZE);
    
    double total_time = 0.0;
    for (int run = 0; run < NUM_RUNS; run++) {
        memcpy(test_array, original_array, ARRAY_SIZE * sizeof(int));
        total_time += benchmark_sort((void (*)(int[], int))quicksort, test_array, ARRAY_SIZE, "Quicksort");
    }
    printf("Average quicksort time: %f seconds\n\n", total_time / NUM_RUNS);
    
    total_time = 0.0;
    for (int run = 0; run < NUM_RUNS; run++) {
        memcpy(test_array, original_array, ARRAY_SIZE * sizeof(int));
        total_time += benchmark_sort((void (*)(int[], int))merge_sort, test_array, ARRAY_SIZE, "Merge sort");
    }
    printf("Average merge sort time: %f seconds\n\n", total_time / NUM_RUNS);
    
    // Test with sorted data (best case for some algorithms)
    printf("=== Sorted Data Test ===\n");
    generate_sorted_array(original_array, ARRAY_SIZE);
    
    total_time = 0.0;
    for (int run = 0; run < NUM_RUNS; run++) {
        memcpy(test_array, original_array, ARRAY_SIZE * sizeof(int));
        total_time += benchmark_sort((void (*)(int[], int))quicksort, test_array, ARRAY_SIZE, "Quicksort");
    }
    printf("Average quicksort time (sorted): %f seconds\n\n", total_time / NUM_RUNS);
    
    free(original_array);
    free(test_array);
    
    return 0;
} 