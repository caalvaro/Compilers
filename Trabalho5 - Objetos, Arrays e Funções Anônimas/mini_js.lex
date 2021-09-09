D	[0-9]
L	[A-Za-z_$]

WS          [ \t]
NUM         {D}+("."{D}+)?([Ee]("+"|"-")?{D}+)?
ID          {L}({L}|{D})*
STRING      ([\"]([^\"\n]*(\"\")*(\\\")*)*[\"])|([\']([^\'\n]*(\'\')*(\\\')*)*[\'])
ARGS        {WS}*{ID}{WS}*(","{WS}*{ID}{WS}*)*")"{WS}"=>"

%%

{WS}        { }

"\n"        { linha++; }

{NUM}       { yylval.c = novo + yytext; 
              return NUM; }

"("/{ARGS} { return ABRE_PAR_SETA; }

"true"	    { yylval.c = novo + "true"; 
              return TRUE; }

"false"	    { yylval.c = novo + "false"; 
              return FALSE; }

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

"function(" { yylval.c = novo + "function_anonima"; 
              return FUNCTION_ANON; }

"return"   { yylval.c = novo + "return"; 
              return RETURN; }

"asm{".*"}"  {  yylval.c = split( trim( yytext + 4 ) );
                return ASM; }

"=="        { yylval.c = novo + "=="; 
              return IGUAL; }

"=>"        { yylval.c = novo + "=>"; 
              return SETA; }

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
