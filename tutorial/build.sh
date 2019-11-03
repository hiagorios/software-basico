#!/bin/bash
#Working on manjaro
yasm -f elf $1.asm
ld -m elf_i386 $1.o -o $1
./$1
rm $1.o
rm $1
