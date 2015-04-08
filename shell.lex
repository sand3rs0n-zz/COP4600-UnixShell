%{
#include <stdio.h>
#include <string.h>
#include "y.tab.h"
%}
%%
alias return ALIAS;
bye return BYE;
on return STATE;
setenv return SETENV;
printenv return PRINTENV;
unsetenv return UNSETENV;
cd return CD;
unalias return UNALIAS;
[0-9a-zA-Z/\.]+ {yylval.str = strdup(yytext); return VARIABLE; };
ls return LS;
\" return QUOTE;
\$ return DOLLAR;
\{ return OCURL;
\} return ECURL;
\< return LESS;
\> return GREATER;
\n return -1;
%%
