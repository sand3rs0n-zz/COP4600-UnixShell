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
	int pid[2]; 
	int i = 0;
	int ab[2], ba[2];
	pid[0] = fork();
	/*if (pid[0] == 0) {
		//error
	}*/
	pid[1] = fork();
	if (pid[i] == 0) {
		dup2(ab[0], STDIN_FILENO); 
		dup2(ba[1], STDOUT_FILENO);
		int j;
		for (j = 0; j < 2; j++) {
			close(ab[j]);
			close(ba[j]);
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
		close(ba[j]);
	}
	wait();
	wait();
}
