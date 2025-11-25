# CS25 2025FA
# cjeronim, Christian Jeronimo
# chrstnjeronimo@gmail.com
# print n number of primes
.text
	li s0, 0				# input int
	li s1, 2				# prime candidate number	
	
	la t0, prompt			# print prompt, number of primes
	sout t0
	din s0					# take in integer input

	blez s0, exit			# exit program if input = 0
	
main:mv a0, s1				# move prime candidate to argument
							# register for function use
	jal ra, prime			# jump to prime function, link ra
	beq a0, zero, update	# if a0 = 0, candidate != prime
							# jump to increment cand by 1
	mv a0, s1				# else print candidate number
	dout a0
	nl
	addi s0, s0, -1			# decrease input value, like countdown

update:	addi s1, s1, 1		# increment candidate by 1, loop back
	bnez s0, main

exit:	halt				# end program

# prime function
# @param a0, integer to test
# @return a0, 1 if prime, 0 otherwise

prime:	mv t0, a0			# t0 = num to test
	li t1, 2				# divisor i = 2
	li a0, 0				# not prime = default
	blt t0, t1, done 		# num < 2 = not prime


loop:	
	mul t2, t1, t1			# t2 = i*i
	bgt t2, t0, is_prime	# if t2 > num, prime
	rem t3, t0, t1			# remainder num % i
	beq t3, zero, done		# if divisible, not prime
	addi t1, t1, 1			# i++
	ble t1, t0, loop		# continue testing
	
is_prime:
	li a0, 1				# set prime flag

done:	ret					# return to return address (ra)

	
.data	
prompt:		.asciz "How many primes? "
