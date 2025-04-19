section .data

msg: db 'Arsenal at the Bernebau!', 0
msg1: db 'Different', 0
newline: db 10

section .text

global _start
global _str_len
global _print_str
global _print_char
global _print_newline
global _print_uint
global _print_int
global _str_cmp
global _str_cpy

_start:
        lea rdi, [msg]
        call _print_str
        call _print_newline

	mov rdi, msg1
	mov rsi, msg
	mov rdx, 20
	call _str_cpy

	mov rdi, rsi
	call _print_str
	call _print_newline

        call exit


; counts null-terminated string length
_str_len:
        xor rax, rax
        mov cl, 0
.iter:
        cmp cl, byte[rdi + rax]
        je .done
        add rax, 1
        jmp .iter
.done:
        ret


; prints a null-terminated string
_print_str:
        push rdi
	sub rsp, 8

        call _str_len

	add rsp, 8
	pop rsi

        mov rdx, rax
        mov rax, 1
        mov rdi, 1
        syscall
        ret


; prints a character
_print_char:
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
_print_newline:
        mov rax, 1
        mov rdi, 1
        mov rsi, newline
        mov rdx, 1
        syscall
        ret


; prints an unsigned integer in decimal format
_print_uint:
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
        call _print_str

        add rsp, 32
        ret


; prints a signed integer in decimal format
_print_int:
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
        call _print_str

        add rsp, 32
        ret


; returns 1, 0, -1 if [rdi] is lexicographically above, equal, below [rsi]
_str_cmp:
	xor rax, rax
.loop:
	mov rcx, [rdi + rax]
	cmp rcx, [rsi + rax]
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
_str_cpy:
	xor rax, rax
.loop:
	cmp byte[rdi + rax], 0
	je .break
	add rax, 1
	cmp rax, rcx
	ja .fail

	mov dl, [rdi + rax - 1]
	mov [rsi + rax - 1], dl
	jmp .loop
.fail:
	mov rax, 0
	ret
.break:
	cmp rax, rcx
	je .done
	mov byte[rsi + rax], 0
.done:
	mov rax, rsi
	ret


; exits the process, assumes exit code is set
exit:
        mov rax, 60
        syscall

