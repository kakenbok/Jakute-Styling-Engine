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
package com.sibirjak.jakute.framework.states {

	import com.sibirjak.jakute.framework.JCSS_ComponentStyleManager;
	import com.sibirjak.jakute.framework.stylerules.JCSS_Selector;
	import com.sibirjak.jakute.framework.stylerules.JCSS_StyleRule;
	import com.sibirjak.jakute.framework.stylerules.JCSS_StyleRuleTreeNode;

	/**
	 * @author Jens Struwe 11.01.2011
	 */
	public class JCSS_StateManager extends JCSS_StateListener {

		private var _dispatchers : Object;
		
		public function JCSS_StateManager(styleManager : JCSS_ComponentStyleManager) {
			super(styleManager);
			
			_dispatchers = new Object();
		}
		
		/*
		 * JCSS_DynamicStyleRuleListener
		 */
		
		override public function notifyParentStateChanged(dispatcher : JCSS_StateDispatcher) : void {
			//trace ("state changed", this, dispatcher);
			_styleManager.dynamicStyleRuleManager_notifyStyleRuleActivated(dispatcher.styleRule, dispatcher.isActive());
		}

		/*
		 * JCSS_StateManager
		 */

		public function setListenersForStyleRule(styleRule : JCSS_StyleRule) : void {
			//trace ("#########setListenersForStyleRule", this, styleRule.selectorString, styleRule.lastSelector.selectorString, "(" + styleRule.lastSelector.selectorID + ")");
			//trace (_styleManager, "setListenersForStyleRule", styleRule);
			setListenersForSelector(
				this,
				styleRule,
				styleRule.styleRuleTreeNode,
				styleRule.lastSelector,
				styleRule.numStates
			);
		}
		
		public function removeListenersForStyleRule(styleRule : JCSS_StyleRule) : void {
			//trace ("removeListenersForStyleRule", _styleManager, styleRule);
			removeStyleRuleListener(
				this,
				styleRule.styleRuleTreeNode,
				styleRule.lastSelector
			);
		}
		
		public function setState(stateName : String, oldValue : String, value : String) : void {
			var dispatcher : JCSS_StateDispatcher;
			for each (dispatcher in _dispatchers) {
				//trace ("STATE changed", stateDispatcher);
				dispatcher.notifyComponentStateChanged(stateName, oldValue, value);
			}
		}
		
		public function styleRuleIsActive(styleRule : JCSS_StyleRule) : Boolean {
			var dispatcher : JCSS_StateDispatcher = _dispatchers[styleRule.lastSelector.selectorID];
			return dispatcher.isActive();
		}

		/*
		 * Private
		 */

		private function setListenersForSelector(
			listener : JCSS_StateListener,
			styleRule : JCSS_StyleRule,
			styleRuleTreeNode : JCSS_StyleRuleTreeNode,
			selector : JCSS_Selector,
			numStatesToTest : uint
		) : void {
			
			//trace ("+++++++++setListenersForSelector", this, styleRule.selectorString, selector.selectorString, "(" + selector.selectorID + ")");

			var dispatcher : JCSS_StateDispatcher = _dispatchers[selector.selectorID];
			
			if (!dispatcher) {
				dispatcher = createDispatcher(styleRule, selector);

				if (numStatesToTest > selector.numStates) {

					_styleManager.componentRoleManager.foreachAncestorComponentStyleManager(
						ancestorStyleManagerCallback, styleRuleTreeNode
					);

					function ancestorStyleManagerCallback(ancestorStyleManager : JCSS_ComponentStyleManager) : void {
						ancestorStyleManager.stateManager.setListenersForSelector(
							dispatcher,
							styleRule,
							styleRuleTreeNode.parentTreeNode,
							selector.ancestor,
							numStatesToTest - selector.numStates
						);
					}
				}
			}
			
			//trace ("register", this);
			dispatcher.registerListener(listener);
		}

		private function removeStyleRuleListener(
			listener : JCSS_StateListener,
			styleRuleTreeNode : JCSS_StyleRuleTreeNode,
			selector : JCSS_Selector
		) : void {

			var dispatcher : JCSS_StateDispatcher = _dispatchers[selector.selectorID];
			
			if (dispatcher) {
				
				dispatcher.unregisterListener(listener);
				
				if (!dispatcher.hasListener()) {
					removeDispatcher(selector);
					
					if (selector.ancestor) {
						_styleManager.componentRoleManager.foreachAncestorComponentStyleManager(
							ancestorStyleManagerCallback, styleRuleTreeNode
						);
	
						function ancestorStyleManagerCallback(ancestorStyleManager : JCSS_ComponentStyleManager) : void {
							ancestorStyleManager.stateManager.removeStyleRuleListener(
								dispatcher,
								styleRuleTreeNode.parentTreeNode,
								selector.ancestor
							);
						}
					}

				}
				//else trace ("-------------------------------HAS LISTENER", _dispatchers[selector.selectorID], "from", this);
	
			}
		}
		
		private function createDispatcher(styleRule : JCSS_StyleRule, selector : JCSS_Selector) : JCSS_StateDispatcher {
			var dispatcher : JCSS_StateDispatcher = new JCSS_StateDispatcher(_styleManager, styleRule, selector);
			//trace ("CREATE", dispatcher, "in", this, "rule:", styleRule.selectorString, "selector:", selector.selectorString, "(" + selector.selectorID + ")");
			//trace ("CREATE", this, dispatcher, "rule:", styleRule.selectorString, "selector:", selector.selectorString, "(" + selector.selectorID + ")");
			//if (_dispatchers[selector.selectorID] != null) trace ("EXISTS");
			_dispatchers[selector.selectorID] = dispatcher;
			return dispatcher;
		}

		public function removeDispatcher(selector : JCSS_Selector) : void {
//			trace ("-------------------------------REMOVE", _dispatchers[selector.selectorID], "from", this);
			//var dispatcher : JCSS_StateDispatcher = _dispatchers[selector.selectorID];
			//trace ("REMOVE", this, dispatcher, "rule:", dispatcher.styleRule.selectorString, "selector:", selector.selectorString, "(" + selector.selectorID + ")");
			
			//_dispatchers[selector.selectorID].infoListeners();
			delete _dispatchers[selector.selectorID];
		}

		/*
		 * Info
		 */
		
		public function toString() : String {
			//return "[StateManager] " + _styleManager + " listenerID:" + listenerID;
			return "[StateManager] smID:" + _styleManager.styleManagerID + " lID:" + listenerID;
		}

	}
}
