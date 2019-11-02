;Programa que compara x e y e diz o resultado

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
    RET_EXIT    equ 5
    SYS_READ    equ 3
    SYS_WRITE   equ 4
    STD_IN      equ 0
    STD_OUT     equ 1
    MAX_IN      equ 10

    x dd 10
    y dd 10
    msg1 db 'X maior que Y', 0xA
    len1 equ $ - msg1
    msg2 db 'Y maior que X', 0xA
    len2 equ $ - msg2
    msg3 db 'X e Y são iguais', 0xA
    len3 equ $ - msg3

section .text

    global _start

    _start:
        mov eax, DWORD[x]
        mov ebx, DWORD[y]
        cmp eax, ebx        ;comparacao
        jg maior
        jl menor
        mov ecx, msg3
        mov edx, len3
        jmp final

    maior:
        mov ecx, msg1
        mov edx, len1
        jmp final

    menor:
        mov ecx, msg2
        mov edx, len2
        jmp final

    final:
        mov eax, SYS_WRITE
        mov ebx, STD_OUT
        int 0x80
        mov eax, SYS_EXIT
        int 0x80