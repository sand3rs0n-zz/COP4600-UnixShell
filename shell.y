%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <limits.h>
#include <sys/file.h> 
#include <dirent.h>

extern char **environ;
void yyerror(const char *s){fprintf(stderr, "user error, quit being dumb: %s\n",s);}
int yywrap() {return 1;}
%}
%union {
char* str;
int num;
}
%token NUMBER STATE SETENV PRINTENV UNSETENV CD ALIAS UNALIAS LS BYE 
%token <str> VARIABLE
%%
// Cmdline = cmdline PIPE Cmdline | CmdLine GT FINLENAME | CmdLine LT FILENAME | simpleCmd
commands:
| commands command;
command:
setenv_case|printenv_case|unsetenv_case|cd_case|alias_case|unalias_case|ls_case|bye_case;
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
		while (environ[i]) {
			printf("%s\n", environ[i++]);
		}
	};
unsetenv_case:
	UNSETENV VARIABLE {
		const char* name = $2;
		unsetenv(name);
	};
cd_case:
	CD {
		printf("\t cd !! \n");
		chdir(getenv("HOME"));
	};
	| CD VARIABLE {
		chdir($2);
	};
alias_case:
	ALIAS {
		printf("\t alias !! \n");
	};
unalias_case:
	UNALIAS {
		printf("\t unalias !! \n");
	};
ls_case: 
	LS {
		DIR *d;
		struct dirent *dir;
		d = opendir(".");
		if(d) {
			while ((dir = readdir(d)) != NULL) {
				printf("%s\n", dir->d_name);
			}
			closedir(d);
		}
	};
	| LS VARIABLE {
		DIR *d;
		struct dirent *dir;
		d = opendir(".");
		int works;
		const char* strIn = $2;
		int len = strlen($2);
		char* strOut;
		if(d) {
			while ((dir = readdir(d)) != NULL) {
				works = 1;
				strOut = dir->d_name;
				int i;
				for (i = 0; i < len; i++) {
					if (strIn[i] != strOut[i]) {
						works = 0;
						break;
					}
				}
				if (works == 1)
					printf("%s\n", dir->d_name);

			}
			closedir(d);
		}
	};
bye_case:
	BYE {
		printf("\t bye!! \n"); 
		exit(0);
		
	};
%%
