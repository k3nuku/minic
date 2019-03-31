#include <stdio.h>
#include <stdlib.h>

#define MAX_ELEMENTS 100

struct singlyll {
  symbol_t *head;
  symbol_t *next;
} llhead_t;

struct symbol {
  llhead_t *ll;

  char* id;
  int type;
  void* value;
} symbol_t;

void initTable(int size);
int disposeTable();
int dumpTable();

int insert(char* id, void* value);
int lookup(char* id);
