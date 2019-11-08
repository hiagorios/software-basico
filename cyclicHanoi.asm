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

        ; Fim
        call exit

    funcaoHanoi: 
        ;[ebp+8] = n (número de discos iniciais)
        ;[ebp+12] = pino de origem
        ;[ebp+16] = pino auxiliar
        ;[ebp+20] = pino de destino
        ;link: http://www.devmedia.com.br/torres-de-hanoi-solucao-recursiva-em-java/23738

        push ebp                        ; salva o registrador ebp na pilha
        mov ebp,esp                     ; ebp recebe o endereço do topo da pilha

        mov eax,[ebp+8]                 ; pega o a posição do primeiro elemento da pilha e mov para eax
        cmp eax,0x0                     ; cmp faz o comparativo do valor que estar em eax com 0x0 = 0 em hexadecimal 
        jle fim                         ; se eax for menor ou igual a 0, vai para o fim, desempilhar
        
        ;PASSO1 - RECURSIVIDADE
        dec eax                         ; decrementa 1 de eax
        push dword [ebp+16]             ; coloca na pilha o pino de trabalho
        push dword [ebp+20]             ; coloca na pilha o pino de destino
        push dword [ebp+12]             ; coloca na pilha o pino de origem
        push dword eax                  ; poe eax na pilha como parâmetro n, já com -1 para a recursividade
        call funcaoHanoi                ; Chama a mesma função (recursividade)

        ;PASSO2 - MOVER PINO E IMPRIMIR
        add esp,12                      ; libera mais 12 bits de espaço (20 - 8) Último e primeiro parâmetro
        push dword [ebp+16]             ; pega o pino de origem referenciado pelo parâmetro ebp+16
        push dword [ebp+12]             ; coloca na pilha o pino de origem
        push dword [ebp+8]              ; coloca na pilha o pino de o numero de disco inicial
        call imprime                    ; Chama a função 'imprime'
        
        ;PASSO3 - RECURSIVIDADE
        add esp,12                      ; libera mais 12 bits de espaço (20 - 8) Último e primeiro parâmetro
        push dword [ebp+12]             ; coloca na pilha o pino de origem
        push dword [ebp+16]             ; coloca na pilha o pino de trabalho
        push dword [ebp+20]             ; coloca na pilha o pino de destino
        mov eax,[ebp+8]                 ; move para o registrador eax o espaço reservado ao número de discos atuais
        dec eax                         ; decrementa 1 de eax

    push dword eax                      ; poe eax na pilha
        call funcaoHanoi                ; (recursividade)

    fim: 
        mov esp,ebp                     ; Move o valor de ebp para esp (guarda em outro registrador)
        pop ebp                         ; Remove da pilha (desempilha) o ebp
        ret                             ; Retorna a função de origem (antes de ter chamado a função 'fim')

    imprime:
        push ebp                        ; Empilha
        mov ebp, esp                    ; ebp recebe o endereÃ§o do topo da pilha

        mov eax, [ebp + 12]             ; pino de trabalho
        add al, '0'                     ; conversao para ASCII
        mov [pino_origem], al           ; movimento: movendo o conteudo de al para [pino_origem]

        mov eax, [ebp + 16]             ; pino de destino**
        add al, '0'                     ; conversao para ASCII
        mov [pino_destino], al          ; movimento: movendo o conteudo de al para [pino_destino]

        mov edx, lenght                 ; tamanho da mensagem formatada
        mov ecx, msg                    ; mensagem formatada
        mov ebx, 1                      ; dá permissão para a saida
        mov eax, 4                      ; informa que será uma escrita no ecrã
        int 0x80                        ; Interrupção para kernel do linux

        mov     esp, ebp                ; Copiando o valor do registrador EBP para o ESP
        pop     ebp                     ; Recupera valor do topo da pilha para o registrador EBP
        ret                             ; retornar ao chamador