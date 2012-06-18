package game.events
{
	/**
	 * GameViewEvent
	 * @author satansdeer
	 */
	import flash.events.Event;
	
	public class GameViewEvent extends Event{
		public static var MOVE:String = "game_view_move";
		public function GameViewEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}