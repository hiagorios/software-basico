;ax - acumulador pra operacoes numericas
;bx - acumulador de registro base
;cx - registrador usado com strings
;dx - registrador de dados
;Em assembly 32 bits -> eax, ebx, ecx, edx
;Em assembly 64 bits -> rax, rbx, rcx, rdx
;-----------------------------------------
;db     Define byte         1 byte
;dw     Define word         2 bytes
;dd     Define double word  4 bytes
;dq     Define quad word    4 bytes
;dt     Define ten word     10 bytes
;-----------------------------
;variable      RESB    1       ; reserve space for 1 byte
;variable      RESW    1       ; reserve space for 1 word
;variable      RESD    1       ; reserve space for 1 double word
;variable      RESQ    1       ; reserve space for 1 double precision float (quad word)
;variable      REST    1       ; reserve space for 1 extended precision float

;----------------------------------
; Define standard constants.
LF              equ 10 ; line feed
NULL            equ 0 ; end of string
TRUE            equ 1
FALSE           equ 0
EXIT_SUCCESS    equ 0 ; success code
STD_IN          equ 0 ; standard input
STD_OUT         equ 1 ; standard output
STD_ERR         equ 2 ; standard error
SYS_EXIT        equ 1
SYS_READ        equ 3 ; read
SYS_WRITE       equ 4 ; write
SYS_OPEN        equ 2 ; file open
SYS_CLOSE       equ 3 ; file close
SYS_FORK        equ 57 ; fork
SYS_CREAT       equ 85 ; file open/create
SYS_TIME        equ 201 ; get time

;------------------------------------------
; int stringLen(String message)
; String length calculation function
stringLen:
    push    ebx
    mov     ebx, eax
 
nextchar:
    cmp     byte [eax], 0
    jz      finished
    inc     eax
    jmp     nextchar
 
finished:
    sub     eax, ebx
    pop     ebx
    ret
 
 
;------------------------------------------
; void stringPrint(String message)
; String printing function
stringPrint:
    push    edx
    push    ecx
    push    ebx
    push    eax
    call    stringLen
 
    mov     edx, eax
    pop     eax
 
    mov     ecx, eax
    mov     ebx, 1
    mov     eax, 4
    int     80h
 
    pop     ebx
    pop     ecx
    pop     edx
    ret
 
;------------------------------------------
; void stringPrintLF(String message)
; String printing with line feed function
stringPrintLF:
    call    stringPrint
 
    push    eax         ; push eax onto the stack to preserve it while we use the eax register in this function
    mov     eax, 0Ah    ; move 0Ah into eax - 0Ah is the ascii character for a linefeed
    push    eax         ; push the linefeed onto the stack so we can get the address
    mov     eax, esp    ; move the address of the current stack pointer into eax for stringPrint
    call    stringPrint      ; call our stringPrint function
    pop     eax         ; remove our linefeed character from the stack
    pop     eax         ; restore the original value of eax before our function was called
    ret                 ; return to our program

;------------------------------------------
; void intPrint(Integer number)
; Integer printing function (itoa)
intPrint:
    push    eax             ; preserve eax on the stack to be restored after function runs
    push    ecx             ; preserve ecx on the stack to be restored after function runs
    push    edx             ; preserve edx on the stack to be restored after function runs
    push    esi             ; preserve esi on the stack to be restored after function runs
    mov     ecx, 0          ; counter of how many bytes we need to print in the end
 
divideLoop:
    inc     ecx             ; count each byte to print - number of characters
    mov     edx, 0          ; empty edx
    mov     esi, 10         ; mov 10 into esi
    idiv    esi             ; divide eax by esi
    add     edx, 48         ; convert edx to it's ascii representation - edx holds the remainder after a divide instruction
    push    edx             ; push edx (string representation of an intger) onto the stack
    cmp     eax, 0          ; can the integer be divided anymore?
    jnz     divideLoop      ; jump if not zero to the label divideLoop
 
printLoop:
    dec     ecx             ; count down each byte that we put on the stack
    mov     eax, esp        ; mov the stack pointer into eax for printing
    call    stringPrint          ; call our string print function
    pop     eax             ; remove last character from the stack to move esp forward
    cmp     ecx, 0          ; have we printed all bytes we pushed onto the stack?
    jnz     printLoop       ; jump is not zero to the label printLoop
 
    pop     esi             ; restore esi from the value we pushed onto the stack at the start
    pop     edx             ; restore edx from the value we pushed onto the stack at the start
    pop     ecx             ; restore ecx from the value we pushed onto the stack at the start
    pop     eax             ; restore eax from the value we pushed onto the stack at the start
    ret
 
 
;------------------------------------------
; void intPrintLF(Integer number)
; Integer printing function with linefeed (itoa)
intPrintLF:
    call    intPrint          ; call our integer printing function
 
    push    eax             ; push eax onto the stack to preserve it while we use the eax register in this function
    mov     eax, 0Ah        ; move 0Ah into eax - 0Ah is the ascii character for a linefeed
    push    eax             ; push the linefeed onto the stack so we can get the address
    mov     eax, esp        ; move the address of the current stack pointer into eax for stringPrint
    call    stringPrint          ; call our stringPrint function
    pop     eax             ; remove our linefeed character from the stack
    pop     eax             ; restore the original value of eax before our function was called
    ret

;------------------------------------------
; void exit()
; Exit program and restore resources
exit:
    mov     ebx, 0
    mov     eax, 1
    int     80h
    ret