package buttontutorial.step3 {

	import com.sibirjak.jakute.JCSS_Sprite;
	import com.sibirjak.jakute.constants.JCSS_StyleValueFormat;
	import com.sibirjak.jakute.events.JCSS_ChangeEvent;

	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class Label extends JCSS_Sprite {
		// event
		public static const EVENT_CHANGE : String = "label_change";
		// children
		private var _textField : TextField;

		public function Label() {
			jcss_cssName = "Label";
			jcss_defineStyle("color", 0x333333, JCSS_StyleValueFormat.FORMAT_HTML_COLOR);
			jcss_defineStyle("size", 11, JCSS_StyleValueFormat.FORMAT_NUMBER);

			_textField = new TextField();
			_textField.autoSize = TextFieldAutoSize.LEFT;
			_textField.selectable = false;
			addChild(_textField);
		}

		public function set text(text : String) : void {
			_textField.text = text;
			draw();
		}

		public function get innerWidth() : uint {
			return _textField.width;
		}

		public function get innerHeight() : uint {
			return _textField.height;
		}

		override protected function jcss_onStylesInitialized() : void {
			draw();
		}

		override protected function jcss_onStylesChanged(changeEvent : JCSS_ChangeEvent) : void {
			draw();
		}

		private function draw() : void {
			if (!jcss_initialized) return;

			// text field
			_textField.textColor = jcss_getStyle("color");

			// text format
			var textFormat : TextFormat = new TextFormat();
			textFormat.font = "_sans";
			textFormat.size = jcss_getStyle("size");
			_textField.setTextFormat(textFormat);

			dispatchEvent(new Event(EVENT_CHANGE, true));
		}
	}
}