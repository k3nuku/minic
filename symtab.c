#include "symtab.h"
#include <string.h>

symbol_t *symbol_table;

void initTable(int size) {
  symbol_table = (symbol_t*)malloc(sizeof(symbol_t) * 100);
  symbol_table->ll = (llhead_t*)malloc(sizeof(llhead_t));
  symbol_table->ll->head = NULL;
  symbol_table->ll->next = NULL;
  symbol_table->type = -1; // type -1 == 테이블에 아무 element도 없음
}

int dumpTable() {
  return -1;
}

int disposeTable() {
  return -1;
}

int insert_id(char* id) {

}

int insert_value(void* value) {
  symbol_t sym = lookup_wait();
}

int insert_all(char* id, void* value) {
  if (!lookup(id))
    return 0;



  return 1;
}

int lookup(char* id) {
  return -1;
}

int lookup_wait() {
  return -1;
}
