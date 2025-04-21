section .data

section .text

global str_len
global print_str
global print_char
global print_newline
global print_uint
global print_int
global read_char
global read_word
global parse_uint
global parse_int
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
	mov dil, 10
	jmp print_char


print_uint:
	mov rsi, 0
	jmp print_int.guard


print_int:
	mov rsi, 0
	cmp rdi, 0
	jge print_int.guard
	neg rdi
	mov rsi, 1
.guard:
	test rdi, rdi
	jnz .core
	add dil, '0'
	jmp print_char
.core:
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
	cmp rsi, 0
	je .print
	mov byte[rdi], '-'
	sub rdi, 1
.print:
        add rdi, 1
        call print_str

        add rsp, 32
        ret


; may leave unread bytes in the stream
read_char:
	sub rsp, 16
	xor rax, rax
	xor rdi, rdi
	mov rsi, rsp
	mov rdx, 16
	syscall

	test rax, rax
	jz .done

	xor rax, rax
	mov al, [rsp]
.done:
	add rsp, 16
	ret


; opts to read all available bytes in one syscall
read_word:
	mov r10, rdi

	xor rax, rax
	mov rdx, rsi
	mov rsi, rdi
	xor rdi, rdi
	syscall

	test rax, rax
	jz .fail

	cmp rax, rdx
	jb .fits

	cmp byte[r10 + rax - 1], 10
	je .fits
.fail:
	xor rax, rax  ; failed, return NULL
	ret
.fits:
	xor rsi, rsi  ; slow pointer
	xor rdx, rdx  ; fast pointer
.loop:
	cmp byte[r10 + rdx], 0x20 ; space
	je .skip
	cmp byte[r10 + rdx], 0x09 ; tab
	je .skip
	jmp .next
.skip:
	add rdx, 1
	jmp .loop
.next:
	cmp rdx, rax
	jge .done
	mov cl, [r10 + rdx]
	cmp cl, 10
	je .done

	mov [r10 + rsi], cl
	add rsi, 1
	add rdx, 1
	jmp .loop
.done:
	mov byte[r10 + rsi], 0
	mov rax, r10
	ret


parse_uint:
	xor rax, rax
	xor rsi, rsi
	xor rdx, rdx
	xor r10, r10
	mov rcx, 10
.loop:
	mov r10b, [rdi + rsi]

	test r10b, r10b
	jz .done
	cmp r10b, '0'
	jb .next
	cmp r10b, '9'
	ja .next

	sub r10b, '0'
	mul rcx
	add rax, r10
	jo .done
.next:
	add rsi, 1
	jmp .loop
.done:
	ret
	

parse_int:
	xor rax, rax
	xor rsi, rsi
	xor rdx, rdx
	xor r10, r10
	xor r11, r11
	mov rcx, 10

	mov r10b, [rdi + rsi]
	cmp r10b, '-'
	sete r11b
	jne .loop
	add rsi, 1
.loop:
	mov r10b, [rdi + rsi]
	test r10b, r10b
	jz .break

	cmp r10b, '0'
	jb .next
	cmp r10b, '9'
	ja .next

	mul rcx
	sub r10b, '0'
	add rax, r10 
	jo .done
.next:
	add rsi, 1
	jmp .loop
.break:
	xor rsi, rsi
	sub rsi, r11
	test rsi, rsi
	jz .done
	imul rsi
.done:
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

