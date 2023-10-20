# takes input, evaluates parity, and outputs it with parity bit set accordingly

	.text
	.align 2
main:	li $v0, 4 # call print string with cause code and string address
	la $a0, query
	syscall
	li $v0, 5 # call read int
	syscall
	move $8, $v0 # grab the value and store it
	addi $a0, $8, 0 # and put it in as an argument to call print
	li $v0, 1
	syscall
	li $v0, 4 # finally print a new line
	la $a0, nl
	syscall
	li $9, 0 # the next register will hold the parity (starting at 0)
	li $10, 1 # the following register will hold a mask (starting at 1)
	li $11, 1 # and I also need a register to hold a 1 to shift by 1
loop:	and $12, $8, $10 # now check if the next digit is 1
	slti $12, $12, 1 # that gives us the value, so this sets it to 1 (if less than 1)
	slti $12, $12, 1 # this swaps it, so it's 1 if > 0 and 0 otherwise
	add $9, $9, $12 # add the result to the register holding the parity
	sllv $10, $10, $11 # then shift the mask left 1
	slti $13, $10, 0x80 # check if the mask is at the top digit
	bgtz $13, loop # if it's less than the top digit, keep going
	andi $9, $9, 1 # once that's done, check if the parity is even or odd (ends in a 1)
	beqz $9, even # if it's even, put a 0 out front
	ori $8, $8, 0x80 # otherwise, if it's odd, put a 1 out front
	b prnt # then jump to printing
even:	andi $8 $8, 0x7F # otherwise, this should put a 0 out front
prnt:	and $12, $8, $10 # mask the value again, starting from the highest digit this time
	beqz $12, pzero # if it's a zero, load zero to print
	la $a0, one # otherwise load one to print
	b pr # and actually do the printing
pzero:	la $a0, zero # or load zero to print
pr:	li $v0, 4 # call print string
	syscall
	srlv $10, $10, $11 # shift the mask right one
	slti $13, $10, 1 # check if the mask has dropped below 1
	beqz $13, prnt # if not, keep printing
	la $a0, nl # finally, print a new line
	syscall
	jr $31 # when it's done, jump back to the operating system
	
	.data
query:	.asciiz "Enter a value: "
one:	.asciiz "1"
zero:	.asciiz "0"
nl:	.asciiz "\n"
