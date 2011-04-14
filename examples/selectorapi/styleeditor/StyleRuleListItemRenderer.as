package selectorapi.styleeditor {

	import com.sibirjak.asdpc.button.Button;
	import com.sibirjak.asdpc.button.ButtonEvent;
	import com.sibirjak.asdpc.listview.ListItemData;
	import com.sibirjak.asdpc.listview.renderer.ListItemContent;
	import com.sibirjak.asdpcbeta.colorpicker.ColorPicker;
	import com.sibirjak.jakute.JCSS;
	import com.sibirjak.jakute.framework.core.JCSS_StyleManagerMap;
	import com.sibirjak.jakute.framework.stylerules.JCSS_StyleDeclaration;
	import com.sibirjak.jakute.framework.stylerules.JCSS_StyleRule;

	public class StyleRuleListItemRenderer extends ListItemContent {
		private var _backgroundColorPicker : ColorPicker;
		private var _removeButton : Button;
		/* assets */
		[Embed(source="remove.png")]
		private var _remove : Class;
		private var _buttonStyles : Array = [Button.style.disabledSkin, null, Button.style.upIconSkin, null, Button.style.overIconSkinName, Button.UP_ICON_SKIN_NAME, Button.style.downIconSkinName, Button.UP_ICON_SKIN_NAME, Button.style.disabledIconSkinName, Button.UP_ICON_SKIN_NAME];

		public function StyleRuleListItemRenderer() {
			setStyles([style.labelFunction, function(data : ListItemData) : String {
				var patternRoot : RegExp = new RegExp(">This\\S* ", "g");
				var patternChildren : RegExp = new RegExp(">", "g");
				return getStyleRule(data.item).selectorString.replace(patternRoot, "").replace(patternChildren, "> ");
				// return getStyleRule(data.item).selectorString.replace(">This ", "").replace(patternChildren, "> ");
			}]);
		}

		private function getStyleRule(item : StyleRuleListItem = null) : JCSS_StyleRule {
			if (!item) item = data.item;
			return StyleRuleListItem(item).styleRule;
		}

		override protected function draw() : void {
			super.draw();

			var styleRule : JCSS_StyleRule = getStyleRule();

			_backgroundColorPicker = new ColorPicker();
			_backgroundColorPicker.setSize(16, 16);
			_backgroundColorPicker.moveTo(_width - 68, 2);
			_backgroundColorPicker.toolTip = "Background";
			_backgroundColorPicker.selectedColor = JCSS_StyleDeclaration(styleRule.styles["backgroundColor"]).value;
			_backgroundColorPicker.bindProperty(ColorPicker.BINDABLE_PROPERTY_SELECTED_COLOR, setBackgroundColor);
			addChild(_backgroundColorPicker);

			_removeButton = new Button();
			_removeButton.setSize(13, 13);
			_removeButton.moveTo(_width - 18, 3);
			_removeButton.setStyles(_buttonStyles);
			_removeButton.setStyle(Button.style.upIconSkin, _remove);
			_removeButton.toolTip = "Remove";
			_removeButton.addEventListener(ButtonEvent.CLICK, removeButtonClickHandler);
			addChild(_removeButton);
		}

		override protected function update() : void {
			super.update();

			if (isInvalid(UPDATE_PROPERTY_DATA) || isInvalid(UPDATE_PROPERTY_DATA_PROPERTY)) {
				var styleRule : JCSS_StyleRule = getStyleRule();
				_backgroundColorPicker.selectedColor = JCSS_StyleDeclaration(styleRule.styles["backgroundColor"]).value;
			}

			if (isInvalid(UPDATE_PROPERTY_WIDTH)) {
				_backgroundColorPicker.moveTo(_width - 68, 2);
				_removeButton.moveTo(_width - 18, 3);
			}
		}

		private function setBackgroundColor(color : uint) : void {
			JCSS.getInstance().setStyle(getStyleRule().selectorString, "backgroundColor", color);
		}

		private function removeButtonClickHandler(event : ButtonEvent) : void {
			JCSS_StyleManagerMap.getInstance().applicationStyleManager.removeStyleRule(getStyleRule());
		}
	}
}
