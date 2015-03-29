#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <stddef.h>
#include <limits.h>
#include "y.tab.h"

void shellInit() {
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
	if (yyparse())
		//understand_errors();
		return(0);
	else
		return(1);
}

void processCommand() {
}

int main(void) {
	printf("\t\tWelcome to the Grand Illusion\n");
	//shell initialize	
	const size_t size = PATH_MAX;
	char buf[PATH_MAX] = "";

	while(1) {
	getcwd(buf, size);
	printf("%s>> ", buf);
	int CMD;
	switch (CMD = getCommand()) {
		case 2: 		exit(0);
		case 1: 	 	;//recover_from_errors();
		case 0: 		processCommand();
	}
	}
}