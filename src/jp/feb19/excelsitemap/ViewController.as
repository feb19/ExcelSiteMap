package jp.feb19.excelsitemap
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import jp.feb19.excelsitemap.utils.TextFormats;

	public class ViewController extends EventDispatcher
	{
		public static const CLICK_LOADSITE		:String = "viewController_loadSite";
		public static const CLICK_LOADSITEMAP	:String = "viewController_loadSiteMap";
		public static const CLICK_CANCEL		:String = "viewController_cancel";
		public static const CLICK_EXEC			:String = "viewController_exec";
		public static const CLICK_OK			:String = "viewController_ok";
		
		private var _stage:Stage;
		private var _topView:TopView;
		private var _warningView:WarningView;
		private var _tf:TextField;
		private var _completeView:CompleteView;
		private var _resultTf:TextField;
		private var _currentView:DisplayObjectContainer;
		
		public function ViewController(stage:Stage)
		{
			_stage = stage;
			
			_topView = new TopView();
			_topView.x = 20;
			_topView.y = 20;
			_stage.addChild(_topView);
			_currentView = _topView;
			
			_warningView = new WarningView();
			_warningView.x = 20;
			_warningView.y = 20;
			
			
			_tf = new TextField();
			_tf.defaultTextFormat = TextFormats.normalCentered();
			_tf.width = _stage.stageWidth;
			_tf.y = 85;
			_warningView.addChild(_tf);
			
			_completeView = new CompleteView();
			_completeView.x = 20;
			_completeView.y = 20;
			
			_topView.analyzemc.buttonMode = true;
			_topView.analyzemc.addEventListener(MouseEvent.CLICK, _clickHandler);
			_topView.updatemc.buttonMode = true;
			_topView.updatemc.addEventListener(MouseEvent.CLICK, _clickHandler);
			_warningView.cancelmc.buttonMode = true;
			_warningView.cancelmc.addEventListener(MouseEvent.CLICK, _clickHandler);
			_warningView.execmc.buttonMode = true;
			_warningView.execmc.addEventListener(MouseEvent.CLICK, _clickHandler);
			_completeView.okmc.buttonMode = true;
			_completeView.okmc.addEventListener(MouseEvent.CLICK, _clickHandler);
			_completeView.scrollermc.buttonMode = true;
			_completeView.scrollermc.addEventListener(MouseEvent.MOUSE_DOWN, _mouseDownHandler);
			
			var mask:Shape = new Shape();
				mask.graphics.beginFill(0xff0000);
				mask.graphics.drawRect(0,0,440,187);
				mask.graphics.endFill();
				mask.cacheAsBitmap = true;
				mask.y = 63;
			_completeView.addChild(mask);
			
			
			_resultTf = new TextField();
			_resultTf.autoSize = TextFieldAutoSize.LEFT;
			_resultTf.defaultTextFormat = TextFormats.normal();
			_resultTf.width = 440;
			_resultTf.x = 30;
			_resultTf.y = 70;
			_resultTf.cacheAsBitmap = true;
			_resultTf.mask = mask;
			_completeView.addChild(_resultTf);
			
			_completeView.setChildIndex(_completeView.scrollermc, _completeView.numChildren - 1);
			
			super();
		}
		
		protected function _clickHandler(event:MouseEvent):void
		{
			switch(event.currentTarget)
			{
				case _topView.analyzemc:	dispatchEvent(new Event(ViewController.CLICK_LOADSITE));	break;
				case _topView.updatemc:		dispatchEvent(new Event(ViewController.CLICK_LOADSITEMAP));	break;
				case _warningView.cancelmc:	dispatchEvent(new Event(ViewController.CLICK_CANCEL));		gotoTopView();	break;
				case _warningView.execmc:	dispatchEvent(new Event(ViewController.CLICK_EXEC));		break;
				case _completeView.okmc:	dispatchEvent(new Event(ViewController.CLICK_OK));			gotoTopView();	break;
			}
		}
		
		protected function _mouseDownHandler(event:MouseEvent):void
		{
			_stage.addEventListener(MouseEvent.MOUSE_UP, _mouseUpHandler);
			_stage.addEventListener(MouseEvent.MOUSE_MOVE, _mouseMoveHandler);
			_completeView.scrollermc.startDrag(false, new Rectangle(432, 70, 0, 110));
			event.preventDefault();
			event.stopImmediatePropagation();
		}
		
		protected function _mouseMoveHandler(event:MouseEvent):void
		{
			var per:Number = (_completeView.scrollermc.y - 70)/110;
			_resultTf.y = -1 * (_resultTf.height - 160) * per + 70;
			event.preventDefault();
			event.stopImmediatePropagation();
		}
		
		protected function _mouseUpHandler(event:MouseEvent):void
		{
			_stage.removeEventListener(MouseEvent.MOUSE_UP, _mouseUpHandler);
			_stage.removeEventListener(MouseEvent.MOUSE_MOVE, _mouseMoveHandler);
			_completeView.scrollermc.stopDrag();
			event.preventDefault();
			event.stopImmediatePropagation();
		}
		
		
		public function gotoWarningView():void
		{
			_stage.removeChild(_currentView);
			_stage.addChild(_warningView);
			_currentView = _warningView;
		}
		
		public function changeWarningTextFieldContent(message:String):void
		{
			_tf.text = message;
		}
		
		public function gotoCompleteView():void
		{
			_stage.removeChild(_currentView);
			_stage.addChild(_completeView);
			_currentView = _completeView;
		}
		
		public function changeResultTextFieldContent(message:String):void
		{
			_completeView.scrollermc.visible = true;
			_completeView.scrollermc.y = 70;
			
			_resultTf.y = 70;
			_resultTf.text = message;
			
			if (_resultTf.height < 187)
				_completeView.scrollermc.visible = false;
			
		}
		
		public function gotoTopView():void
		{
			_stage.removeChild(_currentView);
			_stage.addChild(_topView);
			_currentView = _topView;
		}
	}
}