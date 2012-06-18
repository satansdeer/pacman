package core
{
	/**
	 * FpsMeter
	 * @author satansdeer
	 */
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.getTimer;
	
	import org.casalib.util.StageReference;
	
	public class FpsMeter extends EventDispatcher{
		
		public var fps:int;
		private var frames:int;
		private var time:int;
		private var prevTime:int;
		
		private static var _instance:FpsMeter;
		public function FpsMeter(target:IEventDispatcher=null)
		{
			super(target);
			prevTime = getTimer();
			StageReference.getStage().addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		public static function get instance():FpsMeter{
			if(!_instance){
				_instance = new FpsMeter();
			}
			return _instance;
		}
		
		protected function onEnterFrame(event:Event):void{
			time = getTimer();
			frames++;
			if(time - prevTime >= 1000){
				prevTime = getTimer();
				fps =  frames;
				frames = 0;
				dispatchEvent(new Event(Event.CHANGE));
			}
		}
	}
}