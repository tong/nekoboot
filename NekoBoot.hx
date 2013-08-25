
import haxe.io.Bytes;

#if sys
import sys.FileSystem;
import sys.io.File;
#end

/**
	Haxe port of nekoboot.neko for creating executables from neko bytecode.
	Original version: https://github.com/HaxeFoundation/neko/blob/master/src/tools/nekoboot.neko
	
	neko(.exe) + bytecode.n + 'NEKO' + original neko(.exe) size 
		
*/
class NekoBoot {

	/**
		Create executable from neko bytecode
	*/
	public static inline function createExecuteable( bytecode : Bytes, path : String, ?boot : Bytes ) {
		var bootName = 'neko';
		if( Sys.systemName() == 'Windows' ) bootName += '.exe';
		if( boot == null ) {
			#if neko
			if( ( boot = findNekoBoot( bootName ) ) == null )
			#end
			throw 'Bootable executable file not found';
		}
		var size = boot.length;
		var f = File.write( path );
		f.write( boot );
		f.write( bytecode );
		f.writeString( 'NEKO' );
		f.writeByte( size & 0xFF );
		f.writeByte( ( size >> 8 ) & 0xFF );
		f.writeByte( ( size >> 16 ) & 0xFF );
		f.writeByte( ( size >> 24 ) & 0xFF );
		f.close();
		#if sys
		if( Sys.systemName() != "Windows" ) Sys.command( "chmod", [ "755", path ] ); // Set execution rights
		#end
	}

	#if sys

	public static inline function createExecuteableFromFile( bytecodeFile : String, ?path : String, ?boot : Bytes ) {
		if( path == null ) {
			var i = ( path = bytecodeFile ).indexOf('.');
			if( i != -1 ) path = path.substring( 0, i );
		}
		createExecuteable( File.getBytes( bytecodeFile ), path, boot );
	}

	#end

	#if neko

	public static function findNekoBoot( exe : String ) : Bytes {
		var b : Bytes = null;
		for( path in neko.vm.Loader.local().getPath() ) {
			var p = path + exe;
			if( !FileSystem.exists( p ) )
				continue;
			b = File.getBytes( p );
			if( b.get( 0 ) == 35 ) // '#' It's a script
				b = null;
		}
		return b;
	}

	#end

	#if nekoboot_main

	static var USAGE = '  Usage : nekoboot <file.n> 
  Options :
    -b <path> : Path to bootable binary 
';

	static function main() {
		var args = Sys.args();
		if( args.length < 1 ) {
			Sys.println( 'Missing bytecode argument' );
			Sys.println( USAGE );
			Sys.exit( 1 );
		}
		switch args[0] {
		case '-help','-h':
			Sys.println( USAGE );
			Sys.exit( 0 );
		}
		var file = args[0];
		createExecuteableFromFile( file );
	}

	#end

}
