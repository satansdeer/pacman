package game {
	
	import as3isolib.display.IsoView;
	
	/**
	 * Базовый класс отображения игры, в него добавляются все сцены и бэкграунд
	 * 
	 * @author kutu
	 */
	public class SceneViewBase extends IsoView {
		
		public function SceneViewBase() {
			super();
			showBorder = false;
			clipContent = false;
			setSize(0, 0);
		}
		
	}
	
}
