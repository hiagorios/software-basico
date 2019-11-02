;Programa que retorna um valor

;ax - acumulador pra operacoes numericas
;bx - acumulador de registro base
;cx - registrador usado com strings
;dx - registrador de dados
;Em assembly 32 bits -> eax, ebx, ecx, edx
;Em assembly 64 bits -> rax, rbx, rcx, rdx

section .data
    SYS_EXIT    equ 1

section .text
    global _start

    _start:
        mov eax, SYS_EXIT
        mov ebx, 9
        int 0x80
