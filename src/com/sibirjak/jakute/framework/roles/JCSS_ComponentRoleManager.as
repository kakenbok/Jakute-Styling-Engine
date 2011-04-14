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
	import com.sibirjak.jakute.framework.finder.JCSS_StyleRuleTreePathFinder;
	import com.sibirjak.jakute.framework.stylerules.JCSS_StyleRule;
	import com.sibirjak.jakute.framework.stylerules.JCSS_StyleRuleTreeNode;
	import flash.utils.Dictionary;


	/**
	 * @author Jens Struwe 11.01.2011
	 */
	public class JCSS_ComponentRoleManager extends JCSS_RoleManager {

		private var _componentKeys : Object;
		private var _enclosingParent : JCSS_ComponentStyleManager;
		
		private var _ancestors : Dictionary;
		
		private var _cachedCSSClassTreeNodes : Array;
		
		public function JCSS_ComponentRoleManager(styleManager : JCSS_ComponentStyleManager) {
			super(styleManager);
		}
		
		override public function initRoles() : void {
			super.initRoles();

			// reinitializes all component keys
			
			setComponentKeys();
			
			// directly assigned styles for the component

			_descendantStyleRuleTreeNodes["This"] = _styleManager.styleRuleTree;

			// directly assigned styles for descendant components already initialized in super.initRoles()
		
			// directly assigned styles for this
		
			addAncestor(_styleManager, _descendantStyleRuleTreeNodes["This"]);

			// styles assigned to ancestors
			
			_componentStyleManager().foreachParentStyleManager(foreachParentStyleManagerCallback);
			
			function foreachParentStyleManagerCallback(parentStyleManager : JCSS_StyleManager) : Boolean {
				
				var testKey : String;
				
				for (var key : String in _componentKeys) {
					
					// inheriting styles

					testKey = key;
					parentStyleManager.roleManager.foreachDescendantStyleRuleTreeNode(foreachAncestorCallback, testKey);
					
					// non inheriting styles

					if (_componentKeys[key] <= parentStyleManager.depth) {
						testKey = ">" + key;
						parentStyleManager.roleManager.foreachDescendantStyleRuleTreeNode(foreachAncestorCallback, testKey);
					}

					function foreachAncestorCallback(styleRuleTreeNode : JCSS_StyleRuleTreeNode) : void {
						addAncestor(parentStyleManager, styleRuleTreeNode);
						setDescendantNodes(styleRuleTreeNode);
						
						//trace ("register", _styleManager, "IN", parentStyleManager, "FOR", testKey, styleRuleTreeNode.treeNodeID);
					}
				}
				
				if (parentStyleManager == _enclosingParent) return false;
				return true;
			}
		}
		
		/**
		 * Since ancestor roles for a certain tree node id can not be multiple,
		 * it is not possible to have 2 roles with the same treeNode and the same parent.
		 * However, we may have 2 roles with the same treeNode but a different parent.
		 * 
		 * Example
		 * 
		 * Rule: A B
		 * Display-List: A1 A2 B C
		 * Descendant roles of B: A B (A1), A B (A2)
		 * Ancestor roles of B: C
		 * Descendant Roles of C: B C (B) 
		 */
		public function addAncestor(parentStyleManager : JCSS_StyleManager, styleRuleTreeNode : JCSS_StyleRuleTreeNode) : void {
			var ancestors : Object = _ancestors[styleRuleTreeNode];

			if (!ancestors) {
				ancestors = new Object();
				_ancestors[styleRuleTreeNode] = ancestors;
			}

			/*
			 * If the tree node contains style rules, we need to register
			 * to this tree node in order to receive notifications for changed styles.
			 * If an ancestor for a particular tree node already exists, it still
			 * might be possible that the node later is set with style rules.
			 * 
			 * Example: First rule is Box Box {}. The node for the first Box does
			 * not contain styles. Later added: Box {}. This is the same node as
			 * the first Box of the first rule. But now its accompanied with styles.
			 */
			if (styleRuleTreeNode.firstStyleRule) {
				styleRuleTreeNode.registerComponent(_componentStyleManager());
			} else {
				//trace ("no style rule in node", _styleManager);
			}

			if (!ancestors[parentStyleManager.styleManagerID]) {
				ancestors[parentStyleManager.styleManagerID] = parentStyleManager;
			} else {
				//trace ("-- ancestor registered", parentStyleManager.styleManagerID, "FOR node", styleRuleTreeNode.treeNodeID);
			}
		}

		public function notifyCSSClassChangesNext() : void {
			_cachedCSSClassTreeNodes = getTreeNodesForClass();
		}

		public function hasComponentKey(key : String) : Boolean {
			return _componentKeys[key] !== undefined;
		}
		
		public function unregisterFromTreeNodes() : void {
			var styleRuleTreeNode : JCSS_StyleRuleTreeNode;
			for (var key : * in _ancestors) {
				styleRuleTreeNode = key;
				if (styleRuleTreeNode.firstStyleRule) {
					styleRuleTreeNode.unregisterComponent(_componentStyleManager());
				}
			}
		}
		
		/*
		 * Iterators
		 */
		
		public function foreachClassRelatedChildComponentStyleManager(callback : Function) : void {
			var nodes : Array = _cachedCSSClassTreeNodes.concat(getTreeNodesForClass());
			_cachedCSSClassTreeNodes = null;
			
			var styleManagerMap : Object = new Object();
			
			new JCSS_StyleRuleTreePathFinder().find(findPathCallback, _styleManager, nodes);
			
			function findPathCallback(...args) : void {
				var styleManager : JCSS_ComponentStyleManager = args[0];
				if (styleManagerMap[styleManager.styleManagerID]) return;
				callback(styleManager);
				styleManagerMap[styleManager.styleManagerID] = true;
			}
		}
		
		/**
		 * Note, the ancestor for the _styleRuleTree of a component is the component itself.
		 */
		public function foreachAncestorComponentStyleManager(callback : Function, styleRuleTreeNode : JCSS_StyleRuleTreeNode) : void {
			for each (var parentStyleManager : JCSS_StyleManager in _ancestors[styleRuleTreeNode]) {
				if (parentStyleManager is JCSS_ComponentStyleManager) callback(parentStyleManager);
			}
		}
		
		public function foreachStyleRule(callback : Function) : void {
			var styleRule : JCSS_StyleRule;
			var styleRuleTreeNode : JCSS_StyleRuleTreeNode;
			for (var key : * in _ancestors) {
				styleRuleTreeNode = key;
				styleRule = styleRuleTreeNode.firstStyleRule; // can be null if no rule exists for this node
				while (styleRule) {
					callback(styleRule);
					styleRule = styleRule.nextRule;
				}
			}
		}
		
		/*
		 * Protected
		 */

		override protected function reset() : void {
			super.reset();
			
			_componentKeys = new Object();
			_ancestors = new Dictionary();
			_enclosingParent = null;
		}

		/*
		 * Private
		 */

		private function setComponentKeys() : void {
			_componentKeys[_componentStyleManager().cssName] = 0;
			if (_componentStyleManager().cssID) _componentKeys[_componentStyleManager().cssName + "#" + _componentStyleManager().cssID] = 0;

			if (_componentStyleManager().cssClass) {
				_componentKeys[_componentStyleManager().cssName + "." + _componentStyleManager().cssClass] = 0;
			}

			if (_componentStyleManager().cssID && _componentStyleManager().cssClass) {
				_componentKeys[_componentStyleManager().cssName + "#" + _componentStyleManager().cssID + "." + _componentStyleManager().cssClass] = 0;
			}
			
			// init depth of components with same signature (selector, class, id)
			
			_componentStyleManager().foreachParentComponentStyleManager(setComponentKeysCallback);
			
			function setComponentKeysCallback(parentStyleManager : JCSS_ComponentStyleManager) : Boolean {
				// store the depth of parent elements that have the same
				// signature (component, component#id, component.class, component#id.class)
				for (var key : String in _componentKeys) {
					if (!_componentKeys[key] && parentStyleManager.componentRoleManager._componentKeys[key] !== undefined) {
						_componentKeys[key] = parentStyleManager.depth;
					}
				}
				
				// check if the parent manager encloses this component
				if (!_enclosingParent && parentStyleManager.childrenEnclosed()) {
					_enclosingParent = parentStyleManager;
				}
				
				return true;
			}
		}

		private function _componentStyleManager() : JCSS_ComponentStyleManager {
			return _styleManager as JCSS_ComponentStyleManager;
		}

		private function getTreeNodesForClass() : Array {
			// init class keys
			
			var classKeys : Array = new Array();
			classKeys.push(_componentStyleManager().cssName + "." + _componentStyleManager().cssClass);
			
			if (_componentStyleManager().cssID) {
				classKeys.push(_componentStyleManager().cssName + "#" + _componentStyleManager().cssID + "." + _componentStyleManager().cssClass);
			}
			
			// styles assigned to ancestors
			
			var styleRuleTreeNodes : Array = new Array();
			
			_componentStyleManager().foreachParentStyleManager(foreachParentStyleManagerCallback);
			
			function foreachParentStyleManagerCallback(parentStyleManager : JCSS_StyleManager) : Boolean {
				var testKey : String;
				
				for each (var key : String in classKeys) {
					
					// inheriting styles

					testKey = key;
					parentStyleManager.roleManager.foreachDescendantStyleRuleTreeNode(foreachAncestorCallback, testKey);
					
					// non inheriting styles

					if (_componentKeys[key] <= parentStyleManager.depth) {
						testKey = ">" + key;
						parentStyleManager.roleManager.foreachDescendantStyleRuleTreeNode(foreachAncestorCallback, testKey);
					}

					function foreachAncestorCallback(styleRuleTreeNode : JCSS_StyleRuleTreeNode) : void {
						styleRuleTreeNodes.push(styleRuleTreeNode);
					}
				}
				
				if (parentStyleManager == _enclosingParent) return false;
				return true;
			}

			return styleRuleTreeNodes;

		}

	}
}
