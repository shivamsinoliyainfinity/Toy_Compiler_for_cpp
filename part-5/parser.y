%{
#include <stdio.h>
#include <stdlib.h>
#include "parser.tab.h"
int yylex(void);
int yyerror(char *);
%}


%token a 
%%
S : S A 
  | A
  |  

A : a

%%

int main()
{
    yyparse();
}