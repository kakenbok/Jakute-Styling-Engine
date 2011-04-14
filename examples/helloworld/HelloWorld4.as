package helloworld {

	import helloworld.panel.ControlPanelStyles;
	import com.sibirjak.jakute.JCSS;
	import com.sibirjak.jakute.JCSS_Adapter;
	import flash.display.Sprite;

	public class HelloWorld4 extends Sprite {
		public function HelloWorld4() {
			var jcss : JCSS = JCSS.getInstance();
			jcss.setStyleSheet(CSS.styles);

			var adapter : JCSS_Adapter = new JCSS_Adapter();
			adapter.cssName = "Box";
			adapter.defineStyle("width", 150, JCSS.FORMAT_NUMBER);
			adapter.defineStyle("height", 150, JCSS.FORMAT_NUMBER);
			adapter.defineStyle("background", "#BCCC7A", JCSS.FORMAT_COLOR);
			adapter.defineStyle("border", "#81991F", JCSS.FORMAT_COLOR);
			adapter.defineStyle("thickness", 1, JCSS.FORMAT_NUMBER);
			adapter.stylesInitializedHandler = onStylesInitializedOrChanged;
			adapter.stylesChangedHandler = onStylesInitializedOrChanged;

			var box : Component = new Component();
			jcss.registerComponent(box, adapter);
			addChild(box);
		}

		private function onStylesInitializedOrChanged(styles : Object, adapter : JCSS_Adapter) : void {
			var box : Component = adapter.component as Component;
			box.w = adapter.getStyle("width");
			box.h = adapter.getStyle("height");
			box.backgroundColor = adapter.getStyle("background");
			box.borderColor = adapter.getStyle("border");
			box.borderSize = adapter.getStyle("thickness");
			box.draw();

			// box control panel
			if (numChildren == 1) addChild(new ControlPanelStyles(box));
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