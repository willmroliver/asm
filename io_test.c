#include <stdint.h>
#include <stdio.h>

extern uint64_t str_len(char *s);
extern void print_str(char *s);
extern void print_char(char c);
extern void print_newline();
extern void print_uint(uint64_t n);
extern void print_int(int64_t n);
extern char read_char();
extern char *read_word(char *buf, uint64_t size);
extern uint64_t parse_uint(char *s);
extern int64_t parse_int(char *s);
extern int str_cmp(char *s0, char *s1);
extern char *str_cpy(char *src, char *dst, uint64_t len);
extern char *f_read(char *fname);

int main() {
	char s0[32] = "Arsenal at the Bernebau!\0";
	char *s1 = "Different";

	printf("strlen: "); fflush(stdout);
	print_uint(str_len(s0)); print_newline();
	print_str(s0); print_newline();
	print_int(-123); print_newline();
	printf("strcmp: %d\n", str_cmp(s0, s1));
	str_cpy(s1, s0, sizeof(s0));
	print_str(s0); print_newline();
	printf("input: %c\n", read_char());
	if (read_word(s0, 32) != NULL) {
		print_str(s0); print_newline();
	} else {
		printf("null returned\n");
	}

	printf("parse_uint: %lu\n", parse_uint(read_word(s0, 32)));
	printf("str: %s\n", s0);
	printf("parse_int: %ld\n", parse_int(read_word(s0, 32)));
	printf("str: %s\n", s0);
	printf("file content:\n%s\n", f_read("io_test.c"));
	
	return 0;
}
