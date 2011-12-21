package features.textfield {

	import com.sibirjak.jakute.JCSS;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;

	public class TextFieldStyles extends Sprite {
		public function TextFieldStyles() {
			loaderInfo.addEventListener(Event.INIT, initHandler);
		}

		private function initHandler(event : Event) : void {
			var jcss : JCSS = new JCSS();
			jcss.setStyleSheet(TextFieldStylesCSS.styles);
			jcss.startTypeMonitoring(stage);
			jcss.registerType(TextField, TextFieldAdapter);
			
			var tf : TextField = new TextField();
			tf.text = "TextField 1";
			addChild(tf);

			tf = new TextField();
			tf.text = "TextField 2";
			addChild(tf);

			tf = new TextField();
			tf.text = "TextField 3";
			addChild(tf);
		}
	}
}