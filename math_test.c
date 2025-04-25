#include <stdint.h>
#include <stdio.h>

extern uint64_t factorial(uint8_t n);
extern uint64_t fibonacci(uint8_t n);
extern uint64_t isqrt(uint64_t n);
extern int is_fib(int n); 

void print_test(uint64_t exp, uint64_t got);

int main()
{
	int i, res;

	print_test(2*3*4*5*6*7*8*9*10, factorial(10));
	print_test(55, fibonacci(10));
	print_test(7, isqrt(49));
	print_test(7, isqrt(53));
	print_test(100, isqrt(10000));

	res = 1;
	for (i = 0; i < 20; ++i)
		res = res && 1 == is_fib(fibonacci(i));

	printf("%s\n", res ? "passed! is_fib == 1" : "failed: is_fib == 1");

	res = 0;
	for (i = 56; i < 89; ++i)
		res = res || is_fib(i);

	printf("%s\n", res == 0 ? "passed! is_fib == 0" : "failed: is_fib == 0");

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
