%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <limits.h>
#include <sys/file.h> 
#include <dirent.h>
#include "linked_list.h"

extern FILE *yyin;
const char* string = "a";
linked_list *linklist;
int command = -1;
const char* cmdtbl[100][100] = {"a"};
int i = 0; //row
int j = 0; //col
int curr;
void yyerror(const char *s){
	fprintf(stderr, "user error, quit being dumb: %s\n",s);
}
int yywrap() {
	return 1;
}
%}
%union {
	char* str;
	int num;
}
%token NUMBER STATE SETENV PRINTENV UNSETENV CD ALIAS UNALIAS LS QUOTE DOLLAR OCURL ECURL LESS GREATER BYE 
%token <str> VARIABLE 
%%
// Cmdline = cmdline PIPE Cmdline | CmdLine GT FINLENAME | CmdLine LT FILENAME | simpleCmd
commands:
| commands command;
command:
read_case|setenv_case|printenv_case|unsetenv_case|cd_case|alias_case|unalias_case|variable_case|ls_case|bye_case;

read_case:
	LESS VARIABLE {
		j = 0;
		command = 11;
		const char* file = $2;
		const char* io = "greater";
		cmdtbl[i][j] = io;
		j += 1;
		cmdtbl[i][j] = file;
		j += 1;
		i += 1;
	};

setenv_case:
	SETENV VARIABLE arguments {
		command = 1;
		j = 0;
		const char* name = $2;
		const char* value = string;
		cmdtbl[i][j] = name;
		j += 1;
		cmdtbl[i][j] = value;
		j += 1;
		i += 1;
	};
	| SETENV VARIABLE QUOTE arguments QUOTE {
		command = 1;
		j = 0;
		const char* name = $2;
		const char* value = string;
		cmdtbl[i][j] = name;
		j += 1;
		cmdtbl[i][j] = value;
		j += 1;
		i += 1;
	};
	| SETENV VARIABLE arguments GREATER VARIABLE {
		command = 1;
		j = 0;
		const char* name = $2;
		const char* value = string;
		const char* io = "greater";
		const char* file = $5;
		cmdtbl[i][j] = name;
		j += 1;
		cmdtbl[i][j] = value;
		j += 1;
		cmdtbl[i][j] = io;
		j += 1;
		cmdtbl[i][j] = file;
		j += 1;
		i += 1;
	};

arguments:
	VARIABLE {
		string = $1;
	};
	| env_expansion;
	//| io_redirection;
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

/*io_redirection:
	IO VARIABLE {
	LESS VARIABLE {

	};
	| GREATER VARIABLE {
	
	};*/
	
printenv_case:
	PRINTENV {
		command = 2;
	};
unsetenv_case:
	UNSETENV VARIABLE {
		command = 3;
		j = 0;
		cmdtbl[i][j] = $2;
		i += 1;
	};
cd_case:
	CD {
		command = 4;
	};
	| CD VARIABLE {
		command = 5;
		j = 0;
		cmdtbl[i][j] = $2;
		i += 1; 
	};
	| CD arguments {
		command = 5;
		j = 0;
		cmdtbl[i][j] = string;
		i += 1;
	};
		 
alias_case:
	ALIAS VARIABLE VARIABLE {
		command = 6;
		char *name = $2;
		char *value = $3;
		cmdtbl[i][j] = name;
		j += 1;
		cmdtbl[i][j] = value;
		j += 1;
		i += 1;
	}
	| ALIAS VARIABLE CD {
		char *name = $2;
		char *value = "cd";
		printf("\t alias !! \n");
		push_linked_list(linklist, name, value);
	}
	| ALIAS VARIABLE QUOTE arguments QUOTE {
		char *name = $2;
		char *value = string;
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
variable_case:
	VARIABLE {
	char *expand = value_from_list(linklist, $1);
	command = 30;
	if(equals("Does not Exist", expand)) {
		perror("Does not Exist");
	} else {

	printf("%s\n", expand);
	/*
		int mypipe[2]; //pipe with two ends, read and write
		pid_t p;
		int status, wpid;
		pipe(mypipe); //creates pipe
		p = fork();
		if (p < 0) {
			perror("failed to fork");
		}
		else if (p == 0) {
			FILE *f;
			f = fopen("alias.txt", "w");	
			fprintf(f, "%s\n%s", expand, "bye");
			fclose(f);
			f = fopen("alias.txt", "r");	
			int fd = fileno(f);
			dup2(fd, fileno(stdin));
			fclose(f);
			const char* path = getenv("PWD");
			char dest[100];
			strcpy(dest, path);
			strcat(dest, "/");
			strcat(dest, "alias.txt");
			execl(dest, "alias.txt", 0);
			command = 10;
		} else {
			while ((wpid = wait(&status)) > 0) {
				//
			}
		}*/
	}
};
ls_case: 
	LS {
		command = 8;
	};
	| LS VARIABLE {
		j = 0;
		command = 9;
		cmdtbl [i][j] = $2;
		i += 1; 
	};
bye_case:
	BYE {
		command = 10;		
	};
%%
