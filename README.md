
# Nekoboot [![Build Status](https://travis-ci.org/tong/nekoboot.svg?branch=master)](https://travis-ci.org/tong/nekoboot) [![Haxelib Version](https://img.shields.io/github/tag/tong/nekoboot.svg?style=flat&label=haxelib)](http://lib.haxe.org/p/nekoboot)

Tool to create executables from neko bytecode; haxe port of [nekoboot.neko](https://github.com/HaxeFoundation/neko/blob/master/src/tools/nekoboot.neko).

Nekoboot merges the [neko-vm](http://nekovm.org/) and your application bytecode (.n) into a single executeable file:  
`neko(.exe) + bytecode.n + 'NEKO' + original neko(.exe) size`


#### Usage

```shell
Usage : nekoboot <file.n>
  Options :
    -p <path> : Path to generated executeable
    -b <path> : Path to bootable binary
```
