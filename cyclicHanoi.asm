; Projeto para a disciplina Software Básico 2019.2 da UESC
; Autor: Hiago Rios Cordeiro

;Programar a variante cíclica do algoritmo das
;torres de Hanói em linguagem de montagem;
;O algoritmo deverá acessar a pilha para
;implementar a recursividade típica do problema;
;O programa deverá solicitar do usuário, via
;teclado, a configuração inicial das torres, a torre
;de origem, a torre de destino, e a quantidade de
;discos a serem movimentados;
;Para cada movimentação unitária de disco deverá
;ser impressa na tela uma mensagem informando
;o disco de origem, e de destino.

%include        'lib.asm'

section .data
   
    promptDiscos db 'Digite a quantidade de discos: ', NULL
    promptOrigem db 'Digite o pino de origem: ', NULL
    promptAuxiliar db 'Digite o pino auxiliar: ', NULL
    promptDestino db 'Digite o pino de destino: ', NULL
    nAtual db 'N atual: ', NULL

    outputMovimento:
                          db        "Movendo um disco de "
        origem:      db        " "
                          db        " para "
        destino:     db        " ", NULL

section .bss

    qntDiscos resb 4
    pinoOrigem resb 4
    pinoAuxiliar resb 4
    pinoDestino resb 4
    
section .text

    global _start

    _start:

        ;Criando uma nova stack frame
        push ebp
        mov ebp,esp
        ;---------------------------

        ; Pedindo a quantidade de discos
        mov eax, promptDiscos
        call stringPrintLF
        ; Input da quantidade de discos
        mov eax, qntDiscos
        mov ebx, 4
        call inputString
        ; Transformando a qnt de string para inteiro
        mov eax, qntDiscos
        call atoi
        mov [qntDiscos], eax

        ; Pedindo o pino de origem
        mov eax, promptOrigem
        call stringPrintLF
        ; Input da quantidade de discos
        mov eax, pinoOrigem
        mov ebx, 4
        call inputString
        ; Transformando o pino de origem de string para inteiro
        mov eax, pinoOrigem
        call atoi
        mov [pinoOrigem], eax

        ; Pedindo o pino auxiliar
        mov eax, promptAuxiliar
        call stringPrintLF
        ; Input da quantidade de discos
        mov eax, pinoAuxiliar
        mov ebx, 4
        call inputString
        ; Transformando o pino auxiliar de string para inteiro
        mov eax, pinoAuxiliar
        call atoi
        mov [pinoAuxiliar], eax

        ; Pedindo o pino de destino
        mov eax, promptDestino
        call stringPrintLF
        ; Input da quantidade de discos
        mov eax, pinoDestino
        mov ebx, 4
        call inputString
        ; Transformando o pino de destino de string para inteiro
        mov eax, pinoDestino
        call atoi
        mov [pinoDestino], eax

        ; Criando o escopo da chamada de clock
        push dword [pinoAuxiliar]       ; Criando o pino auxiliar na pilha
        push dword [pinoDestino]        ; ''    ''    '' destino na pilha
        push dword [pinoOrigem]         ; ''    ''    '' origem na pilha
        push dword [qntDiscos]          ; Colocando a qnt de discos na pilha

        call clock

        ;Fim
        call exit

    ;clock (n, from, to, aux)
    ;n = ebp+8
    ;from = ebp+12
    ;to = ebp+16
    ;aux = ebp+20
    clock:
        ;Criando uma nova stack frame
        push ebp
        mov ebp,esp
        ;---------------------------

        ;--Verifica se é o caso base--
        ;eax recebe o valor do primeiro elemento da pilha (n atual)
        mov eax,[ebp+8]
        ;Compara n atual com 0x0 = 0 em hexadecimal
        cmp eax,0x0
        ;Se n <= 0, é o caso base e vai para o fim dessa chamada
        jle fim
        ;------------------------------


        ;-------RECURSIVIDADE---------
        ;Colocando o que será o pino auxiliar na pilha
        push dword [ebp+16]
        ;Colocando o que será o pino de destino na pilha
        push dword [ebp+20]
        ;Colocando o que será o pino de origem na pilha
        push dword [ebp+12]
        ;Poe n-1 na pilha
        dec eax
        push dword eax
        call anti
        ;-------RECURSIVIDADE---------

        ;Faz um pop de 4x4bytes
        add esp,16

        ;-------IMPRIME MOVIMENTO ------
        ;Colocando o que será o pino de destino na pilha
        push dword [ebp+16]
        ;Colocando o que será o pino de origem na pilha
        push dword [ebp+12]
        ;Coloca n atual na pilha
        push dword [ebp+8]
        call imprimePasso
        ;-------IMPRIME MOVIMENTO ------
        
        ;Faz um pop de 3x4bytes
        add esp,12

        ;-------RECURSIVIDADE---------
        ;Colocando o que será o pino auxiliar na pilha
        push dword [ebp+12]
        ;Colocando o que será o pino de destino na pilha
        push dword [ebp+16]
        ;Colocando o que será o pino de origem na pilha
        push dword [ebp+20]
        ;Move n para eax
        mov eax,[ebp+8]
        ;Decrementa 1 de eax (n atual)
        dec eax
        push dword eax
        call anti
        ;-------RECURSIVIDADE---------

        ;Faz um pop de 4x4bytes
        add esp,16
        jmp fim

    ;anti (n, from, to, aux)
    ;n = ebp+8
    ;from = ebp+12
    ;to = ebp+16
    ;aux = ebp+20
    anti:
        ;Criando uma nova stack frame
        push ebp
        mov ebp,esp
        ;---------------------------

        ;--Verifica se é o caso base--
        ;eax recebe o valor do primeiro elemento da pilha (n atual)
        mov eax,[ebp+8]
        ;Compara n atual com 0x0 = 0 em hexadecimal
        cmp eax,0x0
        ;Se n <= 0, é o caso base e vai para o fim dessa chamada
        jle fim
        ;------------------------------

        ;-------RECURSIVIDADE---------
        ;Colocando o que será o pino auxiliar na pilha
        push dword [ebp+20]
        ;Colocando o que será o pino de destino na pilha
        push dword [ebp+16]
        ;Colocando o que será o pino de origem na pilha
        push dword [ebp+12]
        ;Decrementa n e poe na pilha
        dec eax
        push dword eax
        call anti
        ;-------RECURSIVIDADE---------

        ;Faz um pop de 5x4bytes
        add esp,16

        ;-------IMPRIME MOVIMENTO ------
        ;Colocando o que será o pino de destino na pilha
        push dword [ebp+20]
        ;Colocando o que será o pino de origem na pilha
        push dword [ebp+12]
        ;Coloca n atual na pilha
        push dword [ebp+8]
        call imprimePasso
        ;-------IMPRIME MOVIMENTO ------
        
        ;Faz um pop de 3x4bytes
        add esp,12

        ;-------RECURSIVIDADE---------
        ;Colocando o que será o pino auxiliar na pilha
        push dword [ebp+20]
        ;Colocando o que será o pino de destino na pilha
        push dword [ebp+12]
        ;Colocando o que será o pino de origem na pilha
        push dword [ebp+16]
        ;Move n para eax
        mov eax,[ebp+8]
        ;Decrementa n e poe na pilha
        dec eax
        push dword eax
        call clock
        ;-------RECURSIVIDADE---------

        ;Faz um pop de 4x4bytes
        add esp,16

        ;-------IMPRIME MOVIMENTO ------
        ;Colocando o que será o pino de destino na pilha
        push dword [ebp+16]
        ;Colocando o que será o pino de origem na pilha
        push dword [ebp+20]
        ;Coloca n atual na pilha
        push dword [ebp+8]
        call imprimePasso
        ;-------IMPRIME MOVIMENTO ------

        ;Faz um pop de 3x4bytes
        add esp,12

        ;-------RECURSIVIDADE---------
        ;Colocando o que será o pino auxiliar na pilha
        push dword [ebp+20]
        ;Colocando o que será o pino de destino na pilha
        push dword [ebp+16]
        ;Colocando o que será o pino de origem na pilha
        push dword [ebp+12]
        ;Move n para eax
        mov eax,[ebp+8]
        ;Decrementa n e poe na pilha
        dec eax
        push dword eax
        call anti
        ;-------RECURSIVIDADE---------

        ;Faz um pop de 4x4bytes
        add esp,16
        jmp fim

    fim:
        ;Voltando à stack frame anterior
        mov esp,ebp
        pop ebp
        ;--------------------------------
        ret

    imprimePasso:
        ;Criando uma nova stack frame
        push ebp
        mov ebp,esp
        ;---------------------------

        ;Pino de origem
        mov eax, [ebp+12]
        ;Conversao para ASCII
        add al, '0'
        ;Movimento: movendo o conteudo de al para [origem]
        mov [origem], al

        ;Pino de destino
        mov eax, [ebp+16]
        ;Conversao para ASCII
        add al, '0'
        ;Movimento: movendo o conteudo de al para [destino]
        mov [destino], al

        ;Imprime a mensagem de movimento de disco
        mov eax, outputMovimento
        call stringPrintLF

        ;mov eax, nAtual
        ;call stringPrint
        ;mov eax, [ebp+8]
        ;call intPrintLF

        ;Voltando à stack frame anterior
        mov esp,ebp
        pop ebp
        ;--------------------------------
        ret