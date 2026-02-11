# CS24, 2025FA
# cjeronim, Christian Jeronimo
# chrstnjeronimo@gmail.com
# Pattern matching program (tested/working)
.text
	la t0, greeting
	sout t0			    # print greeting
	nl
	
	la t0, prompt
	sout t0			    # print prompt
	nl

	la t0, example
	sout t0			    # print example for string length
	nl

	la t0, string
	sin t0			    # take in binary string

	la a0, string		# get input from string address
	jal to_int		    # call to_int function: input->integer
	mv s0, a0

	mv a0, s0
	jal ra, match		# call match function to find matching pattern
	
	bgez a0, index		# if a0(index) >=0, jump to print value
	
	la t0, error		# falls through to print error message if a0 < 0
	sout t0			    # print error
	halt			    # end program

index:	dout a0			# print index value
	halt
	
# Function: to_int->Convert binary string to integer
# @param a0 = string address
# @return a0 = integer value
	
to_int:	mv t0, a0		# string pointer
	li t1, 0		    # result
	li t2, 32		    # counter
	li t4, '0'		    # ASCII '0' for subtraction

loop:	lb t3, 0(t0)	# load character
	slli t1, t1, 1		# shift result left
	sub t3, t3, t4		# convert '0'->0 and '1'->1
	or t1, t1, t3		# set LSB to 0 or 1
	
	addi t0, t0, 1		# next char
	addi t2, t2, -1		# decrement counter
	bnez t2, loop		# loop 32 times

	mv a0, t1		    # move result to a0, to return to caller
	ret

# Function: diff-> calculates hamming distance.
# @param a0 = user given pattern, a1 = pattern from array
# @return a0 = number of differing bits

diff:   xor t2, a0, a1		# XOR to find differing bits
	li t3, 0		    # count
	li t4, 32		    # bit counter

loop_b:	andi t5, t2, 1	# check LSB
	add t3, t3, t5		# add to count
	srli t2, t2, 1		# shift right
	addi t4, t4, -1		# decrement counter
	bnez t4, loop_b		# loop 32 times,

	mv a0, t3		    # puts count into argument register to return
	ret

# function: match -> finc closest matching pattern
# @param a0 = input pattern
# @return a0 = index or -1

match:	addi sp, sp, -20# makes space on stack, stores s reg. for use
	sw ra, 16(sp)		# return address
	sw s0, 12(sp)		# input pattern
	sw s1, 8(sp)
	sw s2, 4(sp)
	sw s3, 0(sp)

	mv s0, a0		# save input pattern
	li s1, 32		# best_diff = max+1
	li s2, -1		# best index
	li s3, 0		# current index
	la t0, patterns		# pattern array pointer
	li t1, 32		# pattern count

find:	lw a1, 0(t0)		# load pattern
	mv a0, s0		# pass input pattern
	jal ra, diff		# calculate difference
	mv t2, a0		# current difference

	bge t2, s1, next
	mv s1, t2		# update best_diff
	mv s2, s3		# update best index

next:	addi t0, t0, 4		# next pattern address
	addi s3, s3, 1		# increment index
	blt s3, t1, find	# loop through all patterns

	li t0, 8		# threshold = 7 bit difference
	bge s1, t0, none	# check best_diff to threshold
	mv a0, s2		# return best address
	j done

none:	li a0, -1

done:	lw s3, 0(sp)
	lw s2, 4(sp)
	lw s1, 8(sp)
	lw s0, 12(sp)
	lw ra, 16(sp)
	addi sp, sp, 20		# restores stack and registers
	ret

.data
string:		.space 33, 0
greeting:	.asciz "CS24: Pattern Matching Program"
prompt:		.asciz "Enter Your Pattern"
example:	.asciz "01234567890123456789012345678901"
error:		.asciz "error"
patterns:
	.word 0, 1431655765, 858993459, 1717986918, 252645135, 1515870810
	.word 1010580540, 1768515945, 16711935, 1437226410, 869020620, 1721329305
	.word 267390960, 1520786085, 1019428035, 1771465110, 65535, 1431677610
	.word 859032780, 1718000025, 252702960, 1515890085, 1010615235
	.word 1769576086, 16776960, 1437248085, 869059635, 1721342310, 267448335
	.word 1520805210, 1019462460, 1771476585
