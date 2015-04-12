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
| piping to execute. Currently parses string but doesn't execute commands after first one
multiple | piping cases not handled
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
background processing. We think this is complete. We arent sure.




How to run
type    make    command line, compiles and runs
ignore warnings

How to use File I/O
< (filename here)