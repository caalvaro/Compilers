all: saida entrada.txt
	./saida < entrada.txt

lex.yy.c: analisador.lex
	lex analisador.lex

saida: lex.yy.c
	g++ -Wall -std=c++17 lex.yy.c -o saida -ll

clean:
	rm saida lex.yy.c
