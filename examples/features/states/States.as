package features.states {

	import features.states.box.Box;
	import com.sibirjak.jakute.JCSS;
	import flash.display.Sprite;

	public class States extends Sprite {
		public function States() {
			JCSS.getInstance().setStyleSheet(StatesCSS.styles);
			
			var box : Box = new Box();
			box.addChild(new Box());
			addChild(box);
		}
	}
}