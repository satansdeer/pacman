package model
{
	
	import model.vo.DataVO;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class DataProxy extends Proxy implements IProxy
	{
		public static const NAME:String                         = 'DataProxy';
		
		public function DataProxy()
		{
			super( NAME, new DataVO() );
		}
		
	}
}