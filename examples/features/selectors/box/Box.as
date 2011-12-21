package features.selectors.box {
	import com.sibirjak.jakute.JCSS_Sprite;
	import com.sibirjak.jakute.constants.JCSS_StyleValueFormat;
	import common.ColorUtil;
	import flash.display.GradientType;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class Box extends JCSS_Sprite {

		private var _tf : TextField;

		public function Box() {
			jcss_cssName = "Box";
			jcss_defineStyle("x", 0, JCSS_StyleValueFormat.FORMAT_NUMBER);
			jcss_defineStyle("y", 0, JCSS_StyleValueFormat.FORMAT_NUMBER);
			jcss_defineStyle("w", 150, JCSS_StyleValueFormat.FORMAT_NUMBER);
			jcss_defineStyle("h", 150, JCSS_StyleValueFormat.FORMAT_NUMBER);
			jcss_defineStyle("background-color", "#BCCC7A", JCSS_StyleValueFormat.FORMAT_HTML_COLOR);
			jcss_defineStyle("border-color", "#81991F", JCSS_StyleValueFormat.FORMAT_HTML_COLOR);
			jcss_defineStyle("border-size", 1, JCSS_StyleValueFormat.FORMAT_NUMBER);
		}

		override protected function jcss_onStylesInitialized() : void {
			createLabel();
			draw();
		}

		private function createLabel() : void {
			_tf = new TextField();
			_tf.mouseEnabled = false;
			_tf.autoSize = TextFieldAutoSize.LEFT;
			_tf.textColor = 0x333333;
			_tf.text = jcss_componentSelectorAsString();
			_tf.x = _tf.y = 2;
			addChild(_tf);

			var textFormat : TextFormat = new TextFormat();
			textFormat.font = "_sans";
			textFormat.size = 9;
			_tf.setTextFormat(textFormat);
			_tf.defaultTextFormat = textFormat;
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
				if (style("border-size")) {
					lineStyle(style("border-size"), style("border-color"));
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