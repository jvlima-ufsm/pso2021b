
#  Build and Debug Programs

## GNU Make

GNU Make is a tool which controls the generation of executables or
other non-source files of a program from the program's source file.
It basically determines which pieces of a large program need to be
recompiled, and issues commands to recompile them.

You need a file called `makefile`, `Makefile`, or `GNUmakefile` to tell make
what to do.

The GNU Make manual is at:
https://www.gnu.org/software/make/manual/make.html

### Basic structure

A basic makefile has the structure:
```makefile
target ... : prerequisites ...
	recipe
	...
	...
```

When you type:
```
make
```

`make` reads the makefile in the current directory and beings by
processing the first rule. 

In the example below, we have four targets and the first rule is
`all`. This rule depends on the `program` target, which is not the first
target of the makefile.
```makefile
CXX = g++
CXXFLAGS = -Wall -g -std=c++11
LDFLAGS = -lm
PROG = program

all: $(PROG)

principal.o: principal.cpp 

program: principal.o 
	$(CXX) $(CXXFLAGS) -o $@ $^ $(LDFLAGS)
clean:
	rm -f *.o $(PROG)
```

To execute a specific target, type:
```
make clean
```

Some options are:
- `make -C dir` change to directory `dir` before reading the makefiles.
- `make -f file` use `file` as makefile.

### Simple example

A very simple example compiles only a source file:
```makefile
program: program.c foo.c
	gcc -o program program.c foo.c
```

We can also define variables:
```makefile
CC := gcc
CFLAGS := -Wall -g
sources := program.c foo.c
program := program

$(program): $(sources)
	$(CC) $(CFLAGS) -o $(program) $(sources)
clean:
	rm -f $(program) *.o
```

### Variable assignment

Variable assignment can be:
- `=` recursively expanded
- `:=`  simply expanded
- `+=` add contents
- `?=` conditional assignment, it only has an effect if the variable is not yet defined.

An example of recursively expanded variables:
```makefile
foo = $(bar)
bar = $(ugh)
ugh = Hello

all:
	echo $(foo)
```

This will echo `Hello`. But, a major disadvantage is that you can not
append something to the end of a variable:
```makefile
CFLAGS = $(CFLAGS) -O
```
It will cause a infinite loop.

### Wildcard

We can use *wildcards* to specify a list of files in the working
directory. For example:
```makefile
clean:
	rm -f *.o
```
Wildcard expansion is not possible for variable definition like:
```makefile
objects = *.o
```

In variables, you need to use the function `wildcard`:
```makefile
CC = gcc
CFLAGS = -Wall -g
sources = $(wildcard *.c)
program = program

$(program): $(sources)
	$(CC) $(CFLAGS) -o $(program) $(sources)
clean:
	rm -f $(program) *.o
```

We can also create a variable with all objects using string
substitution:
```makefile
sources = $(wildcard *.c)
objects = $(sources:.c=.o)
```

### Automatic variables

*Automatic variables* are computed for each rule at execution time. For
example:
- `$@` the file name of the target
- `$<` the first prerequisite
- `$?` the names of all prerequisites that are newer than the target
- `$^` the names of all prerequisites

A makefile example with two or more sources can be:
```makefile
CC = gcc
CFLAGS = -Wall -g
files = program.c library.c

program: $(files)
	$(CC) $(CFLAGS) -o $@ $^
```

### Implicit rules
*Implicit rules* tell `make` to use costumary techniques so that we do not
have to specify all details.

For example:
```makefile
program: program.o foo.o
	gcc -o program program.o foo.o
```
Since we mention `foo.o` but do not give a rule for it, `make` will look
for an implicit rule that tells how to update it.

### Variables used by implicit rules

The variables used in implicit rules fall into two classes: those that
are names of programs (like `CC`) and those that contain arguments for
the programs (like `CFLAGS`).

Some program variables are:
- `CC` C compiler
- `CXX` CXX compiler
- `FC` Fortran compiler
- `CPP` C preprocessor
- `RM` command to remove files

Som variables for arguments are:
- `CFLAGS` flags to the C compiler
- `CXXFLAGS` flags to the C++ compiler
- `FFLAGS` flags to the Fortran compiler
- `CPPFLAGS` flags to the C preprocessor
- `LDFLAGS` flags to the linker (`-L`)
- `LDLIBS` flags to the the linker (`-lfoo`)

### Conditionals

A conditional `ifeq` uses three directives: `ifeq`, `else` and `endif`.
For example, to enable OpenMP for Intel ICC compiler or others:
```makefile
ifreq ($(CC), icc)
	$(CC) -openmp -o foo $(objects)
else
	$(CC) -fopenmp -o foo $(objects)
endif
```

### Other functions

The `shell` function performs the same function as `` or `$()` in
shells. The only processing `make` does on the results is to convert
each newline to a single space.
```makefile
directory = $(shell pwd)
```

## CMake

CMake is a portable software for managing the build process of
software using a compiler-indenpent method. Comparing to GNU Make,
CMake is much more simple.

The building process of CMake occurs in two stages. First, standard
build files are created from configuration files. Then the native
build tools are used for the actual building.

Each build project contains a `CMakeLists.txt` file in every directory
that controls the build process.

### Simple example

In our `Editor` project, a configuration file is:
```cmake
cmake_minimum_required (VERSION 2.6)
project (Editor)
set(CMAKE_CXX_STANDARD 11)
add_executable(Editor principal.cpp vetor.hpp)
```

To build the project:
```
cmake .
make
```

Note that CMake creates a makefile. Type `help` to see the available
targets:
```
$ make help
The following are some of the valid targets for this Makefile:
... all (the default if no target is provided)
... clean
... depend
... edit_cache
... rebuild_cache
... Editor
... principal.o
... principal.i
... principal.s
```

### Build types

CMake has *build types* which are a set of compile-time decisions used
while compiling the source code. 
The available types are:
- None : `CMAKE_C_FLAGS` or `CMAKE_CXX_FLAGS`
- Debug : `CMAKE_C_FLAGS_DEBUG` or `CMAKE_CXX_FLAGS_DEBUG`
- Release : `CMAKE_C_FLAGS_RELEASE` or `CMAKE_CXX_FLAGS_RELEASE`
- RelWithDebInfo : `CMAKE_C_FLAGS_RELWITHDEBINFO` or `CMAKE_CXX_FLAGS_RELWITHDEBINFO`
- MinSizeRel : `CMAKE_C_FLAGS_MINSIZEREL` or `CMAKE_CXX_FLAGS_MINSIZEREL`

To build the project in debug mode:
```
cmake -DCMAKE_BUILD_TYPE=Debug .
```
and build  in release mode:
```
cmake -DCMAKE_BUILD_TYPE=Release .
```

To include a default type on the project file:
```cmake
if(NOT CMAKE_BUILD_TYPE) 
	set(CMAKE_BUILD_TYPE Release)
endif(NOT CMAKE_BUILD_TYPE)
```

### Compiler flags
Some userful variables are:
- `CMAKE_C_COMPILER` : the compiler for C files.
- `CMAKE_CXX_COMPILER` : the compiler for C++ files.
- `CMAKE_C_FLAGS` : the compiler flags for C sources. 
- `CMAKE_CXX_FLAGS` : the compiler flags for C++ sources.

For example:
```cmake
set(CMAKE_CXX_FLAGS "-O0 -Wall")
set(CMAKE_CXX_FLAGS_DEBUG "-O0 -g -Wall")
set(CMAKE_CXX_FLAGS_RELEASE "-O3 -Wall")
```

To specify libraries or flags to use when linking, use
`target_link_libraries` function. For example:
```cmake
target_link_libraries(Editor  -lallegro -lallegro_main -lallegro_color -lallegro_font -lallegro_primitives -lallegro_image)
```

### Libraries
Besides `target_link_libraries`, CMake comes with numerous modules that
help in finding various well-known libraries and packages. 
You can get a list of which modules your version of CMake supports by
typing:
```
cmake --help-module-list
```

For example, to include the `bzip2` library add this to your project:
```cmake
find_package (BZip2)
if (BZIP2_FOUND)
  include_directories(${BZIP_INCLUDE_DIRS})
  target_link_libraries (helloworld ${BZIP2_LIBRARIES})
endif (BZIP2_FOUND)
```

For instance, if you have optional libraries, add an option to the
project (in this case OpenBLAS):
```cmake
option(USE_BLAS "Use OpenBLAS" OFF)
if (USE_BLAS)
	include_directories ("~/install/openblas/include")
	find_library(BLAS_LIBRARY openblas "~/install/openblas/lib")
	target_link_libraries(Editor ${BLAS_LIBRARY})
endif (USE_BLAS)
```

To compile with BLAS:
```
cmake -DUSE_BLAS=ON .
```

### Example
An example of a C++ program would be:
```cmake
cmake_minimum_required (VERSION 2.6)
project (Editor)
set(CMAKE_CXX_STANDARD 11)
add_executable(Editor principal.cpp vetor.hpp)
```


## GDB

First, enable debugging information at compile time with `-g`:
```
gcc -g -o program program.c
```

`gdb` has an interactive shell, use the `help` command to get a
description of available commands or information of a specific
command:
```
(gdb) help [command]
```

### Runing a program

Debug a program typing:
```
gdb program
```
Or if the program has command line arguments:
```
gdb --args program arg1 arg2 arg3
```

To run the program, use:
```
(gdb) run
```
If the program has arguments:
```
(gdb) run arg1 arg2 arg3
```

### Breakpoints

- `break` : set a breakpoint at the given location, which can
     be a function name, a line number (`file.c:10`), or an instruction
     address.
- `break ... if` : set a breakpoint with a condition, evaluate
     the expression each time the breakpoint is reached, and stop
     only if the value is non-zero.
- `info breakpoints` : print all breakpoints.
- `delete` : delete a specific breakpoint.

### Watchpoint

A watchpoint can stop execution whenever the value changes, without
having to predict a particular place.
To watch a single variable, type:
```
watch foo
info watchpoints
```

### Continuing and Stepping
- `continue` : resume program execution.
- `step` : continue running until control reaches a different source
     line.
- `next` : continue to the next source line in the current stack frame.
- `finish` : runs until the current function is finished.

### Stack
- `backtrace`, `bt` : print a backtrace of the entire stack.
- `backtrace n`, `bt n` : similar, but print only the innermost `n` frames.
- `frame n`, `f n` : select frame number `n` (the innermost frame is zero).
- `up n` : move `n` frames up the stack.
- `down n` : move `n` frames down the stack.

### Threads

- `thread id` : switch among threads
- `info threads` : print existing threads

### Post mortem

A core file is an image of the process that has crashed or stopped. It
can be geneerated at execution time or using gdb.

From gdb, at any time during debbuging, type:
```
(gdb) gcore
```

It will generate a `core.pid` file where `pid` is the process ID. Latter,
to load the image for inspection:
```
(gdb) core core.24039
```

Where `core.24039` was the process image. Another way to load the image
is:
```
gdb program core.24039
```

The core file can be generated at execution time setting the
*core file size property* in `ulimit`:
```
ulimit -c unlimited
```

Then execute the program to generate a *core* file. After a crash, it
will print:
```
Segmentation fault (core dumped)
```

### Printing

- `print expr` :
print the contents of *expr* according to its data type. If you need a
different format use `print /f` where `f` is a format similar to `printf`.

## LLDB

LLDB is a next generation, high-performance debugger from the
[LLVM project](http://lldb.llvm.org). 

To install lldb on a Debian/Ubuntu system:
```
sudo apt-get install lldb
```

Note that for each command, lldb allows *auto completion*, including
variable names and functions.

### Running
Debug a program typing:
```
lldb program
```
To run the program:
```
(lldb) run
```

Or if the program has command line arguments use:
```
(lldb) run arg1 arg2 arg3
```
Alternatively:
```
lldb -- program arg1 arg2 arg3 
```

### Breakpoints

To set a breakpoint in a specific location, type:
```
(lldb) breakpoint set --file foo.c --line 12
```

This is equivalent to:
```
(lldb) breakpoint set -f foo.c -l 12
```

To set a breakpoint on a function:
```
(lldb) breakpoint set --name foo
```

Contitional breakpoints can be set using:
```
(lldb) breakpoint set --name foo --condition i >= 10
```

To print all breakpoints:
```
(lldb) breakpoint list
```

### Watchpoint
To set a watchpoint in lldb type:
```
(lldb) watchpoint set variable foo
(lldb) watchpoint list
```

To delete a watchpoint:
```
watchpoint delete 1
```

More options are available (see `help watchpoints`)

### Continuing and Stepping
LLDB has the same commands of gdb:
- step
- next
- continue

### Stack

To show the stack backtrace of the current thread, type:
```
(lldb) thread backtrace
(lldb) bt
```
Both commands are equivalent.
To view another frame:
```
(lldb) frame select 5
```

You can also inspect local variables of the frame with:
```
(lldb) frame variable
```

### Threads

To list all threads, type:
```
(lldb) thread list
Process 30811 stopped
thread #1: tid = 30811, 0x000000000040158e lulesh2.0`::CollectDomainNodesToElemNodes(domain=0x000000000062f050, elemToNode=0x00007ffff7efe010, elemX=0x00007fffffffda50, elemY=0x00007fffffffda90, elemZ=0x00007fffffffdad0) + 129 at lulesh.cc:270, name = 'lulesh2.0', stop reason = breakpoint 1.1
  thread #2: tid = 30814, 0x000000000040158e lulesh2.0`::CollectDomainNodesToElemNodes(domain=0x000000000062f050, elemToNode=0x00007ffff7f32bd0, elemX=0x00007ffff65aecb0, elemY=0x00007ffff65aecf0, elemZ=0x00007ffff65aed30) + 129 at lulesh.cc:270, name = 'lulesh2.0', stop reason = breakpoint 1.1
  thread #3: tid = 30815, 0x000000000040158e lulesh2.0`::CollectDomainNodesToElemNodes(domain=0x000000000062f050, elemToNode=0x00007ffff7f67790, elemX=0x00007ffff5dadcb0, elemY=0x00007ffff5dadcf0, elemZ=0x00007ffff5dadd30) + 129 at lulesh.cc:270, name = 'lulesh2.0', stop reason = breakpoint 1.1
  thread #4: tid = 30816, 0x000000000040158e lulesh2.0`::CollectDomainNodesToElemNodes(domain=0x000000000062f050, elemToNode=0x00007ffff7f9c350, elemX=0x00007ffff55accb0, elemY=0x00007ffff55accf0, elemZ=0x00007ffff55acd30) + 129 at lulesh.cc:270, name = 'lulesh2.0', stop reason = breakpoint 1.1
```
Where `*` indicates the current thread.

### Printing

The command `print` is a alias to the `expression` command, which
evaluates an expression in the current program context:
```
(lldb) print foo
```

To print a local variable `foo`, and formatted as hex:
```
frame variable foo
frame variable --format x foo
```

To show the contents of global variables:
```
target variable gfoo
```

### GDB counterparts
A table of equivalent gdb commands in LLDB can be found in:
- http://lldb.llvm.org/lldb-gdb.html

## Valgrind

The Valgrind tool suite provides a number of debugging and profiling
tools. We are going to use the Memcheck to detect many memory-related
errors that are common in C and C++ programs.

First, it is important to compile your program with `-g` and `-O0`. Then,
to call Memcheck:
```
valgrind ./program arg1 arg2 arg3
```

The output would be (depending on the valgrind version):
```
==3449== Invalid read of size 4
==3449==    at 0x40301B: testa_vetor_pontos() (principal.cpp:90)
==3449==    by 0x403116: main (principal.cpp:102)
==3449==  Address 0x4 is not stack'd, malloc'd or (recently) free'd
==3449== 
==3449== 
==3449== Process terminating with default action of signal 11 (SIGSEGV)
==3449==  Access not within mapped region at address 0x4
==3449==    at 0x40301B: testa_vetor_pontos() (principal.cpp:90)
==3449==    by 0x403116: main (principal.cpp:102)
==3449==  If you believe this happened as a result of a stack
==3449==  overflow in your program's main thread (unlikely but
==3449==  possible), you can try to increase the size of the
==3449==  main thread stack using the --main-stacksize= flag.
==3449==  The main thread stack size used in this run was 8388608.
==3449== 
==3449== HEAP SUMMARY:
==3449==     in use at exit: 72,944 bytes in 31 blocks
==3449==   total heap usage: 32 allocs, 1 frees, 73,968 bytes allocated
==3449== 
==3449== LEAK SUMMARY:
==3449==    definitely lost: 232 bytes in 29 blocks
==3449==    indirectly lost: 0 bytes in 0 blocks
==3449==      possibly lost: 0 bytes in 0 blocks
==3449==    still reachable: 72,712 bytes in 2 blocks
==3449==         suppressed: 0 bytes in 0 blocks
==3449== Rerun with --leak-check=full to see details of leaked memory
==3449== 
==3449== For counts of detected and suppressed errors, rerun with: -v
==3449== ERROR SUMMARY: 1 errors from 1 contexts (suppressed: 0 from 0)
```
In this example, there is a seg fault and a invalid read.

Adding some options:
```
valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes  program arg1 arg2
```

The output shows detailed information on the memory leaks:
```
==3465== Invalid read of size 4
==3465==    at 0x40301B: testa_vetor_pontos() (principal.cpp:90)
==3465==    by 0x403116: main (principal.cpp:102)
==3465==  Address 0x4 is not stack'd, malloc'd or (recently) free'd
==3465==
==3465==
==3465== Process terminating with default action of signal 11 (SIGSEGV)
==3465==  Access not within mapped region at address 0x4
==3465==    at 0x40301B: testa_vetor_pontos() (principal.cpp:90)
==3465==    by 0x403116: main (principal.cpp:102)
==3465==  If you believe this happened as a result of a stack
==3465==  overflow in your program's main thread (unlikely but
==3465==  possible), you can try to increase the size of the
==3465==  main thread stack using the --main-stacksize= flag.
==3465==  The main thread stack size used in this run was 8388608.
==3465==
==3465== HEAP SUMMARY:
==3465==     in use at exit: 72,944 bytes in 31 blocks
==3465==   total heap usage: 32 allocs, 1 frees, 73,968 bytes allocated
==3465==
==3465== 8 bytes in 1 blocks are still reachable in loss record 1 of 3
==3465==    at 0x4C2E0EF: operator new(unsigned long) (in /usr/lib/valgrind/vgpreload_memcheck-amd64-linux.so)
==3465==    by 0x402EB1: testa_vetor_pontos() (principal.cpp:81)
==3465==    by 0x403116: main (principal.cpp:102)
==3465==
==3465== 232 bytes in 29 blocks are definitely lost in loss record 2 of 3
==3465==    at 0x4C2E0EF: operator new(unsigned long) (in /usr/lib/valgrind/vgpreload_memcheck-amd64-linux.so)
==3465==    by 0x402EB1: testa_vetor_pontos() (principal.cpp:81)
==3465==    by 0x403116: main (principal.cpp:102)
==3465==
==3465== 72,704 bytes in 1 blocks are still reachable in loss record 3 of 3
==3465==    at 0x4C2DB8F: malloc (in /usr/lib/valgrind/vgpreload_memcheck-amd64-linux.so)
==3465==    by 0x4EC3EFF: ??? (in /usr/lib/x86_64-linux-gnu/libstdc++.so.6.0.21)
==3465==    by 0x40104E9: call_init.part.0 (dl-init.c:72)
==3465==    by 0x40105FA: call_init (dl-init.c:30)
==3465==    by 0x40105FA: _dl_init (dl-init.c:120)
==3465==    by 0x4000CF9: ??? (in /lib/x86_64-linux-gnu/ld-2.23.so)
==3465==
==3465== LEAK SUMMARY:
==3465==    definitely lost: 232 bytes in 29 blocks
==3465==    indirectly lost: 0 bytes in 0 blocks
==3465==      possibly lost: 0 bytes in 0 blocks
==3465==    still reachable: 72,712 bytes in 2 blocks
==3465==         suppressed: 0 bytes in 0 blocks
==3465==
==3465== For counts of detected and suppressed errors, rerun with: -v
==3465== ERROR SUMMARY: 2 errors from 2 contexts (suppressed: 0 from 0)
```

## Links
- http://lldb.llvm.org/tutorial.html
- http://lldb.llvm.org/lldb-gdb.html
- http://valgrind.org/docs/manual/quick-start.html
- https://sourceware.org/gdb/current/onlinedocs/gdb/


