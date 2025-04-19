builddir = build
exedir = exe
testdir = test

srcs = $(wildcard *.s)
objs = $(patsubst %.s, $(builddir)/%.s.o, $(srcs))
exes = $(patsubst %.s, $(exedir)/%, $(srcs))

testsrcs = $(wildcard *_test.c)
testobjs = $(patsubst %_test.c, $(builddir)/%_test.o, $(testsrcs))
tests = $(patsubst %_test.c, $(testdir)/%, $(testsrcs))

flags = -f elf64
cflags = -Wall -Wextra -std=gnu89

ifeq ($(OS), macos)
	flags = -f macho64
	cflags += -arch x86_64
endif

ifeq ($(DEBUG), 1)
	flags := $(flags) -g -F dwarf
	builddir = debug
	exedir = dexe
endif

all : dirs $(objs) $(testobjs) $(tests)

dirs :
	mkdir -p $(builddir) $(exedir) $(testdir)

$(builddir)/%.s.o : %.s
	nasm $(flags) -o $@ $<

$(builddir)/%_test.o : %_test.c
	gcc $(cflags) -c -o $@ $<

$(testdir)/% : $(builddir)/%_test.o
	gcc $(cflags) -o $@ $< $(objs)

.PHONY : clean

clean :
	rm -r $(builddir) $(exedir) $(testdir) 

