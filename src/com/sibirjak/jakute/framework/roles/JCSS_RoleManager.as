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
package com.sibirjak.jakute.framework.roles {
	import com.sibirjak.jakute.framework.JCSS_ComponentStyleManager;
	import com.sibirjak.jakute.framework.JCSS_StyleManager;
	import com.sibirjak.jakute.framework.finder.JCSS_StyleRulePathFinder;
	import com.sibirjak.jakute.framework.stylerules.JCSS_Selector;
	import com.sibirjak.jakute.framework.stylerules.JCSS_StyleRule;
	import com.sibirjak.jakute.framework.stylerules.JCSS_StyleRuleTreeNode;

	/**
	 * @author Jens Struwe 11.01.2011
	 */
	public class JCSS_RoleManager {
		
		protected var _styleManager : JCSS_StyleManager;
		protected var _descendantStyleRuleTreeNodes : Object;

		public function JCSS_RoleManager(styleManager : JCSS_StyleManager) {
			_styleManager = styleManager;
		}
		
		public function initRoles() : void {
			reset();

			// directly assigned styles for descendant components
			setDescendantNodes(_styleManager.styleRuleTree);
		}
		
		public function setRolesForRuntimeAddedStyleRule(styleRule : JCSS_StyleRule) : void {
			var descendantSelector : JCSS_Selector = styleRule.firstSelector.descendant;
			
			addDescendantNode(descendantSelector.selectorString, _styleManager.styleRuleTree.descendants[descendantSelector.selectorString]);
			
			new JCSS_StyleRulePathFinder().find(findStyleRulePathCallback, _styleManager, styleRule);
			
			function findStyleRulePathCallback(
				componentStyleManager : JCSS_ComponentStyleManager,
				parentStyleManager : JCSS_StyleManager,
				styleRuleTreeNode : JCSS_StyleRuleTreeNode,
				selector : JCSS_Selector
			) : void {
				
//				trace ("ADD");
//				trace ("--", componentStyleManager);
//				trace ("--", parentStyleManager);
//				trace ("--", selector.selectorString, selector.selectorID);
//				
				componentStyleManager.componentRoleManager.addAncestor(parentStyleManager,styleRuleTreeNode);
				
				if (selector.descendant) {
					componentStyleManager.roleManager.addDescendantNode(selector.descendant.selectorString, styleRuleTreeNode.descendants[selector.descendant.selectorString]);
				}
			}
		}

		/*
		 * Iterators
		 */

		public function foreachDescendantStyleRuleTreeNode(callback : Function, componentKey : String) : void {
			var	descendantNodes : Object = _descendantStyleRuleTreeNodes[componentKey];
			for each (var styleRuleTreeNode : JCSS_StyleRuleTreeNode in descendantNodes) {
				callback(styleRuleTreeNode);
			}
		}
		
		/*
		 * Protected
		 */

		protected function reset() : void {
			_descendantStyleRuleTreeNodes = new Object();
		}
		
		protected function setDescendantNodes(styleRuleTreeNode : JCSS_StyleRuleTreeNode) : void {
			var descendantNode : JCSS_StyleRuleTreeNode;
			
			for (var treeNodeKey : String in styleRuleTreeNode.descendants) {
				descendantNode = styleRuleTreeNode.descendants[treeNodeKey];
				
				addDescendantNode(treeNodeKey, descendantNode);
			}
		}
		
		protected function addDescendantNode(componentKey : String, descendantNode : JCSS_StyleRuleTreeNode) : void {
			// you cannot set an ancestor role for the same the node again,
			// which would be the case for rule: A A B and the display list: A1 A2 A3 B.
			// the A3 would set here B for A1 A3 B and for A2 A3 B. instead, we
			// only store a single "B" for A3.
			// In that case the A3 has 2 different descendant roles (A1 A3 and A2 A3)

			var descendantsNodes : Object = _descendantStyleRuleTreeNodes[componentKey];

			if (!descendantsNodes) {
				descendantsNodes = new Object();
				_descendantStyleRuleTreeNodes[componentKey] = descendantsNodes;
			}

			if (!descendantsNodes[descendantNode.treeNodeID]) {
				descendantsNodes[descendantNode.treeNodeID] = descendantNode;
			} else {
				//trace ("-- descendant registered", _styleManager.styleManagerID, "FOR node", descendantNode.treeNodeID);
			}
		}

	}
}
