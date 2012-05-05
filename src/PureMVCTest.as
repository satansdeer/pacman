package{
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.filters.BlurFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.net.SharedObject;
	import flash.text.Font;
	
	import org.puremvc.as3.patterns.facade.Facade;
	
	import view.component.Background;
	import view.component.Tile;

	[SWF (width="640", height="480", frameRate="30", backgroundColor="0x006699")]
	public class PureMVCTest extends Sprite{
		private var arialFont:Class;
		public function PureMVCTest(){
			init()
		}
		
		private function init():void{
			var cookie:SharedObject = SharedObject.getLocal("pacmanRpg");
			trace(cookie.size);
			if(cookie.size == 0){
				cookie.data.Name = "PacmanRpg";
			}
			ApplicationFacade.getInstance().startup(this);
		}
	}
}