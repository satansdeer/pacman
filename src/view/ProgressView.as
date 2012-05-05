package view
{
	import com.greensock.TweenLite;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import view.component.Tile;
	
	public class ProgressView extends Sprite
	{
		public static const NAME:String                         = 'ProgressView';
		
		public static const SHOW:String                         = NAME + 'Show';
		public static const HIDE:String                         = NAME + 'Hide';
		public static const UPDATE:String                       = NAME + 'Update';
		
		private var textField:TextField;
		
		public function ProgressView()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		protected function onAddedToStage(event:Event):void
		{
			init();
		}
		private function init():void
		{
			var textFormat:TextFormat = new TextFormat();
			
			textFormat.color = 0xFFFFFF;
			textFormat.font = 'Arial';
			
			textField = new TextField();
			
			textField.autoSize = TextFieldAutoSize.CENTER;
			textField.defaultTextFormat = textFormat;
			textField.text = 'Please wait...';
			textField.x = stage.stageWidth/2 - ( textField.width / 2 );
			textField.y = stage.stageHeight/2 - ( textField.height / 2 );
			
			addChild( textField );
		}
		
		public function show():void
		{
			textField.text = 'Please wait...';
			
			TweenLite.to( this, .5, { alpha: 1 } );
		}
		
		public function hide():void
		{
			TweenLite.to( this, .5, { alpha: 0 } );
		}
		
		public function update(percent:Number):void
		{
			textField.text = 'Loaded ' + percent + '%';
		}
	}
}