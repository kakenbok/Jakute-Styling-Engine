package features.usestyles {

	import features.usestyles.box.BoxWithoutStyles;
	import flash.display.Sprite;

	public class WithoutStyles extends Sprite {
		public function WithoutStyles() {
			addChild(new BoxWithoutStyles());
			addChild(new BoxWithoutStyles()).x = 70;
			addChild(new BoxWithoutStyles()).x = 140;
			addChild(new BoxWithoutStyles()).x = 210;
		}
	}
}