package features.states.box {
	import com.sibirjak.jakute.JCSS_Sprite;
	import com.sibirjak.jakute.constants.JCSS_StyleValueFormat;
	import com.sibirjak.jakute.events.JCSS_ChangeEvent;
	import common.ColorUtil;
	import flash.display.GradientType;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class Box extends JCSS_Sprite {
		// states
		private var _over : Boolean = false;
		private var _down : Boolean = false;
		// children
		private var _tf : TextField;

		public function Box() {
			jcss_cssName = "Box";
			jcss_defineStyle("x", 0, JCSS_StyleValueFormat.FORMAT_NUMBER);
			jcss_defineStyle("y", 0, JCSS_StyleValueFormat.FORMAT_NUMBER);
			jcss_defineStyle("w", 150, JCSS_StyleValueFormat.FORMAT_NUMBER);
			jcss_defineStyle("h", 150, JCSS_StyleValueFormat.FORMAT_NUMBER);
			jcss_defineStyle("background-color", "#BCCC7A", JCSS_StyleValueFormat.FORMAT_HTML_COLOR);
			jcss_defineStyle("background-gradient", "bright_to_dark", JCSS_StyleValueFormat.FORMAT_STRING);
			jcss_defineStyle("border-color", "#81991F", JCSS_StyleValueFormat.FORMAT_HTML_COLOR);
		}

		override protected function jcss_onStylesInitialized() : void {
			createLabel();
			draw();

			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
		}

		override protected function jcss_onStylesChanged(changeEvent : JCSS_ChangeEvent) : void {
			// redraw necessary
			if (changeEvent.valueHasChanged("w")
				|| changeEvent.valueHasChanged("h")
				|| changeEvent.valueHasChanged("background-color")
				|| changeEvent.valueHasChanged("background-gradient")
				|| changeEvent.valueHasChanged("border-color")) {
				draw();

			// only reposition or opacity update
			} else {
				x = style("x");
				y = style("y");
			}
		}

		private function mouseOverHandler(event : MouseEvent) : void {
			if (event.target != this) return;

			_over = true;
			jcss_setState("over", "true");
			setLabel();
		}

		private function mouseOutHandler(event : MouseEvent) : void {
			if (event.target != this) return;

			_over = false;
			jcss_setState("over", "false");
			setLabel();
		}

		private function mouseDownHandler(event : MouseEvent) : void {
			if (event.target != this) return;

			_down = true;
			jcss_setState("down", "true");
			setLabel();

			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		}

		private function mouseUpHandler(event : MouseEvent) : void {
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);

			_down = false;
			jcss_setState("down", "false");
			setLabel();
		}

		private function setLabel() : void {
			_tf.text = jcss_componentSelectorAsString();
			if (_over) _tf.appendText(":over");
			if (_down) _tf.appendText(":down");
		}

		private function createLabel() : void {
			_tf = new TextField();
			_tf.mouseEnabled = false;
			_tf.autoSize = TextFieldAutoSize.LEFT;
			_tf.textColor = 0x333333;
			setLabel();
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
			var gradient : Array = gradient = ColorUtil.getGradient(
				style("background-color"), 20, style("background-gradient")
			);

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