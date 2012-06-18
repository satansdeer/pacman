package game.map
{
	/**
	 * MapLoader
	 * @author satansdeer
	 */
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class MapLoader extends EventDispatcher{
		
		public static var map:Vector.<Vector.<Tile>>;
		
		private static var _instance:MapLoader;
		
		public function MapLoader(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public static function get instance():MapLoader{
			if(!_instance){
				_instance = new MapLoader();
			}
			return _instance;
		}
		
		public static function mapFromFile():void{
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onMapLoaded);
			loader.load(new URLRequest("data/map.xml"));
		}
		
		protected static function onMapLoaded(event:Event):void{
			var mapXml:XML = new XML(event.target.data);
			var output:Vector.<Vector.<Tile>> = new Vector.<Vector.<Tile>>(mapXml.@width, true);
			var k:int;
			if(mapXml){
				map = new Vector.<Vector.<Tile>>(mapXml.@width, true);
				for (var i:int = 0; i < mapXml.@width; i++){
					map[i] = new Vector.<Tile>(mapXml.@height, true);
					for(var j:int = 0; j < mapXml.@height; j++){
						k++;
						map[i][j] = new Tile(i,j, mapXml.tile[k], null);
					}
				}
			}
			instance.dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}