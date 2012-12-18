package jp.feb19.excelsitemap
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	public class ExcelSiteMapUpdater extends EventDispatcher
	{
		private var _targetPath:String;
		private var _sitemapData:Vector.<WebSiteData>;
		private var _baseFile:File;
		public function ExcelSiteMapUpdater()
		{
			super();
			_sitemapData = new Vector.<WebSiteData>();
			_baseFile = null;
			_targetPath = "";
		}
		
		public function get targetPath():String
		{
			return _targetPath;
		}

		public function openTargetPathDialog(sitemapData:Vector.<WebSiteData>):void
		{
			_sitemapData = sitemapData;
			
			var file:File = new File();
			file.addEventListener(Event.SELECT, _fileSelectedHandler);
			file.browseForDirectory(ExcelSiteMapConfig.BROWSE_FOR_DIRECTORY);
		}
		
		protected function _fileSelectedHandler(event:Event):void
		{
			var file:File = File.documentsDirectory.resolvePath(File(event.target).nativePath);
			if (file.isDirectory)
			{
				_baseFile = file;
				_targetPath = file.url;
				dispatchEvent(new Event(Event.SELECT));
			}
		}
		
		public function exec():void
		{
			var sitemapData:Vector.<WebSiteData> = _sitemapData,
				html:String;
			
			for (var i:uint = 0, l:uint = sitemapData.length; i < l; i++)
			{
				if (sitemapData[i] && sitemapData[i].relativePath && sitemapData[i].relativePath.length > 0) {
					var websiteData:WebSiteData = sitemapData[i];
					var f:File = _baseFile.resolvePath("." + websiteData.relativePath);
					if (f.exists) {
						
						var htmlFile:HTMLFile = new HTMLFile(f);
						html = htmlFile.html;
						
						html = html.replace(WebSiteRegExp.TITLE, "<title>"+websiteData.title+"</title>");
						html = html.replace(WebSiteRegExp.DESCRIPTION, "<meta name=\"description\" content=\""+websiteData.description+"\"");
						html = html.replace(WebSiteRegExp.KEYWORDS, "<meta name=\"keywords\" content=\""+websiteData.keywords+"\"");
						html = html.replace(WebSiteRegExp.OG_TITLE, "<meta property=\"og:title\" content=\""+websiteData.og_title+"\"");
						html = html.replace(WebSiteRegExp.OG_TYPE, "<meta property=\"og:type\" content=\""+websiteData.og_type+"\"");
						html = html.replace(WebSiteRegExp.OG_DESCRIPTION, "<meta property=\"og:description\" content=\""+websiteData.og_description+"\"");
						html = html.replace(WebSiteRegExp.OG_URL, "<meta property=\"og:url\" content=\""+websiteData.og_url+"\"");
						html = html.replace(WebSiteRegExp.OG_IMAGE, "<meta property=\"og:image\" content=\""+websiteData.og_image+"\"");
						html = html.replace(WebSiteRegExp.OG_SITE_NAME, "<meta property=\"og:site_name\" content=\""+websiteData.og_site_name+"\"");
						html = html.replace(WebSiteRegExp.FB_APP_ID, "<meta property=\"fb:app_id\" content=\""+websiteData.fb_app_id+"\"");
						
						var fileStream:FileStream = new FileStream();
							fileStream.open(f, FileMode.WRITE);
							fileStream.writeUTFBytes(html);
							fileStream.close();
					} else {
						// TODO: create new html file
					}
				}
			}
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}