package features.externalcss {

	import features.externalcss.box.Box;
	import com.sibirjak.jakute.JCSS;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class LoadExternalStyles extends Sprite {
		public function LoadExternalStyles() {
			var loader : URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, stylesLoaded);
			var path : String = loaderInfo.parameters["path"] || "";
			loader.load(new URLRequest(path + "load_external_styles.css"));
		}

		private function stylesLoaded(event : Event) : void {
			JCSS.getInstance().setStyleSheet(URLLoader(event.currentTarget).data);
			
			var box : Box = new Box();
			box.addChild(new Box());
			addChild(box);
		}
	}
}