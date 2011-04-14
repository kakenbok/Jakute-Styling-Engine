package helloworld {

	import flash.display.Sprite;

	public class HelloWorld1 extends Sprite {
		public function HelloWorld1() {
			var box : Component = new Component();
			box.draw();
			addChild(box);
		}
	}
}