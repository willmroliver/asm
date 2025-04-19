builddir = build
exedir = exe

srcs = $(wildcard *.s)
objs = $(patsubst %.s, $(builddir)/%.o, $(srcs))
exes = $(patsubst %.s, $(exedir)/%, $(srcs))

flags = -f elf64
ifeq ($(DEBUG), 1)
	flags := $(flags) -g -F dwarf
	builddir = debug
	exedir = dexe
endif

all : dirs $(objs) $(exes)

dirs :
	mkdir -p $(builddir) $(exedir)

$(builddir)/%.o : %.s
	nasm $(flags) -o $@ $<

$(exedir)/% : $(builddir)/%.o 
	gcc -m64 -o $@ $< -nostartfiles -no-pie

.PHONY : clean

clean :
	rm -r $(builddir) $(exedir) 

