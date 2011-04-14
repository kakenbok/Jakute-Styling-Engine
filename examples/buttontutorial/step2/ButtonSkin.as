package buttontutorial.step2 {

	import com.sibirjak.jakute.JCSS;
	import com.sibirjak.jakute.JCSS_Sprite;
	import flash.display.GradientType;
	import flash.geom.Matrix;

	public class ButtonSkin extends JCSS_Sprite {
		// properties
		private var _w : uint = 100;
		private var _h : uint = 100;

		public function ButtonSkin() {
			jcss_cssName = "ButtonSkin";
			jcss_defineStyle("gradientDirection", "bright_to_dark", JCSS.FORMAT_STRING); // for :down
			jcss_defineStyle("backgroundColor", 0xDFDFDF, JCSS.FORMAT_COLOR);
			jcss_defineStyle("backgroundColorOffset", 0, JCSS.FORMAT_NUMBER); // for :over
			jcss_defineStyle("borderColor", 0x999999, JCSS.FORMAT_COLOR);
			jcss_defineStyle("borderSize", 2, JCSS.FORMAT_NUMBER);
			jcss_defineStyle("borderRadius", 10, JCSS.FORMAT_NUMBER);
		}

		public function setSize(w : uint, h : uint) : void {
			_w = w > 20 ? w : 20;
			_h = h > 20 ? h : 20;
			draw();
		}

		override protected function jcss_onStylesInitialized(styles : Object) : void {
			draw();
		}

		override protected function jcss_onStylesChanged(styles : Object) : void {
			draw();
		}

		private function draw() : void {
			if (!jcss_initialized) return;

			// gradient
			var matrix : Matrix = new Matrix();
			matrix.createGradientBox(_w, _h, Math.PI / 180 * 45, 0, 0);
			var gradientDirection : String = jcss_getStyle("gradientDirection");
			var gradient : Array;

			// border
			var borderSize : uint = jcss_getStyle("borderSize");
			var borderColor : uint = jcss_getStyle("borderColor");

			var backgroundColor : uint = jcss_getStyle("backgroundColor");
			var offset : int = jcss_getStyle("backgroundColorOffset");
			if (offset) backgroundColor = ColorUtil.lightenBy(backgroundColor, offset);

			with (graphics) {
				clear();

				// border
				if (borderSize) {
					lineStyle(borderSize);
					gradient = ColorUtil.getGradient(borderColor, 60, gradientDirection);
					lineGradientStyle(GradientType.LINEAR, gradient, [1, 1], [0, 255], matrix);
				}

				// background
				gradient = ColorUtil.getGradient(backgroundColor, 60, gradientDirection);
				beginGradientFill(GradientType.LINEAR, gradient, [1, 1], [0, 255], matrix);
				drawRoundRect(0, 0, _w, _h, jcss_getStyle("borderRadius"));
			}
		}
	}
}