package helloworld.panel {

	import helloworld.Component;
	import com.sibirjak.jakute.JCSS;

	public class ControlPanelStyles extends ControlPanel {
		
		public function ControlPanelStyles(component : Component) {
			super(component);
		}

		override protected function setWidth(w : uint) : void {
			JCSS.getInstance().setStyle("Box", "width", w);
		}

		override protected function setHeight(h : uint) : void {
			JCSS.getInstance().setStyle("Box", "height", h);
		}

		override protected function setBackgroundColor(color : uint) : void {
			JCSS.getInstance().setStyle("Box", "background", color);
		}

		override protected function setBorderColor(color : uint) : void {
			JCSS.getInstance().setStyle("Box", "border", color);
		}

		override protected function setBorderSize(size : uint) : void {
			super.setBorderSize(size);
			JCSS.getInstance().setStyle("Box", "thickness", size);
		}
	}
}
