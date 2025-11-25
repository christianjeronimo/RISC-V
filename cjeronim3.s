# CS24, 2025FA
# cjeronim, Christian Jeronimo
# chrstnjeronimo@gmail.com
# Greatest common divisor
.text
	la t0, greeting		# load greeting into temp. register to print
	sout t0
	nl			        # newline

	la t0, first_int	# load prompt to ask for integer, to print
	sout t0
	din s0			    # save to saved register

	la t0, second_int	# load prompt to ask for second integer, to print
	sout t0
	din s1			    # save to saved register

	mv a0, s0   		# a0 = 1st integer for function use
	mv a1, s1	    	# a1 = 2nd integer for function use
	jal ra, gcd		    # jump to function--function call

	mv t0, a0   		# once returned, t0 = gcd of input
	la t1, output		# load and print string output
	sout t1
	dout t0		    	# print integer from function

	halt			    # end program

# Recursive GCD function
# parameters a0, a1 == m, n
# returns gcd in a0
gcd:	addi sp, sp, -8	# save return address and arguments on stack
	sw ra, 4(sp)
	sw a0, 0(sp)		# store a0 value which changes though tests

	beq a1, zero, base	# base case a1(n) = 0, a0 already equal to gcd

	rem t0, a0, a1		# t0 = m % n
	mv a0, a1		    # a0 = n
	mv a1, t0		    # a1 = m % n
	jal ra, gcd		    # recursive call
	j return		    # jump call needed for recursive path

base:	lw a0, 0(sp)	# base case, return m(saved in a0). not restored
                        # in return since a0 is modified during recursion

return:	lw ra, 4(sp)	# restore return address
	addi sp, sp, 8		# restore stack
	ret			        # return to main program

.data
greeting:	.asciz 	"Euclid's Greatest Common Divisor Algorithm"
first_int:	.asciz  "m ?"
second_int:	.asciz  "n ?"
output:		.asciz  "gcd(m, n) = "
