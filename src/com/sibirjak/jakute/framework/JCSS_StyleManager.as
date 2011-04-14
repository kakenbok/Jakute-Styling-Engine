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

	import com.sibirjak.jakute.framework.core.JCSS_ID;
	import com.sibirjak.jakute.framework.parser.JCSS_Parser;
	import com.sibirjak.jakute.framework.parser.JCSS_SelectorMetaData;
	import com.sibirjak.jakute.framework.parser.JCSS_SelectorParser;
	import com.sibirjak.jakute.framework.roles.JCSS_RoleManager;
	import com.sibirjak.jakute.framework.stylerules.JCSS_StyleDeclaration;
	import com.sibirjak.jakute.framework.stylerules.JCSS_StyleRule;
	import com.sibirjak.jakute.framework.stylerules.JCSS_StyleRuleTree;
	import com.sibirjak.jakute.framework.update.JCSS_UpdateManager;

	/**
	 * @author Jens Struwe 11.01.2011
	 */
	public class JCSS_StyleManager {
		
		protected var _styleManagerID : uint; // Only for debugging purposes
		protected var _styleRuleTree : JCSS_StyleRuleTree;
		protected var _roleManager : JCSS_RoleManager;
		
		protected var _updatesEnabled : Boolean = true;
		
		protected var _descendants : Object;
		
		/*
		 * Constructor
		 */
		
		public function JCSS_StyleManager() {
			_styleManagerID = JCSS_ID.uniqueID();

			_styleRuleTree = new JCSS_StyleRuleTree(this);
			_descendants = new Object();
		}
		
		public function get depth() : uint {
			return 0;
		}

		public function get styleManagerID() : uint {
			return _styleManagerID;
		}
		
		/*
		 * Descendant Registration
		 */

		public function registerDescendant(styleManager : JCSS_ComponentStyleManager) : void {
			_descendants[styleManager.styleManagerID] = styleManager;
		}

		public function unregisterDescendant(styleManager : JCSS_ComponentStyleManager) : void {
			delete _descendants[styleManager.styleManagerID];
		}

		/*
		 * Styles
		 */
		
		public function startBulkUpdate() : void {
			JCSS_UpdateManager.getInstance().startBulkUpdate();
		}

		public function commitBulkUpdate() : void {
			JCSS_UpdateManager.getInstance().commitBulkUpdate();
		}

		public function setStyleSheet(styleSheet : String) : void {
			JCSS_Parser.parse(styleSheet, _styleRuleTree);

			if (_updatesEnabled) JCSS_UpdateManager.getInstance().commit();
		}

		public function setStyle(selector : String, styleName : String, styleValue : *, priority : uint = 1) : void {
			var selectorMetaData : JCSS_SelectorMetaData = JCSS_SelectorParser.parse(selector);
			if (selectorMetaData.firstSelector) {
				var styleRule : JCSS_StyleRule = new JCSS_StyleRule(selectorMetaData);
				var styleDeclaration : JCSS_StyleDeclaration = new JCSS_StyleDeclaration();
				styleDeclaration.propertyName = styleName;
				styleDeclaration.value = styleValue;
				styleDeclaration.priority = priority;
				styleRule.styles[styleName] = styleDeclaration;
				_styleRuleTree.addStyleRule(styleRule);
			}
			
			if (_updatesEnabled) JCSS_UpdateManager.getInstance().commit();
		}
		
		/*
		 * RoleManager
		 */
		
		public function get roleManager() : JCSS_RoleManager {
			return _roleManager;
		}

		/*
		 * StyleRuleTree
		 */
		
		public function get styleRuleTree() : JCSS_StyleRuleTree {
			return _styleRuleTree;
		}
		
		public function styleRuleTree_notifyStyleRuleAdded(styleRule : JCSS_StyleRule, clientsNotRegisteredYet : Boolean) : void {
			//trace ("styleRuleTree_notifyStyleRuleAdded", _updatesEnabled);
			if (!_updatesEnabled) return;
			
			styleRule.setOwnerDepth(depth);
			
			// register related components with this role if the rule belongs
			// to a new tree node
			if (clientsNotRegisteredYet) {

				/*
				 * If we have a direct style rule and no clients registration then we
				 * either try to add styles to the application style manager or our
				 * component did not define any style before. In both cases we do not
				 * call setRolesForRuntimeAddedStyleRule().
				 */
				if (styleRule.firstSelector.descendant) {
					_roleManager.setRolesForRuntimeAddedStyleRule(styleRule);
				}

			}

			for each (var styleManager : JCSS_ComponentStyleManager in styleRule.styleRuleTreeNode.registeredComponents) {
				styleManager.styleManager_notifyStyleRuleAdded(styleRule);
			}
		}

		public function styleRuleTree_notifyStyleChanged(styleRule : JCSS_StyleRule) : void {
			if (!_updatesEnabled) return;

			for each (var styleManager : JCSS_ComponentStyleManager in styleRule.styleRuleTreeNode.registeredComponents) {
				styleManager.styleManager_notifyStyleChanged(styleRule);
			}
		}

		/*
		 * Iterators
		 */
		
		public function foreachChildComponentStyleManager(callbackComponent : Function, callbackFinishedChildren : Function = null) : void {
			for each (var styleManager : JCSS_ComponentStyleManager in _descendants) {
				if (callbackComponent(styleManager)) {
					styleManager.foreachChildComponentStyleManager(callbackComponent, callbackFinishedChildren);
				}
				if (callbackFinishedChildren != null) callbackFinishedChildren(styleManager);
			}
		}

		/*
		 * Info
		 */
		
		public function styleRuleTreeAsString() : String {
			var string : String = "------------------ StyleRuleTree for ApplicationStyleManager\n";
			string += _styleRuleTree.dumpAsString("This");
			string += "\n";
			return string;
		}
		
	}
}
