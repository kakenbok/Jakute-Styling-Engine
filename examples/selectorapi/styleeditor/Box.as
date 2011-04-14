package selectorapi.styleeditor {

	import com.sibirjak.jakute.JCSS;
	import com.sibirjak.jakute.JCSS_Sprite;
	import flash.display.GradientType;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class Box extends JCSS_Sprite {
		// events
		public static const EVENT_OVER : String = "box_over";
		public static const EVENT_OUT : String = "box_out";
		public static const EVENT_CLICK : String = "box_click";
		// properties
		private var _w : uint;
		private var _h : uint;
		// internal
		private var _active : Boolean = false;
		private var _over : Boolean = false;
		private var _down : Boolean = false;
		// children
		private var _tf : TextField;

		public function Box(x : uint, y : uint, w : uint, h : uint, cssName : String = null, cssID : String = null, cssClass : String = null) {
			this.x = x;
			this.y = y;
			_w = w;
			_h = h;

			jcss_cssName = cssName;
			jcss_cssID = cssID;
			jcss_cssClass = cssClass;

			jcss_setState("active", "false");
			jcss_setState("over", "false");
			jcss_setState("down", "false");

			jcss_defineStyle("backgroundColor", 0xEEEEEE, JCSS.FORMAT_COLOR);

			addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler);
			addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler);
		}

		override protected function jcss_onStylesInitialized(styles : Object) : void {
			_tf = new TextField();
			_tf.mouseEnabled = false;
			_tf.autoSize = TextFieldAutoSize.LEFT;
			_tf.textColor = 0x333333;
			setLabel();
			_tf.x = _tf.y = 2;
			addChild(_tf);

			var textFormat : TextFormat = new TextFormat();
			textFormat.font = "_sans";
			textFormat.size = 9;
			_tf.defaultTextFormat = textFormat;

			draw();
		}

		override protected function jcss_onStylesChanged(styles : Object) : void {
			draw();
		}

		private function mouseOverHandler(event : MouseEvent) : void {
			if (event.target != this) return;

			_over = true;
			jcss_setState("over", "true");
			setLabel();

			dispatchEvent(new Event(EVENT_OVER, true));
		}

		private function mouseOutHandler(event : MouseEvent) : void {
			if (event.target != this) return;

			_over = false;
			jcss_setState("over", "false");
			setLabel();

			dispatchEvent(new Event(EVENT_OUT, true));
		}

		private function mouseDownHandler(event : MouseEvent) : void {
			if (event.target != this) return;

			_down = true;
			jcss_setState("down", "true");
			setLabel();

			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		}

		private function mouseUpHandler(event : MouseEvent) : void {
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);

			_down = false;
			jcss_setState("down", "false");
			var dispatchClick : Boolean;
			if (_over) {
				_active = !_active;
				jcss_setState("active", _active ? "true" : "false");
				dispatchClick = true;
			}
			setLabel();

			if (dispatchClick) dispatchEvent(new Event(EVENT_CLICK, true));
		}

		private function setLabel() : void {
			_tf.text = _jcssAdapter.componentSelectorAsString();
			if (_active) _tf.appendText(":active");
			if (_over) _tf.appendText(":over");
			if (_down) _tf.appendText(":down");
		}

		private function draw() : void {
			var backgroundColor : uint = jcss_getStyle("backgroundColor");

			_tf.textColor = ColorUtil.getContrastColor(backgroundColor, 200);
			setLabel();

			// gradient
			var matrix : Matrix = new Matrix();
			matrix.createGradientBox(_w, _h, Math.PI / 180 * 45, 0, 0);
			var gradient : Array = ColorUtil.getGradient(backgroundColor, 20, "bright_to_dark");

			with (graphics) {
				clear();

				// border
				lineStyle(1);
				lineStyle(1, ColorUtil.getContrastColor(backgroundColor, 40));

				// background
				beginGradientFill(GradientType.LINEAR, gradient, [1, 1], [0, 255], matrix);
				drawRoundRect(0, 0, _w, _h, 0);
			}
		}
	}
}