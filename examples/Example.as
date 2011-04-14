package {

	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;

	public class Example extends Sprite {
		public function Example() {
			x = y = 10;

			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;

			var background : Background = new Background();
			var w : uint = stage.stageWidth;
			if (!w) w = 550;
			var h : uint = stage.stageHeight;
			if (!h) h = 400;

			background.setSize(w, h);
			// stage.addChildAt(background, 0);
			stage.addChildAt(background, 0);

			var url : String = loaderInfo.parameters["movie"];
			var path : String = url.replace(/(\/)?[^\/]+$/, "$1");
			
			var symbol : String = "?";
			if (url.indexOf("?") > -1) symbol = "&";
			if (path) url = url + symbol + "path=" + path;

			var loader : Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, IOErrorHandler);
			loader.load(new URLRequest(url));
			addChild(loader);
		}

		private function IOErrorHandler(event : IOErrorEvent) : void {
			// do nothing
		}
	}
}

import com.sibirjak.asdpc.core.skins.BackgroundSkin;

internal class Background extends BackgroundSkin {
	override protected function border() : Boolean {
		return false;
	}
}