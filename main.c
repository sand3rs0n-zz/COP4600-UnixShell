#include <stdio.h>
#include <string.h>
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
	while(1) {
	printf("Type your input you: ");
	getCommand();
	//switch (CMD = getCommand()) {
		//Case: BYE		exit();
		//Case: ERRORS 	recover_from_errors();
		//Case: OK 		processCommand();
	//}
	}
}