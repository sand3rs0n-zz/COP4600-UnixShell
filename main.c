#include <stdio.h>
#include <string.h>
#include "y.tab.h"
#include <stdlib.h>
#include <unistd.h>
#include <stddef.h>
#include <limits.h>
#include "linked_list.h"
#include <dirent.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <sys/types.h>

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
	else {
		return(1);
	}
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

void IO_redirect_greater(const char* f) {
	int fd = open(f, O_RDWR | O_CREAT | O_EXCL, S_IREAD | S_IWRITE);
	if (fd != -1) {
		dup2(fd, 2);
	}
	else {
		perror(f);
	}
	close(f);
}

void ls_dir() {
	DIR *d;
	struct dirent *dir;
	d = opendir(".");
	int works;
	const char* strIn = "a";
	int len;
	char* strOut;
	if (j >= 2) {
		if (string_equals(cmdtbl[i-1][j-2], "greater")) {		
			IO_redirect_greater(cmdtbl[i-1][j-1]);
			strIn = cmdtbl[i-1][j-3];
			len = strlen(cmdtbl[i-1][j-3]);
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
		else if (string_equals(cmdtbl[i-1][j-2], "less")) {
			perror("Can't read from file in ls");
		}
	}
	else {
		strIn = cmdtbl[i-1][j-1];
		len = strlen(cmdtbl[i-1][j-1]);
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
}

int IO_redirect_less () {
	int mypipe[2]; //pipe with two ends, read and write
	pid_t p;
	int status, wpid;
	pipe(mypipe); //creates pipe
	p = fork();
	if (p < 0) {
		perror("failed to fork");
	}
	else if (p == 0) {
		int fd = open(cmdtbl[i-1][j-1], O_RDONLY);
		dup2(fd, STDIN_FILENO);
		close(fd);
		const char* path = getenv("PWD");
		char dest[100];
		strcpy(dest, path);
		strcat(dest, "/");
		strcat(dest, cmdtbl[i-1][j-1]);
		execl(dest, cmdtbl[i-1][j-1], 0);
	}
	else {
		while ((wpid = wait(&status)) > 0) {
			//
		}
	}
	return 0;
}

int string_equals (const char* string1, const char* string2) {
	int ret = 1;
	int i;
	for (i = 0; i < strlen(string1); i++) {
		if (string1[i] != string2[i]) {
			ret = 0;
			break;
		}
	}
	return ret;
}

void setenv1 () {
	if (string_equals(cmdtbl[i-1][j-2], "greater")) {
		IO_redirect_greater(cmdtbl[i-1][j-1]);
		setenv(cmdtbl[i-1][j-4], cmdtbl[i-1][j-3], 1);
	}
	else if (string_equals(cmdtbl[i-1][j-2], "less")) {
		perror("Can't read from file with setenv");
	}
	else {
		setenv(cmdtbl[i-1][j-2], cmdtbl[i-1][j-1], 1);
	}
}

void cd () {
	if (j == 4) {
		if (string_equals(cmdtbl[i-1][j-2], "greater")) {
			IO_redirect_greater(cmdtbl[i-1][j-1]);
			int a = chdir(cmdtbl[i-1][j-3]);
			if (a < 0) {
			perror("Not a directory");
			}
		}
		else if (string_equals(cmdtbl[i-1][j-2], "less")) {
			perror("Can't read from file with cd");
		}
	}
	else {
		int a = chdir(cmdtbl[i-1][j-1]);
		if (a < 0) {
			perror("Not a directory");
		}
	}
}

void unsetenv1 () {
	if (j >= 2) {
		if (string_equals(cmdtbl[i-1][j-2], "greater")) {
			IO_redirect_greater(cmdtbl[i-1][j-1]);
			unsetenv(cmdtbl[i-1][j-3]);
		}
		else if (string_equals(cmdtbl[i-1][j-2], "less")) {
			perror("Can't read from file with unsetenv");
		}
	}	
	else {
		unsetenv(cmdtbl[i-1][j-1]);
	}
}

void printenv1 () {
	if (j >= 2) {
		if (string_equals(cmdtbl[i-1][j-2], "greater")) {
			IO_redirect_greater(cmdtbl[i-1][j-1]);
		}
		else if (string_equals(cmdtbl[i-1][j-2], "less")) {
			perror("Can't read from file with printenv");
		}
	}
	printenv();
}

void do_it() {
	switch (command) {
		case 1: //setenv
			setenv1();
			break;
		case 2: //printenv
			printenv1();
			break;
		case 3: //unsetenv
			unsetenv1();
			break;
		case 4:	//cd home
			chdir(getenv("HOME"));
			break;
		case 5: //cd dir
			cd();	
			break;
		case 6: //alias	
			printf("\t alias !! \n");
			push_linked_list(linklist, cmdtbl[i-1][j-2], cmdtbl[i-1][j-1]);
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
		case 11: //read
			IO_redirect_less();
			break;
	};
}

void processCommand() {

	if (command < 12 && command > 0) {
		do_it();
	}
	else 
		execute_it();
}

int main(int argc, char* argv[], char **envp) {
	char line[256];
	printf("\t\tWelcome to the Grand Illusion\n");
	shellInit();
	size_t size = PATH_MAX;
	char buf[PATH_MAX] = "";
	while(1) {
		getcwd(buf, size);
		printf("%s>>", buf);

		int c = getCommand();
		switch (c) { 
			//Case: BYE exit();
			//case 0:  recover_from_errors();
			case 1: //no errors
				processCommand();
				break;
		};
	}
	return 0;
}
