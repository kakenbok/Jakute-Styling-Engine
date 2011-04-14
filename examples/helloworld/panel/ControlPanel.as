package helloworld.panel {

	import helloworld.Component;

	public class ControlPanel extends ControlPanelBase {
		protected var _component : Component;
		public function ControlPanel(component : Component) {
			// button
			_component = component;
			_component.x = 2;
			_component.y = 66;

			// controls
			addChild(
				document(
					hLayout(
						label("Width:"),
						sliderWithLabel({value:_component.w, minValue:50, maxValue:400, snapInterval:5, change:setWidth}),
						spacer(0),
						label("Height:"),
						sliderWithLabel({value:_component.h, minValue:50, maxValue:200, snapInterval:5, change:setHeight})
					),
					hLayout(
						label("Background:"),
						colorPicker({color:_component.backgroundColor, tip:"Background", change:setBackgroundColor}),
						spacer(0),
						label("Border:"),
						colorPicker({color:_component.borderColor, tip:"Border", change:setBorderColor}),
						spacer(0),
						label("Border size:"),
						sliderWithLabel({value:_component.borderSize, minValue:0, maxValue:10, snapInterval:1, change:setBorderSize})
					),
					vSpacer(0),
					dottedSeparator(580)
				)
			);
		}
		
		protected function setWidth(color : uint) : void {
		}

		protected function setHeight(color : uint) : void {
		}

		protected function setBackgroundColor(color : uint) : void {
		}

		protected function setBorderColor(color : uint) : void {
		}

		protected function setBorderSize(size : uint) : void {
			_component.x = Math.floor(size / 2);
			_component.y = 65 + Math.floor(size / 2);
		}
		
	}
}
