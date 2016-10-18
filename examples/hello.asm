.data
hello: .asciiz "Hello world!"

.text
main:
li $v0, 4 # system call code for printing string = 4
la $a0, hello # load address of string to be printed into $a0
syscall

end:
li $v0, 10 # terminate program
syscall
