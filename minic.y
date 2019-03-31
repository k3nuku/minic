%error-verbose
%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
//#include "symtab.h"

extern FILE *yyin;
extern FILE *yyout;
extern char *yytext;
extern int yyparse();

int yylex();
int yyerror(const char*);
%}
%token INTEGER DOUBLE STRING
%token ID

%token OP_PLUS OP_MINUS OP_MULTI OP_DIVIDE
%token EQUALS

%token LGT LEGT RGT REGT EQ NEQ
%token LPAREN RPAREN LCURLY RCURLY COMMA COLON

%token KWTYPE_INT KWTYPE_DOUBLE KWTYPE_STRING
%token KWSTMT_IF KWSTMT_ELSE KWSTMT_WHILE KWSTMT_RETURN
%token KWFUNC_PRINT
%%
program       : fun_list /* block should not be appeared that fun_def already has, it can be error. */
              ;

fun_list      : fun_def fun_list
              | /* epsilon */
              ;

fun_def       : type ID LPAREN arg_list RPAREN LCURLY decl_list stmt_list RCURLY
              ;

arg_list      : arg COMMA arg_list
              | arg
              ;

arg           : type variable
              ;

decl_list     : decl decl_list
              | /* epsilon */
              ;

decl          : type var_list COLON
              ;

type          : KWTYPE_INT
              | KWTYPE_DOUBLE
              | KWTYPE_STRING
              ;

stmt_list     : stmt stmt_list
              | stmt
              ;

stmt          : expr COLON
              | print_stmt COLON
              | return_stmt COLON
              | control_stmt
              | block;

print_stmt    : KWFUNC_PRINT LPAREN expr_list RPAREN
              ;

return_stmt   : KWSTMT_RETURN expr
              ;

control_stmt  : if_stmt
              | while_stmt
              ;

if_stmt       : KWSTMT_IF LPAREN expr RPAREN stmt KWSTMT_ELSE stmt
              | KWSTMT_IF LPAREN expr RPAREN stmt
              ;

while_stmt    : KWSTMT_WHILE LPAREN expr RPAREN stmt
              | /* epsilon */
              ;

block         : LCURLY stmt_list RCURLY
              ;

var_list      : variable COMMA var_list
              | variable
              ;

expr          : value
              | variable
              | variable EQUALS expr
              | expr OP_PLUS expr
              | expr OP_MINUS expr
              | expr OP_MULTI expr
              | expr OP_DIVIDE expr
              | expr LGT expr
              | expr LEGT expr
              | expr RGT expr
              | expr REGT expr
              | expr EQ expr
              | expr NEQ expr
              | OP_MINUS expr
              | LPAREN expr RPAREN
              | ID LPAREN expr_list RPAREN
              ;

expr_list     : expr COMMA expr_list
              | expr
              ;

value         : INTEGER
              | DOUBLE
              | STRING
              ;

variable      : ID
              ;
%%
int errcnt = 0;
char errmsg[40];

int main(int argc, char *argv[])
{
   strcpy(errmsg, "Type error\n"); // defining error message into buffer

   int i, flag;

   if (argc < 2) {
      printf("Usage: ./minic source.c\n");
      exit(0);
   }

   FILE *fp = fopen(argv[1], "r");
  
   if (!fp) {
     printf("Error occured while opening file to parse\n");
     exit(0);
   }

   yyin = fp;

   //fp = fopen("minic_parsed.sbt","w");
   
   //if (!fp) {
   //  printf("Error occured while opening file to save symbol table\n");
   //  exit(0);
   //}

   printf("TOKEN\t\t\tLEXEME\n");
   printf("----------------------------\n");
   flag = yyparse();
   // dumpTable(fp);

   // lineno--;

   // printf("\n%d of semantic errors\tlines of code: %d\n", errcnt, lineno);

   // fclose(fp);
   fclose(yyin);

   return flag;
}

int yyerror(const char* msg)
{
  fprintf(stderr, "%s\n", msg/*, lineno*/);
  return 0;
}