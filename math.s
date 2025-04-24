section .text

global factorial
global fibonacci
global is_fib
global isqrt


factorial:
	xor rax, rax
	mov al, dil
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
	and rdi, 0xff
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

