/* Coloque aqui definições regulares */

D	[0-9]
L	[A-Za-z_$]

WS	         [ \t\n]
INT	         {D}+
FLOAT	     {INT}("."{INT})?([Ee]("+"|"-")?{INT})?
ID           {L}({L}|{D})*
IF           [Ii][Ff]
FOR          [Ff][Oo][Rr]
STRING       ([\"]([^\"\n]*(\"\")*(\\\")*)*[\"])
COMENTARIO   ("//"([^\n])*)|(([\/][\*](([\*][^\/])|([\/][^\/])|[^\/])*"*/"))


%%
    /* Padrões e ações. Nesta seção, comentários devem ter um tab antes */

{WS}	    { /* ignora espaços, tabs e '\n' */ }
{IF}	    { return _IF; }
{INT}	    { return _INT; }
{FLOAT}	    { return _FLOAT; }

">="            { return _MAIG; }
"<="	        { return _MEIG; }
"=="	        { return _IG; }
"!="    	    { return _DIF; }
{COMENTARIO}    { return _COMENTARIO; }
{STRING}        { return _STRING; }

{ID}            { return _ID; }

.       { return *yytext; 
          /* Essa deve ser a última regra. Dessa forma qualquer caractere isolado será retornado pelo seu código ascii. */ }

%%

/* Não coloque nada aqui - a função main é automaticamente incluída na hora de avaliar e dar a nota. */