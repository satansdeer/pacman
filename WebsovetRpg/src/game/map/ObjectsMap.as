package game.map
{
	import as3isolib.display.IsoSprite;
	import as3isolib.geom.IsoMath;
	import as3isolib.geom.Pt;
	
	import core.AppData;
	import core.display.InteractivePNG;
	import core.display.IsoFurnitureGrid;
	import core.enum.ScenesENUM;
	import core.layer.LayersENUM;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import game.GameView;
	import game.vo.MapObjectVO;
	
	import mouse.MouseManager;
	
	import org.casalib.util.StageReference;
	
	import ru.beenza.framework.layers.LayerManager;
	import ru.beenza.framework.utils.EventJoin;

	/**
	 * ObjectsMap
	 * @author satansdeer
	 */
	public class ObjectsMap extends MapBase{
		
		private var _map:Array;
		private var objects:Array = [];
		
		//private var grid:IsoFurnitureGrid;
		
		private var _objectForBuying:MapObject;
		
		private var _loadEventJoin:EventJoin;
		private var _controller:MapsController;
		
		private var _shownObjects:Array = [];
		
		private var _tempObjects:Array = [];
		private var _newObjectsForShow:Array = [];
		private var tempObject:MapObject;
		private const SHOW_NUM:int = 1;
		private var loader:URLLoader;
		
		public function ObjectsMap(gameView:GameView, controller:MapsController)
		{
			super(gameView);
			_controller = controller;
			_scene = _gameView.getScene(ScenesENUM.OBJECTS);
			LayerManager.getLayer(LayersENUM.SCENE).addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			LayerManager.getLayer(LayersENUM.SCENE).addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			StageReference.getStage().addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			StageReference.getStage().addEventListener(Event.ENTER_FRAME, onEnterFrame);
			AppData.instance.addEventListener(Event.COMPLETE, onDataLoaded);
			_loadEventJoin = new EventJoin(2, load);
		}
		
		public function setObjectForBuying(value:MapObjectVO):void{
			var isoMouse:Point = stageToIso(new Point(_scene.container.mouseX,_scene.container.mouseY));
			_objectForBuying = new MapObject(value, this);
			_objectForBuying.x = isoMouse.x;
			_objectForBuying.y = isoMouse.y;
			_objectForBuying.isoSprite.moveTo(isoMouse.x, isoMouse.y, 0);
			_scene.addChild(_objectForBuying.isoSprite);
			GameView.instance.getScene(ScenesENUM.GRID).render();
			_objectForBuying.isoSprite.render();
		}
		
		public function addObject(object:MapObject):void{
			
		}
		
		public function get objectForBuying():MapObject{
			return _objectForBuying;
		}
		
		public function addObjectAt(x:int, y:int, vo:MapObjectVO):void{
			objects.push(new MapObject(vo, this));
			objects[objects.length -1].shown = true;
			_shownObjects.push(objects[objects.length-1]);
			_scene.addChild(_shownObjects[_shownObjects.length-1].isoSprite);
			_shownObjects[_shownObjects.length-1].x = x/Main.UNIT_SIZE;
			_shownObjects[_shownObjects.length-1].y = y/Main.UNIT_SIZE;
			_shownObjects[_shownObjects.length-1].isoSprite.moveTo(x,y,0);
			(_shownObjects[_shownObjects.length-1].isoSprite as IsoSprite).setSize(_shownObjects[_shownObjects.length-1].vo.width *Main.UNIT_SIZE,_shownObjects[_shownObjects.length-1].vo.length *Main.UNIT_SIZE,1);
			_shownObjects[_shownObjects.length-1].isoSprite.render();
		}
		
		public function removeObject(object:MapObject):void{
			object.remove();
			_scene.removeChild(object.isoSprite);
			objects.splice(objects.indexOf(object),1);
			_shownObjects.splice(_shownObjects.indexOf(object),1);
			save();
		}
		
		
		protected function onDataLoaded(event:Event):void{
			_loadEventJoin.join(event);
		}
		
		protected function onEnterFrame(event:Event):void{
			_scene.render();
		}
		
		protected function onMouseUp(event:MouseEvent):void{
			if(_objectForBuying){
				_objectForBuying.isoSprite.container.mouseChildren = true;
				_objectForBuying.isoSprite.container.mouseEnabled = true;
				_scene.removeChild(_objectForBuying.isoSprite);
				if(placeAvailable(_objectForBuying)){
					addObjectAt(_objectForBuying.x, _objectForBuying.y, _objectForBuying.vo);
				}
				_objectForBuying = null;
				//grid.clear();
				setObjectsMouseEnabled(true);
				save()
			}
		}
		
		private function save():void{
			var mapString:String = "<objects>";
			for(var i:int=0; i < objects.length; i++){
				mapString += "<object id=\""+objects[i].vo.id+"\"" + " x=\""+ objects[i].x + "\"" + "y=\""+ objects[i].y + "\"" + "/>";
			}
			mapString += "</objects>";
			var mapXML:XML = new XML(mapString);
		}
		
		private function load():void{
			loader = new URLLoader()
			loader.addEventListener(Event.COMPLETE, onMapLoaded)
			loader.load(new URLRequest("data/objectsMap.xml"))
		}
		
		protected function onMapLoaded(event:Event):void
		{
			AppData.objectsMap= new XML(loader.data);
			var mapXML:XML = AppData.objectsMap;
			var mO:MapObject;
			for(var i:int = 0; i<mapXML.object.length(); i++){
				mO = new MapObject(getVOById(mapXML.object[i].@id), this);
				mO.x = int(mapXML.object[i].@x);
				mO.y = int(mapXML.object[i].@y);
				mO.shown = false;
				objects.push(mO);
			}
			updateRegion();
		}
		
		private function getVOById(id:String):MapObjectVO{
			var vo:MapObjectVO = new MapObjectVO();
			for (var i:int = 0; i<AppData.objects.object.length(); i++){
				if(AppData.objects.object[i].@id == id){
					vo.id = AppData.objects.object[i].@id;
					vo.name = AppData.objects.object[i].@name;
					vo.url = AppData.objects.object[i].@url;
					vo.length = AppData.objects.object[i].@length;
					vo.width = AppData.objects.object[i].@width;
					vo.offsetX = AppData.objects.object[i].@offsetX;
					vo.offsetY = AppData.objects.object[i].@offsetY;
				}
			}
			return vo;
		}
		
		protected function onMouseMove(event:MouseEvent):void{
			if(_objectForBuying){
				var isoMouse:Point = stageToIso(new Point(_scene.container.mouseX,_scene.container.mouseY));
				if((_objectForBuying.y != isoMouse.y) || (_objectForBuying.x != isoMouse.x)){
					_objectForBuying.x = isoMouse.x;
					_objectForBuying.y = isoMouse.y;
					_objectForBuying.isoSprite.moveTo(isoMouse.x, isoMouse.y, 0);
				}
				_scene.render();
			}
		}
		
		private function setObjectsMouseEnabled(value:Boolean):void{
			for each (var obj:MapObject in objects) {
				obj.isoSprite.container.mouseEnabled = value;
				obj.isoSprite.container.mouseChildren = value;
			}
		}
		
		protected function onMouseOver(event:Event):void{
			if(!_objectForBuying && MouseManager.instance.data){
				setObjectForBuying(MouseManager.instance.data as MapObjectVO);
				MouseManager.instance.img = null;
			}
		}
		
		private function placeAvailable(object:MapObject):Boolean{
			var obj:MapObject;
			var rect:Rectangle;
			const objectRect:Rectangle = new Rectangle(int(object.isoSprite.x/Main.UNIT_SIZE), int(object.isoSprite.y/Main.UNIT_SIZE), object.vo.width, object.vo.length);
			const objRect:Rectangle = new Rectangle();
			for each (obj in _shownObjects) {
				objRect.x = int(obj.isoSprite.x/Main.UNIT_SIZE);
				objRect.y = int(obj.isoSprite.y/Main.UNIT_SIZE);
				objRect.width = obj.vo.width;
				objRect.height = obj.vo.length;
				rect = objectRect.intersection(objRect);
				if (rect.width > 0 || rect.height > 0) {
					return false;
				}
			}
			return true;
		}
		
		private function stageToIso(p:Point):Point {
			p = LayerManager.getLayer(LayersENUM.SCENE).globalToLocal(p);
			const pt:Pt = new Pt(p.x, p.y);
			IsoMath.screenToIso(pt);
			p.x = Math.floor(pt.x / Main.UNIT_SIZE) * Main.UNIT_SIZE;
			p.y = Math.floor(pt.y / Main.UNIT_SIZE) * Main.UNIT_SIZE;
			return p;
		}
		
		private function getObjectByXY(oX:int, oY:int):MapObject{
			for(var i:int = 0; i<objects.length; i++){
				if((objects[i].x == oX) && (objects[i].y == oY)){
					return objects[i];
				}
			}
			return null;
		}
		
		public function updateRegion():void {
			//grid.moveTo(_controller.minUnitIsoPoint.x*Main.UNIT_SIZE, _controller.minUnitIsoPoint.y * Main.UNIT_SIZE, 0);
			//grid.render();
			_gameView.getScene(ScenesENUM.GRID).render();
			for (var k:int = 0; k<objects.length; k++){
				if((objects[k].x>_controller.minUnitIsoPoint.x) && (objects[k].y>_controller.minUnitIsoPoint.y) && (objects[k].x<_controller.maxUnitIsoPoint.x) && (objects[k].y<_controller.maxUnitIsoPoint.y)){
					if(objects[k].shown == false){
						objects[k].shown = true;
						_newObjectsForShow.push(objects[k]);
					}
				}
			}
			_tempObjects = [];
			for (k = 0; k < _shownObjects.length; k++){
				if((_shownObjects[k].x<_controller.minUnitIsoPoint.x) || (_shownObjects[k].y<_controller.minUnitIsoPoint.y) || (_shownObjects[k].x>_controller.maxUnitIsoPoint.x) || (_shownObjects[k].y>_controller.maxUnitIsoPoint.y)){
					_scene.removeChild(_shownObjects[k].isoSprite);
					getObjectByXY(_shownObjects[k].x, _shownObjects[k].y).shown = false;
				}else{
					_tempObjects.push(_shownObjects[k]);
				}
			}
			_shownObjects = _tempObjects;
		}
		
		public function showNewObjects():void {
			if(_newObjectsForShow.length >0){
				var max:int;
				if(_newObjectsForShow.length >= SHOW_NUM){
					max = SHOW_NUM;
				}else{
					max = _newObjectsForShow.length;
				}
				for (var i:int = 0; i < SHOW_NUM; i++){
					tempObject = _newObjectsForShow[_newObjectsForShow.length -1];
					if(tempObject && ((tempObject.x>_controller.minUnitIsoPoint.x) || (tempObject.y>_controller.minUnitIsoPoint.y) || (tempObject.x<_controller.maxUnitIsoPoint.x) || (tempObject.y<_controller.maxUnitIsoPoint.y))){
						var object:MapObject = _newObjectsForShow.shift();
						if(object){
							_shownObjects.push(object);
							_shownObjects[_shownObjects.length-1].isoSprite.moveTo(object.x * Main.UNIT_SIZE, object.y * Main.UNIT_SIZE, 0);
							_scene.addChild(_shownObjects[_shownObjects.length-1].isoSprite);
							_shownObjects[_shownObjects.length-1].isoSprite.render();
							//_scene.render();
						}
					}
				}
			}
		}
		
		public function setSize(sW:int, sL:int):void {
			//grid.setGridSize(_controller.maxUnitIsoPoint.x - _controller.minUnitIsoPoint.x,_controller.maxUnitIsoPoint.y - _controller.minUnitIsoPoint.y);
			//grid.y = -Main.UNIT_SIZE/2;
			//grid.x = Main.UNIT_SIZE/2;
		}
	}
}