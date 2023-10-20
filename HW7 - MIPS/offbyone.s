	.data
instat:	.word 0xffff0000
indata:	.word 0xffff0004
outstat:	.word 0xffff0008
outdata:	.word 0xffff000c

	.text
	.align 2
main:	lw instat($R0), $R8 # get the address for the input status
in:	lw 0($R8), $R9 # get the actual input status
	andi $R9, $R9, 1 # get just the last bit
	beqz $R9, in # if that last bit is 0, try again
	lw indata($R0), $R8 # get the address for the input data
	lw 0($R8), $R9 # once the input is ready, get the data
	addi $R9, $R9, 1 # add 1 to the value
	lw outstat($R0), $R8 # get the address for the output status
out:	lw 0($R8) $R10 # now check if the output is ready
	andi $R10, $R10, 1 # again, just get the last bit
	beqz $R10, out # if it's not ready yet, try again
	lw outdata($R0), $R8 # finally, get the address for the output data
	sw $R10, 0($R8) # output the result to the I/O
	jr $R31 # and then end the function
