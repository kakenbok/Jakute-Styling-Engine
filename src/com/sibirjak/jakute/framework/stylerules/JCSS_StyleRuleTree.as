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
package com.sibirjak.jakute.framework.stylerules {

	import com.sibirjak.jakute.framework.JCSS_ComponentStyleManager;
	import com.sibirjak.jakute.framework.JCSS_StyleManager;

	/**
	 * @author Jens Struwe 06.09.2010
	 */
	public class JCSS_StyleRuleTree extends JCSS_StyleRuleTreeNode {
		
		private var _styleManager : JCSS_StyleManager;
		private var _selectorStyleRuleMap : Object;
		
		public function JCSS_StyleRuleTree(styleManager : JCSS_StyleManager) {
			_styleManager = styleManager;
			_selectorStyleRuleMap = new Object();
		}

		public function get styleManager() : JCSS_StyleManager {
			return _styleManager;
		}

		public function addStyleRule(styleRule : JCSS_StyleRule) : void {
//			trace ("addrule", styleRule.selectorString, styleRule.firstSelector.selectorID, _selectorStyleRuleMap[styleRule.selectorString]);
			
			var oldStyleRule : JCSS_StyleRule = _selectorStyleRuleMap[styleRule.selectorString];
			
			// replace existing style rule

			if (oldStyleRule) {
				oldStyleRule.update(styleRule);

				_styleManager.styleRuleTree_notifyStyleChanged(oldStyleRule);
//				trace ("---rule updated", oldStyleRule.selectorString, oldStyleRule.firstSelector.selectorID);

			// add new style rule

			} else {
				var clientsNotRegisteredYet : Boolean = addNewStyleRule(this, styleRule, styleRule.firstSelector);
				_selectorStyleRuleMap[styleRule.selectorString] = styleRule;

				_styleManager.styleRuleTree_notifyStyleRuleAdded(styleRule, clientsNotRegisteredYet);
//				trace ("---rule added", styleRule, styleRule.firstSelector.selectorID);
			}
		}
		
		public function clearStyle(selectorString : String, styleName : String = null) : void {
			var styleRule : JCSS_StyleRule = _selectorStyleRuleMap[selectorString];

			
			if (styleRule) {
				
				var removeStyleRule : Boolean;
				var definedStyles : Object;
				
				// remove property
				if (styleName) {
					if (!styleRule.styles.hasOwnProperty(styleName)) return;
					
					var i : uint;
					var propertyName : String;
					for each (propertyName in styleRule.styles) i++;
					
					// other properties left
					if (i > 1) {
						if (styleRule.selectorString == ">This") {
							//trace ("\REMOVE PROP", styleRule.selectorString, styleName, styleRule.selectorString == ">This");
							if (_styleManager is JCSS_ComponentStyleManager) {
								definedStyles = JCSS_ComponentStyleManager(_styleManager).getDefinedStyles();
								styleRule.resetStyle(definedStyles, styleName);
								_styleManager.styleRuleTree_notifyStyleRemoved(styleRule, styleName);
							}
							
						} else {
							//trace ("REMOVE PROP", styleRule.selectorString, styleName, styleRule.selectorString == ">This");
							delete styleRule.styles[styleName];
							_styleManager.styleRuleTree_notifyStyleRemoved(styleRule, styleName);
						}
					
					// remove sole property from rule => remove rule
					} else {
						removeStyleRule = true;
					}
				
				} else {
					removeStyleRule = true;
				}

				// remove style rule
				if (removeStyleRule) {
					if (styleRule.selectorString == ">This") {
						//trace ("\UPDATE RULE", styleRule.selectorString, styleRule.selectorString == ">This");
						if (_styleManager is JCSS_ComponentStyleManager) {
							definedStyles = JCSS_ComponentStyleManager(_styleManager).getDefinedStyles();
							if (styleName) {
								styleRule.resetStyle(definedStyles, styleName);
								_styleManager.styleRuleTree_notifyStyleChanged(styleRule);
							} else {
								styleRule.reset(definedStyles);
								_styleManager.styleRuleTree_notifyStyleChanged(styleRule);
							}
						}
						
					} else {
						//trace ("REMOVE RULE", styleRule.selectorString, styleRule.selectorString == ">This");
						removeExistingStyleRule(styleRule);
						delete _selectorStyleRuleMap[styleRule.selectorString];
		
						_styleManager.styleRuleTree_notifyStyleRuleRemoved(styleRule);
					}
				}
			}
		}
		
		public function foreachStyleRule(callback : Function) : void {
			for each (var styleRule : JCSS_StyleRule in _selectorStyleRuleMap) {
				callback(styleRule);
			}
		}
		
		/*
		 * Private
		 */
		
		private function removeExistingStyleRule(styleRule : JCSS_StyleRule) : void {
			var styleRuleTreeNode : JCSS_StyleRuleTreeNode = styleRule.styleRuleTreeNode;
			var oldStyleRule : JCSS_StyleRule = styleRuleTreeNode.firstStyleRule;
			styleRuleTreeNode.firstStyleRule = null;
			
			while (oldStyleRule) {
				var nextRule : JCSS_StyleRule = oldStyleRule.nextRule;
				if (oldStyleRule != styleRule) {
					oldStyleRule.nextRule = styleRuleTreeNode.firstStyleRule;
					styleRuleTreeNode.firstStyleRule = oldStyleRule;
				}
				oldStyleRule = nextRule;
			}
		}

		private function addNewStyleRule(styleRuleTreeNode : JCSS_StyleRuleTreeNode, styleRule : JCSS_StyleRule, selector : JCSS_Selector) : Boolean {
			
			var descendantNodeAdded : Boolean = false;
			
			// add related style rules

			if (!selector.descendant) { // last selector
				
				// if the node is empty, then there are no components registered
				// to that style rule yet, so we have to find these components and
				// hence return true.
				var nodeEmpty : Boolean = styleRuleTreeNode.firstStyleRule == null;
				
				styleRule.styleRuleTreeNode = styleRuleTreeNode;
				styleRule.nextRule = styleRuleTreeNode.firstStyleRule;
				styleRuleTreeNode.firstStyleRule = styleRule;
				
				return nodeEmpty;
			}
			
			selector = selector.descendant;
			
			// create sub tree only if style manager has not been initialized yet
			
			if (!styleRuleTreeNode.descendants) {
				styleRuleTreeNode.descendants = new Object();
			}

			var descendantTreeNode : JCSS_StyleRuleTreeNode = styleRuleTreeNode.descendants[selector.selectorString];
			
			if (!descendantTreeNode) {
				descendantTreeNode = new JCSS_StyleRuleTreeNode(styleRuleTreeNode);
				styleRuleTreeNode.descendants[selector.selectorString] = descendantTreeNode;
				descendantNodeAdded = true;
			}
			
			var descendantNodeAdded2 : Boolean = addNewStyleRule(descendantTreeNode, styleRule, selector);

			return descendantNodeAdded || descendantNodeAdded2;
		}

		public function toString() : String {
			return "[JCSS_StyleRuleTree] id:" + treeNodeID;
		}
		
	}
}
