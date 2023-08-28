%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "parser_1.tab.h"


%}

%%

[ \t]+ ;
"{"    { printf("Detected %s\n", yytext); return yytext[0]; }
"}"    { printf("Detected %s\n", yytext); return yytext[0];}
"("    { printf("Detected %s\n", yytext); return yytext[0];}
")"    { printf("Detected %s\n", yytext); return yytext[0];}
"int"  { printf("Detected %s\n", yytext); return INT_CONST; }
[A-Za-z0-9]* { printf("Detected %s\n", yytext); return ID; }
\n         { printf("Inside newline\n"); }
.          { return yytext[0];}
%%
