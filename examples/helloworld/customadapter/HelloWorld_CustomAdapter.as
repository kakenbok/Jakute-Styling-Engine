package helloworld.customadapter {

	import com.sibirjak.jakute.JCSS;
	import com.sibirjak.jakute.JCSS_Adapter;
	import flash.display.Sprite;
	import helloworld.Component;

	public class HelloWorld_CustomAdapter extends Sprite {
		public function HelloWorld_CustomAdapter() {
			var jcss : JCSS = new JCSS();
			jcss.setStyleSheet(CSS.styles);

			var box : Component = new Component();
			var adapter : JCSS_Adapter = new CustomAdapter();
			jcss.registerComponent(box, adapter);
			addChild(box);
		}
	}
}

internal class CSS {
	public static var styles : String = <styles><![CDATA[
		Box {
			width: 200;
			height: 200;
			background: #99CCFF;
			border: #779999
		}
	]]></styles>.toString();
}