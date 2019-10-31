section .data
	str: db 'Hello, World!', 10
	strlen: equ $ - str

section .text
global _start

_start:
	mov	eax, 4        ; write system call
	mov	ebx, 1        ; STDOUT
	mov	ecx, str      ; string
	mov	edx, strlen   ; length
	int	80h           ; system call

	mov	eax, 1  ; exit system call
	mov	ebx, 0  ; error code 0
	int	80h     ; system call
