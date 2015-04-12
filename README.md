# COP4600-UnixShell
Korn-like Unix shell built in C for COP4600 Operating Systems term project

Incomplete features-
Handling an alias multi token infinite loop. Bus Error.
Handling an alias of a pre-existing command. complex cases dont work.
error handling a handful of cases
CMD
background proccessing
file i/o stores command so when you hit enter after finish it re-executes file
alias results are in separate process


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