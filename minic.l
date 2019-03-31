%{
#include <stdio.h>
#include "minic.tab.h"
%}

LETTER      [a-zA-Z]
DIGIT       [0-9]
USANDLETTER [a-zA-Z_]
LETANDDIGIT [a-zA-Z0-9]

%%
(\/{2}.+)|(\/\*.+\*\/) {
  /* comment: line */
  printf("comment\n");
}

(int|double|str) {
/* type detection */
  if (strcmp(yytext, "int") == 0)
  {
    printf("<INT,>\t%s\n", yytext);
    return(KWTYPE_INT);
  }
  else if (strcmp(yytext, "double") == 0)
  {
    printf("<DOUBLE,>\t%s\n", yytext);
    return(KWTYPE_DOUBLE);
  }
  else if (strcmp(yytext, "str") == 0)
  {
    printf("<STRING,>\t%s\n", yytext);
    return(KWTYPE_STRING);
  }
  else printf("<UNKNOWN_TYPE,>\n");
}

"if"                    { printf("<IF,>\t%s\n", yytext); return(KWSTMT_IF); }
"while"                 { printf("<WHILE,>\t%s\n", yytext); return(KWSTMT_WHILE); }
"return"                { printf("<RETURN,>\t%s\n", yytext); return(KWSTMT_RETURN); }
"else"                  { printf("<ELSE,>\t%s\n", yytext); return(KWSTMT_ELSE); }

"print"                 { printf("<PRINT,>\t%s\n", yytext); return(KWFUNC_PRINT); }

"+"                     { printf("<PLUS,>\t%s\n", yytext); return(OP_PLUS); }
"-"                     { printf("<MINUS,>\t%s\n", yytext); return(OP_MINUS); }
"*"                     { printf("<MULTI,>\t%s\n", yytext); return(OP_MULTI); }
"/"                     { printf("<DIVIDE,>\t%s\n", yytext); return(OP_DIVIDE); }
"="                     { printf("<EQUALS,>\t%s\n", yytext); return(EQUALS); }
">"                     { printf("<LGT,>\t%s\n", yytext); return(LGT); }
">="                    { printf("<LEGT,>\t%s\n", yytext); return(LEGT); }
"<"                     { printf("<RGT,>\t%s\n", yytext); return(RGT); }
"<="                    { printf("<REGT>\t%s\n", yytext); return(REGT); }
"=="                    { printf("<EQ,>\t%s\n", yytext); return(EQ); }
"!="                    { printf("<NEQ,>\t%s\n", yytext); return(NEQ); }
","                     { printf("<COMMA,>\t%s\n", yytext); return(COMMA); }
"("                     { printf("<LPAREN,>\t%s\n", yytext); return(LPAREN); }
")"                     { printf("<RPAREN,>\t%s\n", yytext); return(RPAREN); }
"{"                     { printf("<LCURLY,>\t%s\n", yytext); return(LCURLY); }
"}"                     { printf("<RCURLY,>\t%s\n", yytext); return(RCURLY); }
";"                     { printf("<COLON,>\t%s\n", yytext); return(COLON); }

({USANDLETTER}{LETANDDIGIT}*)|{LETTER} {
  /* ID */
  printf("<ID, %d>\t%s\n", 1, yytext);
  return(ID);
}

\".+\" {
  /* string */
  printf("value[string]:\t%s\n", yytext);
  return(STRING);
}

{DIGIT}+ {
  /* integer */
  printf("value[integer]:\t%d\n", atoi(yytext));
  return(INTEGER);
}
%%