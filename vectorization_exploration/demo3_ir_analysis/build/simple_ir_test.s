	.file	"simple_ir_test.c"
# GNU C17 (Ubuntu 13.1.0-8ubuntu1~22.04) version 13.1.0 (x86_64-linux-gnu)
#	compiled by GNU C version 13.1.0, GMP version 6.2.1, MPFR version 4.1.0, MPC version 1.2.1, isl version isl-0.24-GMP

# GGC heuristics: --param ggc-min-expand=100 --param ggc-min-heapsize=131072
# options passed: -mtune=generic -march=x86-64 -O2 -fasynchronous-unwind-tables -fstack-protector-strong -fstack-clash-protection -fcf-protection
	.text
	.p2align 4
	.globl	simple_vectorizable
	.type	simple_vectorizable, @function
simple_vectorizable:
.LFB39:
	.cfi_startproc
	endbr64	
# src/simple_ir_test.c:9:     for (int i = 0; i < n; i++) {
	testl	%ecx, %ecx	# n
	jle	.L1	#,
	movslq	%ecx, %rcx	# n, n
	xorl	%eax, %eax	# ivtmp.15
	salq	$2, %rcx	#, _23
	.p2align 4,,10
	.p2align 3
.L3:
# src/simple_ir_test.c:10:         c[i] = a[i] + b[i];
	movss	(%rdi,%rax), %xmm0	# MEM[(float *)a_13(D) + ivtmp.15_25 * 1], MEM[(float *)a_13(D) + ivtmp.15_25 * 1]
	addss	(%rsi,%rax), %xmm0	# MEM[(float *)b_14(D) + ivtmp.15_25 * 1], tmp93
# src/simple_ir_test.c:10:         c[i] = a[i] + b[i];
	movss	%xmm0, (%rdx,%rax)	# tmp93, MEM[(float *)c_15(D) + ivtmp.15_25 * 1]
# src/simple_ir_test.c:9:     for (int i = 0; i < n; i++) {
	addq	$4, %rax	#, ivtmp.15
	cmpq	%rax, %rcx	# ivtmp.15, _23
	jne	.L3	#,
.L1:
# src/simple_ir_test.c:12: }
	ret	
	.cfi_endproc
.LFE39:
	.size	simple_vectorizable, .-simple_vectorizable
	.p2align 4
	.globl	complex_loop
	.type	complex_loop, @function
complex_loop:
.LFB40:
	.cfi_startproc
	endbr64	
	movslq	%ecx, %r8	# n, n
# src/simple_ir_test.c:18:             c[i] = a[i] * b[i] + 1.0f;
	movss	.LC1(%rip), %xmm3	#, tmp97
# src/simple_ir_test.c:16:     for (int i = 0; i < n; i++) {
	xorl	%eax, %eax	# ivtmp.28
# src/simple_ir_test.c:17:         if (a[i] > 0.0f) {
	pxor	%xmm2, %xmm2	# tmp94
	salq	$2, %r8	#, _16
# src/simple_ir_test.c:16:     for (int i = 0; i < n; i++) {
	testl	%ecx, %ecx	# n
	jg	.L11	#,
	ret	
	.p2align 4,,10
	.p2align 3
.L17:
# src/simple_ir_test.c:18:             c[i] = a[i] * b[i] + 1.0f;
	mulss	%xmm1, %xmm0	# pretmp_31, tmp95
# src/simple_ir_test.c:18:             c[i] = a[i] * b[i] + 1.0f;
	addss	%xmm3, %xmm0	# tmp97, _9
# src/simple_ir_test.c:18:             c[i] = a[i] * b[i] + 1.0f;
	movss	%xmm0, (%rdx,%rax)	# _9, MEM[(float *)c_21(D) + ivtmp.28_23 * 1]
# src/simple_ir_test.c:16:     for (int i = 0; i < n; i++) {
	addq	$4, %rax	#, ivtmp.28
	cmpq	%rax, %r8	# ivtmp.28, _16
	je	.L6	#,
.L11:
# src/simple_ir_test.c:17:         if (a[i] > 0.0f) {
	movss	(%rdi,%rax), %xmm0	# MEM[(float *)a_19(D) + ivtmp.28_23 * 1], _4
# src/simple_ir_test.c:18:             c[i] = a[i] * b[i] + 1.0f;
	movss	(%rsi,%rax), %xmm1	# MEM[(float *)b_20(D) + ivtmp.28_23 * 1], pretmp_31
# src/simple_ir_test.c:17:         if (a[i] > 0.0f) {
	comiss	%xmm2, %xmm0	# tmp94, _4
	ja	.L17	#,
# src/simple_ir_test.c:20:             c[i] = a[i] - b[i];
	subss	%xmm1, %xmm0	# pretmp_31, _9
# src/simple_ir_test.c:18:             c[i] = a[i] * b[i] + 1.0f;
	movss	%xmm0, (%rdx,%rax)	# _9, MEM[(float *)c_21(D) + ivtmp.28_23 * 1]
# src/simple_ir_test.c:16:     for (int i = 0; i < n; i++) {
	addq	$4, %rax	#, ivtmp.28
	cmpq	%rax, %r8	# ivtmp.28, _16
	jne	.L11	#,
.L6:
# src/simple_ir_test.c:23: }
	ret	
	.cfi_endproc
.LFE40:
	.size	complex_loop, .-complex_loop
	.p2align 4
	.globl	reduction_loop
	.type	reduction_loop, @function
reduction_loop:
.LFB41:
	.cfi_startproc
	endbr64	
# src/simple_ir_test.c:28:     for (int i = 0; i < n; i++) {
	testl	%esi, %esi	# n
	jle	.L21	#,
	movslq	%esi, %rsi	# n, n
# src/simple_ir_test.c:27:     float sum = 0.0f;
	pxor	%xmm0, %xmm0	# <retval>
	leaq	(%rdi,%rsi,4), %rax	#, _21
	andl	$1, %esi	#, n
	je	.L20	#,
# src/simple_ir_test.c:29:         sum += a[i];
	addss	(%rdi), %xmm0	# MEM[(float *)_5], <retval>
# src/simple_ir_test.c:28:     for (int i = 0; i < n; i++) {
	addq	$4, %rdi	#, ivtmp.36
	cmpq	%rax, %rdi	# _21, ivtmp.36
	je	.L28	#,
	.p2align 4,,10
	.p2align 3
.L20:
# src/simple_ir_test.c:29:         sum += a[i];
	addss	(%rdi), %xmm0	# MEM[(float *)_5], <retval>
# src/simple_ir_test.c:28:     for (int i = 0; i < n; i++) {
	addq	$8, %rdi	#, ivtmp.36
# src/simple_ir_test.c:29:         sum += a[i];
	addss	-4(%rdi), %xmm0	# MEM[(float *)_5], <retval>
# src/simple_ir_test.c:28:     for (int i = 0; i < n; i++) {
	cmpq	%rax, %rdi	# _21, ivtmp.36
	jne	.L20	#,
	ret	
	.p2align 4,,10
	.p2align 3
.L21:
# src/simple_ir_test.c:27:     float sum = 0.0f;
	pxor	%xmm0, %xmm0	# <retval>
# src/simple_ir_test.c:32: }
	ret	
.L28:
	ret	
	.cfi_endproc
.LFE41:
	.size	reduction_loop, .-reduction_loop
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC3:
	.string	"Simple IR Level Vectorization Analysis Test"
	.align 8
.LC4:
	.string	"==========================================\n"
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC5:
	.string	"Memory allocation failed!"
	.section	.rodata.str1.8
	.align 8
.LC7:
	.string	"Test Case 1: Simple vectorizable loop"
	.align 8
.LC9:
	.string	"Time: %f seconds (1000 iterations)\n"
	.align 8
.LC10:
	.string	"\nTest Case 2: Complex loop with conditionals"
	.section	.rodata.str1.1
.LC11:
	.string	"\nTest Case 3: Reduction loop"
	.section	.rodata.str1.8
	.align 8
.LC12:
	.string	"Time: %f seconds (1000 iterations), Sum: %f\n"
	.align 8
.LC13:
	.string	"\nSimple IR analysis test completed."
	.section	.text.startup,"ax",@progbits
	.p2align 4
	.globl	main
	.type	main, @function
main:
.LFB42:
	.cfi_startproc
	endbr64	
	pushq	%r14	#
	.cfi_def_cfa_offset 16
	.cfi_offset 14, -16
# /usr/include/x86_64-linux-gnu/bits/stdio2.h:112:   return __printf_chk (__USE_FORTIFY_LEVEL - 1, __fmt, __va_arg_pack ());
	leaq	.LC3(%rip), %rdi	#, tmp138
# src/simple_ir_test.c:34: int main() {
	pushq	%r13	#
	.cfi_def_cfa_offset 24
	.cfi_offset 13, -24
	pushq	%r12	#
	.cfi_def_cfa_offset 32
	.cfi_offset 12, -32
	pushq	%rbp	#
	.cfi_def_cfa_offset 40
	.cfi_offset 6, -40
	pushq	%rbx	#
	.cfi_def_cfa_offset 48
	.cfi_offset 3, -48
	subq	$16, %rsp	#,
	.cfi_def_cfa_offset 64
# /usr/include/x86_64-linux-gnu/bits/stdio2.h:112:   return __printf_chk (__USE_FORTIFY_LEVEL - 1, __fmt, __va_arg_pack ());
	call	puts@PLT	#
	leaq	.LC4(%rip), %rdi	#, tmp139
	call	puts@PLT	#
# src/simple_ir_test.c:39:     float* a = malloc(SIZE * sizeof(float));
	movl	$400, %edi	#,
	call	malloc@PLT	#
# src/simple_ir_test.c:40:     float* b = malloc(SIZE * sizeof(float));
	movl	$400, %edi	#,
# src/simple_ir_test.c:39:     float* a = malloc(SIZE * sizeof(float));
	movq	%rax, %rbx	# tmp190, a
# src/simple_ir_test.c:40:     float* b = malloc(SIZE * sizeof(float));
	call	malloc@PLT	#
# src/simple_ir_test.c:41:     float* c = malloc(SIZE * sizeof(float));
	movl	$400, %edi	#,
# src/simple_ir_test.c:40:     float* b = malloc(SIZE * sizeof(float));
	movq	%rax, %rbp	# tmp191, b
# src/simple_ir_test.c:41:     float* c = malloc(SIZE * sizeof(float));
	call	malloc@PLT	#
# src/simple_ir_test.c:43:     if (!a || !b || !c) {
	testq	%rbx, %rbx	# a
# src/simple_ir_test.c:41:     float* c = malloc(SIZE * sizeof(float));
	movq	%rax, %r12	# tmp192, c
# src/simple_ir_test.c:43:     if (!a || !b || !c) {
	sete	%al	#, tmp144
# src/simple_ir_test.c:43:     if (!a || !b || !c) {
	testq	%rbp, %rbp	# b
	sete	%dl	#, tmp146
# src/simple_ir_test.c:43:     if (!a || !b || !c) {
	orb	%dl, %al	# tmp146, tmp199
	jne	.L46	#,
	testq	%r12, %r12	# c
	je	.L46	#,
	movdqa	.LC2(%rip), %xmm1	#, vect_vec_iv_.61
	movdqa	.LC6(%rip), %xmm3	#, tmp183
	xorl	%eax, %eax	# ivtmp.116
	.p2align 4,,10
	.p2align 3
.L30:
	movdqa	%xmm1, %xmm0	# vect_vec_iv_.61, vect_vec_iv_.61
	paddd	%xmm3, %xmm1	# tmp183, vect_vec_iv_.61
# src/simple_ir_test.c:50:         a[i] = (float)i;
	cvtdq2ps	%xmm0, %xmm2	# vect_vec_iv_.61, vect__7.62
# src/simple_ir_test.c:51:         b[i] = (float)(i * 2);
	pslld	$1, %xmm0	#, vect__8.65
# src/simple_ir_test.c:50:         a[i] = (float)i;
	movups	%xmm2, (%rbx,%rax)	# vect__7.62, MEM <vector(4) float> [(float *)a_34 + ivtmp.116_23 * 1]
# src/simple_ir_test.c:51:         b[i] = (float)(i * 2);
	cvtdq2ps	%xmm0, %xmm0	# vect__8.65, vect__10.66
# src/simple_ir_test.c:51:         b[i] = (float)(i * 2);
	movups	%xmm0, 0(%rbp,%rax)	# vect__10.66, MEM <vector(4) float> [(float *)b_36 + ivtmp.116_23 * 1]
	addq	$16, %rax	#, ivtmp.116
	cmpq	$400, %rax	#, ivtmp.116
	jne	.L30	#,
# /usr/include/x86_64-linux-gnu/bits/stdio2.h:112:   return __printf_chk (__USE_FORTIFY_LEVEL - 1, __fmt, __va_arg_pack ());
	leaq	.LC7(%rip), %rdi	#, tmp155
	call	puts@PLT	#
# src/simple_ir_test.c:56:     clock_t start = clock();
	call	clock@PLT	#
	movl	$1000, %edx	#, ivtmp_25
	movq	%rax, %r13	# tmp193, start
	.p2align 4,,10
	.p2align 3
.L33:
	xorl	%eax, %eax	# ivtmp.101
	.p2align 4,,10
	.p2align 3
.L34:
# src/simple_ir_test.c:10:         c[i] = a[i] + b[i];
	movups	(%rbx,%rax), %xmm0	# MEM <vector(4) float> [(float *)a_34 + ivtmp.101_10 * 1], vect__71.58
	movups	0(%rbp,%rax), %xmm4	# MEM <vector(4) float> [(float *)b_36 + ivtmp.101_10 * 1], tmp202
	addps	%xmm4, %xmm0	# tmp202, vect__71.58
# src/simple_ir_test.c:10:         c[i] = a[i] + b[i];
	movups	%xmm0, (%r12,%rax)	# vect__71.58, MEM <vector(4) float> [(float *)c_38 + ivtmp.101_10 * 1]
	addq	$16, %rax	#, ivtmp.101
	cmpq	$400, %rax	#, ivtmp.101
	jne	.L34	#,
# src/simple_ir_test.c:57:     for (int iter = 0; iter < 1000; iter++) {
	subl	$1, %edx	#, ivtmp_25
	jne	.L33	#,
# src/simple_ir_test.c:60:     clock_t end = clock();
	call	clock@PLT	#
# src/simple_ir_test.c:62:            ((double)(end - start)) / CLOCKS_PER_SEC);
	pxor	%xmm0, %xmm0	# tmp160
# /usr/include/x86_64-linux-gnu/bits/stdio2.h:112:   return __printf_chk (__USE_FORTIFY_LEVEL - 1, __fmt, __va_arg_pack ());
	movl	$1, %edi	#,
# src/simple_ir_test.c:62:            ((double)(end - start)) / CLOCKS_PER_SEC);
	subq	%r13, %rax	# start, tmp159
# /usr/include/x86_64-linux-gnu/bits/stdio2.h:112:   return __printf_chk (__USE_FORTIFY_LEVEL - 1, __fmt, __va_arg_pack ());
	leaq	.LC9(%rip), %r13	#, tmp185
	movq	%r13, %rsi	# tmp185,
# src/simple_ir_test.c:62:            ((double)(end - start)) / CLOCKS_PER_SEC);
	cvtsi2sdq	%rax, %xmm0	# tmp159, tmp160
# /usr/include/x86_64-linux-gnu/bits/stdio2.h:112:   return __printf_chk (__USE_FORTIFY_LEVEL - 1, __fmt, __va_arg_pack ());
	movl	$1, %eax	#,
# src/simple_ir_test.c:61:     printf("Time: %f seconds (1000 iterations)\n", 
	divsd	.LC8(%rip), %xmm0	#, tmp161
# /usr/include/x86_64-linux-gnu/bits/stdio2.h:112:   return __printf_chk (__USE_FORTIFY_LEVEL - 1, __fmt, __va_arg_pack ());
	call	__printf_chk@PLT	#
	leaq	.LC10(%rip), %rdi	#, tmp164
	call	puts@PLT	#
# src/simple_ir_test.c:66:     start = clock();
	call	clock@PLT	#
	movl	$1000, %edx	#, ivtmp_78
# src/simple_ir_test.c:17:         if (a[i] > 0.0f) {
	pxor	%xmm2, %xmm2	# tmp165
# src/simple_ir_test.c:18:             c[i] = a[i] * b[i] + 1.0f;
	movss	.LC1(%rip), %xmm3	#, tmp188
# src/simple_ir_test.c:66:     start = clock();
	movq	%rax, %r14	# tmp195, start
	.p2align 4,,10
	.p2align 3
.L36:
# src/simple_ir_test.c:56:     clock_t start = clock();
	xorl	%eax, %eax	# ivtmp.92
	jmp	.L40	#
	.p2align 4,,10
	.p2align 3
.L55:
# src/simple_ir_test.c:18:             c[i] = a[i] * b[i] + 1.0f;
	mulss	%xmm1, %xmm0	# pretmp_93, tmp166
# src/simple_ir_test.c:18:             c[i] = a[i] * b[i] + 1.0f;
	addss	%xmm3, %xmm0	# tmp188, _102
.L39:
# src/simple_ir_test.c:18:             c[i] = a[i] * b[i] + 1.0f;
	movss	%xmm0, (%r12,%rax)	# _102, MEM[(float *)c_38 + ivtmp.92_8 * 1]
# src/simple_ir_test.c:16:     for (int i = 0; i < n; i++) {
	addq	$4, %rax	#, ivtmp.92
	cmpq	$400, %rax	#, ivtmp.92
	je	.L54	#,
.L40:
# src/simple_ir_test.c:17:         if (a[i] > 0.0f) {
	movss	(%rbx,%rax), %xmm0	# MEM[(float *)a_34 + ivtmp.92_8 * 1], _97
# src/simple_ir_test.c:18:             c[i] = a[i] * b[i] + 1.0f;
	movss	0(%rbp,%rax), %xmm1	# MEM[(float *)b_36 + ivtmp.92_8 * 1], pretmp_93
# src/simple_ir_test.c:17:         if (a[i] > 0.0f) {
	comiss	%xmm2, %xmm0	# tmp165, _97
	ja	.L55	#,
# src/simple_ir_test.c:20:             c[i] = a[i] - b[i];
	subss	%xmm1, %xmm0	# pretmp_93, _102
	jmp	.L39	#
	.p2align 4,,10
	.p2align 3
.L54:
# src/simple_ir_test.c:67:     for (int iter = 0; iter < 1000; iter++) {
	subl	$1, %edx	#, ivtmp_78
	jne	.L36	#,
# src/simple_ir_test.c:70:     end = clock();
	call	clock@PLT	#
# src/simple_ir_test.c:72:            ((double)(end - start)) / CLOCKS_PER_SEC);
	pxor	%xmm0, %xmm0	# tmp169
# /usr/include/x86_64-linux-gnu/bits/stdio2.h:112:   return __printf_chk (__USE_FORTIFY_LEVEL - 1, __fmt, __va_arg_pack ());
	movq	%r13, %rsi	# tmp185,
	movl	$1, %edi	#,
# src/simple_ir_test.c:72:            ((double)(end - start)) / CLOCKS_PER_SEC);
	subq	%r14, %rax	# start, tmp168
# src/simple_ir_test.c:72:            ((double)(end - start)) / CLOCKS_PER_SEC);
	cvtsi2sdq	%rax, %xmm0	# tmp168, tmp169
# /usr/include/x86_64-linux-gnu/bits/stdio2.h:112:   return __printf_chk (__USE_FORTIFY_LEVEL - 1, __fmt, __va_arg_pack ());
	movl	$1, %eax	#,
# src/simple_ir_test.c:71:     printf("Time: %f seconds (1000 iterations)\n", 
	divsd	.LC8(%rip), %xmm0	#, tmp170
# /usr/include/x86_64-linux-gnu/bits/stdio2.h:112:   return __printf_chk (__USE_FORTIFY_LEVEL - 1, __fmt, __va_arg_pack ());
	call	__printf_chk@PLT	#
	leaq	.LC11(%rip), %rdi	#, tmp173
	call	puts@PLT	#
# src/simple_ir_test.c:76:     start = clock();
	call	clock@PLT	#
	movl	$1000, %ecx	#, ivtmp_125
	leaq	400(%rbx), %rdx	#, _7
	movq	%rax, %r13	# tmp197, start
	.p2align 4,,10
	.p2align 3
.L42:
	movq	%rbx, %rax	# a, ivtmp.74
# src/simple_ir_test.c:27:     float sum = 0.0f;
	pxor	%xmm1, %xmm1	# sum
	.p2align 4,,10
	.p2align 3
.L43:
	addss	(%rax), %xmm1	# BIT_FIELD_REF <MEM <vector(4) float> [(float *)_6], 32, 0>, stmp_sum_79.51
	addq	$16, %rax	#, ivtmp.74
	addss	-12(%rax), %xmm1	# BIT_FIELD_REF <MEM <vector(4) float> [(float *)_6], 32, 32>, stmp_sum_79.51
# src/simple_ir_test.c:29:         sum += a[i];
	addss	-8(%rax), %xmm1	# BIT_FIELD_REF <MEM <vector(4) float> [(float *)_6], 32, 64>, stmp_sum_79.51
	addss	-4(%rax), %xmm1	# BIT_FIELD_REF <MEM <vector(4) float> [(float *)_6], 32, 96>, sum
	cmpq	%rax, %rdx	# ivtmp.74, _7
	jne	.L43	#,
# src/simple_ir_test.c:78:     for (int iter = 0; iter < 1000; iter++) {
	subl	$1, %ecx	#, ivtmp_125
	jne	.L42	#,
	movss	%xmm1, 12(%rsp)	# sum, %sfp
# src/simple_ir_test.c:81:     end = clock();
	call	clock@PLT	#
# /usr/include/x86_64-linux-gnu/bits/stdio2.h:112:   return __printf_chk (__USE_FORTIFY_LEVEL - 1, __fmt, __va_arg_pack ());
	movss	12(%rsp), %xmm1	# %sfp, sum
# src/simple_ir_test.c:83:            ((double)(end - start)) / CLOCKS_PER_SEC, sum);
	pxor	%xmm0, %xmm0	# tmp177
# /usr/include/x86_64-linux-gnu/bits/stdio2.h:112:   return __printf_chk (__USE_FORTIFY_LEVEL - 1, __fmt, __va_arg_pack ());
	leaq	.LC12(%rip), %rsi	#, tmp180
# src/simple_ir_test.c:83:            ((double)(end - start)) / CLOCKS_PER_SEC, sum);
	subq	%r13, %rax	# start, tmp176
# /usr/include/x86_64-linux-gnu/bits/stdio2.h:112:   return __printf_chk (__USE_FORTIFY_LEVEL - 1, __fmt, __va_arg_pack ());
	movl	$1, %edi	#,
# src/simple_ir_test.c:83:            ((double)(end - start)) / CLOCKS_PER_SEC, sum);
	cvtsi2sdq	%rax, %xmm0	# tmp176, tmp177
# /usr/include/x86_64-linux-gnu/bits/stdio2.h:112:   return __printf_chk (__USE_FORTIFY_LEVEL - 1, __fmt, __va_arg_pack ());
	movl	$2, %eax	#,
# src/simple_ir_test.c:82:     printf("Time: %f seconds (1000 iterations), Sum: %f\n", 
	divsd	.LC8(%rip), %xmm0	#, tmp178
# /usr/include/x86_64-linux-gnu/bits/stdio2.h:112:   return __printf_chk (__USE_FORTIFY_LEVEL - 1, __fmt, __va_arg_pack ());
	cvtss2sd	%xmm1, %xmm1	# sum,
	call	__printf_chk@PLT	#
# src/simple_ir_test.c:86:     free(a);
	movq	%rbx, %rdi	# a,
	call	free@PLT	#
# src/simple_ir_test.c:87:     free(b);
	movq	%rbp, %rdi	# b,
	call	free@PLT	#
# src/simple_ir_test.c:88:     free(c);
	movq	%r12, %rdi	# c,
	call	free@PLT	#
# /usr/include/x86_64-linux-gnu/bits/stdio2.h:112:   return __printf_chk (__USE_FORTIFY_LEVEL - 1, __fmt, __va_arg_pack ());
	leaq	.LC13(%rip), %rdi	#, tmp181
	call	puts@PLT	#
# src/simple_ir_test.c:91:     return 0;
	xorl	%eax, %eax	# <retval>
.L29:
# src/simple_ir_test.c:92: } 
	addq	$16, %rsp	#,
	.cfi_remember_state
	.cfi_def_cfa_offset 48
	popq	%rbx	#
	.cfi_def_cfa_offset 40
	popq	%rbp	#
	.cfi_def_cfa_offset 32
	popq	%r12	#
	.cfi_def_cfa_offset 24
	popq	%r13	#
	.cfi_def_cfa_offset 16
	popq	%r14	#
	.cfi_def_cfa_offset 8
	ret	
.L46:
	.cfi_restore_state
# /usr/include/x86_64-linux-gnu/bits/stdio2.h:112:   return __printf_chk (__USE_FORTIFY_LEVEL - 1, __fmt, __va_arg_pack ());
	leaq	.LC5(%rip), %rdi	#, tmp150
	call	puts@PLT	#
# src/simple_ir_test.c:45:         return 1;
	movl	$1, %eax	#, <retval>
	jmp	.L29	#
	.cfi_endproc
.LFE42:
	.size	main, .-main
	.section	.rodata.cst4,"aM",@progbits,4
	.align 4
.LC1:
	.long	1065353216
	.section	.rodata.cst16,"aM",@progbits,16
	.align 16
.LC2:
	.long	0
	.long	1
	.long	2
	.long	3
	.align 16
.LC6:
	.long	4
	.long	4
	.long	4
	.long	4
	.section	.rodata.cst8,"aM",@progbits,8
	.align 8
.LC8:
	.long	0
	.long	1093567616
	.ident	"GCC: (Ubuntu 13.1.0-8ubuntu1~22.04) 13.1.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	1f - 0f
	.long	4f - 1f
	.long	5
0:
	.string	"GNU"
1:
	.align 8
	.long	0xc0000002
	.long	3f - 2f
2:
	.long	0x3
3:
	.align 8
4:
