package buttontutorial.step1 {

	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.geom.Matrix;

	public class ButtonSkin extends Sprite {
		// properties
		private var _w : uint = 100;
		private var _h : uint = 100;

		public function ButtonSkin() {
		}

		public function draw() : void {
			// gradient
			var matrix : Matrix = new Matrix();
			matrix.createGradientBox(_w, _h, Math.PI / 180 * 45, 0, 0);

			with (graphics) {
				clear();

				// border
				lineStyle(2);
				lineGradientStyle(GradientType.LINEAR, [0xCCCCCC, 0x666666], [1, 1], [0, 255], matrix);

				// background
				beginGradientFill(GradientType.LINEAR, [0xF7F7F7, 0xC7C7C7], [1, 1], [0, 255], matrix);
				drawRoundRect(0, 0, _w, _h, 10);
			}
		}

		public function setSize(w : uint, h : uint) : void {
			_w = w > 20 ? w : 20;
			_h = h > 20 ? h : 20;
		}
	}
}