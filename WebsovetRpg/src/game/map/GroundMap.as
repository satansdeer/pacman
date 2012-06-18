package game.map
{
	import as3isolib.display.IsoSprite;
	import as3isolib.display.scene.IsoScene;
	import as3isolib.geom.Pt;
	
	import core.AppData;
	import core.FpsMeter;
	import core.enum.ScenesENUM;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Point;
	
	import game.GameView;
	import game.events.GameViewEvent;
	
	import org.casalib.util.StageReference;
	
	import ru.beenza.framework.utils.EventJoin;

	/**
	 * GroundMap
	 * @author satansdeer
	 */
	
	public class GroundMap extends MapBase {
		
		private var _map:Vector.<Vector.<Tile>>;
		private var tiles:Vector.<Tile> = new Vector.<Tile>;
		
		private var _eventJ:EventJoin;
		private static var _instance:GroundMap;
		
		private var _newTilesFowShow:Vector.<Tile> = new Vector.<Tile>;
		private var showNum:uint = 0;
		private const MAX_SHOW_NUM:uint = 45;
		private var _controller:MapsController;
		private var tilesLength:uint;
		
		public function GroundMap(gameView:GameView, controller:MapsController) {
			super(gameView);
			_controller = controller;
			_instance = this;
			_stage = StageReference.getStage();
			_scene = _gameView.getScene(ScenesENUM.GROUND);
			_eventJ = new EventJoin(2,load);
			AppData.instance.addEventListener(Event.COMPLETE, onComplete);
		}
		
		protected function onGameViewMove(event:Event):void{
			
		}
		
		public static function get instance():GroundMap{
			return _instance;
		}
		
		public function setSize(w:int, h:int):void{
			var tile:IsoSprite;
			var bmp:Bitmap;
			_tempMap = new Vector.<Vector.<Tile>>(w, true);
			for (var x:int=0; x < w; x++){
				_tempMap[x] = new Vector.<Tile>(h, true);
				for(var y:int= 0; y < h; y++){
					_tempMap[x][y] =  new Tile(x,y, "assets/tile.png", _scene);
				}
			}
			for (x=0; x < _map.length; x++){
				for(y= 0; y < _map[x].length; y++){
					_tempMap[x][y] =  _map[x][y];
				}
			}
			_map = _tempMap;
		}
		
		protected function onComplete(event:Event):void{
			_eventJ.join(event);
		}
		
		private function load():void{
			MapLoader.mapFromFile();
			MapLoader.instance.addEventListener(Event.COMPLETE, onMapLoaderComplete);
		}
		
		protected function onMapLoaderComplete(event:Event):void{
			_map = MapLoader.map;
			makeTileMap();
		}
		
		private function makeTileMap():void {
			var mapWidth:int = _map.length;
			var mapLength:int = _map[0].length;
			for(var x:int = 0; x < mapWidth; x++){
				for(var y:int = 0; y < mapLength; y++){
					tempTile = _map[x][y]
					tempTile.shown = true;
					_newTilesFowShow.push(tempTile);
				}
			}
			_controller.fogMap.setSize(mapWidth, mapLength);
		}
		
		private function getTileByXY(tX:int, tY:int):Tile{
			if(tX<0){return null}
			if(tY<0){return null}
			if(tX>=_map.length){return null}
			if(tY>=_map[tX].length){return null}
			return _map[tX][tY];
		}
		
		public function updateRegion():void {
			for (var k:int = _controller.minUnitIsoPoint.x; k < _controller.maxUnitIsoPoint.x; k++){
				for (var q:int = _controller.minUnitIsoPoint.y; q < _controller.maxUnitIsoPoint.y; q++){
					tempTile = getTileByXY(k,q);
					if(tempTile && !tempTile.shown){
						_newTilesFowShow.push(tempTile);
						tempTile.shown = true;
					} 
				}
			}
			tempTiles = new Vector.<Tile>;
			tilesLength = tiles.length;
			for(k = 0; k < tilesLength; k++){
				tempTile = tiles[k];
				if((tempTile.x<_controller.minUnitIsoPoint.x) || (tempTile.y<_controller.minUnitIsoPoint.y) || (tempTile.x>_controller.maxUnitIsoPoint.x) || (tempTile.y>_controller.maxUnitIsoPoint.y)){
					_scene.removeChild(tempTile.isoSprite);
					tempTile.remove();
					getTileByXY(tempTile.x,tempTile.y).shown = false;
				}else{
					tempTiles.push(tempTile)
				}
			}
			tiles = tempTiles;
		}
		
		public function showNewTiles():void {
			recountShowNum();
			if(_newTilesFowShow.length >0){
				var max:int;
				if(_newTilesFowShow.length >= showNum){
					max = showNum;
				}else{
					max = _newTilesFowShow.length;
				}
				for (var i:int = 0; i < showNum; i++){
					if(_newTilesFowShow.length > 0){
						tempTile = _newTilesFowShow[_newTilesFowShow.length -1];
						if(tempTile && ((tempTile.x>_controller.minUnitIsoPoint.x) || (tempTile.y>_controller.minUnitIsoPoint.y) || (tempTile.x<_controller.maxUnitIsoPoint.x) || (tempTile.y<_controller.maxUnitIsoPoint.y))){
							var tile:Tile = _newTilesFowShow.shift();
							if(tile){
								if(!tile.isoSprite){
									tile.draw();
								}
								tile.isoSprite.moveTo(tile.x * Main.UNIT_SIZE, tile.y * Main.UNIT_SIZE, 0);
								_scene.addChild(tile.isoSprite);
								tile.isoSprite.render();
								tiles.push(tile)
							}
						}
					}
				}
			}
		}
		
		private function recountShowNum():void {
			if(FpsMeter.instance.fps > MAX_SHOW_NUM){
				showNum = MAX_SHOW_NUM
			}else{
				showNum = FpsMeter.instance.fps; 
			}
		}
	}
}