	.text
	.align 2
main:	lw $8, 0xffff0000($0) # load input status into temp 1
	andi $8, $8, 1 # get just the last bit
	beqz $8, main # if that last bit is 0, try again
	lw $9, 0xffff0004($0) # once the input is ready, get the data
	seq $10, $9, 0xA # check if it's an enter
	bnez $10, done # if so, exit
	addi $9, $9, 1 # otherwise, add 1 to the value
#out:	lw $10, 0xffff0008($0) # now check if the output is ready
#	andi $10, $10, 1 # again, just get the last bit
#	beqz $10, out # if it's not ready yet, try again
	sw $9, 0xffff000c($0) # output it to the I/O
	b main # and go again
done:	jr $31 # and then end the function
