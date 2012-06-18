/**
 * User: dima
 * Date: 10/02/12
 * Time: 5:19 PM
 */
package core.display {
import as3isolib.display.IsoSprite;

import flash.display.Sprite;

public class SceneSprite extends Sprite{

	private var _layerType:String;
	public var view:IsoSprite;
	
	public function SceneSprite(layerType:String) {
		_layerType = layerType;
	}

	public function get layerType():String { return _layerType; }

}
}
