
import haxe.io.Bytes;
import haxe.io.Output;
import sys.FileSystem;
import sys.io.File;
import Sys.println;

using haxe.io.Path;

class Run {

	static var USAGE = '  Usage : nekoboot <file.n>
  Options :
    -p <path> : Path to generated executeable
    -b <path> : Path to bootable binary source
';

	static function abort( ?info : String, code = -1 ) {
		if( info != null ) println( info );
		Sys.exit( code );
	}

	static function main() {

		var args = Sys.args();
		var isHaxelibRun = Sys.getEnv( 'HAXELIB_RUN' ) == '1';
		var file = args.shift();

		if( !file.isAbsolute() && isHaxelibRun )
			file = args.pop() + file;

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

		if( boot == null ) boot = NekoBoot.findNekoBoot();
		if( boot == null || !FileSystem.exists( boot ) )
			abort( 'Boot file not found' );

		if( path == null )
			path = file.withoutExtension();

		NekoBoot.create( File.write( path ), File.getBytes( boot ), File.getBytes( file ) );

        if( Sys.systemName() != "Windows" )
            Sys.command( "chmod", [ "755", path ] );
	}

}
