package configuration {

	import com.sibirjak.jakute.JCSS;
	import flash.display.Sprite;

	public class CustomStyleFormatter extends Sprite {
		public function CustomStyleFormatter() {
			var jcss : JCSS = JCSS.getInstance();
			jcss.setStyleSheet(CSS.styles);
			jcss.registerStyleValueFormatter("color_literals", customColorFormatter);

			addChild(new Box());
		}

		private function customColorFormatter(value : *) : uint {
			if (value == "red") return 0xFF0000;
			else if (value == "blue") return 0x0000FF;
			return 0; // else black
		}
	}
}

import com.sibirjak.jakute.JCSS_Sprite;

internal class Box extends JCSS_Sprite {
	public function Box() {
		jcss_cssName = "Box";
		jcss_defineStyle("backgroundColor", 0, "color_literals");
		jcss_defineStyle("borderColor", 0, "color_literals");
	}

	override protected function jcss_onStylesInitialized(styles : Object) : void {
		with (graphics) {
			lineStyle(3, styles["borderColor"]);
			beginFill(styles["backgroundColor"]);
			drawRect(0, 0, 100, 100);
		}
	}
}

internal class CSS {
	public static var styles : String = <styles><![CDATA[
		Box {
			backgroundColor: red;
			borderColor: blue;
		}
	]]></styles>.toString();
}