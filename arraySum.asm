;Faça um programa em linguagem de montagem
;que seja capaz de somar todos os elementos de
;um vetor de inteiros dado como entrada;
;Para tanto, faça a escolha adequada dos modos
;de endereçamento estudados até aqui, de
;maneira a melhorar a eficiência do programa;
;-----------------------------------------------------------------
%include        'lib.asm'

section .data
    msgInput1      db 'Digite o ', NULL
    msgInput2      db 'o elemento do vetor', LF, NULL

section .text

global _start

_start:
    mov eax, msgInput1
    call stringPrintLF
    call exit

output:
    mov eax, SYS_WRITE
    mov ebx, STD_OUT
    int 0x80
    ret

input:
    mov eax, SYS_READ
    mov ebx, STD_IN
    int 0x80
    ret