#include <stdio.h>
#include <string.h>
#include "y.tab.h"
#include <stdlib.h>
#include <unistd.h>
#include <stddef.h>
#include <limits.h>
#include "linked_list.h"
#include <dirent.h>

extern struct linked_list *linklist;
extern int command;
extern const char* cmdtbl[100][100];
extern int i, j;
extern char** environ;

void shellInit() {
	linklist = create_linked_list();
	// init all variables.
	// define (allocate storage) for some var/tables
	//init all tables (e.g., alias table)
	//get PATH environment variable (use getenv())
	//get HOME env variable (also use getenv())
	//disable anything that can kill your shell.
	// (the shell should never die; only can be exit)
	// do anything you feel should be done as init
}
int getCommand() {
	//initialize scanner and parser();
	if (yyparse()) {
		//understand_errors();
		return(0);
	}
	else
		return(1);
}

void execute_it() {
	//build up pipeline using pipe and dup
}

void printenv() {
	int i = 0;
	while (environ[i]) {
		printf("%s\n", environ[i++]);
	}
}

void ls() {
	DIR *d;
		struct dirent *dir;
		d = opendir(".");
		if(d) {
			while ((dir = readdir(d)) != NULL) {
				printf("%s\n", dir->d_name);
			}
			closedir(d);
		}
}

void ls_dir() {
	DIR *d;
	struct dirent *dir;
	d = opendir(".");
	int works;
	const char* strIn = cmdtbl[i-1][j];
	int len = strlen(cmdtbl[i-1][j]);
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
}

void do_it() {
	switch (command) {
		case 1: //setenv
			setenv(cmdtbl[i-1][j-2], cmdtbl[i-1][j-1], 1);
			printf("\t set %s = %s!! \n", cmdtbl[i-1][j-2], cmdtbl[i-1][j-1]);
			break;
		case 2: //printenv
			printenv();
			break;
		case 3: //unsetenv
			unsetenv(cmdtbl[i-1][j]);
			printf ("\t unset !!"); 
			break;
		case 4:	//cd home
			printf("\t cd !! \n");
			chdir(getenv("HOME"));
			break;
		case 5: //cd dir
			printf("\t cd %s\n", cmdtbl[i-1][j]);
			chdir(cmdtbl[i-1][j]);	
			break;
		case 6: //alias
			break;
		case 7: //unalias
			break;
		case 8: //ls
			ls();		
			break;
		case 9: //ls dir
			ls_dir();
			break;
		case 10: //bye
			printf("\t bye!! \n"); 
			exit(0);
			break;
	};
}

void processCommand() {
	if (command)	
		do_it();
	else 
		execute_it();
}

int main(int argc, char* argv[], char **envp) {
	//char* fileName = argv[6];
	//FILE* file = fopen(fileName, "r");
	char line[256];
	printf("\t\tWelcome to the Grand Illusion\n");
	shellInit();
	size_t size = PATH_MAX;
	char buf[PATH_MAX] = "";
	while(1) {
		getcwd(buf, size);
		printf("%s>>", buf);
		//getCommand();
		//int CMD;
		switch (getCommand()) {
		//Case: BYE exit();
		//Case: ERRORS recover_from_errors();
		case 1:
			processCommand();
		};
	}
	//fclose(file);
}
