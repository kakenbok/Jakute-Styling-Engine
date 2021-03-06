package features.externalcss.box {
	import com.sibirjak.jakute.JCSS_Sprite;
	import com.sibirjak.jakute.constants.JCSS_StyleValueFormat;
	import common.ColorUtil;
	import flash.display.GradientType;
	import flash.geom.Matrix;

	public class Box extends JCSS_Sprite {

		public function Box() {
			jcss_cssName = "Box";
			jcss_defineStyle("x", 0, JCSS_StyleValueFormat.FORMAT_NUMBER);
			jcss_defineStyle("y", 0, JCSS_StyleValueFormat.FORMAT_NUMBER);
			jcss_defineStyle("w", 150, JCSS_StyleValueFormat.FORMAT_NUMBER);
			jcss_defineStyle("h", 150, JCSS_StyleValueFormat.FORMAT_NUMBER);
			jcss_defineStyle("background-color", "#BCCC7A", JCSS_StyleValueFormat.FORMAT_HTML_COLOR);
			jcss_defineStyle("border-color", "#81991F", JCSS_StyleValueFormat.FORMAT_HTML_COLOR);
		}

		override protected function jcss_onStylesInitialized() : void {
			draw();
		}

		private function draw() : void {
			// position and opacity
			x = style("x");
			y = style("y");
			
			// gradient
			var matrix : Matrix = new Matrix();
			matrix.createGradientBox(style("w"), style("h"), Math.PI / 180 * 45, 0, 0);
			var gradient : Array = gradient = ColorUtil.getGradient(style("background-color"));

			with (graphics) {
				clear();
				// border
				lineStyle(1, style("border-color"));
				// background
				beginGradientFill(GradientType.LINEAR, gradient, [1, 1], [0, 255], matrix);
				drawRect(0, 0, style("w"), style("h"));
			}
		}
		
		// shortcut to jcss_getStyle()
		private function style(styleName : String) : * {
			return jcss_getStyle(styleName);
		}
	}
}