	.file	"main.c"
	.text
	.globl	binmul_recursive
	.type	binmul_recursive, @function
binmul_recursive:
.LFB26:
	.cfi_startproc
	movq	%rdx, %rax
	movq	%rdi, %rdx
	shrq	%cl, %rdx
	andl	$1, %edx
	movq	%rsi, %r8
	salq	%cl, %r8
	addq	%rax, %r8
	testq	%rdx, %rdx
	cmovne	%r8, %rax
	addq	$1, %rcx
	cmpq	$63, %rcx
	jbe	.L8
	rep ret
.L8:
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	movq	%rax, %rdx
	call	binmul_recursive
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE26:
	.size	binmul_recursive, .-binmul_recursive
	.globl	fmul
	.type	fmul, @function
fmul:
.LFB24:
	.cfi_startproc
	ucomiss	%xmm1, %xmm0
	jp	.L18
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	pushq	%rbx
	.cfi_def_cfa_offset 24
	.cfi_offset 3, -24
	subq	$24, %rsp
	.cfi_def_cfa_offset 48
	movd	%xmm0, %edi
	movd	%xmm1, %esi
	movd	%xmm0, %ebx
	xorl	%esi, %ebx
	pxor	%xmm2, %xmm2
	ucomiss	%xmm2, %xmm0
	setnp	%al
	movl	$0, %edx
	cmovne	%edx, %eax
	testb	%al, %al
	jne	.L25
	ucomiss	%xmm2, %xmm1
	setnp	%al
	cmovne	%edx, %eax
	testb	%al, %al
	jne	.L25
	movd	%xmm0, %edx
	shrl	$23, %edx
	movd	%xmm1, %eax
	shrl	$23, %eax
	movzbl	%dl, %r8d
	movzbl	%al, %ecx
	leal	-127(%r8,%rcx), %ebp
	cmpl	$255, %ebp
	jbe	.L13
	movss	.LC3(%rip), %xmm0
	testl	%ebx, %ebx
	jns	.L9
	movss	.LC2(%rip), %xmm0
	jmp	.L9
.L25:
	movaps	%xmm0, %xmm2
	andps	.LC5(%rip), %xmm2
	movss	.LC0(%rip), %xmm0
	ucomiss	.LC6(%rip), %xmm2
	ja	.L9
	andps	.LC5(%rip), %xmm1
	ucomiss	.LC6(%rip), %xmm1
	ja	.L9
	pxor	%xmm0, %xmm0
	testl	%ebx, %ebx
	jns	.L9
	movss	.LC1(%rip), %xmm0
	jmp	.L9
.L13:
	andl	$8388607, %edi
	testb	%dl, %dl
	setne	%dl
	movzbl	%dl, %edx
	sall	$23, %edx
	orl	%edx, %edi
	movl	%edi, %edi
	andl	$8388607, %esi
	testb	%al, %al
	setne	%al
	movzbl	%al, %eax
	sall	$23, %eax
	orl	%eax, %esi
	movl	%esi, %esi
	movl	$0, %ecx
	movl	$0, %edx
	call	binmul_recursive
	btq	$47, %rax
	jnc	.L16
	shrq	%rax
	movabsq	$9223301668110598143, %rdx
	andq	%rdx, %rax
	addl	$1, %ebp
.L16:
	sall	$23, %ebp
	movq	%rax, %rcx
	andl	$4194304, %ecx
	movq	%rax, %rdx
	orq	$8388608, %rdx
	testq	%rcx, %rcx
	cmovne	%rdx, %rax
	shrq	$23, %rax
	andl	$-2147483648, %ebx
	orl	%ebx, %ebp
	andl	$-8388609, %eax
	orl	%eax, %ebp
	movl	%ebp, 12(%rsp)
	movd	12(%rsp), %xmm0
.L9:
	addq	$24, %rsp
	.cfi_def_cfa_offset 24
	popq	%rbx
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	ret
.L18:
	.cfi_restore 3
	.cfi_restore 6
	movss	.LC0(%rip), %xmm0
	ret
	.cfi_endproc
.LFE24:
	.size	fmul, .-fmul
	.globl	mul
	.type	mul, @function
mul:
.LFB25:
	.cfi_startproc
	subq	$8, %rsp
	.cfi_def_cfa_offset 16
	pxor	%xmm0, %xmm0
	cvtsi2ss	%edi, %xmm0
	pxor	%xmm1, %xmm1
	cvtsi2ss	%esi, %xmm1
	call	fmul
	cvttss2si	%xmm0, %eax
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE25:
	.size	mul, .-mul
	.section	.rodata.str1.1,"aMS",@progbits,1
.LC9:
	.string	"the answer to life is... %d!\n"
	.section	.rodata.str1.8,"aMS",@progbits,1
	.align 8
.LC10:
	.string	"try it yourself! input 2 floats: "
	.section	.rodata.str1.1
.LC11:
	.string	"%f %f"
.LC12:
	.string	"thinking..."
.LC14:
	.string	"your value is %f (in %lf sec)"
	.text
	.globl	main
	.type	main, @function
main:
.LFB23:
	.cfi_startproc
	pushq	%rbx
	.cfi_def_cfa_offset 16
	.cfi_offset 3, -16
	subq	$32, %rsp
	.cfi_def_cfa_offset 48
	movq	%fs:40, %rax
	movq	%rax, 24(%rsp)
	xorl	%eax, %eax
	movss	.LC7(%rip), %xmm1
	movss	.LC8(%rip), %xmm0
	call	fmul
	cvttss2si	%xmm0, %edx
	leaq	.LC9(%rip), %rsi
	movl	$1, %edi
	movl	$0, %eax
	call	__printf_chk@PLT
	leaq	.LC10(%rip), %rsi
	movl	$1, %edi
	movl	$0, %eax
	call	__printf_chk@PLT
	leaq	20(%rsp), %rdx
	leaq	16(%rsp), %rsi
	leaq	.LC11(%rip), %rdi
	movl	$0, %eax
	call	__isoc99_scanf@PLT
	leaq	.LC12(%rip), %rdi
	call	puts@PLT
	call	clock@PLT
	movq	%rax, %rbx
	movss	20(%rsp), %xmm1
	movss	16(%rsp), %xmm0
	call	fmul
	movss	%xmm0, 12(%rsp)
	call	clock@PLT
	pxor	%xmm1, %xmm1
	cvtsi2sdq	%rax, %xmm1
	pxor	%xmm0, %xmm0
	cvtsi2sdq	%rbx, %xmm0
	subsd	%xmm0, %xmm1
	pxor	%xmm0, %xmm0
	cvtss2sd	12(%rsp), %xmm0
	divsd	.LC13(%rip), %xmm1
	leaq	.LC14(%rip), %rsi
	movl	$1, %edi
	movl	$2, %eax
	call	__printf_chk@PLT
	movq	24(%rsp), %rcx
	xorq	%fs:40, %rcx
	jne	.L35
	movl	$0, %eax
	addq	$32, %rsp
	.cfi_remember_state
	.cfi_def_cfa_offset 16
	popq	%rbx
	.cfi_def_cfa_offset 8
	ret
.L35:
	.cfi_restore_state
	call	__stack_chk_fail@PLT
	.cfi_endproc
.LFE23:
	.size	main, .-main
	.globl	BINMUL_ITERS
	.section	.rodata
	.align 4
	.type	BINMUL_ITERS, @object
	.size	BINMUL_ITERS, 4
BINMUL_ITERS:
	.long	64
	.globl	MANTISSA_LOW_BIT
	.align 8
	.type	MANTISSA_LOW_BIT, @object
	.size	MANTISSA_LOW_BIT, 8
MANTISSA_LOW_BIT:
	.quad	8388608
	.globl	MANTISSA_ROUND_BIT
	.align 8
	.type	MANTISSA_ROUND_BIT, @object
	.size	MANTISSA_ROUND_BIT, 8
MANTISSA_ROUND_BIT:
	.quad	4194304
	.globl	MANT_PROD_HIDDEN_BIT_MASK
	.align 8
	.type	MANT_PROD_HIDDEN_BIT_MASK, @object
	.size	MANT_PROD_HIDDEN_BIT_MASK, 8
MANT_PROD_HIDDEN_BIT_MASK:
	.quad	140737488355328
	.globl	HIDDEN_BIT
	.align 4
	.type	HIDDEN_BIT, @object
	.size	HIDDEN_BIT, 4
HIDDEN_BIT:
	.long	8388608
	.globl	SIGN_MASK
	.align 4
	.type	SIGN_MASK, @object
	.size	SIGN_MASK, 4
SIGN_MASK:
	.long	-2147483648
	.globl	EXPONENT_MASK
	.align 4
	.type	EXPONENT_MASK, @object
	.size	EXPONENT_MASK, 4
EXPONENT_MASK:
	.long	2139095040
	.globl	MANTISSA_MASK
	.align 4
	.type	MANTISSA_MASK, @object
	.size	MANTISSA_MASK, 4
MANTISSA_MASK:
	.long	8388607
	.section	.rodata.cst4,"aM",@progbits,4
	.align 4
.LC0:
	.long	2143289344
	.align 4
.LC1:
	.long	2147483648
	.align 4
.LC2:
	.long	4286578688
	.align 4
.LC3:
	.long	2139095040
	.section	.rodata.cst16,"aM",@progbits,16
	.align 16
.LC5:
	.long	2147483647
	.long	0
	.long	0
	.long	0
	.section	.rodata.cst4
	.align 4
.LC6:
	.long	2139095039
	.align 4
.LC7:
	.long	1088421888
	.align 4
.LC8:
	.long	1086324736
	.section	.rodata.cst8,"aM",@progbits,8
	.align 8
.LC13:
	.long	0
	.long	1093567616
	.ident	"GCC: (Ubuntu 7.5.0-3ubuntu1~18.04) 7.5.0"
	.section	.note.GNU-stack,"",@progbits
