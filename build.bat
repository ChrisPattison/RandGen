yasm -f elf32 rng.asm
gcc test.c rng.o -o rng.exe