package helloworld.panel {

	import helloworld.Component;
	import com.sibirjak.jakute.JCSS;

	public class ControlPanelStyles extends ControlPanel {
		
		private var _jcss : JCSS;
		
		public function ControlPanelStyles(jcss : JCSS, component : Component) {
			super(component);
			
			_jcss = jcss;
		}

		override protected function setWidth(w : uint) : void {
			_jcss.setStyle("Box", "width", w);
		}

		override protected function setHeight(h : uint) : void {
			_jcss.setStyle("Box", "height", h);
		}

		override protected function setBackgroundColor(color : uint) : void {
			_jcss.setStyle("Box", "background", color);
		}

		override protected function setBorderColor(color : uint) : void {
			_jcss.setStyle("Box", "border", color);
		}

		override protected function setBorderSize(size : uint) : void {
			super.setBorderSize(size);
			_jcss.setStyle("Box", "thickness", size);
		}
	}
}
