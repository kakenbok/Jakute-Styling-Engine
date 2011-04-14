package buttontutorial.step3 {

	import buttontutorial.step3.panel.ControlPanel;
	import flash.display.Sprite;

	public class ButtonExample extends Sprite {
		private var _button : Button;

		public function ButtonExample() {
			// button
			_button = new Button();
			_button.text = "Click";
			addChild(_button);

			// button control panel
			addChild(new ControlPanel(_button));
		}
	}
}