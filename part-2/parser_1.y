%{
#include <stdio.h>
#include "parser_1.tab.h"
int yylex(void);
int yyerror(char *);
%}
%token ID INT_CONST 
%%
prog : funcDef { printf("Accepted\n"); }
funcDef : INT_CONST ID '(' argList ')' '{' declList '}'
argList : arg ',' arg | ;
arg : INT_CONST ID;
declList :  ;
%%

int main()
{
    yyparse();
}
int yyerror(char *s)
{
    fprintf(stderr, "An error in the parser : %s\n", s);
}
