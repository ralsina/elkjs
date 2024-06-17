bin/elkjs: src/elk.o src/elk.cr src/js.cr
	shards build 

src/elk.o: src/elk.h src/elk.c
	gcc -DJS_DUMP -c src/elk.c -o src/elk.o

lint:
	crystal tool format 
	ameba --all --fix src spec

PHONY: lint
