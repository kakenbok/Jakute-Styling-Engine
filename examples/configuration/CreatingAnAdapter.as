package configuration {

	import com.sibirjak.jakute.JCSS;
	import com.sibirjak.jakute.JCSS_Adapter;
	import com.sibirjak.jakute.JCSS_Sprite;
	import com.sibirjak.jakute.constants.JCSS_StyleValueFormat;

	import flash.display.Sprite;

	public class CreatingAnAdapter extends Sprite {
		public function CreatingAnAdapter() {
			var jcss : JCSS = new JCSS();
			
			// Version 1 - Default adapter configuration

			var box1 : Sprite = new Sprite();
			var adapter1 : JCSS_Adapter = new JCSS_Adapter();
			adapter1.cssName = "Box";
			adapter1.defineStyle("color", "#CCFF99", JCSS_StyleValueFormat.FORMAT_HTML_COLOR);
			adapter1.stylesInitializedHandler = function(adapter : JCSS_Adapter) : void {
				draw(adapter.component as Sprite, adapter.getStyle("color"));
			};
			jcss.registerComponent(box1, adapter1);
			addChild(box1);

			// Version 2 - Custom adapter configuration

			var box2 : Sprite = new Sprite();
			box2.x = 100;
			var adapter2 : JCSS_Adapter = new BoxAdapter();
			jcss.registerComponent(box2, adapter2);
			addChild(box2);

			// Version 3 - UI base class configuration

			JCSS_Sprite.jcss = jcss;
			var box3 : Box = new Box();
			box3.x = 200;
			addChild(box3);
		}
	}
}

import com.sibirjak.jakute.JCSS_Adapter;
import com.sibirjak.jakute.JCSS_Sprite;
import com.sibirjak.jakute.constants.JCSS_StyleValueFormat;

import flash.display.Sprite;

internal class BoxAdapter extends JCSS_Adapter {
	public function BoxAdapter() {
		cssName = "Box";
		defineStyle("color", "#CC99FF", JCSS_StyleValueFormat.FORMAT_HTML_COLOR);
	}

	override protected function onStylesInitialized() : void {
		draw(component as Sprite, getStyle("color"));
	}
}

internal class Box extends JCSS_Sprite {
	public function Box() {
		jcss_cssName = "Box";
		jcss_defineStyle("color", "#99CCFF", JCSS_StyleValueFormat.FORMAT_HTML_COLOR);
		// automatically registered in JCSS by super constructor
	}

	override protected function jcss_onStylesInitialized() : void {
		draw(this, jcss_getStyle("color"));
	}
}

internal function draw(shape : Sprite, color : uint) : void {
	with (shape.graphics) {
		beginFill(color);
		drawRect(0, 0, 80, 80);
	}
}