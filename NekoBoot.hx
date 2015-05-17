
import haxe.io.Bytes;
import haxe.io.Output;
import sys.FileSystem;
import sys.io.File;
import Sys.println;

using haxe.io.Path;

/**
	Haxe port of nekoboot.neko for creating executables from neko bytecode.
	Original version: https://github.com/HaxeFoundation/neko/blob/master/src/tools/nekoboot.neko

	neko(.exe) + bytecode.n + 'NEKO' + original neko(.exe) size

*/
class NekoBoot {

	public static function write( boot : Bytes, bytecode : Bytes, output : Output ) {
		var size = boot.length;
		output.write( boot );
		output.write( bytecode );
		output.writeString( 'NEKO' );
		output.writeByte( size & 0xFF );
		output.writeByte( ( size >> 8 ) & 0xFF );
		output.writeByte( ( size >> 16 ) & 0xFF );
		output.writeByte( ( size >> 24 ) & 0xFF );
		output.close();
	}

	public static function create( boot : Bytes, bytecode : Bytes, path : String ) {
		write( boot, bytecode, File.write( path ) );
		if( Sys.systemName() != "Windows" )
			Sys.command( "chmod", [ "755", path ] ); // Set execution rights
	}

	public static function findNekoBoot() : String {
		var bootName = 'neko';
		if( Sys.systemName() == 'Windows' ) bootName += '.exe';
		for( path in neko.vm.Loader.local().getPath() ) {
			var p = path + bootName;
			if( !FileSystem.exists( p ) )
				continue;
			return p;
		}
		return null;
	}

	#if nekoboot_run

	static var USAGE = '  Usage : nekoboot <file.n>
  Options :
    -p <path> : Path to generated executeable
    -b <path> : Path to bootable binary source
';

	static inline function abort( msg : String ) {
		println( msg );
		Sys.exit(1);
	}

	static function main() {
		var args = Sys.args();
		if( args.length < 1 ) {
			println( 'Missing neko bytecode argument' );
			abort( USAGE );
		}
		var file = args.shift();
		if( !FileSystem.exists( file ) )
			abort( 'Bytecode file not found [$file]' );
		var path : String = null;
		var boot : String = null;
		var i = 0;
		while( i < args.length ) {
			var k = args[i];
			var v = args[i+1];
			if( v == null ) {
				abort( 'Missing argument' );
			}
			switch k {
			case '-p': path = v;
			case '-b': boot = v;
			}
			i += 2;
		}
		if( boot == null ) boot = findNekoBoot();
		if( boot == null || !FileSystem.exists( boot ) )
			abort( 'Boot file not found' );

		if( path == null )
			path = file.withoutExtension();
		create( File.getBytes( boot ), File.getBytes( file ), path );
	}

	#end

}
