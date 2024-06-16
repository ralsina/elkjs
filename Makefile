bin/elkjs: src/elk.o src/elkjs.cr
	shards build

src/elk.o: src/elk.h src/elk.c
	gcc -DJS_DUMP -c src/elk.c -o src/elk.o

lint:
	crystal tool format --check
	ameba --all --fix src spec

PHONY: lint