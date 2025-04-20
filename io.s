section .data

section .text

global str_len
global print_str
global print_char
global print_newline
global print_uint
global print_int
global str_cmp
global str_cpy


; counts null-terminated string length
str_len:
        xor rax, rax
.loop:
        cmp byte[rdi + rax], 0
        je .done
        add rax, 1
        jmp .loop
.done:
        ret


; prints a null-terminated string
print_str:
        push rdi
	sub rsp, 8

        call str_len

	add rsp, 8
	pop rsi

        mov rdx, rax
        mov rax, 1
        mov rdi, 1
        syscall
        ret


; prints a character
print_char:
        sub rsp, 16
        mov byte[rsp], dil

        mov rax, 1
        mov rdi, 1
        mov rsi, rsp
        mov rdx, 1

        syscall

        add rsp, 16
        ret


; prints the newline character
print_newline:
	sub rsp, 16
	mov byte[rsp], 10
        mov rax, 1
        mov rdi, 1
        mov rsi, rsp
        mov rdx, 1
        syscall
	add rsp, 16
        ret


; prints an unsigned integer in decimal format
print_uint:
        sub rsp, 32
        mov rax, rdi
        lea rdi, [rsp + 31]
        mov byte[rdi], 0
        sub rdi, 1
.loop:
        cmp rax, 0
        je .done

        xor rdx, rdx
        mov rcx, 10
        div rcx

        mov byte[rdi], dl
        add byte[rdi], '0'
        sub rdi, 1

        jmp .loop
.done:
        add rdi, 1
        call print_str

        add rsp, 32
        ret


; prints a signed integer in decimal format
print_int:
        sub rsp, 32
        mov rax, rdi

        ; determine sign
	test rax, rax
	sets r10b

	js .neg
	jmp .then
.neg:
	neg rax
.then:
	; null-terminate string
        lea rdi, [rsp + 31]
        mov byte[rdi], 0
        sub rdi, 1
.loop:
        cmp rax, 0
        je .loop_done

	; div by 10, remainder is digit
        mov rcx, 10
        cqo
        idiv rcx

        mov byte[rdi], dl
        add byte[rdi], '0'
        sub rdi, 1

        jmp .loop
.loop_done:
        cmp r10b, 0
        je .done
        mov byte[rdi], '-'
        sub rdi, 1
.done:
        add rdi, 1
        call print_str

        add rsp, 32
        ret


; returns 1, 0, -1 if [rdi] is lexicographically above, equal, below [rsi]
str_cmp:
	xor rax, rax
.loop:
	mov cl, [rdi + rax]
	cmp cl, [rsi + rax]
	je .eq
	jg .gt
	jmp .lt
.eq:
	jz .done
	jmp .loop
.gt:
	mov rax, 1
	ret
.lt:
	mov rax, -1 
.done:
	ret


; copies string into a buffer, returns 0 if string exceeds buffer size
str_cpy:
	xor rax, rax
.loop:
	cmp rax, rdx
	jae .fail

	mov dl, [rdi + rax]
	mov [rsi + rax], dl

	cmp dl, 0
	je .done

	add rax, 1
	jmp .loop
.fail:
	mov rax, 0
	ret
.done:
	mov rax, rsi
	ret


; exits the process, assumes exit code is set
exit:
        mov rax, 60
        syscall

