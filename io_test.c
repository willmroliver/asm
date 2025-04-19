#include <stdint.h>
#include <stdio.h>

extern uint64_t str_len(char *s);
extern void print_str(char *s);
extern void print_char(char c);
extern void print_newline();
extern void print_uint(uint64_t n);
extern void print_int(int64_t n);
extern int str_cmp(char *s0, char *s1);
extern char *str_cpy(char *src, char *dst, uint64_t len);

int main() {
	char s0[32] = "Arsenal at the Bernebau!\0";
	char *s1 = "Different";

	printf("strlen: %llu\n", str_len(s0));
	print_str(s0); print_newline();
	print_int(-123); print_newline();
	printf("strcmp: %d\n", str_cmp(s0, s1));
	str_cpy(s1, s0, sizeof(s0));
	print_str(s0); print_newline();

	return 0;
}
