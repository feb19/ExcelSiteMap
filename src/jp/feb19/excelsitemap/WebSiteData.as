package jp.feb19.excelsitemap
{
	import flash.filesystem.File;

	public class WebSiteData
	{
		public function WebSiteData()
		{
		}
		
		public var id				:String;
		public var name				:String;
		public var title			:String;
		public var keywords			:String;
		public var description		:String;
		public var og_title			:String;
		public var og_site_name		:String;
		public var og_url			:String;
		public var og_type			:String;
		public var og_image			:String;
		public var og_description	:String;
		public var fb_app_id		:String;
		public var fullpath			:String;
		public var pathArray		:Array;
		public var extension		:String;
		public var encode			:String;
		
		private var _file			:File;
		private var _relativePath	:String;
		
		public function get file():File
		{
			return _file;
		}

		public function set file(value:File):void
		{
			_file = value;
			
			fullpath = value.url;
			name = value.name;
			extension = value.extension;
		}

		public function get relativePath():String
		{
			return _relativePath;
		}

		public function set relativePath(value:String):void
		{
			_relativePath = value;
			pathArray = value.split("/");
			pathArray.shift();
		}

	}
}