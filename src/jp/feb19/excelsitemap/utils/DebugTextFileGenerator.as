package jp.feb19.excelsitemap.utils
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;

	public class DebugTextFileGenerator
	{
		public function DebugTextFileGenerator(text:String)
		{
			// debug
			var file:File = File.desktopDirectory.resolvePath("debug.txt");
			var stream:FileStream = new FileStream()
			stream.open(file, FileMode.WRITE);
			stream.writeUTFBytes(text);
			stream.close();
		}
	}
}