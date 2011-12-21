package helloworld.uibaseclass {

	import com.sibirjak.jakute.JCSS;
	import com.sibirjak.jakute.JCSS_Sprite;

	import flash.display.Sprite;

	public class HelloWorld_UIBaseClass extends Sprite {
		public function HelloWorld_UIBaseClass() {
			JCSS_Sprite.jcss = new JCSS();
			JCSS_Sprite.jcss.setStyleSheet(CSS.styles);

			addChild(new JCSSComponent());
		}
	}
}

internal class CSS {
	public static var styles : String = <styles><![CDATA[
		Box {
			width: 200;
			height: 200;
			background: #99CCFF;
			border: #779999
		}
	]]></styles>.toString();
}