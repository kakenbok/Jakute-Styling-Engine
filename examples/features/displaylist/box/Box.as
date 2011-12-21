package features.displaylist.box {
	import com.sibirjak.jakute.JCSS_Sprite;
	import com.sibirjak.jakute.constants.JCSS_StyleValueFormat;
	import com.sibirjak.jakute.events.JCSS_ChangeEvent;
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
			jcss_defineStyle("alpha", 1, JCSS_StyleValueFormat.FORMAT_NUMBER);
			jcss_defineStyle("background-color", "#BCCC7A", JCSS_StyleValueFormat.FORMAT_HTML_COLOR);
			jcss_defineStyle("border-size", 1, JCSS_StyleValueFormat.FORMAT_NUMBER);
		}

		override protected function jcss_onStylesInitialized() : void {
			draw();
		}

		override protected function jcss_onStylesChanged(changeEvent : JCSS_ChangeEvent) : void {
			// redraw necessary
			if (changeEvent.valueHasChanged("w")
				|| changeEvent.valueHasChanged("h")
				|| changeEvent.valueHasChanged("background-color")
				|| changeEvent.valueHasChanged("border-size")) {
				draw();

			// only reposition or opacity update
			} else {
				x = style("x");
				y = style("y");
				alpha = style("alpha");
			}
		}

		private function draw() : void {
			// position and opacity
			x = style("x");
			y = style("y");
			alpha = style("alpha");
			
			// gradient
			var matrix : Matrix = new Matrix();
			matrix.createGradientBox(style("w"), style("h"), Math.PI / 180 * 45, 0, 0);
			var gradient : Array = gradient = ColorUtil.getGradient(style("background-color"));

			with (graphics) {
				clear();
				// border
				if (style("border-size")) {
					lineStyle(style("border-size"), ColorUtil.darkenBy(style("background-color"), 100));
				}
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