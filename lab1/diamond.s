.data
msg:	.asciiz "Please input a number: "
star:	.asciiz "*"
space:	.asciiz " "	
cl:	.asciiz "\n"

.text
.globl main

main:
#print question
		li  	$v0, 4
		la	$a0, msg
		syscall
#read number
		li  	$v0, 5
		syscall
		move	$t0, $v0 # $t0 : n
#print upper diamond
		li	$t1, 0 # $t1 : i
	loop1:
		addi	$t1, $t1, 1
		li	$t2, 0 # $t2 : j1
		mul	$t8, $t1, -1
		add	$t3, $t0, $t8 # $t3 : n-i
		add	$t4, $t0, $t1 
		addi	$t4, $t4, -1 #$t4 : n+i-1
		
	loop2:	
		beq	$t2, $t3, exit2
		addi	$t2, $t2, 1
		li  	$v0, 4
		#move	$a0, $t2
		la	$a0, space
		syscall
		blt	$t2, $t3, loop2
		
	exit2:
		move	$t2, $t3
	loop3:
		addi	$t2, $t2, 1
		li  	$v0, 4
		la	$a0, star
		syscall
		blt	$t2, $t4, loop3
		
		li  	$v0, 4
		la	$a0, cl
		syscall
		blt	$t1, $t0, loop1
#print lower diamond
		move	$t1, $t0 # $t1 : i
	loop4:
		addi	$t1, $t1, -1
		li	$t2, 0 # $t2 : j1
		mul	$t8, $t1, -1
		add	$t3, $t0, $t8 # $t3 : n-i
		add	$t4, $t0, $t1 
		addi	$t4, $t4, -1 #$t4 : n+i-1
		
	loop5:	
		addi	$t2, $t2, 1
		li  	$v0, 4
		#move	$a0, $t2
		la	$a0, space
		syscall
		blt	$t2, $t3, loop5
	
		move	$t2, $t3
	loop6:
		addi	$t2, $t2, 1
		li  	$v0, 4
		la	$a0, star
		syscall
		blt	$t2, $t4, loop6
		
		li  	$v0, 4
		la	$a0, cl
		syscall
		seq	$t5, $t1, 1
		beq	$t5, $zero, loop4
		
		
# exit
		li	$v0, 10
		syscall
		
		
		
		
		
