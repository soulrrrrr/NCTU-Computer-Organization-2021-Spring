.data
msg:	.asciiz "Please input a number: "

.text
.globl main
main:
		li	$v0, 4
		la	$a0, msg
		syscall
		
		li	$v0, 5
		syscall 
		move	$a0, $v0
		
		jal	fib
		
		move	$t0, $v0
		
		move	$a0, $t0
		li	$v0, 1
		syscall 
		
		li	$v0, 10
		syscall
#---------------------------------------------------------------------------------
.text
fib:
		bgt $a0, 1, fib_rec
		
		move $v0, $a0
		jr $ra

fib_rec:	addi $sp, $sp, -12

		sw $ra, 4($sp)    	# save $ra
		sw $a0, 0($sp)		# save n

		addi $a0, $a0, -1
		jal fib
		
		lw $a0, 0($sp)		# restore n
		sw $v0, 8($sp)		# save returnval fib(n-1)
		
		addi $a0, $a0, -2
		jal fib
		
		lw $t0, 8($sp)		# restore returnval fib(n-1)
		add $v0, $v0, $t0	# fib(n-1) + fib(n-2)
		
		lw $ra, 4($sp)
		addi $sp, $sp, 12
		jr $ra

