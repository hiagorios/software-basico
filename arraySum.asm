;Faça um programa em linguagem de montagem
;que seja capaz de somar todos os elementos de
;um vetor de inteiros dado como entrada;
;Para tanto, faça a escolha adequada dos modos
;de endereçamento estudados até aqui, de
;maneira a melhorar a eficiência do programa;
;-----------------------------------------------------------------

; Example program to demonstrate console output.
; This example will send some messages to the screen.
; **********************************************

section .data
; -----
; Define standard constants.
LF equ 10 ; line feed
NULL equ 0 ; end of string
TRUE equ 1
FALSE equ 0
EXIT_SUCCESS equ 0 ; success code
STDIN equ 0 ; standard input
STDOUT equ 1 ; standard output
STDERR equ 2 ; standard error
SYS_read equ 0 ; read
SYS_write equ 1 ; write
SYS_open equ 2 ; file open
SYS_close equ 3 ; file close
SYS_fork equ 57 ; fork
SYS_exit equ 60 ; terminate
SYS_creat equ 85 ; file open/create

SYS_time equ 201 ; get time
; -----
; Define some strings.
message1 db "Hello World.", LF, NULL
newLine db LF, NULL
;------------------------------------------------------
section .text

global _start

_start:
; -----
; Display first message.
mov edi, message1
call printString

; -----
; Display newline
mov edi, newLine
call printString

; -----
; Example program done.
exampleDone:
mov eax, SYS_exit
mov edi, EXIT_SUCCESS
syscall

; ******************************************************
; Generic function to display a string to the screen.
; String must be NULL terminated.
; Algorithm:
; Count characters in string (excluding NULL)
; Use syscall to output characters

; Arguments:
; 1) address, string
; Returns:
; nothing
global printString
printString:
push ebx

; -----
; Count characters in string.
mov ebx, edi
mov edx, 0
strCountLoop:
cmp byte [ebx], NULL
je strCountDone
inc edx
inc ebx
jmp strCountLoop
strCountDone:
cmp edx, 0
je prtDone
; -----

; Call OS to output string.
mov eax, SYS_write ; system code for write()
mov esi, edi ; address of char's to write
mov edi, STDOUT ; standard out

; RDX=count to write, set above

syscall ; system call

; -----
; String printed, return to calling routine.
prtDone:
pop ebx
ret
