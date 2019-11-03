;This program counts from 1 to 10

%include        'lib.asm'

section .text
global _start

_start:
 
    mov     ecx, 0

    nextNumber:
    inc     ecx
    mov     eax, ecx
    call    intPrintLF        ; NOTE call our new integer printing function (itoa)
    cmp     ecx, 10
    jne     nextNumber
 
    call    exit