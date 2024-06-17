all: bin/elkjs

clean:
	rm -rf bin/elkjs src/elk.o lib/
	crystal clear_cache

test:
	crystal spec

bin/elkjs: src/elk.o src/elk.cr src/js.cr examples/main.cr
	shards build

src/elk.o: src/elk.h src/elk.c
	gcc -DJS_DUMP -c src/elk.c -o src/elk.o

lint:
	crystal tool format
	ameba --all --fix src spec

.PHONY: all clean test lint
