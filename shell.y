%{
#include <stdio.h>
#include <string.h>

void yyerror(const char *s){fprintf(stderr, "user error, quit being dumb: %s\n",s);}
int yywrap() {return 1;}
%}
%union {
    char* str;
    int num;
}
%token NUMBER STATE SETENV PRINTENV UNSETENV CD ALIAS UNALIAS BYE
%token <str> VARIABLE
%%
//	Cmdline = cmdline PIPE Cmdline | CmdLine GT FINLENAME | CmdLine LT FILENAME | simpleCmd
commands:
    | commands command;

command:
    setenv_case|printenv_case|unsetenv_case|cd_case|alias_case|unalias_case|bye_case;

setenv_case:
    SETENV VARIABLE {printf("\t set !! \n");};

printenv_case:
    PRINTENV VARIABLE {printf("\t print %s!! \n", getenv($2));};

unsetenv_case:
    UNSETENV {printf("\t unset !! \n");};

cd_case:
    CD {printf("\t cd !! \n");};

alias_case:
    ALIAS {printf("\t alias !! \n");};

unalias_case:
    UNALIAS {printf("\t unalias !! \n");};

bye_case:
    BYE {printf("\t bye!! \n"); exit(0);};
%%

void shellInit() {
	// init all variables. 
	// define (allocate storage) for some var/tables
	//init all tables (e.g., alias table)
	//get PATH environment variable (use getenv())
	//get HOME env variable (also use getenv())
	//disable anything that can kill your shell. 
	// (the shell should never die; only can be exit)
	// do anything you feel should be done as init
}

int getCommand() {
	//initialize scanner and parser();
	if (yyparse())
		//understand_errors();
		return(0);
	else
		return(1);
}

void processCommand() {
}

int main(void) {
	printf("\t\tWelcome to the Grand Illusion\n");
	//shell initialize
	while(1) {
	printf("Type your input you: ");
	getCommand();
	//switch (CMD = getCommand()) {
		//Case: BYE		exit();
		//Case: ERRORS 	recover_from_errors();
		//Case: OK 		processCommand();
	//}
	}
}