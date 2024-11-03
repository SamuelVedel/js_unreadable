all		:	lex.yy.c y.tab.c a.out
lex.yy.c	:	js_unreadable.l 
			flex js_unreadable.l
y.tab.c		:	js_unreadable.y lex.yy.c
			bison -y -v js_unreadable.y -Wcounterexamples --debug
a.out		:	y.tab.c
			cc y.tab.c -L$(HOME)/.local/lib/ -ll -o js_unreadable -g -O0
clean		:	
			rm -f 	lex.yy.c y.tab.c js_unreadable *~ y.output
