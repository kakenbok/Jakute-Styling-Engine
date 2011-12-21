package helloworld {

	import common.ColorUtil;
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.geom.Matrix;

	public class Component extends Sprite {
		public var w : uint = 300;
		public var h : uint = 100;
		public var backgroundColor : uint = 0xEEEEEE;
		public var borderColor : uint = 0xAAAAAA;
		public var borderSize : uint = 2;

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
	}
}