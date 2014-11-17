yasm -elf32 -g stabs rng.asm
gcc test.c rng.o