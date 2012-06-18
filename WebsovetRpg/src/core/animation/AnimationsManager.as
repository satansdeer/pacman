package core.animation
{
	import com.demonsters.debugger.MonsterDebugger;
	
	import core.animation.VO.AnimationVO;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;
	
	public class AnimationsManager extends EventDispatcher
	{
		
		private static var _instance:AnimationsManager;
		
		private var data:Dictionary = new Dictionary();
		
		public function AnimationsManager(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public static function get instance():AnimationsManager{
			if(!_instance){
				_instance = new AnimationsManager();
			}
			return _instance;
		}
		
		public function getAnimation(animationName:String):AnimationVO{
			if(data[animationName] != undefined){
				return data[animationName];
			}else{
				throw new Error("No such animation " + animationName + " in list");
			}
		}	
		
		public function init():void{
			var request:URLRequest = new URLRequest("animations.xml");
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onLoad);
			loader.load(request);
		}
		
		protected function onLoad(event:Event):void
		{
			var xml:XML = new XML(event.target.data);
			var xmlList:XMLList = new XMLList(xml.animation);
			for(var i:int; i<xmlList.length(); i++){
				data[String(xmlList[i].@name)] = new AnimationVO();
				data[String(xmlList[i].@name)].image = xmlList[i].@image;
				data[String(xmlList[i].@name)].mask = xmlList[i].@mask;
				data[String(xmlList[i].@name)].data = xmlList[i].@data;
				MonsterDebugger.trace(this, data);
			}
			dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}