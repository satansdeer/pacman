package core.display {
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class InteractivePNG extends Sprite {
		
		private var bmp:Bitmap;
		private var hit:Boolean;
		private var basePoint:Point;
		private var mousePoint:Point;
		private var buttonModeCache:Boolean;
		
		private var _src:BitmapData;
		private var _offsetX:int;
		private var _offsetY:int;
		
		public function InteractivePNG(bmd:BitmapData) {
			src = bmd;
			init();
		}
		
		private function init():void {
			basePoint = new Point();
			mousePoint = new Point();
			activate();
		}
		
		private function activate():void {
			addEventListener(MouseEvent.ROLL_OVER, captureMouseEvent, false, 10000, true);
			addEventListener(MouseEvent.MOUSE_OVER, captureMouseEvent, false, 10000, true);
			addEventListener(MouseEvent.ROLL_OUT, captureMouseEvent, false, 10000, true);  
			addEventListener(MouseEvent.MOUSE_OUT, captureMouseEvent, false, 10000, true);
			addEventListener(MouseEvent.MOUSE_MOVE, captureMouseEvent, false, 10000, true);
		}
		private function deactivate():void {
			removeEventListener(MouseEvent.ROLL_OVER, captureMouseEvent);
			removeEventListener(MouseEvent.MOUSE_OVER, captureMouseEvent);
			removeEventListener(MouseEvent.ROLL_OUT, captureMouseEvent);  
			removeEventListener(MouseEvent.MOUSE_OUT, captureMouseEvent);
			removeEventListener(MouseEvent.MOUSE_MOVE, captureMouseEvent);
		}
		
		private function captureMouseEvent(event:Event):void {
			if (event.type == MouseEvent.MOUSE_OVER || event.type == MouseEvent.ROLL_OVER) {
				mouseEnabled = false;
				addEventListener(Event.ENTER_FRAME, trackMouseWhileInBounds, false, 10000, true);
				trackMouseWhileInBounds();
			}
			
			if (!hit)
				event.stopImmediatePropagation();
		}
		
		private function trackMouseWhileInBounds(event:Event = null):void {
			if (bitmapHitTest() != hit) {
				hit = !hit;
				if (hit) {
					deactivate();
					mouseEnabled = true;
					setButtonModeCache(true);
				} else {
					mouseEnabled = false;
					setButtonModeCache();
				}
			}
			
			const localMouse:Point = bmp.localToGlobal(mousePoint);
			if (!hitTestPoint(localMouse.x, localMouse.y)) {
				removeEventListener(Event.ENTER_FRAME, trackMouseWhileInBounds);
				mouseEnabled = true;
				activate();
			}
		}
		
		private function bitmapHitTest():Boolean {
			mousePoint.x = bmp.mouseX;
			mousePoint.y = bmp.mouseY;
			return _src.hitTest(basePoint, 0, mousePoint);
		}
		
		private function setButtonModeCache(restore:Boolean = false):void {
			if (restore && buttonModeCache) {
				super.buttonMode = true;
			} else {
				super.buttonMode = false;
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Getters / Setters
		//
		//--------------------------------------------------------------------------
		
		override public function set buttonMode(value:Boolean):void {
			buttonModeCache = value;
		}
		
		public function get src():BitmapData { return _src }
		public function set src(value:BitmapData):void {
			if (_src == value) return;
			_src = value;
			
			if (!bmp) {
				bmp = new Bitmap();
				bmp.x = -offsetX;
				bmp.y = -offsetY;
				addChild(bmp);
			}
			
			bmp.bitmapData = value;
		}
		
		public function get offsetX():int { return _offsetX }
		public function set offsetX(value:int):void {
			_offsetX = value;
			if (bmp) bmp.x = -offsetX;
		}
		
		public function get offsetY():int { return _offsetY }
		public function set offsetY(value:int):void {
			_offsetY = value;
			if (bmp) bmp.y = -offsetY;
		}
		
	}
	
}
