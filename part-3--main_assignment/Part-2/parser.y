%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "parser.tab.h"
int yylex(void);
int yyerror(char *);
void add_sym_table(char*, char*);
void func();
void func1();
double vbltable[26];
char t_type[10];
int count=0;
char temp[100];
char temp1[100];
char t_type1[100];
struct data{
    char type[10];
    char name[100];
    char id[100];
}data;

struct data sym_table[100];
%}

%union {
    char dval[100];
    char str[100];
} ;

%token <str> ID
%left LOGICOP
%left RELOP



%token INT_CONST FLOAT_CONSTANT INT FLOAT BOOLEAN SEMICOLON COMMA ASSIGN IF ELSE RELOP LOGICOP WHILE RETURN MAIN UNSIGNED_INT SHORT_INT VOID DOUBLE SWITCH CASE FOR STRUCT ENUM UNION   


%%
prog : funcDef {printf("Accepted\n");};
funcDef : type ID '(' argList ')' '{' declList stmtList '}' {printf("Function name %s\n", $2);}
argList : arg ',' arg | ;
arg : type ID;
type : INT {strcpy(t_type,"INT");}|
       FLOAT {strcpy(t_type,"FLOAT");}| 
       BOOLEAN {printf("bool is parsed\n");strcpy(t_type,"BOOLEAN");};
declList : declList decl 
        | decl;
decl : type varList SEMICOLON;
varList : ID COMMA varList {printf("var is parsed %s\n",$1);add_sym_table($1,t_type);}
        | ID {add_sym_table($1,t_type); printf("var is parsed %s\n",$1);};
stmtList : stmt stmtList 
        | stmt;
stmt : assignStmt SEMICOLON 
    | ifStmt 
    | whileStmt 
    | forStmt;
assignStmt : ID '=' EXP{strcpy(temp,$1);func();} | type ID '=' EXP {strcpy(temp,$2); func(); func1();};
EXP :EXP '+' TERM 
    | EXP '-' TERM 
    | TERM;
TERM : TERM '*' FACTOR 
    | TERM '/' FACTOR
    | FACTOR;
FACTOR : ID{
            strcpy(temp1,$1);
            
            int flag=0;
            for(int i=0;i<count;i++){
                
                if(strcmp(sym_table[i].name,$1)==0){
                     flag++; 
                }
            }
           
            if(flag==0){
                printf("\n  !!ERROR %s is not in symbol table!!\n\n",$1);
            }
        }
    | INT_CONST;
ifStmt : IF'(' bExp ')' '{' stmtList '}' elseStmt { };
elseStmt : ELSE '{' stmtList '}' 
        | ELSE ifStmt
        | ;
bExp : bExp LOGICOP bExp
      |EXP RELOP EXP ;
whileStmt : WHILE'('bExp')''{'stmtList'}' 
forStmt : FOR'(' assignStmt SEMICOLON bExp SEMICOLON assignStmt')''{'stmtList'}';
%%

int main()
{
    yyparse();
    for(int i=0;i<count;i++){
        printf("%s %s\n",sym_table[i].name,sym_table[i].id);

    }



}
int yyerror(char *s)
{
    fprintf(stderr, "An error in the parser : %s\n", s);
}
void add_sym_table(char *name, char* id)
{
    printf("Name--%s  ID--%s\n",name,id);
    strcpy(sym_table[count].name, name);
    strcpy(sym_table[count].id, id);
    
    count++;
}
void func(){
    char type[10];
    char type1[10];
    for(int i=0;i<count;i++){
        
        int a = strcmp( sym_table[i].name,temp);
        if(a==0){

           
            strcpy(type, sym_table[i].id);
            break;
        }
    }
    for(int i=0;i<count;i++){
        
        int a = strcmp( sym_table[i].name,temp1);
        if(a==0){

            
            strcpy(type1, sym_table[i].id);
            break;
        }
    }
    if(strcmp(type1,type)>0){
        printf("\n\n    !!Type Mismatch, ERROR!! \n\n");
    }
}

void func1(){
    char type[10];
    for(int i=0;i<count;i++){
        
        int a = strcmp( sym_table[i].name,temp1);
        if(a==0){

           
            strcpy(type, sym_table[i].id);
            break;
        }
    }
    if(strcmp(type, t_type)>0){
        printf("\n\n    !!Error detected type error in if else!!  \n\n");
    }
}