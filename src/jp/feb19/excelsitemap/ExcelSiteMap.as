/**
 * ExcelSiteMap
 * Make a Excel File of Web Site Map and Update title/meta/ogp tags.
 *
 * @author		Nobuhiro Takahashi
 * @version		0.0.1
 */

/*
Licensed under the MIT License

Copyright (c) 2012 Nobuhiro Takahashi

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

*/

package jp.feb19.excelsitemap
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.utils.ByteArray;
	
	public class ExcelSiteMap extends Sprite
	{
		private var _webSiteLoader:WebSiteLoader;
		private var _excelSiteMapLoader:ExcelSiteMapLoader;
		private var _excelSiteMapUpdater:ExcelSiteMapUpdater;
		private var _window:ApplicationWindow;
		private var _viewController:ViewController;
		
		public function ExcelSiteMap()
		{
			super();
			
			_window = new ApplicationWindow();
			
			_viewController = new ViewController(_window.stage);
			_viewController.addEventListener(ViewController.CLICK_LOADSITE, _loadSite_clickHandler);
			_viewController.addEventListener(ViewController.CLICK_LOADSITEMAP, _loadSitemap_clickHandler);
			_viewController.addEventListener(ViewController.CLICK_EXEC, _exec_clickHandler);
			
			
			_webSiteLoader = new WebSiteLoader();
			_webSiteLoader.addEventListener(Event.COMPLETE, _webSiteLoadCompleteHandler);
			_excelSiteMapLoader = new ExcelSiteMapLoader();
			_excelSiteMapLoader.addEventListener(Event.COMPLETE, _xlsSitemapLoadCompleteHandler);
			_excelSiteMapUpdater = new ExcelSiteMapUpdater();
			_excelSiteMapUpdater.addEventListener(Event.SELECT, _xlsParsedHandler);
			_excelSiteMapUpdater.addEventListener(Event.COMPLETE, _websiteUpdatedHandler);
			
			_window.activate();
		}
		
		
		// --------------------------------------------------------------------------------------
		// load sitemap
		// --------------------------------------------------------------------------------------
		
		protected function _loadSitemap_clickHandler(event:Event):void
		{
			_excelSiteMapLoader.openLoadSitemapXLSDialog();
		}
		
		protected function _xlsSitemapLoadCompleteHandler(event:Event):void
		{
			if (_excelSiteMapLoader.fileList.length > 0) {
				_excelSiteMapUpdater.openTargetPathDialog(_excelSiteMapLoader.fileList);
			}
		}
		
		// goto warning view
		protected function _xlsParsedHandler(event:Event):void
		{
			var message:String = _excelSiteMapUpdater.targetPath;
			_viewController.changeWarningTextFieldContent(message);
			_viewController.gotoWarningView();
		}
		
		protected function _exec_clickHandler(event:Event):void
		{
			_excelSiteMapUpdater.exec();
		}
		
		// goto complete view
		protected function _websiteUpdatedHandler(event:Event):void
		{
			var list:Vector.<WebSiteData> = _excelSiteMapLoader.fileList,
				message:String = ExcelSiteMapConfig.COMPLETE_UPDATE;
			
			for (var i:int = 0, l:uint = list.length; i < l; i++)
			{
				if (list[i].relativePath != "")
					message += _excelSiteMapUpdater.targetPath + list[i].relativePath + "\n";
			}
			_viewController.changeResultTextFieldContent(message);
			_viewController.gotoCompleteView();
		}
		
		
		// --------------------------------------------------------------------------------------
		// load website
		// --------------------------------------------------------------------------------------
		
		
		protected function _loadSite_clickHandler(event:Event):void
		{
			_webSiteLoader.openLoadDialog();
		}
		
		// make excel file
		protected function _webSiteLoadCompleteHandler(event:Event):void
		{
			var excelSiteMapBuilder:ExcelSiteMapBuilder = new ExcelSiteMapBuilder(_webSiteLoader.baseDirectoryName, _webSiteLoader.fileList),
				bytes:ByteArray = excelSiteMapBuilder.createExcelBinary();
			
			try {
				var excelFile:File = new File();
					excelFile.addEventListener(Event.SELECT, _createdSitemapXLSHandler);
					excelFile.save(bytes, _webSiteLoader.baseDirectoryName + ExcelSiteMapConfig.SUFFIX_AND_EXTENSION);
			} catch (error:Error) {
				trace(error.message);
			}
		}
		
		// goto complete view
		protected function _createdSitemapXLSHandler(event:Event):void
		{
			var excelFile:File = File(event.target),
				message:String = ExcelSiteMapConfig.COMPLETE_XLS + excelFile.nativePath;
			
			_viewController.changeResultTextFieldContent(message);
			_viewController.gotoCompleteView();
		}
	}
}