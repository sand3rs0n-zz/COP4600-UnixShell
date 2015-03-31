#include <stdio.h>
#include <unistd.h>
#include <sys/types.h>

void strrev (char* p) {
	char* q = p;
	while (q && *q) ++q;
	for (--q; p < q; ++p, --q) {
		*p = *p ^ *q;
		*q = *p ^ *q;
		*p = *p ^ *q;
	}

int main (int argc, char** argv) {
	int pid[n]; //n = number of pipes
	int i = 0;
	int ab[2], bc[2], ca[2]; //create n pipes, should they all be in a linked list?
	pid[0] = fork();
	if (pid[0] == 0) {
		//error
	}
	int i = 1;
	for (i; i < n; i++) {
		pid[i] = fork();
		if (pid[i] == 0) {
			dup2(ab[0], STDIN_FILENO); //change name of array (i.e. next two should be bc and ca) If in linked list, could just move each to next node right before next for loop 
			dup2(bc[1], STDOUT_FILENO);
			int j;
			for (j = 0; j < n; j++) {
				close(ab[j]);
				close(bc[j]);
				close(ca[j]); //keep going
			}
			char str[100];
			scanf("%s\n", str);
			strrev(str);
			printf("%s\n", str);
			exit(0);
		}
	}
	int j;
	for (j = 0; j < n; j++) {
		close(ab[j]);
		close(bc[j]);
		close(ca[j]); //keep going
	}
	int k;
	for (k = 0; k < n; k++) {
		wait();
	}
