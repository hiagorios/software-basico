;Programa que retorna um valor

section .data
    SYS_EXIT    equ 1

section .text
    global _start

    _start:
        mov eax, SYS_EXIT
        mov ebx, 9
        int 0x80
