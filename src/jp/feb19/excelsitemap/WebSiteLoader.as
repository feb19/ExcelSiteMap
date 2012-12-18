package jp.feb19.excelsitemap
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	
	public class WebSiteLoader extends EventDispatcher
	{
		private var _fileList:Vector.<WebSiteData>;
		private var _basePath:String;
		private var _baseDirectoryName:String;
		
		public function WebSiteLoader()
		{
			super();
			_fileList = new Vector.<WebSiteData>();
			_basePath = "";
			_baseDirectoryName = "";
		}
		
		public function get fileList():Vector.<WebSiteData>
		{
			return _fileList;
		}

		public function get basePath():String
		{
			return _basePath;
		}

		public function get baseDirectoryName():String
		{
			return _baseDirectoryName;
		}

		public function openLoadDialog():void
		{
			var file:File = new File();
				file.addEventListener(Event.SELECT, _fileSelectedHandler);
				file.browseForDirectory(ExcelSiteMapConfig.BROWSE_FOR_DIRECTORY);
		}
		
		protected function _fileSelectedHandler(event:Event):void
		{
			var file:File = File.documentsDirectory.resolvePath(File(event.target).nativePath);
			
			if (file.isDirectory)
			{
				_basePath = file.url;
				_baseDirectoryName = file.name;
				searchDirectoryAndPickupFiles(file);
				file.getDirectoryListing();
			}
		}
		
		public function searchDirectoryAndPickupFiles(file:File):void
		{
			_fileList = new Vector.<WebSiteData>();
			_searchDirectoryAndPickupFiles(file);
			for (var k:String in _fileList) {;
				trace(_fileList[k].title);
			}
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function _searchDirectoryAndPickupFiles(file:File):void			
		{
			var list:Array = file.getDirectoryListing(),
				html:String;
			
			for (var i:uint = 0, l:uint = list.length; i < l; i++)
			{
				var f:File = list[i];
				if (f.isDirectory)
					_searchDirectoryAndPickupFiles(f);
				else
				{
					if (HTMLFile.ifHTMLFile(f)) {
						
						try {
							var htmlFile:HTMLFile = new HTMLFile(f);
							
							html = htmlFile.html; 
							
							
							var titleTag:Array = html.match(WebSiteRegExp.TITLE),
								titleContent:String = titleTag.join("").replace(new RegExp(WebSiteRegExp.TITLE_CONTENT), "");
							
							var websiteData:WebSiteData = new WebSiteData();
								websiteData.id = "";
								websiteData.title = titleContent;
								websiteData.keywords = WebSiteRegExp.getMetaContent(html, WebSiteRegExp.KEYWORDS);
								websiteData.description = WebSiteRegExp.getMetaContent(html, WebSiteRegExp.DESCRIPTION);
								websiteData.og_title = WebSiteRegExp.getMetaContent(html, WebSiteRegExp.OG_TITLE);
								websiteData.og_description = WebSiteRegExp.getMetaContent(html, WebSiteRegExp.OG_DESCRIPTION);
								websiteData.og_url = WebSiteRegExp.getMetaContent(html, WebSiteRegExp.OG_URL);
								websiteData.og_image = WebSiteRegExp.getMetaContent(html, WebSiteRegExp.OG_IMAGE);
								websiteData.og_type = WebSiteRegExp.getMetaContent(html, WebSiteRegExp.OG_TYPE);
								websiteData.og_site_name = WebSiteRegExp.getMetaContent(html, WebSiteRegExp.OG_SITE_NAME);
								websiteData.fb_app_id = WebSiteRegExp.getMetaContent(html, WebSiteRegExp.FB_APP_ID);
								websiteData.file = f;
								websiteData.relativePath = f.url.substr(_basePath.length);
								websiteData.encode = htmlFile.encode;
							
							
							_fileList.push(websiteData);
							
						} catch (e:Error) {
							trace(e);
						}
					}
				}
			}
		}
	}
}