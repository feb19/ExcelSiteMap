package jp.feb19.excelsitemap
{
	import com.web2memo.text.Jcode;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;

	public class HTMLFile
	{
		private var _file:File;
		private var _html:String;
		private var _encode:String;
		
		public function HTMLFile(file:File)
		{
			_file = file;
			
			var jcode:Jcode = Jcode.getInstance(),
				html:String = "";
			
			var fileStream:FileStream = new FileStream();
			fileStream.open(_file, FileMode.READ);
			var bytes:ByteArray = new ByteArray();
			fileStream.readBytes(bytes, 0, fileStream.bytesAvailable);
			
			
			var encode:String = jcode.detectEncode(bytes);
			if (encode === "Shift_JIS") {
				html = jcode.SJIStoUTF8(bytes);
			} else if (encode === "EUC") {
				html = jcode.EUCtoUTF8(bytes);
			} else {
				html = bytes.readUTFBytes(bytes.length);
			}
			fileStream.close();
			
			_html = html;
			_encode = encode;
		}
		
		public function get encode():String
		{
			return _encode;
		}

		public function get html():String
		{
			return _html;
		}

		public static function ifHTMLFile(file:File):Boolean
		{
			return file.extension === "html" || file.extension === "htm";
		}
	}
}