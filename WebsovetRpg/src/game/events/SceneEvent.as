package game.events {
import flash.events.Event;

public class SceneEvent extends Event{
	public var reason:String;

	public static const NORMAL:String = "normalReason";

	public static const WANT_REMOVE:String = "wantRemove";
	public function SceneEvent(type:String, reason:String = NORMAL) {
		super(type);
		this.reason = reason;
	}
}
}
