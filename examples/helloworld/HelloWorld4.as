package helloworld {

	import helloworld.panel.ControlPanelStyles;

	import com.sibirjak.jakute.JCSS;
	import com.sibirjak.jakute.JCSS_Adapter;
	import com.sibirjak.jakute.constants.JCSS_StyleValueFormat;

	import flash.display.Sprite;

	public class HelloWorld4 extends Sprite {
		public function HelloWorld4() {
			var jcss : JCSS = new JCSS();
			jcss.setStyleSheet(CSS.styles);

			var adapter : JCSS_Adapter = new JCSS_Adapter();
			adapter.cssName = "Box";
			adapter.defineStyle("width", 150, JCSS_StyleValueFormat.FORMAT_NUMBER);
			adapter.defineStyle("height", 150, JCSS_StyleValueFormat.FORMAT_NUMBER);
			adapter.defineStyle("background", "#BCCC7A", JCSS_StyleValueFormat.FORMAT_HTML_COLOR);
			adapter.defineStyle("border", "#81991F", JCSS_StyleValueFormat.FORMAT_HTML_COLOR);
			adapter.defineStyle("thickness", 1, JCSS_StyleValueFormat.FORMAT_NUMBER);
			adapter.stylesInitializedHandler = onStylesInitialized;
			adapter.stylesChangedHandler = onStylesChanged;

			var box : Component = new Component();
			jcss.registerComponent(box, adapter);
			addChild(box);
			
			addChild(new ControlPanelStyles(jcss, box));
		}

		private function onStylesInitialized(adapter : JCSS_Adapter) : void {
			onStylesChanged(null, adapter);
		}

		private function onStylesChanged(styles : Object, adapter : JCSS_Adapter) : void {
			var box : Component = adapter.component as Component;
			box.w = adapter.getStyle("width");
			box.h = adapter.getStyle("height");
			box.backgroundColor = adapter.getStyle("background");
			box.borderColor = adapter.getStyle("border");
			box.borderSize = adapter.getStyle("thickness");
			box.draw();
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