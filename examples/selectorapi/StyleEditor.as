package selectorapi {

	import selectorapi.styleeditor.Box;
	import selectorapi.styleeditor.StyleRuleListItem;
	import selectorapi.styleeditor.StyleRuleListItemRenderer;

	import com.sibirjak.asdpc.button.Button;
	import com.sibirjak.asdpc.button.ButtonEvent;
	import com.sibirjak.asdpc.core.View;
	import com.sibirjak.asdpc.listview.ListView;
	import com.sibirjak.asdpc.listview.renderer.ListItemContent;
	import com.sibirjak.asdpc.listview.renderer.ListItemRenderer;
	import com.sibirjak.asdpc.textfield.Label;
	import com.sibirjak.asdpc.textfield.TextInput;
	import com.sibirjak.asdpcbeta.colorpicker.ColorPicker;
	import com.sibirjak.asdpcbeta.selectbox.SelectBox;
	import com.sibirjak.jakute.JCSS;
	import com.sibirjak.jakute.JCSS_Sprite;
	import com.sibirjak.jakute.framework.JCSS_ApplicationStyleManager;
	import com.sibirjak.jakute.framework.core.jcss_internal;
	import com.sibirjak.jakute.framework.stylerules.JCSS_StyleRule;

	import org.as3commons.collections.fx.LinkedMapFx;

	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Rectangle;

	public class StyleEditor extends Sprite {
		private var _styleRules : LinkedMapFx;
		private var _selectComponent : SelectBox;
		private var _selectState : SelectBox;
		private var _childButton : Button;
		private var _addRuleInput : TextInput;
		private var _clearButton : Button;
		private var _backgroundColorPicker : ColorPicker;
		private var _addButton : Button;
		private var _list : ListView;
		private var _box : Box;
		private var _buttonStyles : Array = [Button.style.disabledSkin, null, Button.style.upIconSkin, null, Button.style.overIconSkinName, Button.UP_ICON_SKIN_NAME, Button.style.downIconSkinName, Button.UP_ICON_SKIN_NAME, Button.style.disabledIconSkinName, Button.UP_ICON_SKIN_NAME];
		/* assets */
		[Embed(source="styleeditor/add_below.png")]
		private var _add : Class;
		[Embed(source="styleeditor/clear.png")]
		private var _clear : Class;

		public function StyleEditor() {
			_styleRules = new LinkedMapFx();

			JCSS_Sprite.jcss = new JCSS();
			JCSS_Sprite.jcss.jcss_internal::applicationStyleManager.jcssStyleRuleEventCallback = jcssStyleRuleEventCallback;

			JCSS_Sprite.jcss.setStyle("Box:over", "backgroundColor", 0xBBDDDD);
			JCSS_Sprite.jcss.setStyle("Box Box", "backgroundColor", 0x88BB88);
			JCSS_Sprite.jcss.setStyle("Box#1", "backgroundColor", 0xFFFF66);
			JCSS_Sprite.jcss.setStyle("Box#1 > Box", "backgroundColor", 0xBCCC7A);

			/*
			 * Boxes
			 */

			var box : Box = new Box(0, 0, 200, 140);
			box.jcss_cssName = "Box";
			box.jcss_cssID = "1";
			box.jcss_cssClass = "a";
			addChild(box);

			var box2 : Box = new Box(20, 20, 160, 100);
			box2.jcss_cssName = "Box";
			box2.jcss_cssID = "2";
			box2.jcss_cssClass = "b";
			box.addChild(box2);

			var box3 : Box = new Box(20, 20, 120, 60);
			box3.jcss_cssName = "Box";
			box3.jcss_cssID = "3";
			box3.jcss_cssClass = "c";
			box2.addChild(box3);
			_box = box3;

			var box4 : Box = new Box(220, 0, 200, 140);
			box4.jcss_cssName = "Box";
			box4.jcss_cssID = "4";
			box4.jcss_cssClass = "a";
			addChild(box4);

			var box5 : Box = new Box(20, 20, 160, 100);
			box5.jcss_cssName = "Box";
			box5.jcss_cssID = "5";
			box5.jcss_cssClass = "b";
			box4.addChild(box5);

			var box6 : Box = new Box(20, 20, 120, 60);
			box6.jcss_cssName = "Box";
			box6.jcss_cssID = "6";
			box6.jcss_cssClass = "c";
			box5.addChild(box6);

			var view : View = dottedSeparator(420);
			view.moveTo(0, 150);
			addChild(view);

			/*
			 * Add rule controls
			 */

			var controls : Sprite = new Sprite();
			controls.y = 160;
			addChild(controls);

			_selectComponent = new SelectBox();
			_selectComponent.setSize(105, 18);
			_selectComponent.moveTo(0, 0);
			_selectComponent.dataSource = ["Component", "Box", "Box#1", "Box#2", "Box#3", "Box.a", "Box.b", "Box.c"];
			_selectComponent.selectItemAt(0);
			_selectComponent.bindProperty(SelectBox.BINDABLE_PROPERTY_SELECTED_ITEM, componentSelectedHandler);
			controls.addChild(_selectComponent);

			_selectState = new SelectBox();
			_selectState.setSize(105, 18);
			_selectState.moveTo(110, 0);
			_selectState.dataSource = ["State", ":over", ":down", ":active", ":!over", ":!down", ":!active"];
			_selectState.selectItemAt(0);
			_selectState.bindProperty(SelectBox.BINDABLE_PROPERTY_SELECTED_ITEM, stateSelectedHandler);
			controls.addChild(_selectState);

			_childButton = new Button();
			_childButton.setSize(18, 18);
			_childButton.moveTo(220, 0);
			_childButton.label = ">";
			_childButton.toolTip = "Child combinator";
			_childButton.addEventListener(ButtonEvent.CLICK, childButtonClickHandler);
			controls.addChild(_childButton);

			/*
			 * Add rule controls2
			 */

			_addRuleInput = new TextInput();
			_addRuleInput.moveTo(0, 23);
			_addRuleInput.setSize(344, 25);
			_addRuleInput.setStyle(Label.style.font, "_typewriter");
			_addRuleInput.setStyle(Label.style.size, 12);
			_addRuleInput.text = "Box";
			controls.addChild(_addRuleInput);

			_clearButton = new Button();
			_clearButton.setSize(13, 13);
			_clearButton.moveTo(327, 26);
			_clearButton.setStyles(_buttonStyles);
			_clearButton.setStyle(Button.style.upIconSkin, _clear);
			_clearButton.toolTip = "Clear";
			_clearButton.addEventListener(ButtonEvent.CLICK, clearButtonClickHandler);
			controls.addChild(_clearButton);

			_backgroundColorPicker = new ColorPicker();
			_backgroundColorPicker.moveTo(350, 25);
			_backgroundColorPicker.setSize(20, 20);
			_backgroundColorPicker.toolTip = "Background";
			_backgroundColorPicker.selectedColor = 0xBBFF99;
			controls.addChild(_backgroundColorPicker);

			_addButton = new Button();
			_addButton.setSize(20, 20);
			_addButton.moveTo(400, 25);
			_addButton.setStyles(_buttonStyles);
			_addButton.setStyle(Button.style.upIconSkin, _add);
			_addButton.toolTip = "Add";
			_addButton.addEventListener(ButtonEvent.CLICK, addRuleHandler);
			controls.addChild(_addButton);

			view = dottedSeparator(420);
			view.moveTo(0, 58);
			controls.addChild(view);

			/*
			 * Existing rules
			 */

			_list = new ListView();
			_list.setSize(420, 80);
			_list.moveTo(0, 230);
			_list.setStyle(ListItemRenderer.style.contentRenderer, StyleRuleListItemRenderer);
			_list.setStyle(ListItemRenderer.style.overBackgroundColors, [0xEEEEEE]);
			_list.setStyle(ListItemRenderer.style.selectedBackgroundColors, null);
			_list.setStyle(ListItemContent.style.selectedLabelStyles, null);
			_list.setStyle(Label.style.font, "_typewriter");
			_list.dataSource = _styleRules;
			addChild(_list);
		}

		private function componentSelectedHandler(item : String) : void {
			if (item != "Component") {
				var text : String = _addRuleInput.text;
				if (text.length && text.charAt(text.length - 1) != " ") text += " ";
				text += item;
				_addRuleInput.text = text;
			}
			_selectComponent.selectItemAt(0);
		}

		private function stateSelectedHandler(item : String) : void {
			if (item != "State") {
				var text : String = _addRuleInput.text;
				text += item;
				_addRuleInput.text = text;
			}
			_selectState.selectItemAt(0);
		}

		private function clearButtonClickHandler(event : ButtonEvent) : void {
			_addRuleInput.text = "";
		}

		private function childButtonClickHandler(event : ButtonEvent) : void {
			_addRuleInput.text += " > ";
		}

		private function addRuleHandler(event : ButtonEvent) : void {
			JCSS_Sprite.jcss.setStyle(_addRuleInput.text, "backgroundColor", _backgroundColorPicker.selectedColor);
		}

		private function jcssStyleRuleEventCallback(jcssEvent : Object) : void {
			var styleRule : JCSS_StyleRule = jcssEvent["stylerule"];
			if (!styleRule.firstSelector.descendant) return;

			var info : String = jcssEvent["info"];
			var listItem : StyleRuleListItem;

			if (info == JCSS_ApplicationStyleManager.STYLE_RULE_ADDED) {
				listItem = new StyleRuleListItem(styleRule);
				_styleRules.add(styleRule.firstSelector.selectorID, listItem);
				if (_list) _list.scrollToItemAt(_list.numItems - 1);

			} else if (info == JCSS_ApplicationStyleManager.STYLE_RULE_UPDATED) {
				listItem = _styleRules.itemFor(styleRule.firstSelector.selectorID);
				listItem.dispatchUpdate();

			} else if (info == JCSS_ApplicationStyleManager.STYLE_RULE_REMOVED) {
				_styleRules.removeKey(styleRule.firstSelector.selectorID);
				if (_list) _list.scrollToItemAt(_list.numItems - 1);
			}

			// trace (info, styleRule.firstSelector.selectorID, styleRule.selectorString);
		}

		private function dottedSeparator(size : uint) : View {
			var separator : View = new View();

			dashHorizontal(0, 0, size);

			return separator;

			function dashHorizontal(x : int, y : int, width : int) : void {
				var r1 : Rectangle = new Rectangle(0, 0, 2, 1);
				var r2 : Rectangle = new Rectangle(2, 0, 2, 1);

				var horizontalTile : BitmapData = new BitmapData(4, 1, true);
				horizontalTile.fillRect(r1, (0xFF << 24) + 0xCCCCCC);
				horizontalTile.fillRect(r2, 0x00000000);

				with (separator.graphics) {
					lineStyle();
					beginBitmapFill(horizontalTile, null, true);
					drawRect(x, y, width, 1);
					endFill();
				}
			}
		}
	}
}
