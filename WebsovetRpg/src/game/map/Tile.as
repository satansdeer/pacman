/**
 * User: dima
 * Date: 16/02/12
 * Time: 12:18 PM
 */
package game.map {
import as3isolib.display.IsoSprite;
import as3isolib.display.scene.IsoScene;

import core.component.MapObjectPreloader;
import core.display.AssetManager;
import core.display.InteractivePNG;
import core.display.SceneSprite;
import core.event.AssetEvent;
import core.layer.LayersENUM;

import flash.display.Sprite;

public class Tile {
	
	public var shown:Boolean = false;
	
	private var _x:int;
	private var _y:int;
	private var _url:String;
	private var _scene:IsoScene;
	private var _preloader:MapObjectPreloader;
	
	private var img:InteractivePNG;
	
	public var isoSprite:IsoSprite;
	
	public function Tile(x:Number, y:Number, url:String, scene:IsoScene) {
		_x = x;
		_y = y;
		_url = url;
	}
	
	public function get x():int{
		return _x;
	}
	
	public function get y():int{
		return _y;
	}
	
	public function remove():void{
		AssetManager.instance.removeEventListener(AssetEvent.ASSET_LOADED, onAssetLoaded);
	}
	
	public function draw():void{
		isoSprite = new IsoSprite();
		isoSprite.setSize(Main.UNIT_SIZE, Main.UNIT_SIZE, 0);
		isoSprite.data = {x:_x, y:_y}
		if(AssetManager.getImageByURL(_url)){
			setImg();
		}else{
			AssetManager.load(_url);
			AssetManager.instance.addEventListener(AssetEvent.ASSET_LOADED, onAssetLoaded);
			_preloader = new MapObjectPreloader(1, 1);
			_preloader.x = Main.UNIT_SIZE;
			isoSprite.container.addChild(_preloader);
		}
	}
	
	protected function onAssetLoaded(event:AssetEvent):void{
		if(_url == event.url){
			AssetManager.instance.removeEventListener(AssetEvent.ASSET_LOADED, onAssetLoaded);
			setImg();
			if(_preloader && isoSprite.container.contains(_preloader)){
				isoSprite.container.removeChild(_preloader);
				_preloader = null;
			}
		}
	}
	
	private function setImg():void{
		img = new InteractivePNG(AssetManager.getImageByURL(_url));
		img.cacheAsBitmap = true;
		img.mouseEnabled = false;
		isoSprite.container.addChild(img);
	}

}
}
