# MIPS implementation of Bubble sort
# Set aside memory for prompts and array that hold 128 ints.
	.data
prompt1:	.asciiz "Enter number of elements in array: "
prompt2:	.asciiz "Enter elements one per line:\n"
newline:	.asciiz "\n"

	# Make sure the rest of the word size variable start on a byte
	# address that is a multiple of 4
	.align 2
list: 	.space 512 # 512 bytes of memory is reserved to store at max
			   

	# Our code goes in the text segment
	.text

	# n is associated with $s0
	# temp is associated with $s1
	# last_unsorted is associated with $s2
	# i is associated with $s3
	# s4 holds the arrays base address

	# We prompt1 the user
	# Since only the contents of $a0 can be printed
	# address of prompt1 is loaded in to $a0
	# When we call sys_call, it locates the address stored in $a0
	# and prints the value at that adddress  
main:
	la $s4, list    # $s4 = address of the first byte of list
	la $a0, prompt1 # $a0 = address of prompt1
	# sys_call number for string is 4
	# 4 is loaded to the $v0 register 
	li $v0, 4  # $v0 = 4
	syscall

	# Read number of elements from console
	# Store it in $s0
	# Syscall 5 is read_int
	li $v0, 5
	syscall

	move $s0, $v0 # $s0 = n

	# prompt2 the user
	la $a0, prompt2
	li $v0, 4
	syscall

	# Loop n times, reading one int on each iteration
	# and storing it in list[i]
	li $s3, 0 # i = 0
for1:	bge $s3, $s0, for1_exit # branch if i >= n

	# scanf("%d", &list[i])
	# calculate address of list[i]
	sll $t0, $s3, 2   # $t0 = 4i
	add $t0, $t0, $s4 # $t0 = &list[i]

	# read_int
	li $v0, 5
	syscall

	sw $v0, 0($t0) # list[i] = value entered from user

	addi $s3, $s3, 1 # i++

	# end of for loop
	j for1

for1_exit:
	# perform bubble sort on the array

	addi $s2, $s0, -1         # last_unsorted = n - 1

for2:	ble $s2, $zero, for2_exit # exit loop if last_unsorted <= 0
	
	# initialize nested for loop
	li $s3, 0 # i = 0 

for3:   bge $s3, $s2, for3_exit # exit if i >= last_unsorted
	sll $t0, $s3, 2         # $t0 = 4i
	addu $t0, $t0, $s4      # $t0 = &list[i]
	addi $t1, $t0, 4        # $t1 = &list[i + 1]
	lw $t2, 0($t1)          # $t2 = list[i + 1]
	lw $t3, 0($t0)          # $t3 = list[i]

	ble $t3, $t2, if_exit # branch if list[i] <= list[i + 1]
	move $s1, $t2         # temp = list[i + 1]
	sw $t3, 0($t1)        # list[i + 1] = list[i]
	sw $s1, 0($t0)	      # list[i] = temp

if_exit:
	addi $s3, $s3, 1      # ++i
	j for3

for3_exit:
	addi $s2, $s2, -1     # --last_unsorted
	j for2

for2_exit:
	# print a newline
	la $a0, newline
	li $v0, 4
	syscall
	
	
	# print the sorted array
	li $s3, 0 # re-set i to 0 
for4:	bge $s3, $s0, for4_exit # exit loop if i >= n

	# print list[i]
	# calculate &list[i]
	sll $t0, $s3, 2    # $t0 = 4i
	addu $t0, $s4, $t0 # $t0 = &list[i]

	lw $a0, 0($t0)     # $a0 = list[i]
	li $v0, 1
	syscall

	# print a newline
	la $a0, newline
	li $v0, 4
	syscall 
	addi $s3, $s3, 1

	j for4

for4_exit:
	j $ra
	
	
	
	
