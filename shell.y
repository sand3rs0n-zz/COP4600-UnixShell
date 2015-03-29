%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <dirent.h>

extern char **environ;
void yyerror(const char *s){fprintf(stderr, "user error, quit being dumb: %s\n",s);}
int yywrap() {return 1;}
%}
%union {
    char* str;
    int num;
}
%token NUMBER STATE SETENV PRINTENV UNSETENV CD ALIAS UNALIAS BYE LS
%token <str> VARIABLE
%%
//	Cmdline = cmdline PIPE Cmdline | CmdLine GT FINLENAME | CmdLine LT FILENAME | simpleCmd
commands:
    | commands command;

command:
    setenv_case|printenv_case|unsetenv_case|cd_case|ls_case|alias_case|unalias_case|bye_case;

setenv_case:
    SETENV VARIABLE VARIABLE {
    	const char* name = $2; 
    	const char* value = $3; 
    	setenv(name, value, 1); 
    	printf("\t set %s = %s!! \n", name, value);
    };

printenv_case:
    PRINTENV {
    	int i = 0; 
    	while(environ[i]) {
    		printf("%s\n", environ[i++]);
    	}
    };

unsetenv_case:
    UNSETENV VARIABLE {
    	const char* name = $2; 
    	unsetenv(name); 
    	printf("\t unset %s!! \n", name);
    };

cd_case :
	CD VARIABLE {
	 	char* dir = $2; 
	 	chdir(dir);
	 }
    | CD {
    	char* home = getenv("HOME"); 
    	chdir(home);
    };

ls_case:
	LS {
		DIR *d; 
		struct dirent *dir; 
		d = opendir("."); 
		if (d) { 
			while ((dir = readdir(d)) != NULL) {
				printf("%s\n", dir->d_name);
			} 
			closedir(d);
		}
	};

alias_case:
    ALIAS VARIABLE VARIABLE {
    	printf("\t alias %s = %s !! \n", $2, $3);
    };

unalias_case:
    UNALIAS VARIABLE {
    	printf("\t unalias !! \n");
    };

bye_case:
    BYE {
    	printf("\t bye!! \n"); 
    	exit(0);
    };
%%