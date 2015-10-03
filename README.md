
# Nekoboot [![Build Status](https://travis-ci.org/tong/nekoboot.svg?branch=master)](https://travis-ci.org/tong/nekoboot)

Tool to create executables from neko bytecode | Haxe port of [nekoboot.neko](https://github.com/HaxeFoundation/neko/blob/master/src/tools/nekoboot.neko).

Nekoboot merges the [neko-vm](http://nekovm.org/) and your application bytecode (.n) into a single executeable file.  
`neko(.exe) + bytecode.n + 'NEKO' + original neko(.exe) size`

---

#### Install

To install from haxelib run:
```shell
$ haxelib install nekoboot
```

---

#### Usage

```shell
Usage : nekoboot <file.n>
  Options :
    -p <path> : Path to generated executeable
    -b <path> : Path to bootable binary
```
