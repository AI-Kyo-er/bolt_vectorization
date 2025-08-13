	.file	"ir_analysis_test.c"
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
# src/ir_analysis_test.c:9:     for (int i = 0; i < n; i++) {
	testl	%ecx, %ecx	# n
	jle	.L1	#,
	movslq	%ecx, %rcx	# n, n
	xorl	%eax, %eax	# ivtmp.21
	salq	$2, %rcx	#, _23
	.p2align 4,,10
	.p2align 3
.L3:
# src/ir_analysis_test.c:10:         c[i] = a[i] + b[i];
	movss	(%rdi,%rax), %xmm0	# MEM[(float *)a_13(D) + ivtmp.21_25 * 1], MEM[(float *)a_13(D) + ivtmp.21_25 * 1]
	addss	(%rsi,%rax), %xmm0	# MEM[(float *)b_14(D) + ivtmp.21_25 * 1], tmp93
# src/ir_analysis_test.c:10:         c[i] = a[i] + b[i];
	movss	%xmm0, (%rdx,%rax)	# tmp93, MEM[(float *)c_15(D) + ivtmp.21_25 * 1]
# src/ir_analysis_test.c:9:     for (int i = 0; i < n; i++) {
	addq	$4, %rax	#, ivtmp.21
	cmpq	%rax, %rcx	# ivtmp.21, _23
	jne	.L3	#,
.L1:
# src/ir_analysis_test.c:12: }
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
# src/ir_analysis_test.c:18:             c[i] = a[i] * b[i] + 1.0f;
	movss	.LC1(%rip), %xmm3	#, tmp97
# src/ir_analysis_test.c:16:     for (int i = 0; i < n; i++) {
	xorl	%eax, %eax	# ivtmp.34
# src/ir_analysis_test.c:17:         if (a[i] > 0.0f) {
	pxor	%xmm2, %xmm2	# tmp94
	salq	$2, %r8	#, _16
# src/ir_analysis_test.c:16:     for (int i = 0; i < n; i++) {
	testl	%ecx, %ecx	# n
	jg	.L11	#,
	ret	
	.p2align 4,,10
	.p2align 3
.L17:
# src/ir_analysis_test.c:18:             c[i] = a[i] * b[i] + 1.0f;
	mulss	%xmm1, %xmm0	# pretmp_31, tmp95
# src/ir_analysis_test.c:18:             c[i] = a[i] * b[i] + 1.0f;
	addss	%xmm3, %xmm0	# tmp97, _9
# src/ir_analysis_test.c:18:             c[i] = a[i] * b[i] + 1.0f;
	movss	%xmm0, (%rdx,%rax)	# _9, MEM[(float *)c_21(D) + ivtmp.34_23 * 1]
# src/ir_analysis_test.c:16:     for (int i = 0; i < n; i++) {
	addq	$4, %rax	#, ivtmp.34
	cmpq	%rax, %r8	# ivtmp.34, _16
	je	.L6	#,
.L11:
# src/ir_analysis_test.c:17:         if (a[i] > 0.0f) {
	movss	(%rdi,%rax), %xmm0	# MEM[(float *)a_19(D) + ivtmp.34_23 * 1], _4
# src/ir_analysis_test.c:18:             c[i] = a[i] * b[i] + 1.0f;
	movss	(%rsi,%rax), %xmm1	# MEM[(float *)b_20(D) + ivtmp.34_23 * 1], pretmp_31
# src/ir_analysis_test.c:17:         if (a[i] > 0.0f) {
	comiss	%xmm2, %xmm0	# tmp94, _4
	ja	.L17	#,
# src/ir_analysis_test.c:20:             c[i] = a[i] - b[i];
	subss	%xmm1, %xmm0	# pretmp_31, _9
# src/ir_analysis_test.c:18:             c[i] = a[i] * b[i] + 1.0f;
	movss	%xmm0, (%rdx,%rax)	# _9, MEM[(float *)c_21(D) + ivtmp.34_23 * 1]
# src/ir_analysis_test.c:16:     for (int i = 0; i < n; i++) {
	addq	$4, %rax	#, ivtmp.34
	cmpq	%rax, %r8	# ivtmp.34, _16
	jne	.L11	#,
.L6:
# src/ir_analysis_test.c:23: }
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
# src/ir_analysis_test.c:28:     for (int i = 0; i < n; i++) {
	testl	%esi, %esi	# n
	jle	.L21	#,
	movslq	%esi, %rsi	# n, n
# src/ir_analysis_test.c:27:     float sum = 0.0f;
	pxor	%xmm0, %xmm0	# <retval>
	leaq	(%rdi,%rsi,4), %rax	#, _21
	andl	$1, %esi	#, n
	je	.L20	#,
# src/ir_analysis_test.c:29:         sum += a[i];
	addss	(%rdi), %xmm0	# MEM[(float *)_5], <retval>
# src/ir_analysis_test.c:28:     for (int i = 0; i < n; i++) {
	addq	$4, %rdi	#, ivtmp.42
	cmpq	%rax, %rdi	# _21, ivtmp.42
	je	.L28	#,
	.p2align 4,,10
	.p2align 3
.L20:
# src/ir_analysis_test.c:29:         sum += a[i];
	addss	(%rdi), %xmm0	# MEM[(float *)_5], <retval>
# src/ir_analysis_test.c:28:     for (int i = 0; i < n; i++) {
	addq	$8, %rdi	#, ivtmp.42
# src/ir_analysis_test.c:29:         sum += a[i];
	addss	-4(%rdi), %xmm0	# MEM[(float *)_5], <retval>
# src/ir_analysis_test.c:28:     for (int i = 0; i < n; i++) {
	cmpq	%rax, %rdi	# _21, ivtmp.42
	jne	.L20	#,
	ret	
	.p2align 4,,10
	.p2align 3
.L21:
# src/ir_analysis_test.c:27:     float sum = 0.0f;
	pxor	%xmm0, %xmm0	# <retval>
# src/ir_analysis_test.c:32: }
	ret	
.L28:
	ret	
	.cfi_endproc
.LFE41:
	.size	reduction_loop, .-reduction_loop
	.p2align 4
	.globl	loop_with_function
	.type	loop_with_function, @function
loop_with_function:
.LFB42:
	.cfi_startproc
	endbr64	
# src/ir_analysis_test.c:38: void loop_with_function(float* a, float* b, float* c, int n) {
	movq	%rsi, %r8	# tmp123, b
	movq	%rdx, %r9	# tmp124, c
# src/ir_analysis_test.c:39:     for (int i = 0; i < n; i++) {
	testl	%ecx, %ecx	# n
	jle	.L29	#,
	movslq	%ecx, %rcx	# n, _31
	xorl	%eax, %eax	# ivtmp.49
# src/ir_analysis_test.c:45:     return (float)(x % 10);
	movl	$3435973837, %r10d	#, tmp101
	.p2align 4,,10
	.p2align 3
.L31:
	movl	%eax, %edx	# ivtmp.49, ivtmp.49
	movl	%eax, %esi	# ivtmp.49, tmp107
# src/ir_analysis_test.c:45:     return (float)(x % 10);
	pxor	%xmm1, %xmm1	# tmp120
# src/ir_analysis_test.c:40:         c[i] = a[i] + b[i] + some_function(i);
	movss	(%rdi,%rax,4), %xmm0	# MEM[(float *)a_14(D) + ivtmp.49_28 * 4], MEM[(float *)a_14(D) + ivtmp.49_28 * 4]
# src/ir_analysis_test.c:45:     return (float)(x % 10);
	imulq	%r10, %rdx	# tmp101, tmp100
# src/ir_analysis_test.c:40:         c[i] = a[i] + b[i] + some_function(i);
	addss	(%r8,%rax,4), %xmm0	# MEM[(float *)b_15(D) + ivtmp.49_28 * 4], tmp95
# src/ir_analysis_test.c:45:     return (float)(x % 10);
	shrq	$35, %rdx	#, tmp97
	leal	(%rdx,%rdx,4), %edx	#, tmp105
	addl	%edx, %edx	# tmp106
	subl	%edx, %esi	# tmp106, tmp107
# src/ir_analysis_test.c:45:     return (float)(x % 10);
	cvtsi2ssl	%esi, %xmm1	# tmp107, tmp120
# src/ir_analysis_test.c:40:         c[i] = a[i] + b[i] + some_function(i);
	addss	%xmm1, %xmm0	# tmp120, tmp121
# src/ir_analysis_test.c:40:         c[i] = a[i] + b[i] + some_function(i);
	movss	%xmm0, (%r9,%rax,4)	# tmp121, MEM[(float *)c_17(D) + ivtmp.49_28 * 4]
# src/ir_analysis_test.c:39:     for (int i = 0; i < n; i++) {
	addq	$1, %rax	#, ivtmp.49
	cmpq	%rcx, %rax	# _31, ivtmp.49
	jne	.L31	#,
.L29:
# src/ir_analysis_test.c:42: }
	ret	
	.cfi_endproc
.LFE42:
	.size	loop_with_function, .-loop_with_function
	.p2align 4
	.globl	some_function
	.type	some_function, @function
some_function:
.LFB43:
	.cfi_startproc
	endbr64	
# src/ir_analysis_test.c:45:     return (float)(x % 10);
	movslq	%edi, %rax	# x, x
	movl	%edi, %edx	# x, tmp91
# src/ir_analysis_test.c:45:     return (float)(x % 10);
	pxor	%xmm0, %xmm0	# tmp85
# src/ir_analysis_test.c:45:     return (float)(x % 10);
	imulq	$1717986919, %rax, %rax	#, x, tmp88
	sarl	$31, %edx	#, tmp91
	sarq	$34, %rax	#, tmp90
	subl	%edx, %eax	# tmp91, tmp86
	leal	(%rax,%rax,4), %eax	#, tmp94
	addl	%eax, %eax	# tmp95
	subl	%eax, %edi	# tmp95, tmp96
# src/ir_analysis_test.c:45:     return (float)(x % 10);
	cvtsi2ssl	%edi, %xmm0	# tmp96, tmp85
# src/ir_analysis_test.c:46: }
	ret	
	.cfi_endproc
.LFE43:
	.size	some_function, .-some_function
	.p2align 4
	.globl	nested_loops
	.type	nested_loops, @function
nested_loops:
.LFB44:
	.cfi_startproc
	endbr64	
# src/ir_analysis_test.c:50:     for (int i = 0; i < n; i++) {
	testl	%ecx, %ecx	# n
	jle	.L34	#,
	movslq	%ecx, %rcx	# n, n
	salq	$2, %rcx	#, _27
	leaq	(%rdi,%rcx), %r8	#, _51
	.p2align 4,,10
	.p2align 3
.L36:
# src/ir_analysis_test.c:49: void nested_loops(float* a, float* b, float* c, int n) {
	xorl	%eax, %eax	# ivtmp.70
	.p2align 4,,10
	.p2align 3
.L37:
# src/ir_analysis_test.c:52:             c[i * n + j] = a[i] * b[j];
	movss	(%rdi), %xmm0	# MEM[(float *)_52], MEM[(float *)_52]
	mulss	(%rsi,%rax), %xmm0	# MEM[(float *)b_23(D) + ivtmp.70_39 * 1], tmp98
# src/ir_analysis_test.c:52:             c[i * n + j] = a[i] * b[j];
	movss	%xmm0, (%rdx,%rax)	# tmp98, MEM[(float *)_43 + ivtmp.70_39 * 1]
# src/ir_analysis_test.c:51:         for (int j = 0; j < n; j++) {
	addq	$4, %rax	#, ivtmp.70
	cmpq	%rax, %rcx	# ivtmp.70, _27
	jne	.L37	#,
# src/ir_analysis_test.c:50:     for (int i = 0; i < n; i++) {
	addq	$4, %rdi	#, ivtmp.75
	addq	%rcx, %rdx	# _27, ivtmp.77
	cmpq	%r8, %rdi	# _51, ivtmp.75
	jne	.L36	#,
.L34:
# src/ir_analysis_test.c:55: }
	ret	
	.cfi_endproc
.LFE44:
	.size	nested_loops, .-nested_loops
	.p2align 4
	.globl	loop_with_dependencies
	.type	loop_with_dependencies, @function
loop_with_dependencies:
.LFB45:
	.cfi_startproc
	endbr64	
# src/ir_analysis_test.c:59:     for (int i = 1; i < n; i++) {
	cmpl	$1, %edx	#, n
	jle	.L39	#,
	movss	(%rdi), %xmm1	# *a_16(D), D__lsm0.82
	movl	%edx, %edx	# n, _28
	movl	$1, %eax	#, ivtmp.86
	.p2align 4,,10
	.p2align 3
.L41:
# src/ir_analysis_test.c:60:         a[i] = a[i] + b[i] + a[i-1];
	movss	(%rdi,%rax,4), %xmm0	# MEM[(float *)a_16(D) + ivtmp.86_33 * 4], MEM[(float *)a_16(D) + ivtmp.86_33 * 4]
	addss	(%rsi,%rax,4), %xmm0	# MEM[(float *)b_17(D) + ivtmp.86_33 * 4], tmp92
# src/ir_analysis_test.c:60:         a[i] = a[i] + b[i] + a[i-1];
	addss	%xmm0, %xmm1	# tmp92, D__lsm0.82
# src/ir_analysis_test.c:60:         a[i] = a[i] + b[i] + a[i-1];
	movss	%xmm1, (%rdi,%rax,4)	# D__lsm0.82, MEM[(float *)a_16(D) + ivtmp.86_33 * 4]
# src/ir_analysis_test.c:59:     for (int i = 1; i < n; i++) {
	addq	$1, %rax	#, ivtmp.86
	cmpq	%rax, %rdx	# ivtmp.86, _28
	jne	.L41	#,
.L39:
# src/ir_analysis_test.c:62: }
	ret	
	.cfi_endproc
.LFE45:
	.size	loop_with_dependencies, .-loop_with_dependencies
	.p2align 4
	.globl	mixed_types
	.type	mixed_types, @function
mixed_types:
.LFB46:
	.cfi_startproc
	endbr64	
# src/ir_analysis_test.c:66:     for (int i = 0; i < n; i++) {
	testl	%ecx, %ecx	# n
	jle	.L43	#,
	movslq	%ecx, %rcx	# n, n
	xorl	%eax, %eax	# ivtmp.105
	salq	$2, %rcx	#, _26
	.p2align 4,,10
	.p2align 3
.L45:
# src/ir_analysis_test.c:67:         c[i] = (float)a[i] + b[i];
	pxor	%xmm0, %xmm0	# tmp94
	cvtsi2ssl	(%rdi,%rax), %xmm0	# MEM[(int *)a_14(D) + ivtmp.105_28 * 1], tmp94
# src/ir_analysis_test.c:67:         c[i] = (float)a[i] + b[i];
	addss	(%rsi,%rax), %xmm0	# MEM[(float *)b_15(D) + ivtmp.105_28 * 1], tmp95
# src/ir_analysis_test.c:67:         c[i] = (float)a[i] + b[i];
	movss	%xmm0, (%rdx,%rax)	# tmp95, MEM[(float *)c_16(D) + ivtmp.105_28 * 1]
# src/ir_analysis_test.c:66:     for (int i = 0; i < n; i++) {
	addq	$4, %rax	#, ivtmp.105
	cmpq	%rax, %rcx	# ivtmp.105, _26
	jne	.L45	#,
.L43:
# src/ir_analysis_test.c:69: }
	ret	
	.cfi_endproc
.LFE46:
	.size	mixed_types, .-mixed_types
	.p2align 4
	.globl	strided_access
	.type	strided_access, @function
strided_access:
.LFB47:
	.cfi_startproc
	endbr64	
# src/ir_analysis_test.c:73:     for (int i = 0; i < n; i += 2) {
	testl	%ecx, %ecx	# n
	jle	.L47	#,
	xorl	%eax, %eax	# ivtmp.114
	.p2align 4,,10
	.p2align 3
.L49:
# src/ir_analysis_test.c:74:         c[i] = a[i] + b[i];
	movss	(%rdi,%rax,4), %xmm0	# MEM[(float *)a_21(D) + ivtmp.114_37 * 4], MEM[(float *)a_21(D) + ivtmp.114_37 * 4]
	addss	(%rsi,%rax,4), %xmm0	# MEM[(float *)b_22(D) + ivtmp.114_37 * 4], tmp94
# src/ir_analysis_test.c:74:         c[i] = a[i] + b[i];
	movss	%xmm0, (%rdx,%rax,4)	# tmp94, MEM[(float *)c_23(D) + ivtmp.114_37 * 4]
# src/ir_analysis_test.c:75:         c[i+1] = a[i+1] + b[i+1];
	movss	4(%rdi,%rax,4), %xmm0	# MEM[(float *)a_21(D) + 4B + ivtmp.114_37 * 4], MEM[(float *)a_21(D) + 4B + ivtmp.114_37 * 4]
	addss	4(%rsi,%rax,4), %xmm0	# MEM[(float *)b_22(D) + 4B + ivtmp.114_37 * 4], tmp96
# src/ir_analysis_test.c:75:         c[i+1] = a[i+1] + b[i+1];
	movss	%xmm0, 4(%rdx,%rax,4)	# tmp96, MEM[(float *)c_23(D) + 4B + ivtmp.114_37 * 4]
# src/ir_analysis_test.c:73:     for (int i = 0; i < n; i += 2) {
	addq	$2, %rax	#, ivtmp.114
	cmpl	%eax, %ecx	# ivtmp.114, n
	jg	.L49	#,
.L47:
# src/ir_analysis_test.c:77: }
	ret	
	.cfi_endproc
.LFE47:
	.size	strided_access, .-strided_access
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC3:
	.string	"IR Level Vectorization Analysis Test"
	.align 8
.LC4:
	.string	"====================================\n"
	.align 8
.LC6:
	.string	"Test Case 1: Simple vectorizable loop"
	.align 8
.LC8:
	.string	"Time: %f seconds (1000 iterations)\n"
	.align 8
.LC9:
	.string	"\nTest Case 2: Complex loop with conditionals"
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC10:
	.string	"\nTest Case 3: Reduction loop"
	.section	.rodata.str1.8
	.align 8
.LC11:
	.string	"Time: %f seconds (1000 iterations), Sum: %f\n"
	.align 8
.LC12:
	.string	"\nTest Case 4: Loop with function call"
	.align 8
.LC14:
	.string	"Time: %f seconds (500 iterations)\n"
	.section	.rodata.str1.1
.LC15:
	.string	"\nTest Case 5: Nested loops"
	.section	.rodata.str1.8
	.align 8
.LC16:
	.string	"Time: %f seconds (10 iterations)\n"
	.align 8
.LC17:
	.string	"\nTest Case 6: Loop with dependencies"
	.align 8
.LC18:
	.string	"\nTest Case 7: Mixed data types"
	.align 8
.LC19:
	.string	"\nTest Case 8: Strided memory access"
	.section	.rodata.str1.1
.LC20:
	.string	"\nIR analysis test completed."
	.section	.text.startup,"ax",@progbits
	.p2align 4
	.globl	main
	.type	main, @function
main:
.LFB48:
	.cfi_startproc
	endbr64	
	pushq	%r15	#
	.cfi_def_cfa_offset 16
	.cfi_offset 15, -16
# /usr/include/x86_64-linux-gnu/bits/stdio2.h:112:   return __printf_chk (__USE_FORTIFY_LEVEL - 1, __fmt, __va_arg_pack ());
	leaq	.LC3(%rip), %rdi	#, tmp201
# src/ir_analysis_test.c:79: int main() {
	pushq	%r14	#
	.cfi_def_cfa_offset 24
	.cfi_offset 14, -24
	pushq	%r13	#
	.cfi_def_cfa_offset 32
	.cfi_offset 13, -32
	pushq	%r12	#
	.cfi_def_cfa_offset 40
	.cfi_offset 12, -40
	pushq	%rbp	#
	.cfi_def_cfa_offset 48
	.cfi_offset 6, -48
	pushq	%rbx	#
	.cfi_def_cfa_offset 56
	.cfi_offset 3, -56
	subq	$24, %rsp	#,
	.cfi_def_cfa_offset 80
# /usr/include/x86_64-linux-gnu/bits/stdio2.h:112:   return __printf_chk (__USE_FORTIFY_LEVEL - 1, __fmt, __va_arg_pack ());
	call	puts@PLT	#
	leaq	.LC4(%rip), %rdi	#, tmp202
	call	puts@PLT	#
# src/ir_analysis_test.c:84:     float* a = malloc(SIZE * sizeof(float));
	movl	$4000, %edi	#,
	call	malloc@PLT	#
# src/ir_analysis_test.c:85:     float* b = malloc(SIZE * sizeof(float));
	movl	$4000, %edi	#,
# src/ir_analysis_test.c:84:     float* a = malloc(SIZE * sizeof(float));
	movq	%rax, %r12	# tmp330, a
# src/ir_analysis_test.c:85:     float* b = malloc(SIZE * sizeof(float));
	call	malloc@PLT	#
# src/ir_analysis_test.c:86:     float* c = malloc(SIZE * sizeof(float));
	movl	$4000, %edi	#,
# src/ir_analysis_test.c:85:     float* b = malloc(SIZE * sizeof(float));
	movq	%rax, %rbp	# tmp331, b
# src/ir_analysis_test.c:86:     float* c = malloc(SIZE * sizeof(float));
	call	malloc@PLT	#
# src/ir_analysis_test.c:87:     int* ia = malloc(SIZE * sizeof(int));
	movl	$4000, %edi	#,
# src/ir_analysis_test.c:86:     float* c = malloc(SIZE * sizeof(float));
	movq	%rax, %r13	# tmp332, c
# src/ir_analysis_test.c:87:     int* ia = malloc(SIZE * sizeof(int));
	call	malloc@PLT	#
	movdqa	.LC2(%rip), %xmm3	#, vect_vec_iv_.170
	movdqa	.LC5(%rip), %xmm2	#, tmp324
	movq	%rax, %r14	# tmp333, ia
	xorl	%eax, %eax	# ivtmp.345
	movdqa	%xmm3, %xmm4	# vect_vec_iv_.170, vect_vec_iv_.199
	.p2align 4,,10
	.p2align 3
.L52:
	movdqa	%xmm4, %xmm0	# vect_vec_iv_.199, vect_vec_iv_.199
	paddd	%xmm2, %xmm4	# tmp324, vect_vec_iv_.199
# src/ir_analysis_test.c:91:         a[i] = (float)i;
	cvtdq2ps	%xmm0, %xmm1	# vect_vec_iv_.199, vect__4.200
# src/ir_analysis_test.c:91:         a[i] = (float)i;
	movups	%xmm1, (%r12,%rax)	# vect__4.200, MEM <vector(4) float> [(float *)a_56 + ivtmp.345_130 * 1]
# src/ir_analysis_test.c:92:         b[i] = (float)(i * 2);
	movdqa	%xmm0, %xmm1	# vect_vec_iv_.199, vect__5.203
	pslld	$1, %xmm1	#, vect__5.203
# src/ir_analysis_test.c:93:         ia[i] = i;
	movups	%xmm0, (%r14,%rax)	# vect_vec_iv_.199, MEM <vector(4) int> [(int *)ia_62 + ivtmp.345_130 * 1]
# src/ir_analysis_test.c:92:         b[i] = (float)(i * 2);
	cvtdq2ps	%xmm1, %xmm1	# vect__5.203, vect__7.204
# src/ir_analysis_test.c:92:         b[i] = (float)(i * 2);
	movups	%xmm1, 0(%rbp,%rax)	# vect__7.204, MEM <vector(4) float> [(float *)b_58 + ivtmp.345_130 * 1]
	addq	$16, %rax	#, ivtmp.345
	cmpq	$4000, %rax	#, ivtmp.345
	jne	.L52	#,
# /usr/include/x86_64-linux-gnu/bits/stdio2.h:112:   return __printf_chk (__USE_FORTIFY_LEVEL - 1, __fmt, __va_arg_pack ());
	leaq	.LC6(%rip), %rdi	#, tmp211
	call	puts@PLT	#
# src/ir_analysis_test.c:98:     clock_t start = clock();
	call	clock@PLT	#
	movl	$1000, %edx	#, ivtmp_269
	movq	%rax, %rbx	# tmp334, start
	.p2align 4,,10
	.p2align 3
.L53:
# src/ir_analysis_test.c:87:     int* ia = malloc(SIZE * sizeof(int));
	xorl	%eax, %eax	# ivtmp.330
	.p2align 4,,10
	.p2align 3
.L54:
# src/ir_analysis_test.c:10:         c[i] = a[i] + b[i];
	movups	(%r12,%rax), %xmm0	# MEM <vector(4) float> [(float *)a_56 + ivtmp.330_319 * 1], vect__126.196
	movups	0(%rbp,%rax), %xmm7	# MEM <vector(4) float> [(float *)b_58 + ivtmp.330_319 * 1], tmp353
	addps	%xmm7, %xmm0	# tmp353, vect__126.196
# src/ir_analysis_test.c:10:         c[i] = a[i] + b[i];
	movups	%xmm0, 0(%r13,%rax)	# vect__126.196, MEM <vector(4) float> [(float *)c_60 + ivtmp.330_319 * 1]
	addq	$16, %rax	#, ivtmp.330
	cmpq	$4000, %rax	#, ivtmp.330
	jne	.L54	#,
# src/ir_analysis_test.c:99:     for (int iter = 0; iter < 1000; iter++) {
	subl	$1, %edx	#, ivtmp_269
	jne	.L53	#,
# src/ir_analysis_test.c:102:     clock_t end = clock();
	call	clock@PLT	#
# src/ir_analysis_test.c:104:            ((double)(end - start)) / CLOCKS_PER_SEC);
	pxor	%xmm0, %xmm0	# tmp216
# /usr/include/x86_64-linux-gnu/bits/stdio2.h:112:   return __printf_chk (__USE_FORTIFY_LEVEL - 1, __fmt, __va_arg_pack ());
	movl	$1, %edi	#,
# src/ir_analysis_test.c:104:            ((double)(end - start)) / CLOCKS_PER_SEC);
	subq	%rbx, %rax	# start, tmp215
# /usr/include/x86_64-linux-gnu/bits/stdio2.h:112:   return __printf_chk (__USE_FORTIFY_LEVEL - 1, __fmt, __va_arg_pack ());
	leaq	.LC8(%rip), %rbx	#, tmp321
	movq	%rbx, %rsi	# tmp321,
# src/ir_analysis_test.c:104:            ((double)(end - start)) / CLOCKS_PER_SEC);
	cvtsi2sdq	%rax, %xmm0	# tmp215, tmp216
# /usr/include/x86_64-linux-gnu/bits/stdio2.h:112:   return __printf_chk (__USE_FORTIFY_LEVEL - 1, __fmt, __va_arg_pack ());
	movl	$1, %eax	#,
# src/ir_analysis_test.c:103:     printf("Time: %f seconds (1000 iterations)\n", 
	divsd	.LC7(%rip), %xmm0	#, tmp217
# /usr/include/x86_64-linux-gnu/bits/stdio2.h:112:   return __printf_chk (__USE_FORTIFY_LEVEL - 1, __fmt, __va_arg_pack ());
	call	__printf_chk@PLT	#
	leaq	.LC9(%rip), %rdi	#, tmp220
	call	puts@PLT	#
# src/ir_analysis_test.c:108:     start = clock();
	call	clock@PLT	#
	movl	$1000, %edx	#, ivtmp_273
# src/ir_analysis_test.c:17:         if (a[i] > 0.0f) {
	pxor	%xmm4, %xmm4	# tmp221
# src/ir_analysis_test.c:18:             c[i] = a[i] * b[i] + 1.0f;
	movss	.LC1(%rip), %xmm5	#, tmp328
# src/ir_analysis_test.c:108:     start = clock();
	movq	%rax, %r15	# tmp336, start
	.p2align 4,,10
	.p2align 3
.L56:
# src/ir_analysis_test.c:98:     clock_t start = clock();
	xorl	%eax, %eax	# ivtmp.321
	jmp	.L60	#
	.p2align 4,,10
	.p2align 3
.L95:
# src/ir_analysis_test.c:18:             c[i] = a[i] * b[i] + 1.0f;
	mulss	%xmm1, %xmm0	# pretmp_356, tmp222
# src/ir_analysis_test.c:18:             c[i] = a[i] * b[i] + 1.0f;
	addss	%xmm5, %xmm0	# tmp328, _166
.L59:
# src/ir_analysis_test.c:18:             c[i] = a[i] * b[i] + 1.0f;
	movss	%xmm0, 0(%r13,%rax)	# _166, MEM[(float *)c_60 + ivtmp.321_294 * 1]
# src/ir_analysis_test.c:16:     for (int i = 0; i < n; i++) {
	addq	$4, %rax	#, ivtmp.321
	cmpq	$4000, %rax	#, ivtmp.321
	je	.L94	#,
.L60:
# src/ir_analysis_test.c:17:         if (a[i] > 0.0f) {
	movss	(%r12,%rax), %xmm0	# MEM[(float *)a_56 + ivtmp.321_294 * 1], _161
# src/ir_analysis_test.c:18:             c[i] = a[i] * b[i] + 1.0f;
	movss	0(%rbp,%rax), %xmm1	# MEM[(float *)b_58 + ivtmp.321_294 * 1], pretmp_356
# src/ir_analysis_test.c:17:         if (a[i] > 0.0f) {
	comiss	%xmm4, %xmm0	# tmp221, _161
	ja	.L95	#,
# src/ir_analysis_test.c:20:             c[i] = a[i] - b[i];
	subss	%xmm1, %xmm0	# pretmp_356, _166
	jmp	.L59	#
	.p2align 4,,10
	.p2align 3
.L94:
# src/ir_analysis_test.c:109:     for (int iter = 0; iter < 1000; iter++) {
	subl	$1, %edx	#, ivtmp_273
	jne	.L56	#,
# src/ir_analysis_test.c:112:     end = clock();
	call	clock@PLT	#
# src/ir_analysis_test.c:114:            ((double)(end - start)) / CLOCKS_PER_SEC);
	pxor	%xmm0, %xmm0	# tmp225
# /usr/include/x86_64-linux-gnu/bits/stdio2.h:112:   return __printf_chk (__USE_FORTIFY_LEVEL - 1, __fmt, __va_arg_pack ());
	movq	%rbx, %rsi	# tmp321,
	movl	$1, %edi	#,
# src/ir_analysis_test.c:114:            ((double)(end - start)) / CLOCKS_PER_SEC);
	subq	%r15, %rax	# start, tmp224
# src/ir_analysis_test.c:114:            ((double)(end - start)) / CLOCKS_PER_SEC);
	cvtsi2sdq	%rax, %xmm0	# tmp224, tmp225
# /usr/include/x86_64-linux-gnu/bits/stdio2.h:112:   return __printf_chk (__USE_FORTIFY_LEVEL - 1, __fmt, __va_arg_pack ());
	movl	$1, %eax	#,
# src/ir_analysis_test.c:113:     printf("Time: %f seconds (1000 iterations)\n", 
	divsd	.LC7(%rip), %xmm0	#, tmp226
# /usr/include/x86_64-linux-gnu/bits/stdio2.h:112:   return __printf_chk (__USE_FORTIFY_LEVEL - 1, __fmt, __va_arg_pack ());
	call	__printf_chk@PLT	#
	leaq	.LC10(%rip), %rdi	#, tmp229
	call	puts@PLT	#
# src/ir_analysis_test.c:118:     start = clock();
	call	clock@PLT	#
	movl	$1000, %ecx	#, ivtmp_277
	leaq	4000(%r12), %rdx	#, _112
	movq	%rax, %r15	# tmp338, start
	.p2align 4,,10
	.p2align 3
.L62:
# src/ir_analysis_test.c:108:     start = clock();
	movq	%r12, %rax	# a, ivtmp.303
# src/ir_analysis_test.c:27:     float sum = 0.0f;
	pxor	%xmm1, %xmm1	# sum
	.p2align 4,,10
	.p2align 3
.L63:
	addss	(%rax), %xmm1	# BIT_FIELD_REF <MEM <vector(4) float> [(float *)_292], 32, 0>, stmp_sum_134.189
	addq	$16, %rax	#, ivtmp.303
	addss	-12(%rax), %xmm1	# BIT_FIELD_REF <MEM <vector(4) float> [(float *)_292], 32, 32>, stmp_sum_134.189
# src/ir_analysis_test.c:29:         sum += a[i];
	addss	-8(%rax), %xmm1	# BIT_FIELD_REF <MEM <vector(4) float> [(float *)_292], 32, 64>, stmp_sum_134.189
	addss	-4(%rax), %xmm1	# BIT_FIELD_REF <MEM <vector(4) float> [(float *)_292], 32, 96>, sum
	cmpq	%rax, %rdx	# ivtmp.303, _112
	jne	.L63	#,
# src/ir_analysis_test.c:120:     for (int iter = 0; iter < 1000; iter++) {
	subl	$1, %ecx	#, ivtmp_277
	jne	.L62	#,
	movss	%xmm1, 12(%rsp)	# sum, %sfp
# src/ir_analysis_test.c:123:     end = clock();
	call	clock@PLT	#
# /usr/include/x86_64-linux-gnu/bits/stdio2.h:112:   return __printf_chk (__USE_FORTIFY_LEVEL - 1, __fmt, __va_arg_pack ());
	movss	12(%rsp), %xmm1	# %sfp, sum
# src/ir_analysis_test.c:125:            ((double)(end - start)) / CLOCKS_PER_SEC, sum);
	pxor	%xmm0, %xmm0	# tmp233
# /usr/include/x86_64-linux-gnu/bits/stdio2.h:112:   return __printf_chk (__USE_FORTIFY_LEVEL - 1, __fmt, __va_arg_pack ());
	leaq	.LC11(%rip), %rsi	#, tmp236
# src/ir_analysis_test.c:125:            ((double)(end - start)) / CLOCKS_PER_SEC, sum);
	subq	%r15, %rax	# start, tmp232
# /usr/include/x86_64-linux-gnu/bits/stdio2.h:112:   return __printf_chk (__USE_FORTIFY_LEVEL - 1, __fmt, __va_arg_pack ());
	movl	$1, %edi	#,
# src/ir_analysis_test.c:125:            ((double)(end - start)) / CLOCKS_PER_SEC, sum);
	cvtsi2sdq	%rax, %xmm0	# tmp232, tmp233
# /usr/include/x86_64-linux-gnu/bits/stdio2.h:112:   return __printf_chk (__USE_FORTIFY_LEVEL - 1, __fmt, __va_arg_pack ());
	movl	$2, %eax	#,
# src/ir_analysis_test.c:124:     printf("Time: %f seconds (1000 iterations), Sum: %f\n", 
	divsd	.LC7(%rip), %xmm0	#, tmp234
# /usr/include/x86_64-linux-gnu/bits/stdio2.h:112:   return __printf_chk (__USE_FORTIFY_LEVEL - 1, __fmt, __va_arg_pack ());
	cvtss2sd	%xmm1, %xmm1	# sum,
	call	__printf_chk@PLT	#
	leaq	.LC12(%rip), %rdi	#, tmp237
	call	puts@PLT	#
# src/ir_analysis_test.c:129:     start = clock();
	call	clock@PLT	#
# src/ir_analysis_test.c:45:     return (float)(x % 10);
	pxor	%xmm7, %xmm7	# tmp242
	movdqa	.LC13(%rip), %xmm5	#, tmp320
	movdqa	.LC2(%rip), %xmm3	#, vect_vec_iv_.170
	movdqa	%xmm7, %xmm8	# tmp242, tmp246
	movdqa	.LC5(%rip), %xmm2	#, tmp324
# src/ir_analysis_test.c:129:     start = clock();
	movq	%rax, %r15	# tmp340, start
	movl	$500, %edx	#, ivtmp_281
# src/ir_analysis_test.c:45:     return (float)(x % 10);
	pcmpgtd	%xmm5, %xmm8	# tmp320, tmp246
	.p2align 4,,10
	.p2align 3
.L65:
# src/ir_analysis_test.c:118:     start = clock();
	xorl	%eax, %eax	# ivtmp.289
	movdqa	%xmm3, %xmm6	# vect_vec_iv_.170, vect_vec_iv_.170
	.p2align 4,,10
	.p2align 3
.L66:
	movdqa	%xmm6, %xmm0	# vect_vec_iv_.170, vect_vec_iv_.170
# src/ir_analysis_test.c:45:     return (float)(x % 10);
	movdqa	%xmm7, %xmm4	# tmp242, tmp243
	movdqa	%xmm8, %xmm9	# tmp246, tmp248
	pcmpgtd	%xmm0, %xmm4	# vect_vec_iv_.170, tmp243
	pmuludq	%xmm0, %xmm9	# vect_vec_iv_.170, tmp248
	movdqa	%xmm0, %xmm1	# vect_vec_iv_.170, tmp249
	pmuludq	%xmm5, %xmm1	# tmp320, tmp249
	movdqa	%xmm8, %xmm10	# tmp246, tmp260
	paddd	%xmm2, %xmm6	# tmp324, vect_vec_iv_.170
	pmuludq	%xmm5, %xmm4	# tmp320, tmp247
	paddq	%xmm9, %xmm4	# tmp248, tmp247
	movdqa	%xmm7, %xmm9	# tmp242, tmp255
	psllq	$32, %xmm4	#, tmp247
	paddq	%xmm4, %xmm1	# tmp247, tmp239
	movdqa	%xmm0, %xmm4	# vect_vec_iv_.170, tmp252
	psrlq	$32, %xmm4	#, tmp252
	pcmpgtd	%xmm4, %xmm9	# tmp252, tmp255
	pmuludq	%xmm4, %xmm10	# tmp252, tmp260
	pmuludq	%xmm5, %xmm4	# tmp320, tmp261
	pmuludq	%xmm5, %xmm9	# tmp320, tmp259
	paddq	%xmm10, %xmm9	# tmp260, tmp259
	psllq	$32, %xmm9	#, tmp259
	paddq	%xmm9, %xmm4	# tmp259, tmp250
	shufps	$221, %xmm4, %xmm1	#, tmp250, tmp265
	pshufd	$216, %xmm1, %xmm1	#, tmp265, vect_patt_371.178
	psrad	$2, %xmm1	#, vect_patt_372.179
	movdqa	%xmm1, %xmm4	# vect_patt_372.179, tmp268
	pslld	$2, %xmm4	#, tmp268
	paddd	%xmm4, %xmm1	# tmp268, vect_patt_373.180
# src/ir_analysis_test.c:40:         c[i] = a[i] + b[i] + some_function(i);
	movups	0(%rbp,%rax), %xmm4	# MEM <vector(4) float> [(float *)b_58 + ivtmp.289_124 * 1], tmp363
# src/ir_analysis_test.c:45:     return (float)(x % 10);
	pslld	$1, %xmm1	#, tmp270
	psubd	%xmm1, %xmm0	# tmp270, vect_patt_374.181
# src/ir_analysis_test.c:40:         c[i] = a[i] + b[i] + some_function(i);
	movups	(%r12,%rax), %xmm1	# MEM <vector(4) float> [(float *)a_56 + ivtmp.289_124 * 1], vect__179.177
# src/ir_analysis_test.c:45:     return (float)(x % 10);
	cvtdq2ps	%xmm0, %xmm0	# vect_patt_374.181, vect__181.182
# src/ir_analysis_test.c:40:         c[i] = a[i] + b[i] + some_function(i);
	addps	%xmm4, %xmm1	# tmp363, vect__179.177
# src/ir_analysis_test.c:40:         c[i] = a[i] + b[i] + some_function(i);
	addps	%xmm1, %xmm0	# vect__179.177, vect__183.183
# src/ir_analysis_test.c:40:         c[i] = a[i] + b[i] + some_function(i);
	movups	%xmm0, 0(%r13,%rax)	# vect__183.183, MEM <vector(4) float> [(float *)c_60 + ivtmp.289_124 * 1]
	addq	$16, %rax	#, ivtmp.289
	cmpq	$4000, %rax	#, ivtmp.289
	jne	.L66	#,
# src/ir_analysis_test.c:130:     for (int iter = 0; iter < 500; iter++) {
	subl	$1, %edx	#, ivtmp_281
	jne	.L65	#,
# src/ir_analysis_test.c:133:     end = clock();
	call	clock@PLT	#
# src/ir_analysis_test.c:135:            ((double)(end - start)) / CLOCKS_PER_SEC);
	pxor	%xmm0, %xmm0	# tmp278
# /usr/include/x86_64-linux-gnu/bits/stdio2.h:112:   return __printf_chk (__USE_FORTIFY_LEVEL - 1, __fmt, __va_arg_pack ());
	movl	$1, %edi	#,
	leaq	.LC14(%rip), %rsi	#, tmp281
# src/ir_analysis_test.c:135:            ((double)(end - start)) / CLOCKS_PER_SEC);
	subq	%r15, %rax	# start, tmp277
# src/ir_analysis_test.c:135:            ((double)(end - start)) / CLOCKS_PER_SEC);
	cvtsi2sdq	%rax, %xmm0	# tmp277, tmp278
# /usr/include/x86_64-linux-gnu/bits/stdio2.h:112:   return __printf_chk (__USE_FORTIFY_LEVEL - 1, __fmt, __va_arg_pack ());
	movl	$1, %eax	#,
# src/ir_analysis_test.c:134:     printf("Time: %f seconds (500 iterations)\n", 
	divsd	.LC7(%rip), %xmm0	#, tmp279
# /usr/include/x86_64-linux-gnu/bits/stdio2.h:112:   return __printf_chk (__USE_FORTIFY_LEVEL - 1, __fmt, __va_arg_pack ());
	call	__printf_chk@PLT	#
	leaq	.LC15(%rip), %rdi	#, tmp282
	call	puts@PLT	#
# src/ir_analysis_test.c:139:     start = clock();
	call	clock@PLT	#
	movl	$10, %edi	#, ivtmp_285
	leaq	40000(%r13), %rsi	#, _123
	movq	%rax, %r15	# tmp342, start
	.p2align 4,,10
	.p2align 3
.L68:
	movq	%r13, %rdx	# c, ivtmp.280
# src/ir_analysis_test.c:52:             c[i * n + j] = a[i] * b[j];
	movq	%r12, %rcx	# a, ivtmp.279
	.p2align 4,,10
	.p2align 3
.L72:
	movss	(%rcx), %xmm1	# MEM[(float *)_121], vect_cst__168
	xorl	%eax, %eax	# ivtmp.268
	shufps	$0, %xmm1, %xmm1	# vect_cst__168
	.p2align 4,,10
	.p2align 3
.L69:
# src/ir_analysis_test.c:52:             c[i * n + j] = a[i] * b[j];
	movups	0(%rbp,%rax), %xmm0	# MEM <vector(4) float> [(float *)b_58 + ivtmp.268_9 * 1], vect__200.167
	mulps	%xmm1, %xmm0	# vect_cst__168, vect__200.167
# src/ir_analysis_test.c:52:             c[i * n + j] = a[i] * b[j];
	movups	%xmm0, (%rdx,%rax)	# vect__200.167, MEM <vector(4) float> [(float *)vectp.169_162 + ivtmp.268_9 * 1]
	addq	$16, %rax	#, ivtmp.268
	cmpq	$400, %rax	#, ivtmp.268
	jne	.L69	#,
# src/ir_analysis_test.c:50:     for (int i = 0; i < n; i++) {
	addq	$400, %rdx	#, ivtmp.280
	addq	$4, %rcx	#, ivtmp.279
	cmpq	%rsi, %rdx	# _123, ivtmp.280
	jne	.L72	#,
# src/ir_analysis_test.c:140:     for (int iter = 0; iter < 10; iter++) {
	subl	$1, %edi	#, ivtmp_285
	jne	.L68	#,
# src/ir_analysis_test.c:143:     end = clock();
	call	clock@PLT	#
# src/ir_analysis_test.c:145:            ((double)(end - start)) / CLOCKS_PER_SEC);
	pxor	%xmm0, %xmm0	# tmp287
# /usr/include/x86_64-linux-gnu/bits/stdio2.h:112:   return __printf_chk (__USE_FORTIFY_LEVEL - 1, __fmt, __va_arg_pack ());
	movl	$1, %edi	#,
	leaq	.LC16(%rip), %rsi	#, tmp290
# src/ir_analysis_test.c:145:            ((double)(end - start)) / CLOCKS_PER_SEC);
	subq	%r15, %rax	# start, tmp286
# src/ir_analysis_test.c:145:            ((double)(end - start)) / CLOCKS_PER_SEC);
	cvtsi2sdq	%rax, %xmm0	# tmp286, tmp287
# /usr/include/x86_64-linux-gnu/bits/stdio2.h:112:   return __printf_chk (__USE_FORTIFY_LEVEL - 1, __fmt, __va_arg_pack ());
	movl	$1, %eax	#,
# src/ir_analysis_test.c:144:     printf("Time: %f seconds (10 iterations)\n", 
	divsd	.LC7(%rip), %xmm0	#, tmp288
# /usr/include/x86_64-linux-gnu/bits/stdio2.h:112:   return __printf_chk (__USE_FORTIFY_LEVEL - 1, __fmt, __va_arg_pack ());
	call	__printf_chk@PLT	#
	leaq	.LC17(%rip), %rdi	#, tmp291
	call	puts@PLT	#
# src/ir_analysis_test.c:149:     start = clock();
	call	clock@PLT	#
	movl	$1000, %edx	#, ivtmp_301
	movq	%rax, %r15	# tmp344, start
	.p2align 4,,10
	.p2align 3
.L73:
	movss	(%r12), %xmm1	# *a_56, D__lsm0.216
# src/ir_analysis_test.c:139:     start = clock();
	movl	$4, %eax	#, ivtmp.259
	.p2align 4,,10
	.p2align 3
.L74:
# src/ir_analysis_test.c:60:         a[i] = a[i] + b[i] + a[i-1];
	movss	(%r12,%rax), %xmm0	# MEM[(float *)a_56 + ivtmp.259_6 * 1], MEM[(float *)a_56 + ivtmp.259_6 * 1]
	addss	0(%rbp,%rax), %xmm0	# MEM[(float *)b_58 + ivtmp.259_6 * 1], tmp292
# src/ir_analysis_test.c:60:         a[i] = a[i] + b[i] + a[i-1];
	addss	%xmm0, %xmm1	# tmp292, D__lsm0.216
# src/ir_analysis_test.c:60:         a[i] = a[i] + b[i] + a[i-1];
	movss	%xmm1, (%r12,%rax)	# D__lsm0.216, MEM[(float *)a_56 + ivtmp.259_6 * 1]
# src/ir_analysis_test.c:59:     for (int i = 1; i < n; i++) {
	addq	$4, %rax	#, ivtmp.259
	cmpq	$4000, %rax	#, ivtmp.259
	jne	.L74	#,
# src/ir_analysis_test.c:150:     for (int iter = 0; iter < 1000; iter++) {
	subl	$1, %edx	#, ivtmp_301
	jne	.L73	#,
# src/ir_analysis_test.c:153:     end = clock();
	call	clock@PLT	#
# src/ir_analysis_test.c:155:            ((double)(end - start)) / CLOCKS_PER_SEC);
	pxor	%xmm0, %xmm0	# tmp295
# /usr/include/x86_64-linux-gnu/bits/stdio2.h:112:   return __printf_chk (__USE_FORTIFY_LEVEL - 1, __fmt, __va_arg_pack ());
	movq	%rbx, %rsi	# tmp321,
	movl	$1, %edi	#,
# src/ir_analysis_test.c:155:            ((double)(end - start)) / CLOCKS_PER_SEC);
	subq	%r15, %rax	# start, tmp294
# src/ir_analysis_test.c:155:            ((double)(end - start)) / CLOCKS_PER_SEC);
	cvtsi2sdq	%rax, %xmm0	# tmp294, tmp295
# /usr/include/x86_64-linux-gnu/bits/stdio2.h:112:   return __printf_chk (__USE_FORTIFY_LEVEL - 1, __fmt, __va_arg_pack ());
	movl	$1, %eax	#,
# src/ir_analysis_test.c:154:     printf("Time: %f seconds (1000 iterations)\n", 
	divsd	.LC7(%rip), %xmm0	#, tmp296
# /usr/include/x86_64-linux-gnu/bits/stdio2.h:112:   return __printf_chk (__USE_FORTIFY_LEVEL - 1, __fmt, __va_arg_pack ());
	call	__printf_chk@PLT	#
	leaq	.LC18(%rip), %rdi	#, tmp299
	call	puts@PLT	#
# src/ir_analysis_test.c:159:     start = clock();
	call	clock@PLT	#
	movl	$1000, %edx	#, ivtmp_307
	movq	%rax, %r15	# tmp346, start
	.p2align 4,,10
	.p2align 3
.L76:
# src/ir_analysis_test.c:149:     start = clock();
	xorl	%eax, %eax	# ivtmp.236
	.p2align 4,,10
	.p2align 3
.L77:
# src/ir_analysis_test.c:67:         c[i] = (float)a[i] + b[i];
	movdqu	(%r14,%rax), %xmm3	# MEM <vector(4) int> [(int *)ia_62 + ivtmp.236_4 * 1], tmp366
# src/ir_analysis_test.c:67:         c[i] = (float)a[i] + b[i];
	movups	0(%rbp,%rax), %xmm2	# MEM <vector(4) float> [(float *)b_58 + ivtmp.236_4 * 1], tmp367
# src/ir_analysis_test.c:67:         c[i] = (float)a[i] + b[i];
	cvtdq2ps	%xmm3, %xmm0	# tmp366, vect__221.157
# src/ir_analysis_test.c:67:         c[i] = (float)a[i] + b[i];
	addps	%xmm2, %xmm0	# tmp367, vect__225.161
# src/ir_analysis_test.c:67:         c[i] = (float)a[i] + b[i];
	movups	%xmm0, 0(%r13,%rax)	# vect__225.161, MEM <vector(4) float> [(float *)c_60 + ivtmp.236_4 * 1]
	addq	$16, %rax	#, ivtmp.236
	cmpq	$4000, %rax	#, ivtmp.236
	jne	.L77	#,
# src/ir_analysis_test.c:160:     for (int iter = 0; iter < 1000; iter++) {
	subl	$1, %edx	#, ivtmp_307
	jne	.L76	#,
# src/ir_analysis_test.c:163:     end = clock();
	call	clock@PLT	#
# src/ir_analysis_test.c:165:            ((double)(end - start)) / CLOCKS_PER_SEC);
	pxor	%xmm0, %xmm0	# tmp305
# /usr/include/x86_64-linux-gnu/bits/stdio2.h:112:   return __printf_chk (__USE_FORTIFY_LEVEL - 1, __fmt, __va_arg_pack ());
	movq	%rbx, %rsi	# tmp321,
	movl	$1, %edi	#,
# src/ir_analysis_test.c:165:            ((double)(end - start)) / CLOCKS_PER_SEC);
	subq	%r15, %rax	# start, tmp304
# src/ir_analysis_test.c:165:            ((double)(end - start)) / CLOCKS_PER_SEC);
	cvtsi2sdq	%rax, %xmm0	# tmp304, tmp305
# /usr/include/x86_64-linux-gnu/bits/stdio2.h:112:   return __printf_chk (__USE_FORTIFY_LEVEL - 1, __fmt, __va_arg_pack ());
	movl	$1, %eax	#,
# src/ir_analysis_test.c:164:     printf("Time: %f seconds (1000 iterations)\n", 
	divsd	.LC7(%rip), %xmm0	#, tmp306
# /usr/include/x86_64-linux-gnu/bits/stdio2.h:112:   return __printf_chk (__USE_FORTIFY_LEVEL - 1, __fmt, __va_arg_pack ());
	call	__printf_chk@PLT	#
	leaq	.LC19(%rip), %rdi	#, tmp309
	call	puts@PLT	#
# src/ir_analysis_test.c:169:     start = clock();
	call	clock@PLT	#
	movl	$1000, %edx	#, ivtmp_314
	movq	%rax, %r15	# tmp348, start
	.p2align 4,,10
	.p2align 3
.L79:
# src/ir_analysis_test.c:159:     start = clock();
	xorl	%eax, %eax	# ivtmp.221
	.p2align 4,,10
	.p2align 3
.L80:
# src/ir_analysis_test.c:74:         c[i] = a[i] + b[i];
	movups	0(%rbp,%rax), %xmm0	# MEM <vector(4) float> [(float *)b_58 + ivtmp.221_2 * 1], vect__235.151
	movups	(%r12,%rax), %xmm6	# MEM <vector(4) float> [(float *)a_56 + ivtmp.221_2 * 1], tmp369
	addps	%xmm6, %xmm0	# tmp369, vect__235.151
# src/ir_analysis_test.c:74:         c[i] = a[i] + b[i];
	movups	%xmm0, 0(%r13,%rax)	# vect__235.151, MEM <vector(4) float> [(float *)c_60 + ivtmp.221_2 * 1]
	addq	$16, %rax	#, ivtmp.221
	cmpq	$4000, %rax	#, ivtmp.221
	jne	.L80	#,
# src/ir_analysis_test.c:170:     for (int iter = 0; iter < 1000; iter++) {
	subl	$1, %edx	#, ivtmp_314
	jne	.L79	#,
# src/ir_analysis_test.c:173:     end = clock();
	call	clock@PLT	#
# src/ir_analysis_test.c:175:            ((double)(end - start)) / CLOCKS_PER_SEC);
	pxor	%xmm0, %xmm0	# tmp314
# /usr/include/x86_64-linux-gnu/bits/stdio2.h:112:   return __printf_chk (__USE_FORTIFY_LEVEL - 1, __fmt, __va_arg_pack ());
	movq	%rbx, %rsi	# tmp321,
	movl	$1, %edi	#,
# src/ir_analysis_test.c:175:            ((double)(end - start)) / CLOCKS_PER_SEC);
	subq	%r15, %rax	# start, tmp313
# src/ir_analysis_test.c:175:            ((double)(end - start)) / CLOCKS_PER_SEC);
	cvtsi2sdq	%rax, %xmm0	# tmp313, tmp314
# /usr/include/x86_64-linux-gnu/bits/stdio2.h:112:   return __printf_chk (__USE_FORTIFY_LEVEL - 1, __fmt, __va_arg_pack ());
	movl	$1, %eax	#,
# src/ir_analysis_test.c:174:     printf("Time: %f seconds (1000 iterations)\n", 
	divsd	.LC7(%rip), %xmm0	#, tmp315
# /usr/include/x86_64-linux-gnu/bits/stdio2.h:112:   return __printf_chk (__USE_FORTIFY_LEVEL - 1, __fmt, __va_arg_pack ());
	call	__printf_chk@PLT	#
# src/ir_analysis_test.c:178:     free(a);
	movq	%r12, %rdi	# a,
	call	free@PLT	#
# src/ir_analysis_test.c:179:     free(b);
	movq	%rbp, %rdi	# b,
	call	free@PLT	#
# src/ir_analysis_test.c:180:     free(c);
	movq	%r13, %rdi	# c,
	call	free@PLT	#
# src/ir_analysis_test.c:181:     free(ia);
	movq	%r14, %rdi	# ia,
	call	free@PLT	#
# /usr/include/x86_64-linux-gnu/bits/stdio2.h:112:   return __printf_chk (__USE_FORTIFY_LEVEL - 1, __fmt, __va_arg_pack ());
	leaq	.LC20(%rip), %rdi	#, tmp318
	call	puts@PLT	#
# src/ir_analysis_test.c:185: } 
	addq	$24, %rsp	#,
	.cfi_def_cfa_offset 56
	xorl	%eax, %eax	#
	popq	%rbx	#
	.cfi_def_cfa_offset 48
	popq	%rbp	#
	.cfi_def_cfa_offset 40
	popq	%r12	#
	.cfi_def_cfa_offset 32
	popq	%r13	#
	.cfi_def_cfa_offset 24
	popq	%r14	#
	.cfi_def_cfa_offset 16
	popq	%r15	#
	.cfi_def_cfa_offset 8
	ret	
	.cfi_endproc
.LFE48:
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
.LC5:
	.long	4
	.long	4
	.long	4
	.long	4
	.section	.rodata.cst8,"aM",@progbits,8
	.align 8
.LC7:
	.long	0
	.long	1093567616
	.section	.rodata.cst16
	.align 16
.LC13:
	.long	1717986919
	.long	1717986919
	.long	1717986919
	.long	1717986919
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
