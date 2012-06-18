package core.animation
{
	import com.demonsters.debugger.MonsterDebugger;
	
	import core.animation.VO.AnimationDataVO;
	import core.event.AssetEvent;
	
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.Dictionary;
	
	import net.tautausan.plist.Plist10;

	public class AnimationsDataHolder extends EventDispatcher
	{
		
		private var data:Dictionary = new Dictionary;
		
		public static var urlPrefix:String = "";
		
		private static const THREADS:uint = 3;
		private static const MAX_ATTEMPTS:uint = 3;
		
		private const loaders:Vector.<URLLoader> = new Vector.<URLLoader>();
		private const queues:Vector.<QueueItem> = new Vector.<QueueItem>();
		private const currentQueues:Vector.<QueueItem> = new Vector.<QueueItem>();
		
		private static var _instance:AnimationsDataHolder;
		
		public function AnimationsDataHolder()
		{
			init();
		}
		
		public static function load(url:String):void {
			const q:QueueItem = new QueueItem();
			q.url = url;
			instance.load(q);
		}
		
		public static function get instance():AnimationsDataHolder{
			if(!_instance){
				_instance = new AnimationsDataHolder();
			}
			return _instance;
		}
		
		public function existInCache(animationName:String):Boolean{
			return data[animationName] != undefined;
		}
		
		public function existInQueue(url:String):Boolean {
			var q:QueueItem;
			for each (q in instance.currentQueues) {
				if (q.url == url) return true;
			}
			for each (q in instance.queues) {
				if (q.url == url) return true;
			}
			return false;
		}
		
		public function getAnimationData(animationName:String):AnimationDataVO{
			return data[animationName] as AnimationDataVO;
		}
		
		private function addAnimationData(animationName:String, animationPlist:Object):void{
			var frame:int;
			data[animationName] = new AnimationDataVO();
			if(animationPlist.hasOwnProperty("frameDuration")){
				data[animationName].frameDuration = animationPlist.frameDuration;
			}
			for (var i:String in animationPlist.frames){
				frame = int(i.slice(0, i.indexOf(".")));
				(data[animationName] as AnimationDataVO).frames[frame] = animationPlist.frames[i];
			}
		}
		
		private function init():void {
			var l:URLLoader;
			for (var i:int = 0; i < THREADS; ++i) {
				l = new URLLoader();
				l.addEventListener(Event.COMPLETE, onComplete);
				l.addEventListener(IOErrorEvent.IO_ERROR, onError);
				loaders.push(l);
			}
		}
		
		// LOADER EVENTS
		private function onComplete(event:Event):void {
			complete(event.target)
		}
		private function onError(event:IOErrorEvent):void {
			const li:Object = event.target;
			error(li);
		}
		
		// COMPLETE
		private function complete(li:Object):void {
			const queueItem:QueueItem = getQueueItemByLoader(li as URLLoader);
			if (!queueItem) return;
			
			var parser:PListParser = new PListParser();
			var xml:XML = new XML(li.data);
			var plist:Object = parser.parsePList(new XMLList(xml));
			addAnimationData(queueItem.url, plist); 
			loaders.push(li as URLLoader);
			
			currentQueues.splice(currentQueues.indexOf(queueItem), 1);
			dispatchEvent(new AssetEvent(AssetEvent.ASSET_LOADED, queueItem.url));
			loadNext();
		}
		// ERROR
		private function error(li:Object):void {
			const queueItem:QueueItem = getQueueItemByLoader(li as URLLoader);
			queueItem.attempt++;
			if (queueItem.attempt == MAX_ATTEMPTS) {
				currentQueues.splice(currentQueues.indexOf(queueItem), 1);
				queues.push(queueItem);
				loaders.push(li.loader);
				loadNext();
			} else {
				(li as URLLoader).load(new URLRequest(urlPrefix + queueItem.url));
			}
		}
		
		
		// LOAD NEXT
		private function loadNext():void {
			if (queues.length == 0 || loaders.length == 0) return;
			
			const queueItem:QueueItem = queues.shift();
			
			if (!existInCache(queueItem.url) && !getQueueItemByURL(queueItem.url)) {
				currentQueues.push(queueItem);
				const l:URLLoader = loaders.shift();
				queueItem.attempt = 0;
				queueItem.loader = l;
				l.load(new URLRequest(urlPrefix + queueItem.url));
			}
			
			if (loaders.length > 0) loadNext();
		}
		
		// LOAD
		private function load(queueItem:QueueItem):void {
			queues.push(queueItem);
			if (queues.length == 1) loadNext();
		}
		
		private function getQueueItemByURL(url:String):QueueItem {
			for each (var q:QueueItem in currentQueues) {
				if (q.url == url) return q;
			}
			return null;
		}
		private function getQueueItemByLoader(l:URLLoader):QueueItem {
			for each (var q:QueueItem in currentQueues) {
				if (q.loader == l) return q;
			}
			return null;
		}
	}
}
import flash.net.URLLoader;

class QueueItem {
	
	public var url:String;
	public var attempt:uint;
	public var loader:URLLoader;
	
}