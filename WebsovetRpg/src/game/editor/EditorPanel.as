/**
 * User: dima
 * Date: 16/02/12
 * Time: 12:47 PM
 */
package game.editor {
import core.component.NavigatorBase;
import core.display.SceneSprite;

public class EditorPanel extends NavigatorBase{
	private static const PANEL_WIDTH:Number = 400;
	private static const PANEL_HEIGHT:Number = 100;

	public function EditorPanel() {
		super();
		defaultItemWidth = 100;
		defaultItemHeight = 100;
		numColumns = 4;
		drawInterface();
	}

	/* API */

	override public function addItem(component:SceneSprite):void {
		super.addItem(component);
		pushChild(component);
	}

	override public function removeItem(component:SceneSprite):void {
		super.removeItem(component);
		pullChild(component);
	}

	public function moveToRight(y:Number = 0):void {
		this.x = Main.APP_WIDTH - this.width;
		this.y = y;
	}

	public function moveToTop(x:Number = 0):void {
		this.x = x;
		this.y = PANEL_HEIGHT/2;
	}

	/* Internal functions */

	private function drawInterface():void {
		this.graphics.lineStyle(1, 0xaacc00);
		this.graphics.drawRect(0, -PANEL_HEIGHT/2, PANEL_WIDTH, PANEL_HEIGHT);
	}
}
}
