package features.selectors {

	import features.selectors.box.Box;
	import com.sibirjak.jakute.JCSS;
	import flash.display.Sprite;

	public class Selectors extends Sprite {
		public function Selectors() {
			JCSS.getInstance().setStyleSheet(SelectorsCSS.styles);
			
			var container : Box = new Box();
			container.jcss_cssID = "first";
			container.jcss_cssClass = "big";
			addChildrenTo(container);
			addChild(container);
			
			container = new Box();
			container.jcss_cssID = "second";
			container.jcss_cssClass = "big";
			addChildrenTo(container);
			addChild(container);
		}
		
		private function addChildrenTo(container : Box) : void {
			var box : Box = new Box();
			box.jcss_cssID = "first";
			box.jcss_cssClass = "small";
			container.addChild(box);

			box = new Box();
			box.jcss_cssID = "second";
			box.jcss_cssClass = "small";
			container.addChild(box);
		}
	}
}