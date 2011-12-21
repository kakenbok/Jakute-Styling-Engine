package buttontutorial.step3 {

	import com.sibirjak.jakute.JCSS;
	import com.sibirjak.jakute.JCSS_Sprite;

	import flash.display.Sprite;

	public class ButtonExample2 extends Sprite {
		private var _button : Button;

		public function ButtonExample2() {
			// JCSS
			JCSS_Sprite.jcss = new JCSS();
			JCSS_Sprite.jcss.setStyleSheet(CSS.styles);

			// button
			_button = new Button();
			_button.text = "Click";
			addChild(_button);
		}
	}
}

internal class CSS {
	public static var styles : String = <styles><![CDATA[
		Label {
			color: #CCCCFF;
			size: 10;
		}

		ButtonSkin {
			backgroundColor: #6666CC;
			borderColor: #0000CC;
			borderSize: 2;
			borderRadius: 10;
		}
	]]></styles>.toString();
}