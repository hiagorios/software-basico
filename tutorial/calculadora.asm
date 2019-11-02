;Eu nao acredito que vou realmente fazer uma calculadora em assembly

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

    tit db 10,'+--------------',10,'Calculadora',10,'--------------+',0
    lenTit equ $ - tit

    msgValor1 db 10,'Valor 1: ', 0
    lenMsgValor1 equ $ - msgValor1
    msgValor2 db 10,'Valor 2: ', 0
    lenMsgValor2 equ $ - msgValor2

    opt1 db 10,'1. Adicionar: ', 0
    lenOpt1 equ $ - opt1

    opt2 db 10,'2. Subtrair: ', 0
    lenOpt2 equ $ - opt2

    opt3 db 10,'3. Multiplicar: ', 0
    lenOpt3 equ $ - opt3

    opt4 db 10,'4. Dividir: ', 0
    lenOpt4 equ $ - opt4

    msgOpt db 10,'Deseja realizar? ', 0
    lenMsgOpt equ $ - msgOpt

    msgErro db 10,'Opcao invalida', 0
    lenMsgErro equ $ - msgErro

    nLinha db 10,0
    lenLinha equ $ - nLinha

section .bss
    opt resb 2
    num1 resb 10
    num2 resb 10
    result resb 10

section .text


global _start

_start:
    ;Mostrando titulo
    mov ecx, tit
    mov edx, lenTit
    call output

    mov ecx, msgValor1
    mov edx, lenMsgValor1
    call output

    mov ecx, num1
    mov edx, 10
    call input

    mov ecx, msgValor2
    mov edx, lenMsgValor2
    call output

    mov ecx, num2
    mov edx, 10
    call input

    mov ecx, opt1
    mov edx, lenOpt1
    call output
    
    mov ecx, opt2
    mov edx, lenOpt2
    call output

    mov ecx, opt3
    mov edx, lenOpt3
    call output

    mov ecx, opt4
    mov edx, lenOpt4
    call output

    mov ecx, opt
    mov edx, 2
    call input

    mov ah, opt
    sub ah, '0' ;convertendo a string pra inteiro

    cmp ah, 1
    je adicionar
    cmp ah, 2
    je subtrair
    cmp ah, 3
    je multiplicar
    cmp ah, 4
    je dividir

    mov ecx, msgErro
    mov edx, lenMsgErro
    call output
    jmp exit

adicionar:
    add eax, ebx
    jmp exit

substrair:
    sub eax, ebx
    jmp exit

multiplicar:
    mul bx
    jmp exit

dividir:
    div bx
    jmp exit

exit:
    mov ecx, nLinha
    mov edx, lenLinha
    call output
    mov eax, SYS_EXIT
    int 0x80

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