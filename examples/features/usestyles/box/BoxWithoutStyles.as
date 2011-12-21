package features.usestyles.box {

	import common.ColorUtil;
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.geom.Matrix;

	public class BoxWithoutStyles extends Sprite {
		public function BoxWithoutStyles() {
			// gradient
			var matrix : Matrix = new Matrix();
			matrix.createGradientBox(60, 60, Math.PI / 180 * 45, 0, 0);
			var gradient : Array = gradient = ColorUtil.getGradient(0xBCCC7A);

			with (graphics) {
				clear();
				// border
				lineStyle(1, ColorUtil.darkenBy(0xBCCC7A, 100));
				// background
				beginGradientFill(GradientType.LINEAR, gradient, [1, 1], [0, 255], matrix);
				drawRect(0, 0, 60, 60);
			}
		}
	}
}