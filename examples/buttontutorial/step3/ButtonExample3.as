package buttontutorial.step3 {

	import com.sibirjak.jakute.JCSS;
	import flash.display.Sprite;

	public class ButtonExample3 extends Sprite {
		private var _button : Button;

		public function ButtonExample3() {
			// JCSS
			JCSS.getInstance().setStyleSheet(CSS.styles);

			// button
			_button = new Button();
			_button.text = "Click";
			addChild(_button);
		}
	}
}

internal class CSS {
	public static var styles : String = <styles><![CDATA[
		ButtonSkin {
			gradientDirection: dark_to_bright;

			backgroundColor: #CCCCCC;
			backgroundColorOffset: 0

			borderColor: #888888;
			borderSize: 4;
			borderRadius: 15;
		}
	]]></styles>.toString();
}
