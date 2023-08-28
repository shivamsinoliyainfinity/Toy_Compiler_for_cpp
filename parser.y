%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "parser.tab.h"
int yylex(void);
int yyerror(char *);
void add_sym_table(char*, char*);
void func();
double vbltable[26];
char t_type[10];
int count1=2;
char temp[100];
char temp1[100];
FILE* fp ; 

struct data{
    char type[10];
    char name[100];
    char id[100];
    
}data;

struct stack{
    int arr[20];
}st;
struct store_entry{
    char var_name[100];
    char value[100];
}store_entry;

struct store_entry var_table[100];

int count=1;
struct data sym_table[100];
%}

%union {
    char dval[100];
    char str[100];
} ;

%token <str> ID 
%token <dval> INT_CONST


%type <str> FACTOR
%left LOGICOP
%left RELOP



%token FLOAT_CONSTANT INT FLOAT BOOLEAN SEMICOLON COMMA ASSIGN IF ELSE RELOP LOGICOP WHILE RETURN MAIN UNSIGNED_INT SHORT_INT VOID DOUBLE SWITCH CASE FOR STRUCT ENUM UNION   


%%
prog : funcDef {fprintf(fp,"\tret i32 %%%d\n}\n",count1-1);printf("Accepted!");};
funcDef : type ID '(' argList ')' '{' declList{fprintf(fp, "store i32 0, ptr %1, align 4\n");} stmtList '}' {printf("Function name %s\n", $2);}
argList : arg ',' arg | ;
arg : type ID;
type : INT {strcpy(t_type,"INT");}|
       FLOAT {strcpy(t_type,"FLOAT");}| 
       BOOLEAN {printf("bool is parsed\n");strcpy(t_type,"BOOLEAN");};
declList : declList decl 
        | decl;
decl : type varList SEMICOLON;
varList : ID COMMA varList {printf("var is parsed %s\n",$1);add_sym_table($1,t_type);fprintf(fp,"%%%d = alloca i32, align 4\n",count1);count1++;}
        | ID {add_sym_table($1,t_type); printf("var is parsed %s\n",$1);fprintf(fp,"%%%d = alloca i32, align 4\n",count1);count1++;};
stmtList : stmt stmtList 
        | stmt;
stmt : assignStmt SEMICOLON 
    | ifStmt 
    | whileStmt 
    | forStmt;
assignStmt : ID '=' EXP{strcpy(temp,$1);func();} | type ID '=' EXP ;
EXP :EXP '+' TERM 
    | EXP '-' TERM
    | TERM;
TERM : TERM '*' FACTOR 
    | TERM '/' FACTOR
    | FACTOR;
FACTOR : ID{
            fprintf(fp,"%%%d = load i32, ptr %%%d, align 4\n",count1 -2,count1-4);
            count1++;
            strcpy(temp1,$1);
            
            int flag=0;
            for(int i=0;i<count;i++){
                
                if(strcmp(sym_table[i].name,$1)==0){
                     flag++; 
                }
            }
            printf("%d\n",flag);
            if(flag==0){
                printf("\n !!ERROR %s is not in symbol table!!\n",$1);
            }
        }
    | INT_CONST{
        
        if(count1==8){
            fprintf(fp,"%d:\n",count1-1);
            fprintf(fp,"\tstore i32 %s, ptr %%%d, align 4\n",$1,count1-6);
            fprintf(fp,"\tbr label %%%d\n",count1);
             count1++;
        }else if(count1==9){
            fprintf(fp,"%d:\n",count1-1);
            fprintf(fp,"\tstore i32 %s, ptr %%%d, align 4\n",$1,count1-6);
            fprintf(fp,"\t%%%d = load i32, ptr %%%d, align 4\n",count1,count1-8);
            count1++;
        }else{
            fprintf(fp,"store i32 %s, ptr %%%d, align 4\n",$1,count1-2);

            count1++;
        }
        };
ifStmt : IF'(' bExp ')' '{' {/* if block start*/} stmtList '}' elseStmt { };
elseStmt : ELSE '{' {/* else block start*/} stmtList '}' 
        | ELSE ifStmt
        | ;
bExp : bExp LOGICOP bExp { /*br to if or else*/ }
      |EXP RELOP EXP{fprintf(fp,"%%%d = icmp sgt i32 %%%d, %%%d\n",count1-2, count1-4, count1-3);
                    fprintf(fp,"br i1 %%%d, label %%%d , label %%%d\n\n\n",count1-2,count1-1,count1);} ;
whileStmt : WHILE'('bExp')''{'stmtList'}' 
forStmt : FOR'(' assignStmt SEMICOLON bExp SEMICOLON assignStmt')''{'stmtList'}';
%%

int main()
{
    
    fp =  fopen("output1.ll", "w");
    fprintf(fp,"; ModuleID = \'test1.c\'\nsource_filename = \"test1.c\"\ntarget datalayout = \"e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128\"\ntarget triple = \"x86_64-pc-linux-gnu\"\n\n; Function Attrs: noinline nounwind optnone uwtable\ndefine dso_local i32 @main() #0 {\n");
    fprintf(fp,"%%1 = alloca i32, align 4\n");
    
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
        printf("\n\n!!Type Mismatch, ERROR!!\n\n");
    }
}