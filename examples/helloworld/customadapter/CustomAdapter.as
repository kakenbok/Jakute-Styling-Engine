package helloworld.customadapter {
	import helloworld.Component;
	import com.sibirjak.jakute.JCSS_Adapter;
	import com.sibirjak.jakute.constants.JCSS_StyleValueFormat;
	import com.sibirjak.jakute.events.JCSS_ChangeEvent;

	public class CustomAdapter extends JCSS_Adapter {
		public function CustomAdapter() {
			cssName = "Box";
			defineStyle("width", 150, JCSS_StyleValueFormat.FORMAT_NUMBER);
			defineStyle("height", 150, JCSS_StyleValueFormat.FORMAT_NUMBER);
			defineStyle("background", "#BCCC7A", JCSS_StyleValueFormat.FORMAT_HTML_COLOR);
			defineStyle("border", "#81991F", JCSS_StyleValueFormat.FORMAT_HTML_COLOR);
			defineStyle("thickness", 1, JCSS_StyleValueFormat.FORMAT_NUMBER);
		}

		override protected function onStylesInitialized() : void {
			onStylesInitializedOrChanged();
		}

		override protected function onStylesChanged(changeEvent : JCSS_ChangeEvent) : void {
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