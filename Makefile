minic: minic.l minic.y
	bison -d minic.y
	flex minic.l
	gcc -o $@ minic.tab.c lex.yy.c -ly -ll
	rm -rf minic.tab.c minic.tab.h lex.yy.c

test_spec1_sample1: minic.l minic.y
	bison -vd minic.y
	flex minic.l
	gcc -o $@ minic.tab.c lex.yy.c -ly -ll
	./$@ ./unit_test/sample1.c

test_spec1_sample2: minic.l minic.y
	bison -vd minic.y
	flex minic.l
	gcc -o $@ minic.tab.c lex.yy.c -ly -ll
	./$@ ./unit_test/sample2.c

test_spec1_sample3: minic.l minic.y
	bison -vd minic.y
	flex minic.l
	gcc -o $@ minic.tab.c lex.yy.c -ly -ll
	./$@ ./unit_test/sample3.c

unit_test_symtab: symtab.c unit_test/symboltable_test.c
	gcc -o $@ symtab.c unit_test/symboltable_test.c
	./$@

.PHONY: clean 
clean:
	rm -rf *.tab.c *.tab.h *.yy.c *.output test_* minic
