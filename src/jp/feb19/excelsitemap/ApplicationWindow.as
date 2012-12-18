package jp.feb19.excelsitemap
{
	import flash.desktop.NativeApplication;
	import flash.display.NativeWindow;
	import flash.display.NativeWindowInitOptions;
	import flash.display.NativeWindowSystemChrome;
	import flash.display.NativeWindowType;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Point;

	public class ApplicationWindow extends NativeWindow
	{
		private var _close:CloseView;
		
		public function ApplicationWindow()
		{
			var nwio:NativeWindowInitOptions = new NativeWindowInitOptions();
				nwio.maximizable = false;
				nwio.minimizable = false;
				nwio.resizable = false;
				nwio.systemChrome = NativeWindowSystemChrome.NONE;
				nwio.type = NativeWindowType.LIGHTWEIGHT;
				nwio.transparent = true;
			
			super(nwio);
			
			this.title = "Excel Site Map";
			this.addEventListener(Event.CLOSE, _app_closeHandler);
			this.minSize = new Point(480+40, 340+40);
			this.width = 480+40;
			this.height = 340+40;
			this.stage.align = StageAlign.TOP_LEFT;
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			this.stage.frameRate = 60;
			
			
			var bg:BackgroundView = new BackgroundView();
				bg.filters = [new DropShadowFilter(8,90,0,.4,16,16,1,2)];
				bg.x = 20;
				bg.y = 20;
				bg.cacheAsBitmap = true;
			this.stage.addChild(bg);
			
			
			var close:CloseView = new CloseView();
				close.x = 469;
				close.y = 21;
				close.buttonMode = true;
				close.addEventListener(MouseEvent.CLICK, _closeClickHandler);
			_close = close;
			this.stage.addChild(close);
			
			
			this.stage.addEventListener(Event.ADDED, _addedSubviewHandler);
			this.stage.addEventListener(MouseEvent.MOUSE_DOWN, _windowDragHandler);
		}
		
		protected function _windowDragHandler(event:MouseEvent):void
		{
			event.currentTarget.nativeWindow.activate();
			event.currentTarget.nativeWindow.startMove();
		}
		
		protected function _closeClickHandler(event:MouseEvent):void
		{
			this.close();
		}
		
		protected function _addedSubviewHandler(event:Event):void
		{
			this.stage.setChildIndex(_close, this.stage.numChildren - 1);
		}
		
		protected function _app_closeHandler(event:Event):void
		{
			NativeApplication.nativeApplication.exit();
		}
		
	}
}