%{
#include <stdio.h>

#define MAX_ARSIZE 100

char symtab[MAX_ARSIZE][MAX_ARSIZE];
char stringtab[MAX_ARSIZE][MAX_ARSIZE];

int symbol_seq = 0;
int string_seq = 0;

int table_lookup(char *value, char arr[MAX_ARSIZE][MAX_ARSIZE], int *seq) {
  int i = 1;

  while (i < *seq) {
    if (strncmp(arr[i], value, 16) == 0)
      return i;

    i++;
  }

  return 0;
}

int table_insert(char *value, char arr[MAX_ARSIZE][MAX_ARSIZE], int *seq) {
  int found = 0;

  if ((found = table_lookup(value, arr, seq)) == 0) {
    strcpy(arr[*seq], value);
    return ++(*seq);
  }

  return found;
}
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
   
  }
  else if (strcmp(yytext, "double") == 0)
  {
    printf("<DOUBLE,>\t\t%s\n", yytext);
   
  }
  else if (strcmp(yytext, "str") == 0)
  {
    printf("<STRING,>\t\t%s\n", yytext);
   
  }
  else printf("<UNKNOWN_TYPE,>\n");
}

"if"                    { printf("<IF,>\t\t%s\n", yytext); }
"while"                 { printf("<WHILE,>\t\t%s\n", yytext); }
"return"                { printf("<RETURN,>\t\t%s\n", yytext); }
"else"                  { printf("<ELSE,>\t\t%s\n", yytext); }

"print"                 { printf("<PRINT,>\t\t%s\n", yytext); }

"+"                     { printf("<OP_PLUS,>\t\t%s\n", yytext); }
"-"                     { printf("<OP_MINUS,>\t\t%s\n", yytext); }
"*"                     { printf("<OP_MULTI,>\t\t%s\n", yytext); }
"/"                     { printf("<OP_DIVIDE,>\t\t%s\n", yytext); }
"="                     { printf("<OP_EQUALS,>\t\t%s\n", yytext); }
">"                     { printf("<OP_LGT,>\t\t%s\n", yytext); }
">="                    { printf("<OP_LEGT,>\t\t%s\n", yytext); }
"<"                     { printf("<OP_RGT,>\t\t%s\n", yytext); }
"<="                    { printf("<OP_REGT>\t\t%s\n", yytext); }
"=="                    { printf("<OP_EQ,>\t\t%s\n", yytext); }
"!="                    { printf("<OP_NEQ,>\t\t%s\n", yytext); }
","                     { printf("<COMMA,>\t\t%s\n", yytext); }
"("                     { printf("<LPAREN,>\t\t%s\n", yytext); }
")"                     { printf("<RPAREN,>\t\t%s\n", yytext); }
"{"                     { printf("<LCURLY,>\t\t%s\n", yytext); }
"}"                     { printf("<RCURLY,>\t\t%s\n", yytext); }
";"                     { printf("<COLON,>\t\t%s\n", yytext); }
"\""                    { printf("<DQUOTE,>\t\t%s\n", yytext);}

"\n"                    { /* ignoring newline */ }
" "                     { /* ignoring whitespaces */ }
"\t"                    { /* ignoring tabs */ }

\"((.+)|(.+\\\n.+)?)\" {
  /* string 역슬래시 있으면 멀티라인, 없으면 그냥 */
  printf("<STRING, %s>\t\t%s\n", yytext, yytext);
  table_insert(yytext, stringtab, &string_seq);
}

(-)?([0-9]+\.)[0-9]+([eE][-+][0-9]+)?|(-)?([0-9]+[eE][0-9]+) {
  /* double */
  printf("<DOUBLE, %s>\t\t%s\n", yytext, yytext);
}

^([+-]?(0|[1-9][0-9]*)) {
  /* integer */
  printf("<INTEGER, %s>\t\t%s\n", yytext, &yytext[(int)strlen(yytext) < 10 ? 0 : (int)strlen(yytext) - 10]);
}

(\_)*[A-Za-z][a-zA-Z0-9_]* {
  /* ID */
  int seq = table_insert(yytext, symtab, &symbol_seq);
  printf("<ID, %d>\t\t%s\n", seq, yytext);
}

. {
  printf("<ERROR,>\t\t%s\n", yytext);
}
%%
int main(int argc, char **argv) {
  int flag;

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

  printf("TOKEN\t\t\tLEXEME\n");
  printf("----------------------------\n");
  flag = yylex();

  fclose(yyin);

  printf("\nINDEX\t\tSYMBOL\n--------------------------\n");

  for (int i = 0; i < symbol_seq; i++) {
    printf("%d\t\t%s\n", i, symtab[i]);
  }

  printf("\nINDEX\t\tSTRING\n--------------------------\n");
  for (int j = 0; j < string_seq; j++) {
    printf("%d\t\t%s\n", j, stringtab[j]);
  }

  return flag;
}