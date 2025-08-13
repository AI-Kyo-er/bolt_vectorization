#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <elf.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/stat.h>

#define MAX_SECTIONS 100
#define MAX_SYMBOLS 1000

typedef struct {
    char name[64];
    Elf64_Addr addr;
    Elf64_Xword size;
    unsigned char* data;
} Section;

typedef struct {
    char name[64];
    Elf64_Addr addr;
    Elf64_Xword size;
    unsigned char type;
} Symbol;

typedef struct {
    Section sections[MAX_SECTIONS];
    Symbol symbols[MAX_SYMBOLS];
    int num_sections;
    int num_symbols;
    Elf64_Ehdr ehdr;
} BinaryInfo;

// SIMD instruction patterns for x86-64
typedef struct {
    const char* pattern;
    const char* description;
    int vector_size;
} SIMDPattern;

SIMDPattern simd_patterns[] = {
    {"\x0f\x28", "MOVAPS - Move Aligned Packed Single-Precision", 16},
    {"\x0f\x29", "MOVAPS - Store Aligned Packed Single-Precision", 16},
    {"\x66\x0f\x28", "MOVAPD - Move Aligned Packed Double-Precision", 16},
    {"\x66\x0f\x29", "MOVAPD - Store Aligned Packed Double-Precision", 16},
    {"\xf3\x0f\x6f", "MOVDQU - Move Unaligned Packed Integers", 16},
    {"\xf3\x0f\x7f", "MOVDQU - Store Unaligned Packed Integers", 16},
    {"\x0f\x58", "ADDPS - Add Packed Single-Precision", 16},
    {"\x66\x0f\x58", "ADDPD - Add Packed Double-Precision", 16},
    {"\x0f\x59", "MULPS - Multiply Packed Single-Precision", 16},
    {"\x66\x0f\x59", "MULPD - Multiply Packed Double-Precision", 16},
    {"\x0f\x5c", "SUBPS - Subtract Packed Single-Precision", 16},
    {"\x66\x0f\x5c", "SUBPD - Subtract Packed Double-Precision", 16},
    {"\x0f\x5d", "MINPS - Minimum Packed Single-Precision", 16},
    {"\x66\x0f\x5d", "MINPD - Minimum Packed Double-Precision", 16},
    {"\x0f\x5f", "MAXPS - Maximum Packed Single-Precision", 16},
    {"\x66\x0f\x5f", "MAXPD - Maximum Packed Double-Precision", 16},
    {"\x0f\xc6", "SHUFPS - Shuffle Packed Single-Precision", 16},
    {"\x66\x0f\xc6", "SHUFPD - Shuffle Packed Double-Precision", 16},
    {"\x0f\x76", "PCMPEQD - Compare Packed Integers for Equality", 16},
    {"\x66\x0f\x76", "PCMPEQD - Compare Packed Integers for Equality", 16},
    {"\x0f\xeb", "POR - Bitwise Logical OR", 16},
    {"\x66\x0f\xeb", "POR - Bitwise Logical OR", 16},
    {"\x0f\xdb", "PAND - Bitwise Logical AND", 16},
    {"\x66\x0f\xdb", "PAND - Bitwise Logical AND", 16},
    {"\x0f\xdf", "PANDN - Bitwise Logical AND NOT", 16},
    {"\x66\x0f\xdf", "PANDN - Bitwise Logical AND NOT", 16},
    {"\x0f\xef", "PXOR - Bitwise Logical XOR", 16},
    {"\x66\x0f\xef", "PXOR - Bitwise Logical XOR", 16},
    {NULL, NULL, 0}
};

// AVX2 patterns
SIMDPattern avx2_patterns[] = {
    {"\xc5\xfc\x58", "VADDPS - Add Packed Single-Precision (AVX)", 32},
    {"\xc5\xfd\x58", "VADDPD - Add Packed Double-Precision (AVX)", 32},
    {"\xc5\xfc\x59", "VMULPS - Multiply Packed Single-Precision (AVX)", 32},
    {"\xc5\xfd\x59", "VMULPD - Multiply Packed Double-Precision (AVX)", 32},
    {"\xc5\xfc\x5c", "VSUBPS - Subtract Packed Single-Precision (AVX)", 32},
    {"\xc5\xfd\x5c", "VSUBPD - Subtract Packed Double-Precision (AVX)", 32},
    {"\xc5\xfc\x5d", "VMINPS - Minimum Packed Single-Precision (AVX)", 32},
    {"\xc5\xfd\x5d", "VMINPD - Minimum Packed Double-Precision (AVX)", 32},
    {"\xc5\xfc\x5f", "VMAXPS - Maximum Packed Single-Precision (AVX)", 32},
    {"\xc5\xfd\x5f", "VMAXPD - Maximum Packed Double-Precision (AVX)", 32},
    {"\xc5\xfc\xc6", "VSHUFPS - Shuffle Packed Single-Precision (AVX)", 32},
    {"\xc5\xfd\xc6", "VSHUFPD - Shuffle Packed Double-Precision (AVX)", 32},
    {NULL, NULL, 0}
};

// Load binary file
int load_binary(const char* filename, BinaryInfo* bin) {
    int fd = open(filename, O_RDONLY);
    if (fd == -1) {
        perror("Error opening file");
        return -1;
    }
    
    // Read ELF header
    if (read(fd, &bin->ehdr, sizeof(Elf64_Ehdr)) != sizeof(Elf64_Ehdr)) {
        perror("Error reading ELF header");
        close(fd);
        return -1;
    }
    
    // Verify ELF magic
    if (memcmp(bin->ehdr.e_ident, ELFMAG, SELFMAG) != 0) {
        fprintf(stderr, "Not a valid ELF file\n");
        close(fd);
        return -1;
    }
    
    // Read section headers
    Elf64_Shdr* shdrs = malloc(bin->ehdr.e_shentsize * bin->ehdr.e_shnum);
    lseek(fd, bin->ehdr.e_shoff, SEEK_SET);
    read(fd, shdrs, bin->ehdr.e_shentsize * bin->ehdr.e_shnum);
    
    // Read section names
    Elf64_Shdr* shstr = &shdrs[bin->ehdr.e_shstrndx];
    char* shstrtab = malloc(shstr->sh_size);
    lseek(fd, shstr->sh_offset, SEEK_SET);
    read(fd, shstrtab, shstr->sh_size);
    
    // Process sections
    bin->num_sections = 0;
    for (int i = 0; i < bin->ehdr.e_shnum && bin->num_sections < MAX_SECTIONS; i++) {
        if (shdrs[i].sh_type == SHT_PROGBITS && 
            (shdrs[i].sh_flags & SHF_EXECINSTR)) {
            
            Section* sec = &bin->sections[bin->num_sections];
            strcpy(sec->name, shstrtab + shdrs[i].sh_name);
            sec->addr = shdrs[i].sh_addr;
            sec->size = shdrs[i].sh_size;
            sec->data = malloc(sec->size);
            
            lseek(fd, shdrs[i].sh_offset, SEEK_SET);
            read(fd, sec->data, sec->size);
            
            bin->num_sections++;
        }
    }
    
    free(shdrs);
    free(shstrtab);
    close(fd);
    return 0;
}

// Search for SIMD patterns in binary data
void search_simd_patterns(unsigned char* data, size_t size, const char* section_name) {
    printf("\nAnalyzing section: %s (size: %zu bytes)\n", section_name, size);
    printf("==========================================\n");
    
    int total_simd_instructions = 0;
    
    // Search for SSE/SSE2 patterns
    for (int i = 0; simd_patterns[i].pattern != NULL; i++) {
        int pattern_len = strlen(simd_patterns[i].pattern);
        int count = 0;
        
        for (size_t j = 0; j < size - pattern_len; j++) {
            if (memcmp(data + j, simd_patterns[i].pattern, pattern_len) == 0) {
                count++;
            }
        }
        
        if (count > 0) {
            printf("SSE/SSE2: %s - %d instances (%d-byte vectors)\n", 
                   simd_patterns[i].description, count, simd_patterns[i].vector_size);
            total_simd_instructions += count;
        }
    }
    
    // Search for AVX2 patterns
    for (int i = 0; avx2_patterns[i].pattern != NULL; i++) {
        int pattern_len = strlen(avx2_patterns[i].pattern);
        int count = 0;
        
        for (size_t j = 0; j < size - pattern_len; j++) {
            if (memcmp(data + j, avx2_patterns[i].pattern, pattern_len) == 0) {
                count++;
            }
        }
        
        if (count > 0) {
            printf("AVX2: %s - %d instances (%d-byte vectors)\n", 
                   avx2_patterns[i].description, count, avx2_patterns[i].vector_size);
            total_simd_instructions += count;
        }
    }
    
    if (total_simd_instructions == 0) {
        printf("No SIMD instructions detected in this section.\n");
    } else {
        printf("\nTotal SIMD instructions found: %d\n", total_simd_instructions);
    }
}

// Analyze memory access patterns
void analyze_memory_patterns(unsigned char* data, size_t size) {
    printf("\nMemory Access Pattern Analysis:\n");
    printf("===============================\n");
    
    // Look for common memory access patterns
    int mov_instructions = 0;
    int lea_instructions = 0;
    int call_instructions = 0;
    int jump_instructions = 0;
    
    for (size_t i = 0; i < size - 1; i++) {
        // MOV instructions
        if (data[i] == 0x8b || data[i] == 0x89) { // MOV reg,mem or MOV mem,reg
            mov_instructions++;
        }
        // LEA instructions
        else if (data[i] == 0x8d) { // LEA
            lea_instructions++;
        }
        // CALL instructions
        else if (data[i] == 0xe8) { // CALL
            call_instructions++;
        }
        // JMP instructions
        else if (data[i] == 0xe9 || data[i] == 0xeb) { // JMP
            jump_instructions++;
        }
    }
    
    printf("Memory access instructions: %d\n", mov_instructions);
    printf("Address calculation instructions (LEA): %d\n", lea_instructions);
    printf("Function calls: %d\n", call_instructions);
    printf("Jump instructions: %d\n", jump_instructions);
    
    // Calculate instruction density
    float instruction_density = (float)(mov_instructions + lea_instructions) / size * 100;
    printf("Memory instruction density: %.2f%%\n", instruction_density);
}

// Main analysis function
void analyze_binary_vectorization(const char* filename) {
    BinaryInfo bin;
    
    printf("Binary Vectorization Analysis Tool\n");
    printf("==================================\n");
    printf("Analyzing file: %s\n\n", filename);
    
    if (load_binary(filename, &bin) != 0) {
        return;
    }
    
    printf("ELF Header Information:\n");
    printf("Machine: %d\n", bin.ehdr.e_machine);
    printf("Entry point: 0x%lx\n", bin.ehdr.e_entry);
    printf("Number of sections: %d\n", bin.num_sections);
    
    // Analyze each executable section
    for (int i = 0; i < bin.num_sections; i++) {
        search_simd_patterns(bin.sections[i].data, bin.sections[i].size, 
                           bin.sections[i].name);
        analyze_memory_patterns(bin.sections[i].data, bin.sections[i].size);
    }
    
    // Cleanup
    for (int i = 0; i < bin.num_sections; i++) {
        free(bin.sections[i].data);
    }
}

int main(int argc, char* argv[]) {
    if (argc != 2) {
        printf("Usage: %s <binary_file>\n", argv[0]);
        printf("Example: %s ./vectorization_test\n", argv[0]);
        return 1;
    }
    
    analyze_binary_vectorization(argv[1]);
    return 0;
} 