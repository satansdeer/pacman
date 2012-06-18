package game {
	
	import as3isolib.core.IFactory;
	import as3isolib.display.renderers.SimpleSceneLayoutRenderer;
	import as3isolib.display.scene.IsoScene;
	import as3isolib.geom.IsoMath;
	import as3isolib.geom.Pt;
	
	import flash.display.Bitmap;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import game.events.GameViewEvent;
	
	import org.casalib.util.StageReference;
	
	/**
	 * @author SatansDeer
	 */
	public class GameView extends SceneViewBase {
		
		private static const SCREEN_WIDTH:int = 700;
		private static const SCREEN_HEIGHT:int = 670;
		
		[Embed(source="Остров 1.png")] private static const Infrastructure:Class;
		
		public static var unitSize:uint;
		
		public var velosity_force:Number = .8;
		
		private static var _instance:GameView;
		
		private var curX:Number = 0;
		private var curY:Number = 0;
		
		private const velosity:Point = new Point();
		private const prevPoint:Point = new Point();
		private const currentPoint:Point = new Point();
		private const bounds:Point = new Point();
		
		private var drag:Boolean;
		private var renderOnNextFrame:Boolean;
		
		private var _isoScenes:Dictionary = new Dictionary();
		private var prevPt:Pt;
		private var curPt:Pt;
		private var curPoint:Point;
		
		private var curUnitPoint:Point = new Point();
		private var prevUnitPoint:Point = new Point();
		
		public function GameView(unitSize:uint) {
			super();
			unitSize = unitSize;
			_instance = this;
			autoUpdate = true;
			rangeOfMotionTarget = backgroundContainer;
			setSize(StageReference.getStage().stageWidth, StageReference.getStage().stageHeight);
			var bmp:Bitmap = new Infrastructure();
			backgroundContainer.addChild(bmp);
			addListeners();
			panTo(500, 500);
			render(true);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Public Functions
		//
		//--------------------------------------------------------------------------
		
		
		override public function render(recursive:Boolean=false):void {
			renderOnNextFrame = true;
		}
		
		/**
		 * Создает и добавляет новую сцену
		 * @param sceneName название сцены
		 */
		public function addSceneWithName(sceneName:String):void{
			if (!sceneName) {
				throw new Error("layerName must be non null");
			}
			if (sceneName in _isoScenes) {
				throw new Error("layer with name '" + sceneName + "' already exists");
			}
			const scene:IsoScene = new IsoScene();
			_isoScenes[sceneName] = scene;
			addScene(scene);
		}
		
		/**
		 * Возвращает сцену по ее имени
		 * @param sceneName название сцены
		 * @return возвращает сцену
		 */
		public function getScene(sceneName:String):IsoScene {
			const scene:IsoScene = getSceneByName(sceneName);
			return scene;
		}
		
		public function fullscreen():void{
			if(stage){
				if (stage.displayState == StageDisplayState.NORMAL) {
					stage.displayState=StageDisplayState.FULL_SCREEN;
				} else {
					stage.displayState=StageDisplayState.NORMAL;
				}
			}
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Private Functions
		//
		//--------------------------------------------------------------------------
		
		
		private function addListeners():void{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStageInit);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		protected function onMouseWheel(event:MouseEvent):void{
			zoom(currentZoom + 0.1 * event.delta);
		}
		
		private function onFullscreen(event:Event):void{
			recountBounds();
		}
		
		private function onAddedToStageInit(event:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStageInit);
			recountBounds();
		}
		
		private function recountBounds():void{
			bounds.x = -mainContainer.width + stage.stageWidth;
			bounds.y = -mainContainer.height + stage.stageHeight;
		}
		
		private function onAddedToStage(event:Event):void {
			stage.addEventListener(Event.RESIZE, onFullscreen);
			addEventListener(MouseEvent.MOUSE_DOWN, onViewDown);
			addEventListener(MouseEvent.CLICK, onViewClick, false, 1);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
		}
		
		private function onRemovedFromStage(event:Event):void {
			removeEventListener(MouseEvent.MOUSE_DOWN, onViewDown);
			removeEventListener(MouseEvent.CLICK, onViewClick);
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			if (drag) {
				drag = false;
				stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			}
		}
		private function moveView():void {
			if (Math.abs(velosity.x) >= currentZoom) {
				velosity.x *= velosity_force;
			}else{
				velosity.x = 0;
			}
			if (Math.abs(velosity.y) >= currentZoom) {
				velosity.y *= velosity_force;	
			}else{
				velosity.y = 0;
			}
			if((velosity.x != 0) || (velosity.y !=0)){
				panBy(velosity.x, velosity.y);
				render(true);
				validatePosition();
				curUnitPoint.x = int(currentX/WebsovetRpg.UNIT_SIZE);
				curUnitPoint.y = int(currentY/WebsovetRpg.UNIT_SIZE);
				if((curUnitPoint.x != prevUnitPoint.x) || (curUnitPoint.y != prevUnitPoint.y)){
					dispatchEvent(new GameViewEvent(GameViewEvent.MOVE));
				}
				prevUnitPoint.x = curUnitPoint.x;
				prevUnitPoint.y = curUnitPoint.y;
			}
		}
		
		private function onViewDown(event:MouseEvent):void {
			drag = true;
			currentPoint.x = mouseX + currentX;	
			currentPoint.y = mouseY + currentY;
			prevPt = localToIso(new Point(mouseX, mouseY));
			prevPoint.x = stage.mouseX;
			prevPoint.y = stage.mouseY;
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		private function onViewClick(event:MouseEvent):void {
			// останавлиавем событие если мы хотели просто передвинуть сцену, а не отправить резидента в путь
			if (stage && (Math.abs(prevPoint.x - stage.mouseX) > 2 || Math.abs(prevPoint.y - stage.mouseY) > 2)) {
				event.stopImmediatePropagation();
				event.stopPropagation();
			}
		}
		
		private function onMouseUp(event:MouseEvent):void {
			if (stage) {
				stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			}
			drag = false;
		}
		
		
		private function onEnterFrame(event:Event):void {
			if (drag) {
				if(!curPoint){
					curPoint = new Point();
				}
				curPoint.x = mouseX;
				curPoint.y = mouseY;
				curPt = localToIso(curPoint);
				velosity.x = ((currentPoint.x - curPoint.x) - currentX);
				velosity.y = ((currentPoint.y - curPoint.y) - currentY);
			}
			if(velosity.x != 0 || velosity.y != 0){
				moveView();
			}
		}
		
		private function getSceneByName(scaneName:String):IsoScene {
			if (!scaneName) {
				throw new Error("sceneName must be non null");
			}
			if (!(scaneName in _isoScenes)) {
				throw new Error("scane with name '" + scaneName + "' does not exists");
			}
			const scene:IsoScene = _isoScenes[scaneName] as IsoScene;
			if (!scene) {
				throw new Error("scene '" + scaneName + "' is null");
			}
			return scene;
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Getters / Setters
		//
		//--------------------------------------------------------------------------
		
		public static function get instance():GameView { return _instance; }
		
		
		
		public function resize():void {
			setSize(StageReference.getStage().stageWidth, StageReference.getStage().stageHeight);
		}
	}
	
}
