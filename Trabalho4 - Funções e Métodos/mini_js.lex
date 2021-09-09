D	[0-9]
L	[A-Za-z_$]

WS          [ \t]
NUM         {D}+("."{D}+)?([Ee]("+"|"-")?{D}+)?
NUM_NEG     ("-"){D}+("."{D}+)?([Ee]("+"|"-")?{D}+)?
ID          {L}({L}|{D})*
STRING      ([\"]([^\"\n]*(\"\")*(\\\")*)*[\"])|([\']([^\'\n]*(\'\')*(\\\')*)*[\'])

%%

{WS}        { }

"\n"        { linha++; }

{NUM_NEG}   { yylval.c = novo + (yytext + 1); 
              return NUM_NEG; }

{NUM}       { yylval.c = novo + yytext; 
              return NUM; }

"let"	    { yylval.c = novo + "let"; 
              return LET; }

"if"        { yylval.c = novo + "if"; 
              return IF; }
              
"else"      { yylval.c = novo + "else"; 
              return ELSE; }

"while"    { yylval.c = novo + "while"; 
              return WHILE; }

"for"      { yylval.c = novo + "for"; 
              return FOR; }

"function" { yylval.c = novo + "function"; 
              return FUNCTION; }

"return"   { yylval.c = novo + "return"; 
              return RETURN; }

"asm{".*"}"  {  yylval.c = split( trim( yytext + 4 ) );
                return ASM; }

"=="        { yylval.c = novo + "=="; 
              return IGUAL; }

"<="        { yylval.c = novo + "<="; 
              return MENOR_IGUAL; }

">="        { yylval.c = novo + "<="; 
              return MAIOR_IGUAL; }

{STRING}    { yylval.c = novo + yytext; 
              return STRING; }

{ID}        { yylval.c = novo + yytext; 
              return ID; }

.           { yylval.c = novo + yytext;
	          return *yytext; }

%%
