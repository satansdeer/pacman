/**
 * User: dima
 * Date: 11/01/12
 * Time: 12:28 PM
 */
package game.world {
import flash.events.Event;
import flash.events.EventDispatcher;

public class GameWorld extends EventDispatcher{
	private static var _instance:GameWorld;

	public static function get instance():GameWorld {
		if (!_instance) { _instance = new GameWorld(); }
		return _instance;
	}

	public function GameWorld() {
		super();
	}

}
}
