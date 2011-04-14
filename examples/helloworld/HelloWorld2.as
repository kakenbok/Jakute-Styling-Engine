package helloworld {

	import flash.display.Sprite;

	public class HelloWorld2 extends Sprite {
		public function HelloWorld2() {
			var box : Component = new Component();
			box.w = 150;
			box.h = 150;
			box.backgroundColor = 0xBCCC7A;
			box.borderColor = 0x81991F;
			box.borderSize = 1;
			box.draw();
			addChild(box);
		}
	}
}
