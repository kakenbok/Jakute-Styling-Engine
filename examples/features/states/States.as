package features.states {
	import features.states.box.Box;
	import com.sibirjak.jakute.JCSS;
	import com.sibirjak.jakute.JCSS_Sprite;
	import flash.display.Sprite;

	public class States extends Sprite {
		public function States() {
			JCSS_Sprite.jcss = new JCSS();
			JCSS_Sprite.jcss.setStyleSheet(StatesCSS.styles);
			
			var box : Box = new Box();
			box.addChild(new Box());
			addChild(box);
		}
	}
}