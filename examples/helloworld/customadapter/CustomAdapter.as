package helloworld.customadapter {

	import com.sibirjak.jakute.JCSS;
	import com.sibirjak.jakute.JCSS_Adapter;
	import helloworld.Component;

	public class CustomAdapter extends JCSS_Adapter {
		public function CustomAdapter() {
			cssName = "Box";
			defineStyle("width", 150, JCSS.FORMAT_NUMBER);
			defineStyle("height", 150, JCSS.FORMAT_NUMBER);
			defineStyle("background", "#BCCC7A", JCSS.FORMAT_COLOR);
			defineStyle("border", "#81991F", JCSS.FORMAT_COLOR);
			defineStyle("thickness", 1, JCSS.FORMAT_NUMBER);
		}

		override protected function onStylesInitialized(styles : Object) : void {
			onStylesInitializedOrChanged();
		}

		override protected function onStylesChanged(styles : Object) : void {
			onStylesInitializedOrChanged();
		}

		private function onStylesInitializedOrChanged() : void {
			var box : Component = component as Component;
			box.w = getStyle("width");
			box.h = getStyle("height");
			box.backgroundColor = getStyle("background");
			box.borderColor = getStyle("border");
			box.borderSize = getStyle("thickness");
			box.draw();
		}
	}
}