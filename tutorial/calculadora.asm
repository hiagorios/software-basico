;Eu nao acredito que vou realmente fazer uma calculadora em assembly

%include 'lib.asm'

section .data
    tit db 10,'+--------------',10,'Calculadora',10,'--------------+',0
    msgValor1 db 10,'Valor 1: ', 0
    msgValor2 db 10,'Valor 2: ', 0
    opt1 db 10,'1. Adicionar: ', 0
    opt2 db 10,'2. Subtrair: ', 0
    opt3 db 10,'3. Multiplicar: ', 0
    opt4 db 10,'4. Dividir: ', 0
    msgOpt db 10,'Deseja realizar? ', 0
    msgErro db 10,'Opcao invalida', 0

section .bss
    opt resb 2
    num1 resb 5
    num2 resb 5
    result resb 5

section .text
global _start

_start:
    mov eax, tit
    call stringPrintLF

    mov eax, msgValor1
    call stringPrintLF

    mov ecx, num1
    mov edx, 10
    call input

    mov eax, msgValor2
    call stringPrintLF

    mov ecx, num2
    mov edx, 10
    call input

    mov eax, opt1
    call stringPrintLF
    
    mov eax, opt2
    call stringPrintLF

    mov eax, opt3
    call stringPrintLF

    mov eax, opt4
    call stringPrintLF

    mov ecx, opt
    mov edx, 2
    call input

    mov eax, num1
    call atoi
    ; isso nao ta funcionando, nao consigo mover o valor convertido de eax pra num1 de volta
    mov [num1], eax
    mov eax, num1
    call intPrintLF

    mov eax, opt
    call atoi

    cmp eax, 1
    je adicionar
    cmp eax, 2
    je subtrair
    cmp eax, 3
    je multiplicar
    cmp eax, 4
    je dividir

    mov eax, msgErro
    call stringPrintLF
    jmp exit

adicionar:
    mov     eax, num1     ; move our first number into eax
    mov     ebx, num2      ; move our second number into ebx
    add     eax, ebx    ; add ebx to eax
    call    intPrintLF    ; call our integer print with linefeed function
    jmp exit

subtrair:
    mov     eax, num1       ; move our first number into eax
    mov     ebx, num2       ; move our second number into ebx
    sub     eax, ebx        ; sub ebx from eax
    call    intPrintLF    ; call our integer print with linefeed function
    jmp exit

multiplicar:
    mov     eax, num1       ; move our first number into eax
    mov     ebx, num2       ; move our second number into ebx
    mul     ebx             ;multiply eax by ebx
    call    intPrintLF      ; call our integer print with linefeed function
    jmp exit

dividir:
    mov     eax, 90     ; move our first number into eax
    mov     ebx, 9      ; move our second number into ebx
    div     ebx         ; divide eax by ebx
    call    intPrint      ; call our integer print function on the quotient
    call    stringPrint      ; call our string print function
    mov     eax, edx    ; move our remainder into eax
    call    intPrintLF    ; call our integer printing with linefeed function
    jmp exit

input:
    mov eax, SYS_READ
    mov ebx, STD_IN
    int 0x80
    ret