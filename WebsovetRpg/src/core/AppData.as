package core
{
	import flash.events.Event;
	import flash.events.EventDispatcher;

	/**
	 * AppData
	 * @author satansdeer
	 */
	public class AppData extends EventDispatcher{
		
		private static var _objects:XML;
		private static var _options:XML;
		private static var _objectsMap:XML;
		private static var _groundMap:XML;
		
		
		private static var _instance:AppData;
		
		public static const OBJECTS_MAP_LOADED:String = "objects_map_loaded";
		public static var GROUND_MAP_LOADED:String = "ground_map_loaded";
		
		public function AppData()
		{
			_instance = this;
		}
		
		public static function get instance():AppData{
			if(!_instance){
				_instance = new AppData();
			}
			return _instance;
		}
		
		public static function get objects():XML{
			return _objects;
		}
		
		public static function get objectsMap():XML{
			return _objectsMap;
		}
		
		public static function get groundMap():XML{
			return _groundMap;
		}
		
		public static function set objectsMap(value:XML):void{
			_objectsMap = value;
			_instance.dispatchEvent(new Event(AppData.OBJECTS_MAP_LOADED));
		}
		
		public static function set groundMap(value:XML):void{
			_objects = value;
			_instance.dispatchEvent(new Event(AppData.GROUND_MAP_LOADED));
		}
		
		public static function set objects(value:XML):void{
			_objects = value;
			_instance.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public static function get options():XML{
			return _options;
		}
		
		public static function set options(value:XML):void{
			_options = value;
			_instance.dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}