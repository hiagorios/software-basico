;------------------------------
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

;-----------------------------------------
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