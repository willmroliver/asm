builddir = build
exedir = exe
testdir = test

srcs = $(wildcard *.s)
objs = $(patsubst %.s, $(builddir)/%.s.o, $(srcs))
libs = $(patsubst %.s, $(builddir)/%.s.so, $(srcs))
exes = $(patsubst %.s, $(exedir)/%, $(srcs))

testsrcs = $(wildcard *_test.c)
testobjs = $(patsubst %_test.c, $(builddir)/%_test.o, $(testsrcs))
tests = $(patsubst %_test.c, $(testdir)/%, $(testsrcs))

flags = -f elf64
cflags = -Wall -Wextra -Werror -Wpedantic -std=gnu89 -z noexecstack

ifeq ($(DEBUG), 1)
	flags := $(flags) -g -F dwarf
	builddir = debug
	exedir = dexe
endif

all : dirs $(objs) $(libs) $(testobjs) $(tests)

dirs :
	mkdir -p $(builddir) $(exedir) $(testdir)

$(builddir)/%.s.o : %.s
	nasm $(flags) -o $@ $<

$(builddir)/%.s.so : $(builddir)/%.s.o 
	ld -shared -o $@ $< --dynamic-linker=/lib64/lib64/ld-linux-x86-64.so.2

$(builddir)/%_test.o : %_test.c
	gcc $(cflags) -c -o $@ $<

$(testdir)/% : $(builddir)/%_test.o
	gcc $(cflags) -o $@ $< $(libs) 

.PHONY : clean

clean :
	rm -r $(builddir) $(exedir) $(testdir) 

