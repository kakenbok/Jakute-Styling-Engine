package configuration {

	import com.sibirjak.jakute.JCSS;
	import com.sibirjak.jakute.JCSS_Adapter;
	import flash.display.Sprite;

	public class CreatingAnAdapter extends Sprite {
		public function CreatingAnAdapter() {
			// Version 1 - Default adapter configuration

			var box1 : Sprite = new Sprite();
			var adapter1 : JCSS_Adapter = new JCSS_Adapter();
			adapter1.cssName = "Box";
			adapter1.defineStyle("color", "#CCFF99", JCSS.FORMAT_COLOR);
			adapter1.stylesInitializedHandler = function(styles : Object, adapter : JCSS_Adapter) : void {
				draw(adapter.component as Sprite, adapter.getStyle("color"));
			};
			JCSS.getInstance().registerComponent(box1, adapter1);
			addChild(box1);

			// Version 2 - Custom adapter configuration

			var box2 : Sprite = new Sprite();
			box2.x = 100;
			var adapter2 : JCSS_Adapter = new BoxAdapter();
			JCSS.getInstance().registerComponent(box2, adapter2);
			addChild(box2);

			// Version 3 - UI base class configuration

			var box3 : Box = new Box();
			box3.x = 200;
			addChild(box3);
		}
	}
}

import com.sibirjak.jakute.JCSS;
import com.sibirjak.jakute.JCSS_Adapter;
import com.sibirjak.jakute.JCSS_Sprite;
import flash.display.Sprite;

internal class BoxAdapter extends JCSS_Adapter {
	public function BoxAdapter() {
		cssName = "Box";
		defineStyle("color", "#CC99FF", JCSS.FORMAT_COLOR);
	}

	override protected function onStylesInitialized(styles : Object) : void {
		draw(component as Sprite, getStyle("color"));
	}
}

internal class Box extends JCSS_Sprite {
	public function Box() {
		jcss_cssName = "Box";
		jcss_defineStyle("color", "#99CCFF", JCSS.FORMAT_COLOR);
		// automatically registered in JCSS by super constructor
	}

	override protected function jcss_onStylesInitialized(styles : Object) : void {
		draw(this, jcss_getStyle("color"));
	}
}

internal function draw(shape : Sprite, color : uint) : void {
	with (shape.graphics) {
		beginFill(color);
		drawRect(0, 0, 80, 80);
	}
}