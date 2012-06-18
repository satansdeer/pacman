package game.map
{
	import as3isolib.display.scene.IsoScene;
	import as3isolib.geom.Pt;
	
	import flash.display.Stage;
	import flash.geom.Point;
	
	import game.GameView;
	
	import org.casalib.util.StageReference;

	public class MapBase
	{
		protected var _gameView:GameView;
		protected var _scene:IsoScene;
		
		protected var tempTile:Tile;
		
		protected var tempTiles:Vector.<Tile> = new Vector.<Tile>;
		protected var tempNewShownTiles:Vector.<Tile> = new Vector.<Tile>;
		
		protected var _tempMap:Vector.<Vector.<Tile>>;
		
		protected var _stage:Stage;
		
		public function MapBase(gameView:GameView)
		{
			_gameView = gameView;
			_stage = StageReference.getStage();
		}
	}
}