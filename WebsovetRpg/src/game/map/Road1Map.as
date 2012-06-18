package game.map
{
	/**
	 * RoadsMap
	 * @author satansdeer
	 */
	import as3isolib.display.IsoSprite;
	
	import core.component.MapObjectPreloader;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	import game.GameView;
	import core.enum.ScenesENUM;
	
	public class Road1Map extends MapBase{
		
		
		private var _map:Array;
		private var tiles:Array = [];
		
		[Embed(source="assets/tile_road_1_dldr.png")]			private static const FloorPNG:Class;
		
		private static const floorBmd:BitmapData		= (new FloorPNG() as Bitmap).bitmapData;
		
		public function Road1Map(gameView:GameView)
		{
			super(gameView);
			_scene = _gameView.getScene(ScenesENUM.ROAD_1);
			//_map = MapLoader.mapFromFile("/Users/satansdeer/Workspace/cityville-disney/src/map.xml");
			makeTileMap();
		}
		
		private function makeTileMap():void {
			var tile:IsoSprite;
			var bmp:MapObjectPreloader;
			for(var x:int = 0; x < _map.length; x++){
				for(var y:int = 0; y < _map[x].length; y++){
					tile = new IsoSprite();
					tile.setSize(Main.UNIT_SIZE, Main.UNIT_SIZE, 0);
					tile.moveTo(x * Main.UNIT_SIZE, y * Main.UNIT_SIZE, 0);
					tile.data = {x:x, y:y}
					bmp = new MapObjectPreloader(1,1);
					bmp.x = 32;
					tile.container.addChild(bmp);
					_scene.addChild(tile);
					tile.render();
					tiles.push(tile);
				}
			}
		}
	}
}