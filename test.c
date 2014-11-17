//Copyright 2014 Christopher Pattison

#include <stdio.h>
#include <string.h>

extern int genSequence(int length, char* destination) __attribute__((cdecl));

int main() {
	char values[9];
	printf("Copyright 2014 Christopher Pattison\n");
	genSequence(8, values);
	if (strcmp(values, "--------") != 0)
		printf(values);
	else
		printf("Unsupported Processor, Ivy Bridge or newer required.");
	return 0;
}