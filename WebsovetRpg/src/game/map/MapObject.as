package game.map
{
	/**
	 * MapObject
	 * @author satansdeer
	 */
	import as3isolib.display.IsoSprite;
	
	import core.component.MapObjectPreloader;
	import core.component.PreloaderItem;
	import core.display.AssetManager;
	import core.display.InteractivePNG;
	import core.display.IsoFurnitureGrid;
	import core.event.AssetEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	
	import game.GameView;
	import game.vo.MapObjectVO;
	
	import mouse.MouseManager;
	
	public class MapObject extends EventDispatcher{
		
		public var vo:MapObjectVO;
		public var isoSprite:IsoSprite;
		public var img:InteractivePNG;
		
		private var _controller:ObjectsMap;
		
		private var _x:int;
		private var _y:int;
		private var preloader:MapObjectPreloader;
		
		public var shown:Boolean;
		
		public function MapObject(objectVO:MapObjectVO, controller:ObjectsMap)
		{
			super(null);
			vo = objectVO;
			_controller = controller;
			init();
		}
		
		public function get x():int{
			return _x;
		}
		
		public function get y():int{
			return _y;
		}
		
		public function set x(value:int):void{
			_x = value;
		}
		
		public function set y(value:int):void{
			_y = value;
		}
		
		public function remove():void{
			removeListeners();
		}
		
		private function removeListeners():void {
			img.removeEventListener(MouseEvent.CLICK, onClick);
			img.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		
		private function onMouseDown(event:MouseEvent):void {
			if(MouseManager.instance.mode == MouseManager.MOVE_MODE){
				event.stopPropagation();
				_controller.setObjectForBuying(vo);
				(_controller as ObjectsMap).removeObject(this);
			}
		}
		
		public function init():void{
			if(!isoSprite){
				isoSprite = new IsoSprite();
				isoSprite.setSize(vo.width * Main.UNIT_SIZE,vo.length * Main.UNIT_SIZE, 1);
				isoSprite.moveTo(x * Main.UNIT_SIZE, y * Main.UNIT_SIZE, 0);
				isoSprite.data = {x:x, y:y}
				if(AssetManager.getImageByURL(vo.url)){
					img = new InteractivePNG(AssetManager.getImageByURL(vo.url));
					isoSprite.container.addChild(img);
					img.scaleX = 0.25;
					img.scaleY = 0.25;
					img.x = vo.offsetX;
					img.y = vo.offsetY;
					addListeners()
				}else{
					AssetManager.load(vo.url);
					AssetManager.instance.addEventListener(AssetEvent.ASSET_LOADED, onAssetLoaded);
					preloader = new MapObjectPreloader(vo.width, vo.length);
					isoSprite.container.addChild(preloader);
				}
			}
		}
		
		private function addListeners():void {
			img.addEventListener(MouseEvent.CLICK, onClick);
			img.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			
		}
		
		protected function onAssetLoaded(event:AssetEvent):void{
			if(vo.url == event.url){
				AssetManager.instance.removeEventListener(AssetEvent.ASSET_LOADED, onAssetLoaded);
				img = new InteractivePNG(AssetManager.getImageByURL(vo.url));
				isoSprite.container.addChild(img);
				img.scaleX = 0.25;
				img.scaleY = 0.25;
				img.x = vo.offsetX;
				img.y = vo.offsetY;
				addListeners();
				if(preloader && isoSprite.container.contains(preloader)){
					isoSprite.container.removeChild(preloader);
					preloader = null;
				}
			}
		}
		
		protected function onClick(event:MouseEvent):void{
			if(MouseManager.instance.mode == MouseManager.REMOVE_MODE){
				(_controller as ObjectsMap).removeObject(this);
			}
		}
	}
}