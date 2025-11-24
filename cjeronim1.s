# CS25 2025FA, Steve Hodges
# cjeronim, Christian Jeronimo
# chrstnjeronimo@gmail.com
# sum and max assignment
.text
	li s0, 0			# sum 
	li s1, 0x80000000  	# max = smallest possible integer, issue when 
						# max started at 0: if all input < 0, max = 0
	li s2, 0  			# count 
	
input:	din a0 			# input value
	mv t0, a0 			# t0 = input value
	beq t0, zero, non 	# checks if input = 0, then branches
	
	add s0, s0, t0  	# sum collection: sum = sum + input
	addi s2, s2, 1 		# count number of input, increases by 1
	bge s1, t0, input	# check if current max is greater than input
						# else it move down to the following lines
	mv s1, t0			# if (s1)curr_max < (t0) input: s1 = t0
	j input				# jumps back to take in new input once done
						# handling the current input
non:beq s2, zero, noinput 	# branch to no input case if count = 0

	la t0, int_sum		# load sum str = t0, output in next line
	sout t0			
	mv a0, s0
	dout a0				# a0 = sum int value, output sum value
	nl					# print newline

	la t0, int_max		# load max_str = t0, output in next line
	sout t0			
	mv a0, s1
	dout a0				# a0 = max int value, output max value
	nl					# print new line
	halt				# end program

noinput:
	la t0, int_zero 	# no input section, load no_input = t0
	sout t0				# print no input
	nl					# print newline
	halt				# end program
	
.data
int_sum:	.asciz "Sum: "
int_max:	.asciz "Max: "
int_zero:	.asciz "no input."
