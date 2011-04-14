package buttontutorial.step3.panel {

	import buttontutorial.step3.Button;
	import com.sibirjak.asdpc.textfield.Label;
	import flash.events.Event;

	public class ControlPanel extends ControlPanelBase {
		private var _button : Button;
		private var _clickCount : uint = 0;

		public function ControlPanel(button : Button) {
			// button
			_button = button;
			_button.x = 2;
			_button.y = 225;
			_button.addEventListener(Button.EVENT_STATE_CHANGE, buttonStateHandler);
			_button.addEventListener(Button.EVENT_CLICK, buttonClickHandler);

			// controls
			addChild(
				document(
					headline("Info"),
					hLayout(
						label("State:"),
						label("", 0, "stateTf", false),
						label("Clicked:"),
						label("0", 0, "clickedTf", false)
					),
					dottedSeparator(580),
					headline("Label"),
					hLayout(
						label("Text:"),
						textInput({text:"Click", diff:110, maxchars:50, change:setLabel})
					),
					hLayout(
						label("Color:"),
						colorPicker({color:0xFFFFFF, tip:"Label", change:setLabelColor}),
						spacer(0),
						label("Size:"),
						sliderWithLabel({value:20, minValue:8, maxValue:50, snapInterval:1, change:setLabelSize})
					),
					dottedSeparator(580),
					headline("Skin"),
					hLayout(
						label("Background:"),
						colorPicker({color:0xCC0000, tip:"Background", change:setBackgroundColor}),
						spacer(0),
						label(":over offset:"),
						sliderWithLabel({value:20, minValue:-50, maxValue:50, snapInterval:1, change:setBackgroundOffset})
					),
					hLayout(
						label("Border:"),
						colorPicker({color:0x990000, tip:"Border", change:setBorderColor}),
						spacer(0),
						label("Size:"),
						sliderWithLabel({value:4, minValue:0, maxValue:20, snapInterval:1, change:setBorderSize}),
						label("Radius:"),
						sliderWithLabel({value:15, minValue:0, maxValue:40, snapInterval:1, change:setBorderRadius})
					),
					dottedSeparator(580))
			);
		}

		/*
		 * Info
		 */
		private function buttonStateHandler(event : Event) : void {
			Label(getView("stateTf")).text = _button.state;
		}

		private function buttonClickHandler(event : Event) : void {
			Label(getView("clickedTf")).text = String(++_clickCount);
		}

		/*
		 * Label
		 */
		private function setLabel(text : String) : void {
			_button.text = text;
		}

		private function setLabelColor(color : uint) : void {
			_button.jcss_setStyle("Label", "color", color);
		}

		private function setLabelSize(size : uint) : void {
			_button.jcss_setStyle("Label", "size", size);
		}

		/*
		 * Skin
		 */
		private function setBackgroundColor(color : uint) : void {
			_button.jcss_setStyle("ButtonSkin", "backgroundColor", color);
		}

		private function setBackgroundOffset(offset : int) : void {
			_button.jcss_setStyle(":over ButtonSkin", "backgroundColorOffset", offset);
		}

		private function setBorderColor(color : uint) : void {
			_button.jcss_setStyle("ButtonSkin", "borderColor", color);
		}

		private function setBorderSize(size : uint) : void {
			_button.jcss_setStyle("ButtonSkin", "borderSize", size);
			_button.x = Math.floor(size / 2);
		}

		private function setBorderRadius(radius : uint) : void {
			_button.jcss_setStyle("ButtonSkin", "borderRadius", radius);
		}
	}
}