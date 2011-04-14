package buttontutorial.step1.panel {

	import buttontutorial.step1.Button;
	import com.sibirjak.asdpc.textfield.Label;
	import com.sibirjak.asdpc.textfield.TextInput;
	import com.sibirjak.asdpc.textfield.TextInputEvent;
	import flash.display.Sprite;
	import flash.events.Event;

	public class ControlPanel extends Sprite {
		private var _button : Button;
		private var _labelInput1 : Label;
		private var _labelInput2 : TextInput;
		private var _stateInfo1 : Label;
		private var _stateInfo2 : Label;
		private var _clickCount : uint = 0;
		private var _clickInfo1 : Label;
		private var _clickInfo2 : Label;
		private var _labelStyles : Array = [Label.style.background, true, Label.style.backgroundColor, 0xFFFFFF];

		public function ControlPanel(button : Button) {
			// button

			_button = button;
			_button.y = 70;
			_button.addEventListener(Button.EVENT_STATE_CHANGE, buttonStateHandler);
			_button.addEventListener(Button.EVENT_CLICK, buttonClickHandler);

			// label input

			_labelInput1 = new Label();
			_labelInput1.setSize(70, 18);
			_labelInput1.setStyles(_labelStyles);
			_labelInput1.text = "Label:";
			addChild(_labelInput1);

			_labelInput2 = new TextInput();
			_labelInput2.setSize(200, 20);
			_labelInput2.moveTo(80, 0);
			_labelInput2.setStyle(TextInput.style.maxChars, 50);
			_labelInput2.text = "Click";
			_labelInput2.addEventListener(TextInputEvent.CHANGED, labelChangedHandler);
			addChild(_labelInput2);

			// state info

			_stateInfo1 = new Label();
			_stateInfo1.setSize(70, 18);
			_stateInfo1.moveTo(0, 20);
			_stateInfo1.setStyles(_labelStyles);
			_stateInfo1.text = "State:";
			addChild(_stateInfo1);

			_stateInfo2 = new Label();
			_stateInfo2.setSize(200, 20);
			_stateInfo2.moveTo(80, 20);
			addChild(_stateInfo2);

			// click info

			_clickInfo1 = new Label();
			_clickInfo1.setSize(70, 18);
			_clickInfo1.moveTo(0, 40);
			_clickInfo1.setStyles(_labelStyles);
			_clickInfo1.text = "Clicked:";
			addChild(_clickInfo1);

			_clickInfo2 = new Label();
			_clickInfo2.setSize(200, 20);
			_clickInfo2.moveTo(80, 40);
			addChild(_clickInfo2);
		}

		private function labelChangedHandler(event : TextInputEvent) : void {
			_button.text = _labelInput2.text;
			_button.draw();
		}

		private function buttonStateHandler(event : Event) : void {
			_stateInfo2.text = _button.state;
		}

		private function buttonClickHandler(event : Event) : void {
			_clickInfo2.text = String(++_clickCount);
		}
	}
}