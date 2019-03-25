%{
#include <stdio.h>

#define PROGRAM       1   // func_list block

#define FUN_LIST      5   // (fun_def fun_list) | (EMPTY)
#define FUN_DEF       6   // type ID (arg_list) { decl_list stmt_list }

#define ARG_LIST      10  // arg, arg_list
#define ARG           11  // arg

#define DECL_LIST     15  // type variable
#define DECL          16  // (decl decl_list) | (EMPTY)

#define TYPE          20  // int | double | str

#define STMT_LIST     25  // stmt stmt_list | stmt
#define STMT          26  // expr | print_stmt | return_stmt | control_stmt | block
#define PRINT_STMT    27  // print(expr_list)
#define RETURN_STMT   28  // return exp
#define CONTROL_STMT  29  // if_stmt | while_stmt
#define BLOCK         30  // { stmt_list }
#define IF_STMT       31  // if (expr) stmt else stmt | if (expr) stmt
#define WHILE_STMT    32  // (EMPTY) | while (expr) stmt

#define VAR_LIST      35  // (variable, var_list) | variable
#define VARIABLE      36  // ID

#define EXPR_LIST     40  // (expr, expr_list) | expr
#define EXPR          41  // value | variable | expr [operators] expr | variable = expr ... 
#define VALUE         42  // INTEGER | DOUBLE | STRING

#define COMMENT_LINE  50  // //~~
#define COMMENT_BLOCK 51  // /* ~~ */
%}
letter      [a-zA-Z]
DIGIT       [0-9]
INTEGER     [0-9]{1,10}

COLON       \;
UNDERSCORE  \_
COMMA       \,
SLASH       \/

OP_PLUS     \+
OP_MINUS    \-
OP_STAR     \*
OP_DIVIDE   \/
OP_EQUAL    \=
OP_LGT      \>
OP_LEGT     \>=
OP_RGT      \<
OP_REGT     \<=
OP_ISEQUAL  \==
OP_NEQ      \!=

ST_SQSTART  \(
ST_SQEND    \)
ST_MQSTART  \{
ST_MQEND    \}
ST_DQUOTE   \"

KW_INT      int
KW_DOUBLE   double
KW_STRING   str
KW_IF       if
KW_WHILE    while
KW_RETURN   return
%%
({SLASH}{2}).+ {
  //printf("lex: %s >> _identifier\n", yytext);
  //strcpy(yylval.str, yytext);
  //return(_identifier);
  printf("comment\n");
}
%%
int main(void) {
  int tok;
  while ((tok = yylex()) != 0) {
    if (tok == COMMENT_LINE)
      printf("1\n");
    else printf("2\n");
  }
}