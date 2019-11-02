;Programa que retorna um valor

;ax - acumulador pra operacoes numericas
;bx - acumulador de registro base
;cx - registrador usado com strings
;dx - registrador de dados
;Em assembly 32 bits -> eax, ebx, ecx, edx
;Em assembly 64 bits -> rax, rbx, rcx, rdx

;db     Define byte         1 byte
;dw     Define word         2 bytes
;dd     Define double word  4 bytes
;dq     Define quad word    4 bytes
;dt     Define ten word     10 bytes

section .data
    SYS_EXIT    equ 1

section .text
    global _start

    _start:
        mov eax, SYS_EXIT
        mov ebx, 9
        int 0x80
