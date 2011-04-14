package helloworld {

	import com.sibirjak.jakute.JCSS;
	import com.sibirjak.jakute.JCSS_Adapter;
	import flash.display.Sprite;

	public class HelloWorld3 extends Sprite {
		public function HelloWorld3() {
			var adapter : JCSS_Adapter = new JCSS_Adapter();
			adapter.cssName = "Box";
			adapter.defineStyle("width", 150, JCSS.FORMAT_NUMBER);
			adapter.defineStyle("height", 150, JCSS.FORMAT_NUMBER);
			adapter.defineStyle("background", "#BCCC7A", JCSS.FORMAT_COLOR);
			adapter.defineStyle("border", "#81991F", JCSS.FORMAT_COLOR);
			adapter.defineStyle("thickness", 1, JCSS.FORMAT_NUMBER);
			adapter.stylesInitializedHandler = onStylesInitialized;

			var box : Component = new Component();
			JCSS.getInstance().registerComponent(box, adapter);
			addChild(box);
		}
		
		private function onStylesInitialized(styles : Object, adapter : JCSS_Adapter) : void {
			var box : Component = adapter.component as Component;
			box.w = styles["width"];
			box.h = styles["height"];
			box.backgroundColor = styles["background"];
			box.borderColor = styles["border"];
			box.borderSize = styles["thickness"];
			box.draw();
		}
	}
}