package buttontutorial.step1 {

	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class Label extends Sprite {
		// properties
		private var _text : String = "";
		// children
		private var _textField : TextField;

		public function Label() {
			_textField = new TextField();
			_textField.autoSize = TextFieldAutoSize.LEFT;
			_textField.selectable = false;
			addChild(_textField);
		}

		public function draw() : void {
			// text field
			_textField.textColor = 0x333333;
			_textField.text = _text;

			// text format
			var textFormat : TextFormat = new TextFormat();
			textFormat.font = "_sans";
			textFormat.size = 11;
			_textField.setTextFormat(textFormat);
		}

		public function set text(text : String) : void {
			_text = text;
		}

		public function get innerWidth() : uint {
			return _textField.width;
		}

		public function get innerHeight() : uint {
			return _textField.height;
		}
	}
}