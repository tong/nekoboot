
## NekoBoot

all: build test

run.n: *.hx build.hxml
	haxe build.hxml

build: run.n

test: build
	haxe --cwd test build.hxml

nekoboot.zip: clean build
	zip -r $@ haxelib.json NekoBoot.hx README.md run.n

install: nekoboot.zip
	haxelib local nekoboot.zip

uninstall:
	haxelib remove nekoboot

clean:
	rm -f run.n
	rm -f test/app*
	rm -f nekoboot.zip

.PHONY: build test install uninstall clean
