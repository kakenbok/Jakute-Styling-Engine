package features.usestyles {

	import features.usestyles.box.BoxWithStyles;
	import com.sibirjak.jakute.JCSS;
	import flash.display.Sprite;

	public class WithStyles extends Sprite {
		public function WithStyles() {
			JCSS.getInstance().setStyleSheet(<styles><![CDATA[
				Box#first { w: 90; h: 90; color: #FF9900; }
				Box#second { w: 70; h: 70; x: 100; y: 10; color: #0099FF; }
				Box#third { w: 50; h: 50; x: 180; y: 20; color: #DDDD00; }
				Box#last { w: 30; h: 30; x: 240; y: 30; color: #66DD66; }
			]]></styles>);

			addChild(new BoxWithStyles("first"));
			addChild(new BoxWithStyles("second"));
			addChild(new BoxWithStyles("third"));
			addChild(new BoxWithStyles("last"));
		}
	}
}