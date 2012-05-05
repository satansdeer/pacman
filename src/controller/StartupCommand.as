package controller
{
	import model.DataProxy;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import view.ApplicationMediator;
	
	public class StartupCommand extends SimpleCommand implements ICommand
	{
		override public function execute(notification:INotification):void{
			facade.registerProxy( new DataProxy() );
			
			facade.registerMediator( new ApplicationMediator( notification.getBody() as PureMVCTest) );
		}
	}
}