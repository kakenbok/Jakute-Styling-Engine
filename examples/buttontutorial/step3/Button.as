package buttontutorial.step3 {

	import com.sibirjak.jakute.JCSS_Sprite;
	import com.sibirjak.jakute.constants.JCSS_StyleValueFormat;
	import com.sibirjak.jakute.events.JCSS_ChangeEvent;

	import flash.events.Event;
	import flash.events.MouseEvent;

	public class Button extends JCSS_Sprite {
		// event constants
		public static const EVENT_OVER : String = "button_over";
		public static const EVENT_OUT : String = "button_out";
		public static const EVENT_DOWN : String = "button_down";
		public static const EVENT_UP : String = "button_up";
		public static const EVENT_CLICK : String = "button_click";
		public static const EVENT_STATE_CHANGE : String = "button_state_change";
		// internal
		private var _over : Boolean;
		private var _down : Boolean;
		// children
		private var _skin : ButtonSkin;
		private var _label : Label;

		public function Button() {
			jcss_cssName = "Button";
			jcss_encloseChildren();
			jcss_defineStyle("labelOffset", 0, JCSS_StyleValueFormat.FORMAT_NUMBER);

			jcss_setStyleSheet(<styles><![CDATA[
				Label {
					color: #FFFFFF default;
					size: 20 default;
				}
		
				ButtonSkin {
					backgroundColor: #CC0000 default;
					borderColor: #990000 default;
					borderSize: 4 default;
					borderRadius: 15 default;
				}
				
				:over ButtonSkin {
					backgroundColorOffset: 20 default;
				}

				:over:down ButtonSkin {
					gradientDirection: dark_to_bright default;
				}
				
				:over:down {
					labelOffset: 1 default;
				}
			]]></styles>.toString());

			mouseChildren = false;

			// background
			_skin = new ButtonSkin();
			addChild(_skin);

			// label
			_label = new Label();
			_label.x = 8;
			_label.y = 4;
			_label.addEventListener(Label.EVENT_CHANGE, labelChangeHandler);
			addChild(_label);

			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
		}

		public function set text(text : String) : void {
			_label.text = text;
		}

		public function get state() : String {
			var state : String = "";
			if (_over) state += ":over";
			if (_down) state += ":down";
			return state;
		}

		override protected function jcss_onStylesChanged(changeEvent : JCSS_ChangeEvent) : void {
			var offset : uint = jcss_getStyle("labelOffset");
			_label.x = 8 + offset;
			_label.y = 4 + offset;
		}

		private function mouseOverHandler(event : MouseEvent) : void {
			_over = true;
			jcss_setState("over", "true");
			dispatchStateChange();
		}

		private function mouseOutHandler(event : MouseEvent) : void {
			_over = false;
			jcss_setState("over", "false");
			dispatchStateChange();
		}

		private function mouseDownHandler(event : MouseEvent) : void {
			_down = true;
			jcss_setState("down", "true");
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			dispatchStateChange();
		}

		private function mouseUpHandler(event : MouseEvent) : void {
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			_down = false;
			jcss_setState("down", "false");
			dispatchStateChange();
			if (_over) dispatchEvent(new Event(EVENT_CLICK, true));
		}

		private function dispatchStateChange() : void {
			dispatchEvent(new Event(EVENT_STATE_CHANGE, true));
		}

		private function labelChangeHandler(event : Event) : void {
			_skin.setSize(_label.innerWidth + 16, _label.innerHeight + 8);
		}
	}
}