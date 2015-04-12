# COP4600-UnixShell
Korn-like Unix shell built in C for COP4600 Operating Systems term project
Steven Anderson
Kimberly Naylor


Incomplete features and bugs-
Handling an alias multi token infinite loop. Bus Error.
Handling an alias of a pre-existing command. complex cases dont work.
alias results are in a separate process.
alias only works when very first word is the creted alias
error handling a handful of cases
| piping has weird visual bug but works
multiple | piping cases very buggy
complex | piping also buggy
file i/o stores command so when you hit enter after finish it re-executes file
Weird bugs where it doesnt look like it worked but it does
Clean, easy to read code



Complete features-
Enviroment Variable Expansion
Lex file
Yacc file
alias
alias name word
unalias name
setenv variable word
printenv
unsetenv variable
cd
cd word_directory_name
reading in and executing file
bye
metacharacters
white space
multi token arguments
some error handling
wildcard matching
alias executes
| piping parses string and executes first command only
| piping only works for base case: cd, ls, printenv
background processing. Works for base case setenv, unsetenv,
background process requires you to hit enter after it finishes to register.



How to run
type    make    in command line, compiles and runs
ignore warnings

How to use File I/O
< (filename here)

If an error appears when you typed it with proper syntax, type it again. Some errors are false flags, and they require two inputs to work.