; Projeto para a disciplina Software Básico 2019.2 da UESC
; Autor: Hiago Rios Cordeiro

%include        'lib.asm'

section .data
   
    prompt db 'Digite a quantidade de discos: ', NULL

    msg:
                          db        "ORIGEM: "                      
        pino_origem:      db        " "  
                          db        " | DESTINO: "     
        pino_destino:     db        " ", 0xa  
        lenght            equ       $-msg

section .bss

    qntDiscos resb 5
    
section .text

    global _start

    _start:

        push ebp                        ; salva o registrador base na pilha
        mov ebp, esp                    ; ebp recebe o ponteiro para o topo da pilha (esp)

        ; Pedindo a quantidade de discos
        mov eax, prompt
        call stringPrintLF

        ; Input da quantidade de discos
        mov eax, qntDiscos
        mov ebx, 5
        call inputString
        
        ; Transformando a qnt de string para inteiro
        mov eax, qntDiscos
        call atoi

        ; REFERENCIA PARA AS 3 PILHAS (3 PINOS) DA TORRE DE HANOI EM ORDEM
        push dword 0x2                  ; Criando o pino auxiliar na pilha
        push dword 0x3                  ; ''    ''    '' destino na pilha
        push dword 0x1                  ; ''    ''    '' origem na pilha
        push eax                        ; Colocando a qnt de discos na pilha

        call funcaoHanoi

        ;Fim
        call exit

    funcaoHanoi: 
        ;[ebp+8] = n (número de discos iniciais)
        ;[ebp+12] = pino de origem
        ;[ebp+16] = pino auxiliar
        ;[ebp+20] = pino de destino
        ;link: http://www.devmedia.com.br/torres-de-hanoi-solucao-recursiva-em-java/23738

        ;Salva ebp na pilha
        push ebp
        ;ebp recebe o endereço do topo da pilha
        mov ebp,esp

        ;Pega o a posição do primeiro elemento da pilha e mov para eax
        mov eax,[ebp+8]
        ;Compara o valor que de eax (n atual) com 0x0 = 0 em hexadecimal
        cmp eax,0x0
        ;Se eax <= 0, é o caso base e vai para o fim, desempilhar
        jle fim
        
        ;PASSO1 - RECURSIVIDADE
        ;Decrementa 1 de eax (n atual)
        dec eax            
        ;Coloca o pino auxiliar na pilha
        push dword [ebp+16]
        ;Coloca o pino de destino na pilha
        push dword [ebp+20]
        ;Coloca o pino de origem na pilha
        push dword [ebp+12]
        ;Poe eax na pilha como parâmetro n, já com -1 para a recursividade
        push dword eax
        ;Chama a funcao recursivamente
        call funcaoHanoi

        ;PASSO2 - MOVER PINO E IMPRIMIR
        ;Faz um pop de 3x4bytes - Último e primeiro parâmetro
        add esp,12
        ; pega o pino de origem referenciado pelo parâmetro ebp+16
        push dword [ebp+16]
        ; coloca na pilha o pino de origem
        push dword [ebp+12]
        ; coloca na pilha o pino de o numero de disco inicial
        push dword [ebp+8]
        call imprime
        
        ;PASSO3 - RECURSIVIDADE
        ;Faz um pop de 3x4bytes - Último e primeiro parâmetro
        add esp,12
        ;Coloca o pino de origem na pilha
        push dword [ebp+12]
        ;Coloca o pino auxiliar na pilha
        push dword [ebp+16]
        ;Coloca o pino de destino na pilha
        push dword [ebp+20]
        ;Move para o registrador eax o espaço reservado ao número de discos atuais
        mov eax,[ebp+8]
        ;Decrementa 1 de eax (n atual)
        dec eax
        push dword eax                  ; poe eax na pilha
        call funcaoHanoi                ; (recursividade)

    fim:
        ;Move o valor de ebp para esp
        mov esp,ebp
        ;Desempilha o ebp
        pop ebp
        ret

    imprime:
        ;Empilha ebp
        push ebp
        ;ebp recebe o endereço do topo da pilha
        mov ebp, esp

        ;Pino auxiliar
        mov eax, [ebp + 12]
        ;Conversao para ASCII
        add al, '0'
        ;Movimento: movendo o conteudo de al para [pino_origem]
        mov [pino_origem], al

        ;Pino de destino
        mov eax, [ebp + 16]
        ;Conversao para ASCII
        add al, '0'
        ;Movimento: movendo o conteudo de al para [pino_destino]
        mov [pino_destino], al

        ;Imprime a mensagem de movimento de disco
        mov eax, msg
        mov ebx, lenght
        call stringPrintLF

        ;Copiando o valor do registrador EBP para o ESP
        mov esp, ebp
        ; Recupera valor do topo da pilha para o registrador EBP
        pop ebp
        ret