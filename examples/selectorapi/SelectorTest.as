package selectorapi {

	import selectorapi.selectortest.Box;

	import com.sibirjak.asdpc.listview.ListItemEvent;
	import com.sibirjak.asdpc.listview.ListView;
	import com.sibirjak.asdpc.listview.renderer.ListItemRenderer;
	import com.sibirjak.jakute.JCSS;
	import com.sibirjak.jakute.JCSS_Sprite;
	import com.sibirjak.jakute.constants.JCSS_StyleDeclarationPriority;

	import flash.display.Sprite;

	public class SelectorTest extends Sprite {
		
		private var _lastSelect : String;
		private var _selectList : ListView;
		private var _selectList2 : ListView;
		
		public function SelectorTest() {
			JCSS_Sprite.jcss = new JCSS();
			JCSS_Sprite.jcss.setStyle("> Box > Box", "backgroundColor", "#C2FF99", JCSS_StyleDeclarationPriority.PRIORITY_IMPORTANT);
			_lastSelect = "> Box > Box";

			/*
			 * Boxes
			 */

			var box : Box = new Box(0, 0, 200, 140);
			box.jcss_cssName = "Box";
			addChild(box);

			var box2 : Box = new Box(20, 20, 160, 100);
			box2.jcss_cssName = "Box";
			box.addChild(box2);

			var box3 : Box = new Box(20, 20, 120, 60);
			box3.jcss_cssName = "Box";
			box2.addChild(box3);

			var box4 : Box = new Box(220, 0, 200, 140);
			box4.jcss_cssName = "Box";
			box4.jcss_setState("active", "true");
			addChild(box4);

			var box5 : Box = new Box(20, 20, 160, 100);
			box5.jcss_cssName = "Box";
			box5.jcss_setState("active", "true");
			box4.addChild(box5);

			var box6 : Box = new Box(20, 20, 120, 60);
			box6.jcss_cssName = "Box";
			box6.jcss_setState("active", "true");
			box5.addChild(box6);

			/*
			 * Add rule controls
			 */

			var controls : Sprite = new Sprite();
			controls.y = 150;
			addChild(controls);

			_selectList = new ListView();
			_selectList.setStyle(ListItemRenderer.style.selectedBackgroundColors, [0x92A6E2]);
			_selectList.setSize(200, 160);
			_selectList.dataSource = [
				"Box",
				"Box Box",
				"Box Box Box",
				"> Box",
				"> Box > Box",
				"> Box > Box > Box"
			];
			_selectList.selectItemAt(4);
			_selectList.addEventListener(ListItemEvent.CLICK, listClickHandler);
			controls.addChild(_selectList);

			_selectList2 = new ListView();
			_selectList2.setStyle(ListItemRenderer.style.selectedBackgroundColors, [0x92A6E2]);
			_selectList2.setSize(200, 120);
			_selectList2.moveTo(220, 0);
			_selectList2.dataSource = [
				"Box:over",
				"Box:active",
				"Box:active:over",
				"Box:active Box",
				"Box:active > Box",
				"Box:active Box Box",
			];
			_selectList2.addEventListener(ListItemEvent.CLICK, listClickHandler);
			controls.addChild(_selectList2);

		}

		private function listClickHandler(event : ListItemEvent) : void {
			var select : String = event.item;

			JCSS_Sprite.jcss.setStyle(_lastSelect, "backgroundColor", 0xEEEEEE, JCSS_StyleDeclarationPriority.PRIORITY_IMPORTANT);
			JCSS_Sprite.jcss.setStyle(select, "backgroundColor", "#C2FF99", JCSS_StyleDeclarationPriority.PRIORITY_IMPORTANT);
			
			if (event.currentTarget == _selectList) _selectList2.deselectItemAt(_selectList2.selectedIndex);
			else _selectList.deselectItemAt(_selectList.selectedIndex);
			
			_lastSelect = select;
		}

	}
}