package game.map
{
	import as3isolib.geom.Pt;
	
	import core.FpsMeter;
	import core.enum.ScenesENUM;
	
	import game.GameView;
	
	public class FogMap extends MapBase{
		
		public var map:Vector.<Vector.<Tile>>; 
		private var tiles:Vector.<Tile> = new Vector.<Tile>
			
		private var _controller:MapsController;
		private var _newTilesFowShow:Vector.<Tile> = new Vector.<Tile>;
		private var tilesLength:uint;
		private var MAX_SHOW_NUM:int = 45;
		private var showNum:int;
		public function FogMap(gameView:GameView, controller:MapsController)
		{
			super(gameView);
			_controller = controller;
			_scene = _gameView.getScene(ScenesENUM.FOG);
		}
		
		public function addTile(pt:Pt):void {
			var tile:Tile = new Tile(pt.x * Main.UNIT_SIZE, pt.y * Main.UNIT_SIZE, "assets/fog.png", _scene);
			tile.draw();
			tile.isoSprite.moveTo(pt.x * Main.UNIT_SIZE, pt.y * Main.UNIT_SIZE, 0);
			_scene.addChild(tile.isoSprite);
			tile.isoSprite.render();
			tile.shown = true;
			tiles.push(tile);
			map[pt.x][pt.y] = tile;
			
		}
		
		public function removeTile(pt:Pt):void{
			_scene.removeChild(map[pt.x][pt.y].isoSprite);
			map[pt.x][pt.y].remove();
			map[pt.x][pt.y] = null;
		}
		
		public function setSize(sW:int, sL:int):void {
			map = new Vector.<Vector.<Tile>>(sW, true);
			for(var i:int = 0; i< sW; i++){
				map[i] = new Vector.<Tile>(sL, true);
			}
		}
		
		private function getTileByXY(tX:int, tY:int):Tile{
			if(tX<0){return null}
			if(tY<0){return null}
			if(tX>=map.length){return null}
			if(tY>=map[tX].length){return null}
			return map[tX][tY];
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