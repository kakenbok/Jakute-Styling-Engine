package features.textfield {

	import com.sibirjak.jakute.JCSS;
	import com.sibirjak.jakute.JCSS_Adapter;
	import flash.events.FocusEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;

	public class TextFieldAdapter extends JCSS_Adapter {
		override protected function onComponentRegistered() : void {
			cssName = "Text";
			// some reflection to identify our tf in the display list
			var childIndex : uint = component.parent.getChildIndex(component);
			switch (childIndex) {
				case 0:
					cssID = "first";
					cssClass = "input";
					break;
				case 1:
					cssID = "second";
					cssClass = "label";
					break;
				case 2:
					cssID = "third";
					cssClass = "input";
					break;
			}

			defineStyle("x", 0, JCSS.FORMAT_NUMBER);
			defineStyle("y", 0, JCSS.FORMAT_NUMBER);
			defineStyle("w", 300, JCSS.FORMAT_NUMBER);
			defineStyle("h", 16, JCSS.FORMAT_NUMBER);

			defineStyle("type", TextFieldType.DYNAMIC, JCSS.FORMAT_STRING);
			defineStyle("selectable", false, JCSS.FORMAT_BOOLEAN);

			defineStyle("font-family", "serif", JCSS.FORMAT_STRING);
			defineStyle("font-size", 20, JCSS.FORMAT_NUMBER);
			defineStyle("color", "#000000", JCSS.FORMAT_COLOR);

			defineStyle("background", false, JCSS.FORMAT_BOOLEAN);
			defineStyle("background-color", "#FFFFFF", JCSS.FORMAT_COLOR);
			defineStyle("border", false, JCSS.FORMAT_BOOLEAN);
			defineStyle("border-color", "#000000", JCSS.FORMAT_COLOR);
		}
		
		override protected function onStylesInitialized(styles : Object) : void {
			applyStyles();

			component.addEventListener(FocusEvent.FOCUS_IN, focusIn);
			component.addEventListener(FocusEvent.FOCUS_OUT, focusOut);
		}
		
		override protected function onStylesChanged(styles : Object) : void {
			applyStyles();
		}
		
		private function applyStyles() : void {
			var tf : TextField = component as TextField;
			
			tf.x = getStyle("x");
			tf.y = getStyle("y");
			tf.width = getStyle("w");
			tf.height = getStyle("h");
			
			tf.type = getStyle("type");
			tf.selectable = tf.type == TextFieldType.INPUT;

			tf.textColor = getStyle("color");
			tf.background = getStyle("background");
			tf.backgroundColor = getStyle("background-color");
			tf.border = getStyle("border");
			tf.borderColor = getStyle("border-color");

			var textFormat : TextFormat = new TextFormat();
			textFormat.font = getStyle("font-family");
			textFormat.size = getStyle("font-size");
			tf.setTextFormat(textFormat);
			tf.defaultTextFormat = textFormat;
		}

		private function focusOut(event : FocusEvent) : void {
			setState("focus", "false");
		}
	
		private function focusIn(event : FocusEvent) : void {
			setState("focus", "true");
		}
	}
}