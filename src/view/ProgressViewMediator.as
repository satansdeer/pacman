package view
{
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	public class ProgressViewMediator extends Mediator implements IMediator
	{
		
		public static const NAME:String = "ProgressViewMediator";
		
		private var progressView:ProgressView;
		
		public function ProgressViewMediator(viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}
		
		override public function listNotificationInterests():Array
		{
			return [
				ProgressView.SHOW,
				ProgressView.HIDE,
				ProgressView.UPDATE
			];
		}
		
		override public function handleNotification(notification:INotification):void
		{
			var name:String = notification.getName();
			var body:Object = notification.getBody();
			
			switch ( name )
			{
				case ProgressView.SHOW:
					progressView.show();
					
					break;
				
				case ProgressView.HIDE:
					progressView.hide();
					
					break;
				
				case ProgressView.UPDATE:
					progressView.update( body.percent );
					
					break;
			}
		}
		
		override public function onRegister():void
		{
			progressView = new ProgressView();
			
			viewComponent.addChild( progressView );
		}
	}
}