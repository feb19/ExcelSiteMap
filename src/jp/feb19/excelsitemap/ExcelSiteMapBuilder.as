package jp.feb19.excelsitemap
{
	import com.as3xls.xls.ExcelFile;
	import com.as3xls.xls.Sheet;
	
	import flash.utils.ByteArray;

	public class ExcelSiteMapBuilder
	{
		private var _fileList:Vector.<WebSiteData>;
		private var _webSiteName:String;
		public function ExcelSiteMapBuilder(webSiteName:String, fileList:Vector.<WebSiteData>)
		{
			_webSiteName = webSiteName;
			_fileList = fileList;
		}
		
		public function createExcelBinary():ByteArray
		{
			if (!_fileList)
				return new ByteArray();
			
			const START_ROW:int = ExcelSiteMapConfig.DATA_START_ROW;
			
			var fileList:Vector.<WebSiteData> = _fileList,
				sheet:Sheet = new Sheet();
				sheet.resize(fileList.length + START_ROW, 12);
			
			// set title
			sheet.setCell(0,0,"Sitemap");
			sheet.setCell(0,1,_webSiteName);
			
			// set time stamp
			var d:Date = new Date(),
				dateString:String = d.fullYear + "/" + (d.month+1) + "/" + d.date + " " + d.hours + ":" + d.minutes + ":" + d.seconds; 
			sheet.setCell(1,0,"Date");
			sheet.setCell(1,1,dateString);
			
			// set table column labels
			sheet.setCell(4, 0, "id");
			sheet.setCell(4, 1, "name");
			sheet.setCell(4, 2, "path");
			sheet.setCell(4, 3, "title");
			sheet.setCell(4, 4, "keywords");
			sheet.setCell(4, 5, "description");
			sheet.setCell(4, 6, "og:title");
			sheet.setCell(4, 7, "og:site_name");
			sheet.setCell(4, 8, "og:url");
			sheet.setCell(4, 9, "og:type");
			sheet.setCell(4,10, "og:image");
			sheet.setCell(4,11, "og:description");
			sheet.setCell(4,12, "fb:app_id");
			
			// set data
			for (var i:int, l:uint = fileList.length; i < l; i++) {
				var f:WebSiteData = fileList[i];
				sheet.setCell(i + START_ROW,  0, i.toString());
				sheet.setCell(i + START_ROW,  1, f.name);
				sheet.setCell(i + START_ROW,  2, f.relativePath);
				sheet.setCell(i + START_ROW,  3, f.title);
				sheet.setCell(i + START_ROW,  4, f.keywords);
				sheet.setCell(i + START_ROW,  5, f.description);
				sheet.setCell(i + START_ROW,  6, f.og_title);
				sheet.setCell(i + START_ROW,  7, f.og_site_name);
				sheet.setCell(i + START_ROW,  8, f.og_url);
				sheet.setCell(i + START_ROW,  9, f.og_type);
				sheet.setCell(i + START_ROW, 10, f.og_image);
				sheet.setCell(i + START_ROW, 11, f.og_description);
				sheet.setCell(i + START_ROW, 12, f.fb_app_id);
			}
			
			// create excel binary
			var xls:ExcelFile = new ExcelFile();
				xls.sheets.addItem(sheet);
			var bytes:ByteArray= xls.saveToByteArray();
			
			return bytes;
		}
	}
}