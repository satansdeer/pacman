package view.component
{
	import com.greensock.TweenMax;
	
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;

	public class Background extends Sprite
	{
		private var matrix:Matrix = new Matrix;
		
		public var color1:uint = 0x0066cc;
		public var color2:uint = 0x000000;
		private var colors:Object = {up:color1, down:color2};
		public var animate:Boolean = true;
		public function Background(){
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void{
			drawGradient();
			start();
		}
		
		private function drawGradient():void{
			matrix.createGradientBox( stage.stageWidth, stage.stageHeight, Math.PI * .5 );
			graphics.beginGradientFill( GradientType.LINEAR, [ colors.up, colors.down ], [ 1, 1 ], [ 0, 255 ], matrix );
			graphics.drawRect( 0, 0, stage.stageWidth, stage.stageHeight );
			graphics.endFill();
		}
		
		private function startAnimatingGradient():void{
			TweenMax.to(colors, 5, {hexColors:{up:color2, down:color1}, onUpdate:drawGradient, onComplete:reset});
		}
		private function resetAnimatingGradient():void{
			TweenMax.to(colors, 5, {hexColors:{up:color1, down:color2}, onUpdate:drawGradient, onComplete:start});
		}
		
		private function start():void{
			if(animate){
				startAnimatingGradient();
			}
		}
		
		private function reset():void{
			if(animate){
				resetAnimatingGradient();
			}
		}
	}
}