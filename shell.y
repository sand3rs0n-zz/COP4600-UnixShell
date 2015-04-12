%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <limits.h>
#include <sys/file.h> 
#include <dirent.h>
#include "linked_list.h"

const char* string1 = "a";
const char* string2 = "b";
linked_list *linklist;
int command = -1;
const char* cmdtbl[100][100] = {"a"};
int i = 0; //row
int j = 0; //col
int curr;
const char* io = "";
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
%token NUMBER STATE SETENV PRINTENV UNSETENV CD ALIAS UNALIAS LS QUOTE DOLLAR OCURL ECURL LESS GREATER STAR QUESTION ENDF BYE 
%token <str> VARIABLE 
%%
// Cmdline = cmdline PIPE Cmdline | CmdLine GT FINLENAME | CmdLine LT FILENAME | simpleCmd
commands:
| commands command;
command:
read_case|setenv_case|printenv_case|unsetenv_case|cd_case|alias_case|unalias_case|variable_case|ls_case|bye_case;

read_case:
	LESS arguments {
		j = 0;
		command = 11;
		const char* file = string1;
		const char* io = "less";
		cmdtbl[i][j] = io;
		j += 1;
		cmdtbl[i][j] = file;
		j += 1;
		i += 1;
	};

setenv_case:
	SETENV VARIABLE VARIABLE {
		command = 1;
		j = 0;
		const char* name = $2;
		const char* value = $3;
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
		const char* value = string1;
		cmdtbl[i][j] = name;
		j += 1;
		cmdtbl[i][j] = value;
		j += 1;
		i += 1;
	};
	| SETENV VARIABLE arguments io_redirection {
		command = 1;
		j = 0;
		const char* name = $2;
		const char* value = string1;
		const char* file = string2;
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
	SETENV {
		string1 = "setenv";
	};
	| PRINTENV {
		string1 = "printenv";
	};
	| UNSETENV {
		string1 = "unsetenv";
	};
	| CD {
		string1 = "cd";
	};
	| UNALIAS {
		string1 = "unalias";
	};
	| LS {
		string1 = "ls";
	};
	| VARIABLE {
		string1 = $1;
	};
	| env_expansion;
	| arguments VARIABLE {
		const char* curr = $2;
		strcat(string1, " ");
		strcat(string1, curr);
	};
	| arguments DOLLAR OCURL VARIABLE ECURL {
		const char* curr = getenv($4);
		strcat(string1, " ");
		strcat(string1, curr);
	};
	| STAR VARIABLE {
		DIR *d;
		struct dirent *dir;
		d = opendir(".");
		int works;
		const char* strIn = "a";
		int len;
		const char* strOut;
		strIn = $2;
		len = strlen($2);
		if(d) {
			while ((dir = readdir(d)) != NULL) {
				works = 1;
				strOut = dir->d_name;
				int outLen = strlen(strOut);
				int i;
				for (i = len; i > 0; i--) {
					if (strOut[outLen] != strIn[i]) {
						works = 0;
						break;
					}
					outLen--;
				}
				if (works == 1) {
					string1 = strOut;
				}
			}
		closedir(d);
		}		
	};
	| VARIABLE STAR {
		DIR *d;
		struct dirent *dir;
		d = opendir(".");
		int works;
		const char* strIn = "a";
		int len;
		const char* strOut;
		strIn = $1;
		len = strlen($1);
		if(d) {
			while ((dir = readdir(d)) != NULL) {
				works = 1;
				strOut = dir->d_name;
				int i;
				for (i = 0; i < len; i++) {
					if (strOut[i] != strIn[i]) {
						works = 0;
						break;
					}
				}
				if (works == 1) {
					string1 = strOut;
				}
			}
		closedir(d);
		}		
	};
	| QUESTION VARIABLE {
	DIR *d;
		struct dirent *dir;
		d = opendir(".");
		int works;
		const char* strIn = "a";
		int len;
		const char* strOut;
		strIn = $2;
		len = strlen($2);
		if(d) {
			while ((dir = readdir(d)) != NULL) {
				works = 1;
				strOut = dir->d_name;
				int outLen = strlen(strOut);
				int i;
				for (i = len; i > 0; i--) {
					if (strOut[outLen] != strIn[i]) {
						works = 0;
						break;
					}
					outLen--;
				}
				if (works == 1 && outLen == 1) {
					string1 = strOut;
				}
			}
		closedir(d);
		}		
	};
	| VARIABLE QUESTION {
		DIR *d;
		struct dirent *dir;
		d = opendir(".");
		int works;
		const char* strIn = "a";
		int len;
		const char* strOut;
		strIn = $1;
		len = strlen($1);
		int outlen;
		if(d) {
			while ((dir = readdir(d)) != NULL) {
				works = 1;
				strOut = dir->d_name;
				outlen = strlen(strOut);
				if (outlen - len != 1) {
					works = 0;
				}
				int i;
				for (i = 0; i < len; i++) {
					if (strOut[i] != strIn[i]) {
						works = 0;
						break;
					}
				}
				if (works == 1) {
					string1 = strOut;
				}
			}
		closedir(d);
		}
	};



env_expansion:
	DOLLAR OCURL VARIABLE ECURL {
		string1 = getenv($3);
	};

io_redirection:
	LESS VARIABLE {
		string2 = $2;
		io = "less";
	};
	| GREATER VARIABLE {
		string2 = $2;
		io = "greater";
	};
	
printenv_case:
	PRINTENV {
		command = 2;
	};
	| PRINTENV io_redirection {
		command = 2;
		j = 0;
		cmdtbl[i][j] = io;
		j += 1;
		cmdtbl[i][j] = string2;
		j += 1;
		i += 1;
	};
unsetenv_case:
	UNSETENV VARIABLE {
		command = 3;
		j = 0;
		const char* name = $2;
		cmdtbl[i][j] = name;
		j += 1;
		i += 1;
	};
	| UNSETENV VARIABLE io_redirection {
		command = 3;
		j = 0;
		cmdtbl[i][j] = $2;
		j += 1;
		cmdtbl[i][j] = io;
		j += 1;
		cmdtbl[i][j] = string2;
		j += 1;
		i += 1;
	};
cd_case:
	CD {
		command = 4;
	};	
	| CD arguments {
		command = 5;
		j = 0;
		cmdtbl[i][j] = string1;
		j += 1;
		i += 1;
	};
	| CD arguments io_redirection {
		command = 5;
		j = 0;
		cmdtbl[i][j] = string1;
		j += 1;
		cmdtbl[i][j] = io;
		j += 1;
		cmdtbl[i][j] = string2;
		j += 1;
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
	| ALIAS VARIABLE arguments {
		command = 6;
		char *name = $2;
		char *value = string1;
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
		char *value = string1;
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
		} else {
			while ((wpid = wait(&status)) > 0) {
				//
			}
		}
	}
};
ls_case: 
	LS {
		command = 8;
	};
	| LS arguments {
		j = 0;
		command = 9;
		cmdtbl[i][j] = string1;
		j += 1;
		i += 1; 
	};
	| LS arguments io_redirection {
		j = 0;
		command = 9;
		cmdtbl[i][j] = string1;
		j += 1;
		cmdtbl[i][j] = io;
		j += 1;
		cmdtbl[i][j] = string2;
		j += 1;
		i += 1; 
	};
		
bye_case:
	ENDF {
		exit(0);
	};
	| BYE {
		command = 10;		
	};
%%
