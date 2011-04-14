package helloworld.panel {

	import helloworld.Component;

	public class ControlPanelProperties extends ControlPanel {
		public function ControlPanelProperties(component : Component) {
			super(component);
		}

		override protected function setWidth(w : uint) : void {
			_component.w = w;
			_component.draw();
		}

		override protected function setHeight(h : uint) : void {
			_component.h = h;
			_component.draw();
		}

		override protected function setBackgroundColor(color : uint) : void {
			_component.backgroundColor = color;
			_component.draw();
		}

		override protected function setBorderColor(color : uint) : void {
			_component.borderColor = color;
			_component.draw();
		}

		override protected function setBorderSize(size : uint) : void {
			super.setBorderSize(size);
			_component.borderSize = size;
			_component.draw();
		}
	}
}
