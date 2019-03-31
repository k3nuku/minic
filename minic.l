%{
#include <stdio.h>
#include "minic.tab.h"
%}

LETTER      [a-zA-Z]
USANDLETTER [a-zA-Z_]
LETANDDIGIT [a-zA-Z0-9]

%%
(\/{2}.+)|(\/\*((.+\n.+)|.+)+\*\/) {
  /* comment 오른쪽만 멀티라인 지원 */
  printf("<COMMENTS>\t%s\n", yytext);
}

(int|double|str) {
/* type detection */
  if (strcmp(yytext, "int") == 0)
  {
    printf("<INT,>\t\t%s\n", yytext);
    return(KWTYPE_INT);
  }
  else if (strcmp(yytext, "double") == 0)
  {
    printf("<DOUBLE,>\t\t%s\n", yytext);
    return(KWTYPE_DOUBLE);
  }
  else if (strcmp(yytext, "str") == 0)
  {
    printf("<STRING,>\t\t%s\n", yytext);
    return(KWTYPE_STRING);
  }
  else printf("<UNKNOWN_TYPE,>\n");
}

"if"                    { printf("<IF,>\t\t%s\n", yytext); return(KWSTMT_IF); }
"while"                 { printf("<WHILE,>\t\t%s\n", yytext); return(KWSTMT_WHILE); }
"return"                { printf("<RETURN,>\t\t%s\n", yytext); return(KWSTMT_RETURN); }
"else"                  { printf("<ELSE,>\t\t%s\n", yytext); return(KWSTMT_ELSE); }

"print"                 { printf("<PRINT,>\t\t%s\n", yytext); return(KWFUNC_PRINT); }

"+"                     { printf("<PLUS,>\t\t%s\n", yytext); return(OP_PLUS); }
"-"                     { printf("<MINUS,>\t\t%s\n", yytext); return(OP_MINUS); }
"*"                     { printf("<MULTI,>\t\t%s\n", yytext); return(OP_MULTI); }
"/"                     { printf("<DIVIDE,>\t\t%s\n", yytext); return(OP_DIVIDE); }
"="                     { printf("<EQUALS,>\t\t%s\n", yytext); return(EQUALS); }
">"                     { printf("<LGT,>\t\t%s\n", yytext); return(LGT); }
">="                    { printf("<LEGT,>\t\t%s\n", yytext); return(LEGT); }
"<"                     { printf("<RGT,>\t\t%s\n", yytext); return(RGT); }
"<="                    { printf("<REGT>\t\t%s\n", yytext); return(REGT); }
"=="                    { printf("<EQ,>\t\t%s\n", yytext); return(EQ); }
"!="                    { printf("<NEQ,>\t\t%s\n", yytext); return(NEQ); }
","                     { printf("<COMMA,>\t\t%s\n", yytext); return(COMMA); }
"("                     { printf("<LPAREN,>\t\t%s\n", yytext); return(LPAREN); }
")"                     { printf("<RPAREN,>\t\t%s\n", yytext); return(RPAREN); }
"{"                     { printf("<LCURLY,>\t\t%s\n", yytext); return(LCURLY); }
"}"                     { printf("<RCURLY,>\t\t%s\n", yytext); return(RCURLY); }
";"                     { printf("<COLON,>\t\t%s\n", yytext); return(COLON); }

[a-zA-Z_][a-zA-Z0-9_]* {
  /* ID */
  printf("<ID, %d>\t\t%s\n", 1, yytext);
  return(ID);
}

["]([^"\\\n]|\\.|\\\n)*["] {
  /* string 역슬래시 있으면 멀티라인, 없으면 그냥 */
  printf("<STRING, %s>\t\t%s\n", yytext, yytext);
  return(STRING);
}

(-)?([0-9]+\.)[0-9]+([eE][-+][0-9]+)?|(-)?([0-9]+[eE][0-9]+) {
  /* double */
  printf("<DOUBLE, %s>\t\t%f\n", yytext, atof(yytext));
  return(DOUBLE);
}

-?[0-9]+ {
  /* integer */
  printf("<INTEGER, %s>\t\t%d\n", yytext, atoi(yytext));
  return(INTEGER);
}
%%