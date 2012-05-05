package view.component
{
	import flash.display.Sprite;
	import flash.filters.BlurFilter;
	import flash.utils.Dictionary;
	
	public class Tile extends Sprite
	{
		
		public static const TOP_LEFT_CORNER:String = "top_left_corner";
		public static const TOP_RIGHT_CORNER:String = "top_right_corner";
		public static const BOTTOM_LEFT_CORNER:String = "bottom_left_corner";
		public static const BOTTOM_RIGHT_CORNER:String = "bottom_right_corner";
		
		public static const T_TILE_LEFT:String = "t_tile_left";
		public static const T_TILE_RIGHT:String = "t_tile_right";
		public static const T_TILE_UP:String = "t_tile_up";
		public static const T_TILE_DOWN:String = "t_tile_down";
		
		public static const CROSS_TILE:String = "cross_tile";
		
		public static const VERTICAL_TILE:String = "vertical_tile";
		public static const HORISONTAL_TILE:String = "horisontal_tile";
		
		public function Tile()
		{
			super();
		}
		
		public static function createTile(type:String, color:uint = 0xffffff):Tile{
			var returnTile:Tile;
				returnTile = new Tile();
				returnTile.graphics.lineStyle(2,color);
				returnTile.filters = [new BlurFilter()]
				switch(type){
					case TOP_LEFT_CORNER:
						returnTile.graphics.moveTo(13,32);
						returnTile.graphics.lineTo(13,13);
						returnTile.graphics.lineTo(32,13);
						returnTile.graphics.moveTo(19,32);
						returnTile.graphics.lineTo(19,19);
						returnTile.graphics.lineTo(32,19);
						break;
					case TOP_RIGHT_CORNER:
						returnTile.graphics.moveTo(13,32);
						returnTile.graphics.lineTo(13,19);
						returnTile.graphics.lineTo(0,19);
						returnTile.graphics.moveTo(19,32);
						returnTile.graphics.lineTo(19,13);
						returnTile.graphics.lineTo(0,13);
						break;
					case BOTTOM_LEFT_CORNER:
						returnTile.graphics.moveTo(13,0);
						returnTile.graphics.lineTo(13,19);
						returnTile.graphics.lineTo(32,19);
						returnTile.graphics.moveTo(19,0);
						returnTile.graphics.lineTo(19,13);
						returnTile.graphics.lineTo(32,13);
						break;
					case BOTTOM_RIGHT_CORNER:
						returnTile.graphics.moveTo(13,0);
						returnTile.graphics.lineTo(13,13);
						returnTile.graphics.lineTo(0,13);
						returnTile.graphics.moveTo(19,0);
						returnTile.graphics.lineTo(19,19);
						returnTile.graphics.lineTo(0,19);
						break;
					case T_TILE_RIGHT:
						returnTile.graphics.moveTo(13,0);
						returnTile.graphics.lineTo(13,32);
						returnTile.graphics.moveTo(19,0);
						returnTile.graphics.lineTo(19,13);
						returnTile.graphics.lineTo(32,13);
						returnTile.graphics.moveTo(19,32);
						returnTile.graphics.lineTo(19,19);
						returnTile.graphics.lineTo(32,19);
						break;
					case T_TILE_LEFT:
						returnTile.graphics.moveTo(19,0);
						returnTile.graphics.lineTo(19,32);
						returnTile.graphics.moveTo(13,0);
						returnTile.graphics.lineTo(13,13);
						returnTile.graphics.lineTo(0,13);
						returnTile.graphics.moveTo(13,32);
						returnTile.graphics.lineTo(13,19);
						returnTile.graphics.lineTo(0,19);
						break;
					case T_TILE_UP:
						returnTile.graphics.moveTo(0,19);
						returnTile.graphics.lineTo(32,19);
						returnTile.graphics.moveTo(0,13);
						returnTile.graphics.lineTo(13,13);
						returnTile.graphics.lineTo(13,0);
						returnTile.graphics.moveTo(32,13);
						returnTile.graphics.lineTo(19,13);
						returnTile.graphics.lineTo(19,0);
						break;
					case T_TILE_DOWN:
						returnTile.graphics.moveTo(0,13);
						returnTile.graphics.lineTo(32,13);
						returnTile.graphics.moveTo(0,19);
						returnTile.graphics.lineTo(13,19);
						returnTile.graphics.lineTo(13,32);
						returnTile.graphics.moveTo(32,19);
						returnTile.graphics.lineTo(19,19);
						returnTile.graphics.lineTo(19,32);
						break;
					case CROSS_TILE:
						returnTile.graphics.moveTo(0,13);
						returnTile.graphics.lineTo(13,13);
						returnTile.graphics.lineTo(13,0);
						returnTile.graphics.moveTo(19,0);
						returnTile.graphics.lineTo(19,13);
						returnTile.graphics.lineTo(32,13);
						returnTile.graphics.moveTo(32,19);
						returnTile.graphics.lineTo(19,19);
						returnTile.graphics.lineTo(19,32);
						returnTile.graphics.moveTo(13,32);
						returnTile.graphics.lineTo(13,19);
						returnTile.graphics.lineTo(0,19);
						break;
					case HORISONTAL_TILE:
						returnTile.graphics.moveTo(0,13);
						returnTile.graphics.lineTo(32,13);
						returnTile.graphics.moveTo(0,19);
						returnTile.graphics.lineTo(32,19);
						break;
					case VERTICAL_TILE:
						returnTile.graphics.moveTo(13,0);
						returnTile.graphics.lineTo(13,32);
						returnTile.graphics.moveTo(19,0);
						returnTile.graphics.lineTo(19,32);
						break;
					default:
						break;
			}
			return returnTile;
		}
	}
}