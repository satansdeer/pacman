package core.display {
	
	import as3isolib.display.IsoGroup;
	import as3isolib.display.primitive.IsoRectangle;
	import as3isolib.graphics.SolidColorFill;
	import as3isolib.graphics.Stroke;
	
	import flash.geom.Point;
	
	public class IsoFurnitureGrid extends IsoGroup {
		
		private static const UNIT_SIZE:uint = 32;
		
		private const STROKE:Stroke = new Stroke(0, 0xDDDDDD);
		private const GREEN_STROKE:Stroke = new Stroke(0, 0x00FF00);
		private const RED_STROKE:Stroke = new Stroke(0, 0xFF0000);
		private const GREEN_FILL:SolidColorFill = new SolidColorFill(0x00FF00, .5);
		private const RED_FILL:SolidColorFill = new SolidColorFill(0xFF0000, .5);
		
		private var rects:Vector.<IsoRectangle>;
		private var wid:uint;
		private var len:uint;
		
		public function IsoFurnitureGrid(descriptor:Object=null) {
			super(descriptor);
			
			rects = new Vector.<IsoRectangle>();
			container.cacheAsBitmap = true;
		}
		
		public function setGridSize(w:uint, l:uint):void {
			if (w == wid && l == len) return;
			
			var r:IsoRectangle, x:uint, y:uint;
			
			setSize(w * UNIT_SIZE, l * UNIT_SIZE, 0);
			
			// remove unnecessary
			if (w < wid) {
				for (y = 0; y < len; ++y) {
					for (x = w; x < wid; ++x) {
						r = getRectAt(x, y);
						if (!r) continue;
						rects.splice(rects.indexOf(r), 1);
						removeChild(r);
					}
				}
				wid = w;
			}
			if (l < len) {
				for (y = l; y < len; ++y) {
					for (x = 0; x < wid; ++x) {
						r = getRectAt(x, y);
						if (!r) continue;
						rects.splice(rects.indexOf(r), 1);
						removeChild(r);
					}
				}
				len = l;
			}
			
			// add rects
			if (w > wid || l > len) {
				for (y = 0; y < l; ++y) {
					for (x = 0; x < w; ++x) {
						if (getRectAt(x, y)) continue;
						r = new IsoRectangle();
						r.setSize(UNIT_SIZE, UNIT_SIZE, 0);
						r.moveTo(x * UNIT_SIZE, y * UNIT_SIZE, 0);
						r.data = {x:x, y:y};
						r.stroke = null;
						addChild(r);
						r.render();
						rects.push(r);
					}
				}
				wid = w;
				len = l;
			}
		}
		
		public function clear():void {
			for each (var r:IsoRectangle in rects) {
				if (!r.fill && !r.stroke) continue;
				r.fill = null;
				r.stroke = null;
				r.render();
			}
		}
		
		public function colorized(neutrals:Vector.<uint>=null, greens:Vector.<uint>=null, reds:Vector.<uint>=null):void {
			if (neutrals && !neutrals.length) neutrals = null;
			if (greens && !greens.length) greens = null;
			if (reds && !reds.length) reds = null;
			
			for each (var r:IsoRectangle in rects) {
				if (reds && r.fill != RED_FILL && checkPointIn(reds, r.data.x, r.data.y)) {
					r.fill = RED_FILL;
					r.stroke = RED_STROKE;
					r.render();
					continue;
				}
				if (greens && r.fill != GREEN_FILL && checkPointIn(greens, r.data.x, r.data.y)) {
					r.fill = GREEN_FILL;
					r.stroke = GREEN_STROKE;
					r.render();
					continue;
				}
				if (neutrals && checkPointIn(neutrals, r.data.x, r.data.y)) {
					r.fill = null;
					r.stroke = null;
					r.render();
					continue;
				}
			}
		}
		
		private function getRectAt(x:int, y:int):IsoRectangle {
			for each (var r:IsoRectangle in rects) {
				if (r.data.x == x && r.data.y == y) return r;
			}
			return null;
		}
		
		private function checkPointIn(points:Vector.<uint>, x:int, y:int):Boolean {
			const len:uint = points.length;
			for (var i:uint = 0; i < len; i += 2) {
				if (points[i] == x && points[i+1] == y) return true;
			}
			return false;
		}
		
	}
	
}
