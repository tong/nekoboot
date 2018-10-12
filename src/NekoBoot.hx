
import haxe.io.Bytes;
import haxe.io.Output;
import sys.FileSystem;
import sys.io.File;

/**
	Haxe port of [nekoboot.neko](https://github.com/HaxeFoundation/neko/blob/master/src/tools/nekoboot.neko) for creating executables from neko bytecode.

	neko(.exe) + bytecode.n + 'NEKO' + original neko(.exe) size

**/
class NekoBoot {

	public static function create( output : Output, boot : Bytes, bytecode : Bytes ) {
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

}
