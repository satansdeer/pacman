package
{
	import controller.DataCommand;
	import controller.StartupCommand;
	
	import org.puremvc.as3.interfaces.IFacade;
	import org.puremvc.as3.patterns.facade.Facade;
	
	public class ApplicationFacade extends Facade implements IFacade{
		public static const STARTUP_ACTION:String = "startupAction";
		public static const DATA_LOAD:String = "dataLoad";
		public function ApplicationFacade(){
		}
		
		public static function getInstance():ApplicationFacade
		{
			return (instance ? instance : new ApplicationFacade()) as ApplicationFacade;
		}
		
		public function startup( app:PureMVCTest ):void {
			sendNotification( STARTUP_ACTION, app );
		}
		override protected function initializeController():void {
			super.initializeController();
			registerCommand( STARTUP_ACTION, StartupCommand );
			registerCommand( DATA_LOAD, DataCommand );
		}
	}
}