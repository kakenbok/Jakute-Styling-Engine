package helloworld.uibaseclass {

	import com.sibirjak.jakute.JCSS_Sprite;
	import com.sibirjak.jakute.constants.JCSS_StyleValueFormat;
	import com.sibirjak.jakute.events.JCSS_ChangeEvent;
	import common.ColorUtil;
	import flash.display.GradientType;
	import flash.geom.Matrix;


	public class JCSSComponent extends JCSS_Sprite {
		public var w : uint = 300;
		public var h : uint = 100;
		public var backgroundColor : uint = 0xEEEEEE;
		public var borderColor : uint = 0xAAAAAA;
		public var borderSize : uint = 2;

		public function JCSSComponent() {
			jcss_cssName = "Box";
			jcss_defineStyle("width", 150, JCSS_StyleValueFormat.FORMAT_NUMBER);
			jcss_defineStyle("height", 150, JCSS_StyleValueFormat.FORMAT_NUMBER);
			jcss_defineStyle("background", "#BCCC7A", JCSS_StyleValueFormat.FORMAT_HTML_COLOR);
			jcss_defineStyle("border", "#81991F", JCSS_StyleValueFormat.FORMAT_HTML_COLOR);
			jcss_defineStyle("thickness", 1, JCSS_StyleValueFormat.FORMAT_NUMBER);
		}

		public function draw() : void {
			// gradient
			var matrix : Matrix = new Matrix();
			matrix.createGradientBox(w, h, Math.PI / 180 * 45, 0, 0);
			var gradient : Array = gradient = ColorUtil.getGradient(backgroundColor, 20, "bright_to_dark");

			with (graphics) {
				clear();
				// border
				if (borderSize) lineStyle(borderSize, borderColor);
				// background
				beginGradientFill(GradientType.LINEAR, gradient, [1, 1], [0, 255], matrix);
				drawRect(0, 0, w, h);
			}
		}

		override protected function jcss_onStylesInitialized() : void {
			onStylesInitializedOrChanged();
		}

		override protected function jcss_onStylesChanged(changeEvent : JCSS_ChangeEvent) : void {
			onStylesInitializedOrChanged();
		}

		private function onStylesInitializedOrChanged() : void {
			w = jcss_getStyle("width");
			h = jcss_getStyle("height");
			backgroundColor = jcss_getStyle("background");
			borderColor = jcss_getStyle("border");
			borderSize = jcss_getStyle("thickness");
			draw();
		}
	}
}