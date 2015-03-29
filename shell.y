%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <limits.h>
#include "linked_list.h"
#include <sys/file.h> 
#include <dirent.h>

const char* string = "a";
linked_list *linklist;
extern char **environ;
void yyerror(const char *s){fprintf(stderr, "user error, quit being dumb: %s\n",s);}
int yywrap() {return 1;}
%}

%union {
	char* str;
	int num;
}
%token NUMBER STATE SETENV PRINTENV UNSETENV CD ALIAS UNALIAS LS BYE DOLLAR ECURL OCURL QUOTE
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
	| SETENV VARIABLE env_expansion {
		const char* name = $2;
		const char* value = string;
		setenv(name, value, 1);
		printf("\t set %s = %s!! \n", name, value);
	};
	| SETENV VARIABLE QUOTE arguments QUOTE {
		const char* name2 = $2;
		const char* value2 = string;
		setenv(name2, value2, 1);
		printf("\t set %s = %s!! \n", name2, value2);
	};

arguments:
	VARIABLE {
		string = $1;
	};
	| env_expansion;
	| arguments VARIABLE {
		const char* curr = $2;
		strcat(string, " ");
		strcat(string, curr);
	};
	| arguments DOLLAR OCURL VARIABLE ECURL {
		const char* curr = getenv($4);
		strcat(string, " ");
		strcat(string, curr);
	};

env_expansion:
	DOLLAR OCURL VARIABLE ECURL {
		string = getenv($3);
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
	ALIAS VARIABLE VARIABLE {
		char *name = $2;
		char *value = $3;
		printf("\t alias !! \n");
		push_linked_list(linklist, name, value);
	}
	| ALIAS {
		print_linked_list(linklist);
	};
unalias_case:
	UNALIAS VARIABLE {
		char *name = $2;
		printf("\t unalias !! \n");
		remove_node_from_list(linklist, name);
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
