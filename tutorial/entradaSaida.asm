; Programa para entrada de dados

section .data
    SYS_EXIT    equ 1
    RET_EXIT    equ 5
    SYS_READ    equ 3
    SYS_WRITE   equ 4
    STD_IN      equ 0
    STD_OUT     equ 1
    MAX_IN      equ 10

    msg db 'Entre com seu nome: ', 0xA, 0xD
    msgLen equ $ - msg
    hello db 'Olá ', 0xA, 0xD
    helloLen equ $ - hello

section .bss
    nome resb MAX_IN

section .text
    global _start

    _start:
        ;Msg na tela
        ;Sempre antes de mostrar uma msg
        mov eax, SYS_WRITE
        mov ebx, STD_OUT
        ;se executa esses dois passos
        mov ecx, msg
        mov edx, msgLen
        int 0x80

        ;Entrada de dados
        ;Sempre antes de capturar um input
        mov eax, SYS_READ
        mov ebx, STD_IN
        ;se executa esses dois passos
        mov ecx, nome
        mov edx, MAX_IN
        int 0x80

        ;Dizendo olá pro usuario
        mov eax, SYS_WRITE
        mov ebx, STD_OUT
        mov ecx, hello
        mov edx, helloLen
        int 0x80

    exit:
        mov eax, SYS_EXIT
        mov ebx, RET_EXIT ;equivalente a xor ebx, ebx
        int 0x80