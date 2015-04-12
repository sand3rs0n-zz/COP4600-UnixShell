%{
#include <stdio.h>
#include <string.h>
#include "y.tab.h"
%}
%%
bye return BYE;
on return STATE;
setenv return SETENV;
printenv return PRINTENV;
unsetenv return UNSETENV;
cd return CD;
alias return ALIAS;
unalias return UNALIAS;
ls return LS;
[0-9a-zA-Z/\.]+ {yylval.str = strdup(yytext); return VARIABLE; };
\" return QUOTE;
\$ return DOLLAR;
\{ return OCURL;
\} return ECURL;
\< return LESS;
\> return GREATER;
\* return STAR;
\? return QUESTION;
\n return -1;
<<EOF>> return ENDF;
%%
