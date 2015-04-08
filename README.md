# COP4600-UnixShell
Korn-like Unix shell built in C for COP4600 Operating Systems term project

Incomplete features-
Handling an alias multi token infinite loop. Bus Error.
Handling an alias of a pre-existing command.
Executing an alias.
CMD
error handling
background proccessing
wildcard matching
file i/o infinite loops when not finished with a bye command.
file i/o stores command so when you hit enter after finish it re-executes file


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
