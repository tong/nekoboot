
## NekoBoot

all: build test

run.n: src/*.hx run.hxml
	haxe run.hxml

build: run.n

test: build
	haxe --cwd test build.hxml

nekoboot.zip: clean build
	zip -r $@ src/ haxelib.json README.md run.n

install: nekoboot.zip
	haxelib local nekoboot.zip

uninstall:
	haxelib remove nekoboot

clean:
	rm -f run.n
	rm -f test/app*
	rm -f nekoboot
	rm -f nekoboot.zip

.PHONY: build test install uninstall clean
