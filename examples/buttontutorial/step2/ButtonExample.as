package buttontutorial.step2 {

	import buttontutorial.step2.panel.ControlPanel;
	import com.sibirjak.jakute.JCSS;
	import flash.display.Sprite;

	public class ButtonExample extends Sprite {
		private var _button : Button;

		public function ButtonExample() {
			// JCSS
			JCSS.getInstance().setStyleSheet(CSS.styles);

			// button
			_button = new Button();
			_button.text = "Click";
			addChild(_button);

			// button control panel
			addChild(new ControlPanel(_button));
		}
	}
}

internal class CSS {
	public static var styles : String = <styles><![CDATA[
		Label {
			color: #FFFFFF;
			size: 20;
		}

		ButtonSkin {
			backgroundColor: #CC0000;
			borderColor: #990000;
			borderSize: 4;
			borderRadius: 15;
		}
	]]></styles>.toString();
}