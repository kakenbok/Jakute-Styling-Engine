package helloworld {

	import helloworld.panel.ControlPanelProperties;
	import flash.display.Sprite;

	public class HelloWorld1b extends Sprite {
		public function HelloWorld1b() {
			var box : Component = new Component();
			box.w = 150;
			box.h = 150;
			box.backgroundColor = 0xBCCC7A;
			box.borderColor = 0x81991F;
			box.borderSize = 1;
			box.draw();
			addChild(box);

			// box control panel
			addChild(new ControlPanelProperties(box));
		}
	}
}
