%{#include <stdio.h>
#include <string.h>

void yyerror(const char *str){fprintf(stderr, "error: %s\n",str);}
int yywrap(){return 1;}
main(){yyparse();}
%}
%token SETENV PRINTENV UNSETENV CD ALIAS UNALIAS BYE
%%

commands: /* empty */
    | commands command;

command:
    setenv_case|printenv_case|unsetenv_case|cd_case|alias_case|unalias_case|bye_case;

setenv_case:
    SETENV {printf("\t set !! \n");};

printenv_case:
    PRINTENV {printf("\t print !! \n");};

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