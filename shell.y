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
    PRINTENV VARIABLE {printf("\t print !! \n");};

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