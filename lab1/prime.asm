.data
msg0:	.asciiz "Please input a number: "
msg1:	.asciiz "\nIt's a prime"
msg2:	.asciiz "\nIt's not a prime"

.text
.globl main
#------------------------- main -----------------------------
main:
# print msg1 on the console interface
		li      $v0, 4				# call system call: print string
		la      $a0, msg0			# load address of string into $a0
		syscall                 	# run the syscall
 

# read the input integer in $v0
 		li      $v0, 5          	# call system call: read integer
  		syscall                 	# run the syscall
  		move    $a0, $v0      		# store input in $a0 (set arugument of procedure factorial)
		
# jump to procedure prime
		li $t1, 1
  		jal prime
		move $t0, $v0				# save return value in t0 (because v0 will be used by system call) 


# see is prime or not
		beq $t0, $zero, notp
		j isp

#------------------------- procedure prime-----------------------------
# load argument n in a0, return value in v0. 
.text
prime:	addi $sp, $sp, -8		# adiust stack for 2 items
		sw $ra, 4($sp)				# save the return address
		sw $a0, 0($sp)	
		seq $t0, $a0, 1		# test for n =1
		beq $t0, $zero, loop			# if n !=1 go to loop
		addi $v0, $zero, 0			# return 0
		addi $sp, $sp, 8			# pop 2 items off stack
		jr $ra						# return to caller
loop:		
		addi $t1, $t1, 1
		mul $t4, $t1, $t1
		slt $t3, $a0, $t4
		bne $t3, $zero, isp
		
		div $a0, $t1
		mfhi $t2
		
		beq $t2, $zero, notp
		j loop			

#print prime
isp:		
		li      $v0, 4				# call system call: print string
		la      $a0, msg1			# load address of string into $a0
		syscall
		j exit
#print not prime
notp:		
		li      $v0, 4				# call system call: print string
		la      $a0, msg2			# load address of string into $a0
		syscall
		j exit

#exit
exit:		
		li $v0, 10					# call system call: exit
  		syscall	