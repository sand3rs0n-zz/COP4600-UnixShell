%{#include <stdio.h>
#include "y.tab.h"
%}

%%
setenv      return SETENV;
printenv    return PRINTENV;
unsetenv    return UNSETENV;
cd          return CD;
alias       return ALIAS;
unalias     return UNALIAS;
bye         return BYE;
\n          /* ignore end of line */;
%%