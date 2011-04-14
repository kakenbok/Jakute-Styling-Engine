package buttontutorial.step1 {

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class Button extends Sprite {
		// event constants
		public static const EVENT_OVER : String = "button_over";
		public static const EVENT_OUT : String = "button_out";
		public static const EVENT_DOWN : String = "button_down";
		public static const EVENT_UP : String = "button_up";
		public static const EVENT_CLICK : String = "button_click";
		public static const EVENT_STATE_CHANGE : String = "button_state_change";
		// properties
		private var _text : String;
		// internal
		private var _over : Boolean;
		private var _down : Boolean;
		// children
		private var _skin : ButtonSkin;
		private var _label : Label;

		public function Button() {
			mouseChildren = false;

			// background
			_skin = new ButtonSkin();
			addChild(_skin);

			// label
			_label = new Label();
			_label.x = 8;
			_label.y = 4;
			addChild(_label);

			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
		}

		public function draw() : void {
			_label.text = _text;
			_label.draw();

			_skin.setSize(_label.innerWidth + 16, _label.innerHeight + 8);
			_skin.draw();
		}

		public function set text(text : String) : void {
			_text = text;
		}

		public function get state() : String {
			var state : String = "";
			if (_over) state += ":over";
			if (_down) state += ":down";
			return state;
		}

		private function mouseOverHandler(event : MouseEvent) : void {
			_over = true;
			dispatchStateChange();
		}

		private function mouseOutHandler(event : MouseEvent) : void {
			_over = false;
			dispatchStateChange();
		}

		private function mouseDownHandler(event : MouseEvent) : void {
			_down = true;
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			dispatchStateChange();
		}

		private function mouseUpHandler(event : MouseEvent) : void {
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			_down = false;
			dispatchStateChange();
			if (_over) dispatchEvent(new Event(EVENT_CLICK, true));
		}

		private function dispatchStateChange() : void {
			dispatchEvent(new Event(EVENT_STATE_CHANGE, true));
		}
	}
}