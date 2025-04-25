section .text

global factorial
global fibonacci
global is_fib
global isqrt


factorial:
	xor rax, rax
	mov al, dil ; factorial(256) > 2^64
	xor rdi, rdi
	mov dil, al
.loop:
	cmp rdi, 2
	jbe .done
	sub rdi, 1
	mul rdi
	jmp .loop
.done:
	ret


fibonacci:
	and rdi, 0xff ; fibonacci(256) > 2^64
	xor rax, rax
	mov rcx, 1
	mov rdx, 1
.loop:
	test rdi, rdi
	jz .done
	mov rax, rcx
	mov rcx, rdx
	xor rdx, rdx
	add rdx, rax
	add rdx, rcx
	sub rdi, 1
	jmp .loop
.done:
	ret


; is_fib checks if 5n^2 + 4 or 5n^2 - 4 is perfect square
is_fib:
	push r12

	and rdi, 0xffffffff
	mov rax, rdi
	mul rdi
	mov rcx, 5
	mul rcx
	mov r12, rax
	add r12, 4

	mov rdi, r12
	call isqrt

	mul rax
	cmp rax, r12
	je .true
	sub r12, 8

	mov rdi, r12
	; pushed a qword at prologue, so 16-bit aligned after call
	call isqrt
	mul rax
	cmp rax, r12
	je .true

	xor rax, rax
	jmp .done
.true:
	mov rax, 1
.done:
	pop r12
	ret


isqrt:
	xor rcx, rcx
	mov rcx, 1
	shl rcx, 31 ; max possible sqrt of a 64-bit int < 2^32
.loop:
	cmp rcx, rdi
	jl .break
	shr rcx, 1
	jmp .loop
.break:
	xor rax, rax
.calc:
	or rax, rcx
	mov r8, rax
	mov rdx, rax
	mul rdx
	cmp rax, rdi
	mov rax, r8
	je .done
	jl .less
	xor rax, rcx
.less:
	shr rcx, 1
	test rcx, rcx
	jz .done
	jmp .calc
.done:
	ret

