/*******************************************************************************
* The MIT License
* 
* Copyright (c) 2011 Jens Struwe.
* 
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
* 
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
* 
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
******************************************************************************/
package com.sibirjak.jakute.framework {

	import com.sibirjak.jakute.JCSS_Adapter;
	import com.sibirjak.jakute.framework.core.JCSS_StyleManagerMap;
	import com.sibirjak.jakute.framework.core.jcss_internal;
	import com.sibirjak.jakute.framework.roles.JCSS_ComponentRoleManager;
	import com.sibirjak.jakute.framework.states.JCSS_StateManager;
	import com.sibirjak.jakute.framework.stylerules.JCSS_StyleRule;
	import com.sibirjak.jakute.framework.styles.JCSS_StyleValueManager;
	import com.sibirjak.jakute.framework.update.JCSS_UpdateInfo;
	import com.sibirjak.jakute.framework.update.JCSS_UpdateManager;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;

	/**
	 * @author Jens Struwe 11.01.2011
	 */
	public class JCSS_ComponentStyleManager extends JCSS_StyleManager {

		private var _jcssAdapter : JCSS_Adapter;
		private var _component : DisplayObject;

		private var _cssName : String;
		private var _cssID : String;
		private var _cssClass : String;
		private var _states : Object;

		private var _encloseChildren : Boolean;
		private var _virtualParent : DisplayObject;

		private var _styleValueManager : JCSS_StyleValueManager;
		private var _stateManager : JCSS_StateManager;

		private var _depth : uint;
		private var _parentComponentStyleManager : JCSS_ComponentStyleManager;

		private var _initialized : Boolean;

		/*
		 * Constructor
		 */

		public function JCSS_ComponentStyleManager(adapter : JCSS_Adapter) {
			_jcssAdapter = adapter;

			_styleValueManager = new JCSS_StyleValueManager();
			_stateManager = new JCSS_StateManager(this);
			_roleManager = new JCSS_ComponentRoleManager(this);
			
			_updatesEnabled = false;
		}
		
		/*
		 * JCSS_StyleManager
		 */

		override public function get depth() : uint {
			return _depth;
		}

		/*
		 * Public properties
		 */

		/**
		 * It is not possible to register a component instance that is already on the stage.
		 * 
		 * However, when a component with a registered type is added to the stage, the
		 * ApplicationStyleManager is notified just before the components event handler. 
		 */
		public function set component(component : DisplayObject) : void {
			//trace ("REGISTER", this);
			_component = component;
			_component.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);

			_jcssAdapter.jcss_internal::registered_internal();
		}

		public function get component() : DisplayObject {
			return _component;
		}

		public function get initialized() : Boolean {
			return _initialized;
		}

		/*
		 * Selector Attributes
		 */

		public function set cssName(cssName : String) : void {
			if (_initialized) throw new Error("You cannot change the cssName after the component has been initialized.");
			_cssName = cssName;
		}

		public function get cssName() : String {
			return _cssName;
		}
		
		public function set cssID(cssID : String) : void {
			if (_initialized) throw new Error("You cannot change the cssID after the component has been initialized.");
			if (_cssID == cssID) return;
			_cssID = cssID;
		}
		
		public function get cssID() : String {
			return _cssID;
		}
		
		public function set cssClass(cssClass : String) : void {
			if (!cssClass) cssClass = null; // if intitially set the empty string ""
			if (_cssClass == cssClass) return;
			
			if (_updatesEnabled) {
				// stores all tree nodes for that an update should be performed
				componentRoleManager.notifyCSSClassChangesNext();
			}
			
			_cssClass = cssClass;
			
			if (_updatesEnabled) {
				JCSS_UpdateManager.getInstance().updateAll(this);
				componentRoleManager.foreachClassRelatedChildComponentStyleManager(
					JCSS_UpdateManager.getInstance().updateAll
				);
				JCSS_UpdateManager.getInstance().commit();
			}

		}
		
		public function get cssClass() : String {
			return _cssClass;
		}
		
		public function setState(stateName : String, value : String) : void {
			if (!_states) _states = new Object();
			
			var oldValue : String = _states[stateName];
			if (value === oldValue) return;
			_states[stateName] = value;
			
			if (_updatesEnabled) {
				// notifies all clients/listener about the state change 
				_stateManager.setState(stateName, oldValue, value);
				// finally dispatches all state changes at once
				JCSS_UpdateManager.getInstance().commit();
			}
		}
		
		public function getState(stateName : String) : String {
			if (!_states) return null;
			return _states[stateName];
		}

		/*
		 * Styles
		 */

		/**
		 * TODO enable priority fix to achieve unmodifiable styles.
		 */
		public function defineStyle(styleName : String, styleValue : *, format : String, priority : uint = 0) : void {
			if (_initialized) throw new Error("You cannot define a style for an already initialized component");
			
			_styleValueManager.defineStyle(styleName, format);
			
			setStyle("This", styleName, styleValue, priority);
		}
		
		public function getStyle(styleName : String) : * {
			return _styleValueManager.getStyle(styleName);
		}
		
		/*
		 * Properties
		 */
		
		public function encloseChildren() : void {
			if (_initialized) throw new Error("You cannot call encloseChildren() after the component has been initialized.");
			_encloseChildren = true;
		}

		public function childrenEnclosed() : Boolean {
			return _encloseChildren;
		}

		public function set virtualParent(parent : DisplayObject) : void {
			if (parent == _virtualParent) return;
			
			// You cannot set a descendant as virtual parent
			// The virtual parent needs to be in the display list
			if (parent) {
				if (!parent.stage) {
					throw new Error("You cannot set a virtual parent that is not in the display list");
				}
				if (_component is DisplayObjectContainer) {
					if (DisplayObjectContainer(_component).contains(parent)) {
						throw new Error("You cannot set a child component to a virtual parent.");
					};
				}
			}
			
			_virtualParent = parent;

			if (_virtualParent) {
				_virtualParent.addEventListener(Event.REMOVED_FROM_STAGE, virtualParentRemovedFromStageHandler);
			}

			virtualParentChanged();
		}
		
		public function get virtualParent() : DisplayObject {
			return _virtualParent;
		}
		
		/*
		 * Iterators
		 */

		public function foreachParentStyleManager(callback : Function) : Boolean {
			if (!foreachParentComponentStyleManager(callback)) return false;
			callback(JCSS_StyleManagerMap.getInstance().applicationStyleManager);
			return true;
		}
		
		public function foreachParentComponentStyleManager(callback : Function) : Boolean {
			var parentStyleManager : JCSS_ComponentStyleManager = _parentComponentStyleManager;
			while (parentStyleManager) {
				if (!callback(parentStyleManager)) return false;
				parentStyleManager = parentStyleManager._parentComponentStyleManager;
			}
			return true;
		}

		/*
		 * State
		 */

		public function commitStyleChanged(updateInfo : JCSS_UpdateInfo) : void {
			_styleValueManager.snapshotStyles();

			if (updateInfo.updateAll) {
				removeStyleRuleListeners();
				_styleValueManager.clearAllStyles();
				_roleManager.initRoles();
				initStyleRules();

			} else {
				var reason : String;
				var styleRule : JCSS_StyleRule;
				for (var key : * in updateInfo.styleRules) {
					styleRule = key;
					reason = updateInfo.styleRules[styleRule];
					
					switch (reason) {
						case JCSS_UpdateManager.STYLE_RULE_ACTIVATED:
						case JCSS_UpdateManager.STYLE_RULE_ADDED:
							_styleValueManager.addStyleRule(styleRule);
							break;
						case JCSS_UpdateManager.STYLE_CHANGED:
							_styleValueManager.updateStyleRule(styleRule);
							break;
						case JCSS_UpdateManager.STYLE_RULE_DEACTIVATED:
							_styleValueManager.removeStyleRule(styleRule);
							break;
					}
				}
			}
			
			//trace ("------------------------------commitStateChange", this, parentChainAsString());
			var changedStyles : Object = _styleValueManager.getChangedStyles();
			if (changedStyles) {
				//trace (stylesAsString(changedStyles));
				_jcssAdapter.jcss_internal::stylesChanged_internal(changedStyles);
			}
		}

		/*
		 * StyleManager
		 */

		/**
		 * Called after a matching style rule has been added at runtime.
		 */
		public function styleManager_notifyStyleRuleAdded(styleRule : JCSS_StyleRule) : void {
//			trace ("ADD RULE RUNTIME", styleRule, this);
			if (styleRule.numStates) {
				_stateManager.setListenersForStyleRule(styleRule);
				if (!_stateManager.styleRuleIsActive(styleRule)) return;
			}
			
			JCSS_UpdateManager.getInstance().updateStyleRule(this, styleRule, JCSS_UpdateManager.STYLE_RULE_ADDED);
		}
		
		/**
		 * Called after a matching style rule has been updated at runtime.
		 */
		public function styleManager_notifyStyleChanged(styleRule : JCSS_StyleRule) : void {
//			trace ("UPDATE RULE RUNTIME", styleRule, this);
			if (styleRule.numStates) {
				if (!_stateManager.styleRuleIsActive(styleRule)) return;
			}

			JCSS_UpdateManager.getInstance().updateStyleRule(this, styleRule, JCSS_UpdateManager.STYLE_CHANGED);
		}

		/*
		 * ComponentRoleManager
		 */
		
		public function get componentRoleManager() : JCSS_ComponentRoleManager {
			return _roleManager as JCSS_ComponentRoleManager;
		}

		/*
		 * DynamicStyleRuleManager
		 */

		public function get stateManager() : JCSS_StateManager {
			return _stateManager;
		}

		/**
		 * Called after a dynamic style rule has been activated.
		 */
		public function dynamicStyleRuleManager_notifyStyleRuleActivated(styleRule : JCSS_StyleRule, active : Boolean) : void {
			//trace ("styleRuleActivated", this, styleRule, active);

			if (active) {
				JCSS_UpdateManager.getInstance().updateStyleRule(this, styleRule, JCSS_UpdateManager.STYLE_RULE_ACTIVATED);
			} else {
				JCSS_UpdateManager.getInstance().updateStyleRule(this, styleRule, JCSS_UpdateManager.STYLE_RULE_DEACTIVATED);
			}
		}
		
		/*
		 * Add and Remove events
		 */

		private function addedToStageHandler(event : Event) : void {
			_component.removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
			_component.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
			
			//trace ("ADDED_TO_STAGE", this);
			findAndRegisterToParent();

			// init all ancestor and descendant roles
			_roleManager.initRoles();

			if (_initialized) {
				_styleValueManager.snapshotStyles();
				_styleValueManager.clearAllStyles();
				initStyleRules();

				_updatesEnabled = true;

				var changedStyles : Object = _styleValueManager.getChangedStyles();
				if (changedStyles) _jcssAdapter.jcss_internal::stylesChanged_internal(changedStyles);

			} else {
				// init style rules and styles
				initStyleRules();
				
				_initialized = true;
				_updatesEnabled = true;
	
				_jcssAdapter.jcss_internal::stylesInitialized_internal(_styleValueManager.styles);
			}

		}
		
		private function removedFromStageHandler(event : Event) : void {
			_component.removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler);
			_component.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);

			//trace ("REMOVED_FROM_STAGE", this, _jcssAdapter.component.stage, _jcssAdapter.component.root, _jcssAdapter.component.parent);
			removeStyleRuleListeners();
			unregisterFromParent();

			removeVirtualParent();
			
			JCSS_UpdateManager.getInstance().removeFromUpdates(this);

			_updatesEnabled = false;
		}
		
		/*
		 * Virtual parent
		 */

		private function virtualParentRemovedFromStageHandler(event : Event) : void {
			removeVirtualParent();
			virtualParentChanged();
		}
		
		private function removeVirtualParent() : void {
			if (_virtualParent) {
				_virtualParent.removeEventListener(Event.REMOVED_FROM_STAGE, virtualParentRemovedFromStageHandler);
				_virtualParent = null;
			}
		}

		private function virtualParentChanged() : void {
			if (!_updatesEnabled) return;
			
			unregisterFromParent();
			findAndRegisterToParent();
			JCSS_UpdateManager.getInstance().updateAll(this);

			foreachChildComponentStyleManager(setVirtualParentCallback);
			function setVirtualParentCallback(styleManager : JCSS_ComponentStyleManager) : Boolean {
				styleManager.initDepth();
				JCSS_UpdateManager.getInstance().updateAll(styleManager);
				return true;
			}

			JCSS_UpdateManager.getInstance().commit();
		}
		
		/*
		 * Initialize / Update
		 */

		private function findAndRegisterToParent() : void {
			var parent : DisplayObject = _virtualParent ? _virtualParent : _component.parent;

			while (parent) {
				_parentComponentStyleManager = JCSS_StyleManagerMap.getInstance().getComponentStyleManager(parent);
				if (_parentComponentStyleManager) break;
				parent = parent.parent;
			}
			//trace ("PARENT", _styleManagerID, 0);

			if (_parentComponentStyleManager) {
				_parentComponentStyleManager.registerDescendant(this);
			} else {
				JCSS_StyleManagerMap.getInstance().applicationStyleManager.registerDescendant(this);
			}
			
			initDepth();
		}

		private function initDepth() : void {
			if (_parentComponentStyleManager) {
				_depth = _parentComponentStyleManager.depth + 1;
			} else {
				_depth = 1;
			}
			
			setStyleRuleSpecifities();
		}
		
		private function setStyleRuleSpecifities() : void {
			_styleRuleTree.foreachStyleRule(setStyleRuleSpecifitiesCallback);
			function setStyleRuleSpecifitiesCallback(styleRule : JCSS_StyleRule) : void {
				styleRule.setOwnerDepth(_depth);
			}
		}

		private function initStyleRules() : void {
			componentRoleManager.foreachStyleRule(initStyleRule);
			function initStyleRule(styleRule : JCSS_StyleRule) : void {
				//trace("RULE", _styleManagerID, styleRule.selectorString);
				var active : Boolean = true;
				if (styleRule.numStates) {
					_stateManager.setListenersForStyleRule(styleRule);
					active = _stateManager.styleRuleIsActive(styleRule);
				}
				if (active) _styleValueManager.addStyleRule(styleRule);
			}
		}
		
		/*
		 * Cleanup
		 */
		
		private function unregisterFromParent() : void {
			if (_parentComponentStyleManager) {
				_parentComponentStyleManager.unregisterDescendant(this);
			} else {
				JCSS_StyleManagerMap.getInstance().applicationStyleManager.unregisterDescendant(this);
			}
		}
		
		private function removeStyleRuleListeners() : void {
			componentRoleManager.unregisterFromTreeNodes();

			componentRoleManager.foreachStyleRule(removeListenersCallback);
			function removeListenersCallback(styleRule : JCSS_StyleRule) : void {
				if (styleRule.numStates) {
					_stateManager.removeListenersForStyleRule(styleRule);
				}
			}
		}

		/*
		 * Info
		 */
		
		override public function styleRuleTreeAsString() : String {
			var string : String = "------------------ StyleRuleTree for " + parentChainAsString() + "\n";
			string += _styleRuleTree.dumpAsString("This");
			string += "\n";
			return string;
		}

		public function componentSelectorAsString() : String {
			return _cssName + (_cssID ? "#" + _cssID : "") + (_cssClass ? "." + _cssClass : "");
		}

		public function stylesAsString(styles : Object = null) : String {
			var string : String = "------------------ Styles for";
			string += " " + parentChainAsString();
			string += " ------------------\n";
			
			string += _styleValueManager.stylesAsString(styles);
			return string;
		}

		public function parentChainAsString() : String {
			var ancestorString : String = componentSelectorAsString() + "(" + _styleManagerID + ")";
			var parentStyleManager : JCSS_ComponentStyleManager = _parentComponentStyleManager;
			while (parentStyleManager) {
				ancestorString += " < " + parentStyleManager.componentSelectorAsString() + "(" + parentStyleManager.styleManagerID + ")";
				parentStyleManager = parentStyleManager._parentComponentStyleManager;
			}
			return ancestorString;
		}

		public function toString() : String {
			return "[ComponentStyleManager] id:" + _styleManagerID + " chain:" + parentChainAsString();
		}

	}
}
