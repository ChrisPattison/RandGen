;Copyright 2014 Christopher Pattison

GLOBAL _genSequence

SECTION .text

_genSequence: ; int length, char* destination, remember to call with cdecl!
	push ebp
	mov ebp, esp
	push esi
	push ebx
	push edi
	mov edi, [ebp+12]
	mov eax, 1
	cpuid
	and ecx, 40000000h ; check for rdrand support
	jecxz .Unsupported
	xor ecx, ecx
	.ForGen_Start:
		rdrand eax
		jnc .ForGen_Start
		and eax, 3F3F3F3Fh
		mov edx, eax
		and edx, 0000003Fh
		mov bl, [base64 + edx]
		shr eax, 8
		mov edx, eax
		and edx, 0000003Fh
		mov bh, [base64 + edx]
		shl ebx, 16
		shr eax, 8
		mov edx, eax
		and edx, 0000003Fh
		mov bl, [base64 + edx]
		shr eax, 8
		mov edx, eax
		and edx, 0000003Fh
		mov bh, [base64 + edx]
		call LoopSwitch
		cmp edx, 0
		jne .ForGen_Start
		mov eax, 0
		jmp .Return

	.Unsupported: ; return -
		.Unsupported_ForStart:
		mov ebx, [invalidChar]
		call LoopSwitch
		cmp edx, 0
		jne .Unsupported_ForStart
		mov eax, 1
	.Return:
	not esi
	add ecx, esi
	mov [ecx+edi+1], byte 0
	pop edi
	pop ebx
	pop esi
	pop ebp
	ret

LoopSwitch:
	xor edx, edx
	mov esi, ecx
	sub esi, [ebp + 8]
		cmp esi, -1
		jg .End ; case 0
		jl .Case2 ; anything other than case 1 or 0
		.Case1:
			mov [ecx+edi], bl
			jmp .End
		.Case2:
			cmp esi, -3
			jl .Case4
			mov [ecx+edi], bx
			jne .End
		.Case3:
			shr ebx, 16
			mov [ecx+edi+2], bl
			jmp .End
		.Case4:
			mov [ecx+edi], ebx
			jmp .Start
	.Start:
	inc edx
	add ecx, 4
	.End:
	ret

SECTION .data
base64: db 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
invalidChar: db '----'