package core.display {
	
	import core.event.AssetEvent;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.utils.Dictionary;
	
	[Event(name="assetLoaded", type="ru.beenza.furniture.events.FurnitureAssetEvent")]
	
	public class AssetManager extends EventDispatcher {
		
		public static var urlPrefix:String = "";
		
		private static const THREADS:uint = 3;
		private static const MAX_ATTEMPTS:uint = 3;
		private static const CACHE:Dictionary = new Dictionary();
		private static const LOADER_CONTEXT:LoaderContext = new LoaderContext(true);
		
		private static var _instance:AssetManager;
		
		private const loaders:Vector.<Loader> = new Vector.<Loader>();
		private const queues:Vector.<QueueItem> = new Vector.<QueueItem>();
		private const currentQueues:Vector.<QueueItem> = new Vector.<QueueItem>();
		
		public static function get instance():AssetManager {
			if (_instance == null) {
				_instance = new AssetManager();
			}
			return _instance;
		}
		
		public static function load(url:String):void {
			const q:QueueItem = new QueueItem();
			q.url = url;
			instance.load(q);
		}
		
		public static function existInCache(url:String):Boolean {
			return CACHE[url] != undefined;
		}
		
		public static function existInQueue(url:String):Boolean {
			var q:QueueItem;
			for each (q in instance.currentQueues) {
				if (q.url == url) return true;
			}
			for each (q in instance.queues) {
				if (q.url == url) return true;
			}
			return false;
		}
		
		public static function getImageByURL(url:String):BitmapData {
			return CACHE[url] as BitmapData;
		}
		
		public static function clearCache():void {
			for each (var q:QueueItem in instance.currentQueues) {
				if (q.loader) {
					try {
						q.loader.close();
					} catch(error:Error) {}
					instance.loaders.push(q.loader);
					q.loader = null;
				}
			}
			
			instance.currentQueues.splice(0, instance.currentQueues.length);
			instance.queues.splice(0, instance.queues.length);
			
			var bmd:BitmapData;
			for (var str:String in CACHE) {
				if (CACHE[str] && CACHE[str] is BitmapData) {
					bmd = CACHE[str] as BitmapData;
					bmd.dispose();
					bmd = null;
					CACHE[str] = undefined;
				}
			}
		}
		
		public function AssetManager() {
			init();
		}
		
		private function init():void {
			var l:Loader;
			for (var i:int = 0; i < THREADS; ++i) {
				l = new Loader();
				l.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
				l.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError);
				loaders.push(l);
			}
		}
		
		// LOADER EVENTS
		private function onComplete(event:Event):void {
			const li:LoaderInfo = event.target as LoaderInfo;
			if (li.content == null || !(li.content is Bitmap)) {
				error(li);
			} else {
				complete(li);
			}
		}
		private function onError(event:IOErrorEvent):void {
			const li:LoaderInfo = event.target as LoaderInfo;
			error(li);
		}
		
		// COMPLETE
		private function complete(li:LoaderInfo):void {
			const queueItem:QueueItem = getQueueItemByLoader(li.loader);
			if (!queueItem) return;
			
			const bmd:BitmapData = (li.content as Bitmap).bitmapData;
			CACHE[queueItem.url] = bmd;
			loaders.push(li.loader);
			
			currentQueues.splice(currentQueues.indexOf(queueItem), 1);
			dispatchEvent(new AssetEvent(AssetEvent.ASSET_LOADED, queueItem.url));
			loadNext();
		}
		// ERROR
		private function error(li:LoaderInfo):void {
			const queueItem:QueueItem = getQueueItemByLoader(li.loader);
			queueItem.attempt++;
			if (queueItem.attempt == MAX_ATTEMPTS) {
				currentQueues.splice(currentQueues.indexOf(queueItem), 1);
				queues.push(queueItem);
				loaders.push(li.loader);
				loadNext();
			} else {
				li.loader.load(new URLRequest(urlPrefix + queueItem.url), LOADER_CONTEXT);
			}
		}
		
		// LOAD NEXT
		private function loadNext():void {
			if (queues.length == 0 || loaders.length == 0) return;
			
			const queueItem:QueueItem = queues.shift();
			
			if (!existInCache(queueItem.url) && !getQueueItemByURL(queueItem.url)) {
				currentQueues.push(queueItem);
				const l:Loader = loaders.shift();
				queueItem.attempt = 0;
				queueItem.loader = l;
				l.load(new URLRequest(urlPrefix + queueItem.url), LOADER_CONTEXT);
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
		private function getQueueItemByLoader(l:Loader):QueueItem {
			for each (var q:QueueItem in currentQueues) {
				if (q.loader == l) return q;
			}
			return null;
		}

	}
	
}

import flash.display.Loader;

class QueueItem {
	
	public var url:String;
	public var attempt:uint;
	public var loader:Loader;
	
}
