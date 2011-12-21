package helloworld {
	import com.sibirjak.jakute.constants.JCSS_StyleValueFormat;
	import com.sibirjak.jakute.JCSS;
	import com.sibirjak.jakute.JCSS_Adapter;
	import flash.display.Sprite;

	public class HelloWorld3 extends Sprite {
		public function HelloWorld3() {
			var adapter : JCSS_Adapter = new JCSS_Adapter();
			adapter.cssName = "Box";
			adapter.defineStyle("width", 150, JCSS_StyleValueFormat.FORMAT_NUMBER);
			adapter.defineStyle("height", 150, JCSS_StyleValueFormat.FORMAT_NUMBER);
			adapter.defineStyle("background", "#BCCC7A", JCSS_StyleValueFormat.FORMAT_HTML_COLOR);
			adapter.defineStyle("border", "#81991F", JCSS_StyleValueFormat.FORMAT_HTML_COLOR);
			adapter.defineStyle("thickness", 1, JCSS_StyleValueFormat.FORMAT_NUMBER);
			adapter.stylesInitializedHandler = onStylesInitialized;

			var box : Component = new Component();
			new JCSS().registerComponent(box, adapter);
			addChild(box);
		}
		
		private function onStylesInitialized(adapter : JCSS_Adapter) : void {
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