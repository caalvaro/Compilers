all: js entrada.txt
	@./js < entrada.txt

lex.yy.c: mini_js.lex
	lex mini_js.lex

y.tab.c: mini_js.yacc
	yacc mini_js.yacc

js: lex.yy.c y.tab.c
	g++ -o js y.tab.c -ll