run: shell
	./shell.exe

shell: lex.yy.c y.tab.c main.c
	gcc lex.yy.c y.tab.c main.c -o shell.exe

y.tab.c: shell.y
	bison -dy shell.y

lex.yy.c: shell.lex 
	flex shell.lex

main.c: main.c
	gcc main.c

clean:
	rm shell.exe mainc.o