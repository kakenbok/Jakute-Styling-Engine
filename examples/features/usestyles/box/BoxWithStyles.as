package features.usestyles.box {

	import com.sibirjak.jakute.JCSS;
	import com.sibirjak.jakute.JCSS_Sprite;
	import flash.display.GradientType;
	import flash.geom.Matrix;

	public class BoxWithStyles extends JCSS_Sprite {

		public function BoxWithStyles(cssID : String = "") {
			jcss_cssName = "Box";
			jcss_cssID = cssID;
			jcss_defineStyle("x", 0, JCSS.FORMAT_NUMBER);
			jcss_defineStyle("y", 0, JCSS.FORMAT_NUMBER);
			jcss_defineStyle("w", 100, JCSS.FORMAT_NUMBER);
			jcss_defineStyle("h", 100, JCSS.FORMAT_NUMBER);
			jcss_defineStyle("color", "#BCCC7A", JCSS.FORMAT_COLOR);
		}

		override protected function jcss_onStylesInitialized(styles : Object) : void {
			draw();
		}

		private function draw() : void {
			// position and opacity
			x = style("x");
			y = style("y");
			
			// gradient
			var matrix : Matrix = new Matrix();
			matrix.createGradientBox(style("w"), style("h"), Math.PI / 180 * 45, 0, 0);
			var gradient : Array = gradient = ColorUtil.getGradient(style("color"));

			with (graphics) {
				clear();
				// border
				lineStyle(1, ColorUtil.darkenBy(style("color"), 100));
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