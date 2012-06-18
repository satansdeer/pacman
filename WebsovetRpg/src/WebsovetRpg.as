package
{
	import com.demonsters.debugger.MonsterDebugger;
	
	import core.animation.Animation;
	import core.animation.AnimationsDataHolder;
	import core.animation.AnimationsManager;
	import core.enum.ScenesENUM;
	import core.layer.LayersENUM;
	import core.window.WindowManager;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import game.GameView;
	
	import org.casalib.util.StageReference;
	
	import ru.beenza.framework.layers.LayerManager;
	
	[SWF(width=800, height=730, frameRate=23, backgroundColor="0xFFFFFF")]
	public class WebsovetRpg extends Sprite
	{
		public static const APP_WIDTH:int = 800;
		public static const APP_HEIGHT:int = 730;
		public static const UNIT_SIZE:int = 32;
		
		private var _gameView:GameView;
		
		
		public function WebsovetRpg()
		{
			MonsterDebugger.initialize(this);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		protected function onAddedToStage(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			StageReference.setStage(stage);
			stage.addEventListener(Event.RESIZE, onStageResize);
			
			initLayers();
			initWindows();
			initScenes();
			
			AnimationsManager.instance.init();
			AnimationsManager.instance.addEventListener(Event.COMPLETE, onAnimationsListGet);
		}
		
		protected function onAnimationsListGet(event:Event):void
		{
			var animation:Animation = new Animation();
			animation.playAnimation(AnimationsManager.instance.getAnimation("beaver"))
			LayerManager.getLayer(LayersENUM.CURSOR).addChild(animation);
		}
		
		private function initScenes():void
		{
			_gameView = new GameView(UNIT_SIZE);
			_gameView.addSceneWithName(ScenesENUM.BACKGROUND);
			_gameView.addSceneWithName(ScenesENUM.GROUND);
			_gameView.addSceneWithName(ScenesENUM.GRID);
			_gameView.addSceneWithName(ScenesENUM.OBJECTS);
			_gameView.addSceneWithName(ScenesENUM.FOG);
			_gameView.addSceneWithName(ScenesENUM.HIDDEN_OBJECTS);
			LayerManager.getLayer(LayersENUM.SCENE).addChild(_gameView);
		}
		
		private function initWindows():void
		{
			WindowManager.instance.layer = LayerManager.getLayer(LayersENUM.WINDOWS);
		}
		
		private function initLayers():void
		{
			LayerManager.init();
			LayerManager.addLayer(LayersENUM.SCENE);
			LayerManager.addLayer(LayersENUM.ICONS);
			LayerManager.addLayer(LayersENUM.INTERFACE);
			LayerManager.addLayer(LayersENUM.WINDOWS);
			LayerManager.addLayer(LayersENUM.CURSOR);
			addChild(LayerManager.appLayer);	
		}
		
		protected function onStageResize(event:Event):void
		{
			
		}
	}
}