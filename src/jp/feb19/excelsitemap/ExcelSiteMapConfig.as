package jp.feb19.excelsitemap
{
	public class ExcelSiteMapConfig
	{
		public function ExcelSiteMapConfig()
		{
		}
		
		public static const DATA_START_ROW			:int	= 5;
		
		public static const BROWSE_FOR_DIRECTORY	:String = "ウェブサイトのルートフォルダを選択してください";
		public static const BROWSE_FOR_OPEN			:String = "サイトマップ形式の XLS ファイルを選択してください";
		public static const COMPLETE_UPDATE			:String = "以下の HTML に処理を行いました。\n";
		public static const COMPLETE_XLS			:String = "サイトマップ XLS を作成しました。\n※ MS Office で編集できます。\n※ Numbers や OpenOffice などでは開けないです。\n※ éとかは文字化けしちゃうっぽいです。\n";
		
		public static const SUFFIX_AND_EXTENSION	:String = "_sitemap.xls";
	}
}