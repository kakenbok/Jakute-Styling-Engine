package configuration {

	import com.sibirjak.jakute.JCSS;
	import com.sibirjak.jakute.JCSS_Sprite;

	import flash.display.Sprite;

	public class CustomStyleFormatter extends Sprite {
		public function CustomStyleFormatter() {
			JCSS_Sprite.jcss = new JCSS();
			JCSS_Sprite.jcss.setStyleSheet(CSS.styles);
			JCSS_Sprite.jcss.registerStyleValueFormatter("color_literals", new NamedColorFormatter());

			addChild(new Box());
		}
	}
}

import com.sibirjak.jakute.JCSS_Sprite;
import com.sibirjak.jakute.styles.JCSS_IValueFormatter;

internal class NamedColorFormatter implements JCSS_IValueFormatter {
	public function format(value : *) : * {
		if (value == "red") return 0xFF0000;
		else if (value == "blue") return 0x0000FF;
		return 0; // else black
	}

	public function equals(value1 : *, value2 : *) : Boolean {
		return value1 === value2;
	}
}

internal class Box extends JCSS_Sprite {
	public function Box() {
		jcss_cssName = "Box";
		jcss_defineStyle("backgroundColor", 0, "color_literals");
		jcss_defineStyle("borderColor", 0, "color_literals");
	}

	override protected function jcss_onStylesInitialized() : void {
		with (graphics) {
			lineStyle(3, jcss_getStyle("borderColor"));
			beginFill(jcss_getStyle("backgroundColor"));
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