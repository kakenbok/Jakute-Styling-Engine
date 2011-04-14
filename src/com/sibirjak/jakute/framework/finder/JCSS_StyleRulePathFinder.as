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
package com.sibirjak.jakute.framework.finder {
	import com.sibirjak.jakute.framework.JCSS_ComponentStyleManager;
	import com.sibirjak.jakute.framework.JCSS_StyleManager;
	import com.sibirjak.jakute.framework.stylerules.JCSS_Selector;
	import com.sibirjak.jakute.framework.stylerules.JCSS_StyleRule;
	import com.sibirjak.jakute.framework.stylerules.JCSS_StyleRuleTreeNode;

	import org.as3commons.collections.LinkedMap;
	import org.as3commons.collections.framework.IMapIterator;


	/**
	 * @author Jens Struwe 11.01.2011
	 */
	public class JCSS_StyleRulePathFinder {
		
		private var _styleManager : JCSS_StyleManager;
		private var _callback : Function;
		private var _firstDescendantSelector : JCSS_Selector;

		private var _selectorTreeNodeMap : Object;
		private var _selectorLookupMap : LinkedMap;
		private var _styleManagerStopsMap : Object;
		
		public function find(callback : Function, styleManager : JCSS_StyleManager, styleRule : JCSS_StyleRule) : void {
//			trace ("find", styleRule);
			
			_callback = callback;
			_styleManager = styleManager;
			_firstDescendantSelector = styleRule.firstSelector.descendant;
			
			_selectorLookupMap = new LinkedMap();
//			trace ("REG", _firstDescendantSelector.selectorString, "(" + _firstDescendantSelector.selectorID + ")", "---", "FROM", styleManager);
			addLookup(_styleManager, _firstDescendantSelector);
			createSelectorTreeNodeMap();

			_styleManager.foreachChildComponentStyleManager(foreachChildComponentCallback, childrenFinishedCallback);
		}
		
		private	function foreachChildComponentCallback(componentStyleManager : JCSS_ComponentStyleManager) : Boolean {
			//trace ("\nforeachChildComponentCallback", componentStyleManager);
			
			var lookupStyleManager : JCSS_StyleManager;
			var selectors : Object;
			var lookupsLeft : Boolean = false;
			var iterator : IMapIterator = _selectorLookupMap.iterator() as IMapIterator;
			
			while (iterator.hasNext()) {
				selectors = iterator.next();
				lookupStyleManager = iterator.key;
				
				if (lookupStyleManager == componentStyleManager) continue;
				
				for each (var lookupSelector : LookupSelector in selectors) {
					
					//trace ("lookupSelector", lookupSelector.selector, lookupSelector.stopped);
					if (lookupSelector.stopped) continue;

					var descendantSelector : JCSS_Selector = lookupSelector.selector;

					var descendantKey : String = descendantSelector.selectorString;
					if (!descendantSelector.inheritStyles) descendantKey = descendantKey.replace(">", "");

					if (componentStyleManager.componentRoleManager.hasComponentKey(descendantKey)) {

//						trace (
//							"--- FOUND",
//							componentStyleManager,
//							"Selector",
//							descendantSelector.selectorString,
//							"(" + descendantSelector.selectorID + ")",
//							"FOR", lookupStyleManager.styleManagerID,
//							lookupStyleManager
//						);
						
						_callback(componentStyleManager, lookupStyleManager, _selectorTreeNodeMap[descendantSelector.selectorID], descendantSelector);

						if (descendantSelector.descendant) {
							//trace ("REG", descendantSelector.descendant.selectorString, "(" + descendantSelector.descendant.selectorID + ")", "---", componentStyleManager.parentChainAsString(), "FROM", lookupStyleManager);
							addLookup(componentStyleManager, descendantSelector.descendant);
							lookupsLeft = true;
						}
						
						if (!descendantSelector.inheritStyles) {
							stopLookup(lookupSelector, componentStyleManager);
							//trace ("component manager does not inherit children", componentStyleManager);
							// lookupsLeft is only true if lookups have been started from the current component 
						} else if (componentStyleManager.childrenEnclosed()) {
							//trace ("component manager encloses children", componentStyleManager);
							// lookupsLeft is only true if lookups have been started from the current component 
						} else {
							//trace ("set to true");
							lookupsLeft = true;
						}

					} else {
						// component does not match, ignore the selector and continue
						lookupsLeft = true;
					}
				}

			}
			
			if (componentStyleManager.childrenEnclosed()) {
				stopAllAncestorLookups(componentStyleManager);
			}
			
//			trace ("-- lookupsLeft", lookupsLeft);
			return lookupsLeft;
		}
		
		private function stopAllAncestorLookups(componentStyleManager : JCSS_ComponentStyleManager) : void {
			var lookupStyleManager : JCSS_StyleManager;
			var selectors : Object;
			var iterator : IMapIterator = _selectorLookupMap.iterator() as IMapIterator;
			while (iterator.hasNext()) {
				selectors = iterator.next();
				lookupStyleManager = iterator.key;
				if (lookupStyleManager == componentStyleManager) continue;
				for each (var lookupSelector : LookupSelector in selectors) {
					if (!lookupSelector.stopped) stopLookup(lookupSelector, componentStyleManager);
				}
			}
		}

		private function stopLookup(lookupSelector : LookupSelector, componentStyleManager : JCSS_ComponentStyleManager) : void {
			//trace ("STOP", lookupSelector.selector.selectorID, "BY", componentStyleManager.parentChainAsString());
			lookupSelector.stopped = true;
			
			if (!_styleManagerStopsMap) _styleManagerStopsMap = new Object();
			var stopsOfStyleManager : Array = _styleManagerStopsMap[componentStyleManager.styleManagerID];
			if (!stopsOfStyleManager) {
				stopsOfStyleManager = new Array();
				_styleManagerStopsMap[componentStyleManager.styleManagerID] = stopsOfStyleManager;
			}
			stopsOfStyleManager.push(lookupSelector);
		}

		private function childrenFinishedCallback(styleManager : JCSS_StyleManager) : void {
//			trace ("childrenFinishedCallback", styleManager);
			// delete selectors for this style manager
			_selectorLookupMap.removeKey(styleManager);
			
			// delete stops of this style manager
			if (_styleManagerStopsMap) {
				for each (var lookupSelector : LookupSelector in _styleManagerStopsMap[styleManager.styleManagerID]) {
//					trace ("CONTINUE", lookupSelector.selector.selectorID, "BY", styleManager);
					lookupSelector.stopped = false;
				}
				delete _styleManagerStopsMap[styleManager.styleManagerID];
			}
		}
		
		private function createSelectorTreeNodeMap() : void {
			//trace ("createSelectorTreeNodeMap");
			_selectorTreeNodeMap = new Object();
			var selector : JCSS_Selector = _firstDescendantSelector;
			var currentTreeNode : JCSS_StyleRuleTreeNode = _styleManager.styleRuleTree;
			while (selector) {
//				trace ("-- selector", selector.selectorID, selector.selectorString);
				currentTreeNode = currentTreeNode.descendants[selector.selectorString];
				_selectorTreeNodeMap[selector.selectorID] = currentTreeNode;
				selector = selector.descendant;
			}
		}

		private function addLookup(styleManager : JCSS_StyleManager, selector : JCSS_Selector) : void {
			var selectors : Object = _selectorLookupMap.itemFor(styleManager);
			if (!selectors) {
				selectors = new Object();
				_selectorLookupMap.add(styleManager, selectors);
			}
			
			selectors[selector.selectorID] = new LookupSelector(selector);
			//trace (styleManager, "\n-------------selectors", selectors);
		}

	}
}
import com.sibirjak.jakute.framework.stylerules.JCSS_Selector;

internal class LookupSelector {
	public var selector : JCSS_Selector;
	public var stopped : Boolean;
	
	public function LookupSelector(theSelector : JCSS_Selector) {
		selector = theSelector;
	}
}
