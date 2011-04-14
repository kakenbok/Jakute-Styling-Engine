package buttontutorial.step1 {

	import buttontutorial.step1.panel.ControlPanel;
	import flash.display.Sprite;

	public class ButtonExample extends Sprite {
		private var _button : Button;

		public function ButtonExample() {
			// button
			_button = new Button();
			_button.text = "Click";
			_button.draw();
			addChild(_button);

			// button control panel
			addChild(new ControlPanel(_button));
		}
	}
}