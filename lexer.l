%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "parser.tab.h"


%}
digit [0-9]
minus [-]
letter [a-zA-Z]
letter_or_digit {digit}|{letter}
us     [_]
underscore_or_letter {us}|{letter}
underscore_letter_digit {us}|{letter}|{digit}

%%
[ \t]+                         {printf("White space is ignored\n"); }
"\n"                           {printf("A newline is detected\n"); }          

"if"                           {printf("IF statement detected\n");return IF;}

"else"                         {printf("ELSE statement detected.\n"); return ELSE;}
"for"                          {printf("FOR Loop detected.\n");return FOR;} 
"while"                        {printf("while Loop detected.\n");return WHILE;} 

"int"                          {printf("int is detected\n");return INT;}
"float"                        {printf("float is detected\n");return FLOAT;}
"boolean"                      {printf("boolean is detected\n");return BOOLEAN;}

";"                            {printf("SEMICOLON is detected\n");return SEMICOLON;}
","                            {printf("COMMA is detected\n");return COMMA;}
[0-9]+                         {printf("An INT_CONST %s is detected.\n", yytext);strcpy(yylval.dval,yytext) ;return INT_CONST; }
[A-Za-z0-9]+                   {printf("An identifier %s is detected.\n", yytext); strcpy(yylval.str,yytext);return ID;}
">"|"<"|">="|"<="|"=="|"!="    {printf("Relational operator %s is detected\n",yytext);return RELOP;}
"&&"|"||"|"!"                  {printf("Logical operator %s is detected.\n",yytext);return LOGICOP;}
.                              {printf("Other character %s is detected.\n", yytext); return yytext[0];}

%%

