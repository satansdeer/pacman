package core.animation
{
	import com.demonsters.debugger.MonsterDebugger;
	
	import core.animation.VO.AnimationVO;
	import core.display.AssetManager;
	import core.display.InteractivePNG;
	import core.event.AssetEvent;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	
	public class Animation extends Sprite
	{
		
		private var canvas:Bitmap;
		
		private var data:Object;
		private var imageBmd:BitmapData;
		private var maskBmd:BitmapData;
		
		private var dataUrl:String;
		private var imageUrl:String;
		private var maskUrl:String;
		
		private var dataLoaded:Boolean = true;
		private var imageLoaded:Boolean = true;
		private var maskLoaded:Boolean = true;
		
		private var maskNeeded:Boolean = true;
		
		public var currentFrame:int = 1;
		
		public function Animation()
		{
			super();
		}
		
		public function playAnimation(animationVO:AnimationVO):void{
			dataUrl = animationVO.data;
			if(AnimationsDataHolder.instance.existInCache(animationVO.data)){
				data = AnimationsDataHolder.instance.getAnimationData(animationVO.data);
			}else{
				dataLoaded = false;
				AnimationsDataHolder.instance.addEventListener(AssetEvent.ASSET_LOADED, onDataLoaded);
				if(!AnimationsDataHolder.instance.existInQueue(animationVO.data)){
					AnimationsDataHolder.load(animationVO.data);
				}
			}
			imageUrl = animationVO.image;
			if(AssetManager.existInCache(imageUrl)){
				imageBmd = AssetManager.getImageByURL(imageUrl);
			}else{
				imageLoaded = false;
				AssetManager.instance.addEventListener(AssetEvent.ASSET_LOADED, onImageLoaded);
				if(!AssetManager.existInQueue(imageUrl)){
					AssetManager.load(animationVO.image);
				}
			}
			if(animationVO.mask != "none"){
				maskUrl = animationVO.mask;
				if(AssetManager.existInCache(imageUrl)){
					maskBmd = AssetManager.getImageByURL(maskUrl);
				}else{
					maskLoaded = false;
					AssetManager.instance.addEventListener(AssetEvent.ASSET_LOADED, onMaskLoaded);
					if(!AssetManager.existInQueue(maskUrl)){
						AssetManager.load(animationVO.mask);
					}
				}
			}else{
				maskNeeded = false;
			}
		}
		
		protected function onMaskLoaded(event:AssetEvent):void
		{
			if(event.url == maskUrl){
				maskLoaded = true;
				maskBmd = AssetManager.getImageByURL(maskUrl);
				AnimationsDataHolder.instance.removeEventListener(AssetEvent.ASSET_LOADED, onImageLoaded);
				if(dataLoaded && imageLoaded){
					animate();
				}
			}
		}
		
		
		protected function onImageLoaded(event:AssetEvent):void
		{
			if(event.url == imageUrl){
				imageLoaded = true;
				imageBmd = AssetManager.getImageByURL(imageUrl);
				AnimationsDataHolder.instance.removeEventListener(AssetEvent.ASSET_LOADED, onImageLoaded);
				if(dataLoaded && (maskLoaded || !maskNeeded)){
					animate();
				}
			}
		}
		
		protected function onDataLoaded(event:AssetEvent):void
		{
			if(event.url == dataUrl){
				dataLoaded = true;
				data = AnimationsDataHolder.instance.getAnimationData(dataUrl);
				AnimationsDataHolder.instance.removeEventListener(AssetEvent.ASSET_LOADED, onDataLoaded);
				if(imageLoaded && (maskLoaded || !maskNeeded)){
					animate();
				}
			}	
		}
		
		private function animate():void
		{
			MonsterDebugger.trace(this, data);
			canvas = new Bitmap(new BitmapData( data.frames[currentFrame].width, data.frames[currentFrame].height));
			addEventListener(Event.ENTER_FRAME, update);
			addChild(canvas);
		}
		
		protected function update(event:Event):void
		{
			removeChild(canvas);
			canvas = new Bitmap(new BitmapData( data.frames[currentFrame].width, data.frames[currentFrame].height));
			canvas.bitmapData.lock();
			canvas.bitmapData.fillRect(new Rectangle(0,0,data.frames[currentFrame].width, data.frames[currentFrame].height), 0xffffff);
			canvas.bitmapData.copyPixels(imageBmd, new Rectangle(data.frames[currentFrame].x,0,data.frames[currentFrame].width, data.frames[currentFrame].height),new Point(0,0));
			canvas.bitmapData.unlock();
			addChild(canvas);
			currentFrame++;
			if(currentFrame > 10){
				currentFrame = 1;
			}
		}
	}
}