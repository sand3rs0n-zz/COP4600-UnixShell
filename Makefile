run: shell
	./shell.exe

shell: lex.yy.c y.tab.c
	gcc lex.yy.c y.tab.c -o shell.exe

y.tab.c: shell.y
	bison -dy shell.y

lex.yy.c: shell.lex 
	flex shell.lex

clean:
	rm shell.exe