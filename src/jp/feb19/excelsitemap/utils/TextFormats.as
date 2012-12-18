package jp.feb19.excelsitemap.utils
{
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	public class TextFormats
	{
		public function TextFormats()
		{
		}
		
		public static function normalCentered():TextFormat
		{
			var tfm:TextFormat = new TextFormat();
				tfm.align = TextFormatAlign.CENTER;
				tfm.size = 12;
				tfm.bold = true;
				tfm.font = "_sans";
			return tfm;
		}
		
		public static function normal():TextFormat
		{
			var tfm:TextFormat = new TextFormat();
				tfm.align = TextFormatAlign.LEFT;
				tfm.size = 12;
				tfm.bold = true;
				tfm.font = "_sans";
			return tfm;
		}
	}
}