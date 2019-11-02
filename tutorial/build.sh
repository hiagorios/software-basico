#!/bin/bash
#Working on manjaro
yasm -f elf64 $1.asm
ld -s -o $1 $1.o
./$1
rm $1.o
rm $1
