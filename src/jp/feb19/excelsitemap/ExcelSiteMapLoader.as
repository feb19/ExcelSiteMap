package jp.feb19.excelsitemap
{
	import com.as3xls.xls.ExcelFile;
	import com.as3xls.xls.Sheet;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	import flash.net.FileFilter;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;

	public class ExcelSiteMapLoader extends EventDispatcher
	{
		private var _fileList:Vector.<WebSiteData>;
		
		public function ExcelSiteMapLoader()
		{
			_fileList = new Vector.<WebSiteData>();
		}
		
		public function get fileList():Vector.<WebSiteData>
		{
			return _fileList;
		}

		public function openLoadSitemapXLSDialog():void
		{
			var file:File = new File();
				file.addEventListener(Event.SELECT, _fileSelectedHandler);
				file.browseForOpen(ExcelSiteMapConfig.BROWSE_FOR_OPEN,
					[new FileFilter("XLS Sitemap File", "*.xls")]);
		}
		
		protected function _fileSelectedHandler(event:Event):void
		{
			var file:File = File(event.target);
			var urlLoader:URLLoader = new URLLoader();
				urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
				urlLoader.addEventListener(Event.COMPLETE, _loadCompleteHandler);
				urlLoader.load(new URLRequest(file.url));
		}
		
		private function _loadCompleteHandler(event:Event):void
		{ 
			var data:ByteArray = URLLoader(event.target).data,
				sheetData:Vector.<WebSiteData> = new Vector.<WebSiteData>();
			
			try {
				var excel:ExcelFile = new ExcelFile();
					excel.loadFromByteArray(data);
				var sheet:Sheet = Sheet(excel.sheets[0]),
					l:uint = sheet.rows;
				
				for (var i:int = ExcelSiteMapConfig.DATA_START_ROW; i < l; i++)
				{
					var websiteData:WebSiteData		= new WebSiteData();
						websiteData.id				= sheet.getCell(i, 0).value;
						websiteData.name			= sheet.getCell(i, 1).value;
						websiteData.relativePath	= sheet.getCell(i, 2).value;
						websiteData.title			= sheet.getCell(i, 3).value;
						websiteData.keywords		= sheet.getCell(i, 4).value;
						websiteData.description		= sheet.getCell(i, 5).value;
						websiteData.og_title		= sheet.getCell(i, 6).value;
						websiteData.og_site_name	= sheet.getCell(i, 7).value;
						websiteData.og_url			= sheet.getCell(i, 8).value;
						websiteData.og_type			= sheet.getCell(i, 9).value;
						websiteData.og_image		= sheet.getCell(i, 10).value;
						websiteData.og_description	= sheet.getCell(i, 11).value;
						websiteData.fb_app_id		= sheet.getCell(i, 12).value;
					
					sheetData.push(websiteData);
				}
			} catch(error:Error) {
				trace(error.message);
			}
			_fileList = sheetData;
			
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
	}
}