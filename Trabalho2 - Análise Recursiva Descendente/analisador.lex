%{
#include <stdlib.h>
#include <stdio.h>
#include <map>
#include <vector>
#include <string>
#include <iostream>

using namespace std;

int token;
string lexema;

void L();
void C();
void E();
void E_linha();
void T();
void T_linha();
void F();
void PARAMETROS();
void PROXIMO();

void casa( int esperado );
string nome_token( int token );


enum { _NUM = 256, _STRING, _ID, _FUNCAO, _PRINT };

map<int, string> nome_tokens = {
  { _NUM, "número" },
  { _STRING, "string" },
  { _ID, "identificador" },
  { _FUNCAO, "função" },
  { _PRINT, "print" }
};

%}

/* Coloque aqui definições regulares */

D	[0-9]
L	[A-Za-z_$]

WS          [ \t\n]
NUM         {D}+("."{D}+)?([Ee]("+"|"-")?{D}+)?
ID          {L}({L}|{D})*
STRING      ([\"]([^\"\n]*(\"\")*(\\\")*)*[\"])

%%

{WS}        { }
{NUM}       { return _NUM; }
"print"     { return _PRINT; }

{STRING}    { return _STRING; }

{ID}        { return _ID; }

.           { return *yytext; }

%%

/*

GRAMATICA

L -> C ';' L | ε

C -> ID { Print( id ); } = E { Print( "=" ); }
   | print E { Print( print + "#"); }
    
E -> T E'

E' -> + T { Print( "+" ); } E'
    | - T { Print( "-" ); } E'
    | ε

T -> F T'

T' -> * F { Print( "*" ); } T'
    | / F { Print( "/" ); } T'
    | ε

F -> id { Print(id + "@"); }
   | num { Print( num ); }
   | string { Print( num ); }
   | id ( PARAMETROS )
   | ( E )

PARAMETROS -> E PROXIMO
            | ε

PROXIMO -> , E PROXIMO
         | ε
*/

void L() {
  if (token == _ID | token == _PRINT) {
    C();
    casa( ';' );
    L();
  }
  else return;
}

void C() {
  string temp = lexema + " "; 

  if (token == _ID) {
    casa( _ID );
    printf( temp.c_str() );
    casa( '=' );
    E();
    printf( "= " );
  }
  else if (token == _PRINT) {
    casa( _PRINT );
    E();
    printf( "print # " );
  }
  
}

void E() {
  T();
  E_linha();
}

void E_linha() {
  switch( token ) {
    case '+' : casa( '+' ); T(); printf( "+ " ); E_linha(); break;
    case '-' : casa( '-' ); T(); printf( "- " ); E_linha(); break;
  }
}

void T() {
  F();
  T_linha();
}

void T_linha() {
  switch( token ) {
    case '*' :
      casa( '*' );
      F();
      printf( "* " );
      T_linha();
      break;
    case '/' :
      casa( '/' );
      F();
      printf( "/ " );
      T_linha();
      break;
  }
}

void F() {
  string temp = lexema + " ";

  switch( token ) {
    case _ID :
      casa( _ID );

      if (token == '(') {
        casa( '(' );
        PARAMETROS();
        casa( ')' );
        printf( (temp + "# ").c_str() );
      }
      else {
        printf( (temp + "@ ").c_str() );
      }
      break;
    
    case _NUM :
      casa( _NUM );
      printf( temp.c_str() );
      break;
    
    case _STRING:
      casa( _STRING );
      printf( temp.c_str() );
      break;
    
    case '(': 
      casa( '(' );
      E();
      casa( ')' );
      break;

    default:
      printf( ("Operando esperado, encontrado " + lexema).c_str() );
  }
}

void PARAMETROS() {
  E();
  PROXIMO();
}
void PROXIMO() {
  if (token == ',') {
    casa( ',' );
    E();
    PROXIMO();
  }
  else return;
}

int next_token() {
  return yylex();
}

string nome_token( int token ) {
  if( nome_tokens.find( token ) != nome_tokens.end() )
    return nome_tokens[token];
  else {
    string r;
    
    r = token;
    return r;
  }
}

void casa( int esperado ) {
  if( token == esperado ) {
    token = next_token();
    lexema = yytext;
  } else {
    cout << "Esperado " << nome_token( esperado ) 
	   << " , encontrado: " << nome_token( token ) << endl;
    exit( 1 );
  }
}

int main() {
  token = next_token();
  lexema = yytext;
  L();

  /* if( token == 0 )
    cout << "Sintaxe ok!" << endl;
  else
    cout << "Caracteres encontrados após o final do programa" << endl; */
  
  return 0;
}
