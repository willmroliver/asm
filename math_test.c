#include <stdint.h>
#include <stdio.h>

extern uint64_t factorial(uint8_t n);
extern uint64_t fibonacci(uint8_t n);

void print_test(uint64_t exp, uint64_t got);

int main()
{
	print_test(2*3*4*5*6*7*8*9*10, factorial(10));
	print_test(55, fibonacci(10));
	return 0;
}

void print_test(uint64_t exp, uint64_t got) 
{
	printf(
		"%sexp: %ld; got: %ld\n",
		exp == got ? "passed! " : "failed: ",
		exp,
		got
	);
}
