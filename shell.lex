%{
#include <stdio.h>
#include <string.h>
#include "y.tab.h"
%}

%%
bye         return BYE;
on			return STATE;
setenv      return SETENV;
printenv    return PRINTENV;
unsetenv    return UNSETENV;
cd          return CD;
alias       return ALIAS;
unalias     return UNALIAS;
[a-zA-Z]+	return VARIABLE;
\n          ;
%%