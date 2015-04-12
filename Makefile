run: shell
	./shell.exe

shell: lex.yy.c y.tab.c main.c
	gcc lex.yy.c y.tab.c main.c linked_list.c -o shell.exe

y.tab.c: shell.y
	bison -dy shell.y

lex.yy.c: shell.lex 
	flex shell.lex

main.c: main.c
	gcc main.c

linked_list.c: linked_list.c
	gcc	linked_list.c

tarfile:
	tar cvf COP4600Shell.tar main.c shell.y shell.lex linked_list.h linked_list.c Makefile README.md

clean:
	rm shell.exe main.o linked_list.o pipe.o redirect.o