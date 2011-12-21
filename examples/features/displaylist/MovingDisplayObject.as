package features.displaylist {
	import features.displaylist.box.Box;
	import com.sibirjak.jakute.JCSS;
	import com.sibirjak.jakute.JCSS_Sprite;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class MovingDisplayObject extends Sprite {
		
		private var _childBox : Box;
		private var _lastParent : Box;
		private var _currentDropTarget : Box;
		
		public function MovingDisplayObject() {
			JCSS_Sprite.jcss = new JCSS();
			JCSS_Sprite.jcss.setStyleSheet(MovingDisplayObjectCSS.styles);
			
			// red box
			var redBox : Box = new Box();
			redBox.jcss_cssID = "red";
			redBox.jcss_cssClass = "container";
			addChild(redBox);
			
			// blue box
			var blueBox : Box = new Box();
			blueBox.jcss_cssID = "blue";
			blueBox.jcss_cssClass = "container";
			addChild(blueBox);

			// child box
			_childBox = new Box();
			_childBox.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			blueBox.addChild(_childBox);
		}

		private function mouseDown(event : MouseEvent) : void {
			// cache last parent
			_lastParent = _currentDropTarget = _childBox.parent as Box;

			// perform style related operations
			_lastParent.removeChild(_childBox);
			_childBox.jcss_virtualParent = _lastParent;
			_childBox.jcss_setState("moving", "true");
			addChildAt(_childBox, 2);

			// highlight possible drop target
			_currentDropTarget.jcss_setState("over", "true");

			// start dragging
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
			_childBox.x += _lastParent.x;
			_childBox.y += _lastParent.y;
			_childBox.startDrag();
		}

		private function mouseMove(event : MouseEvent) : void {
			checkDropTarget(event.stageX, event.stageY);
		}

		private function mouseUp(event : MouseEvent) : void {
			// stop dragging
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
			_childBox.stopDrag();

			// reset highlighting of drop target
			_currentDropTarget.jcss_setState("over", "false");
			_lastParent = _currentDropTarget;
			_currentDropTarget = null;

			// perform style related operations
			removeChild(_childBox);
			_childBox.jcss_setState("moving", "false");
			_lastParent.addChild(_childBox);
		}
		
		private function checkDropTarget(stageX : Number, stageY : Number) : void {
			var objects : Array = stage.getObjectsUnderPoint((new Point(stageX, stageY)));
			var target : Box = _lastParent;
			for each (var object : DisplayObject in objects) {
				if (object is Box && object != _childBox) {
					target = object as Box;
					break;
				}
			}

			if (_currentDropTarget != target) {
				_currentDropTarget.jcss_setState("over", "false");
				_currentDropTarget = target;
			}
			_currentDropTarget.jcss_setState("over", "true");
		}
	}
}