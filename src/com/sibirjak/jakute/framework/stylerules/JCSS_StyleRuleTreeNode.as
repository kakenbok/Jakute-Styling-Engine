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
	import com.sibirjak.jakute.framework.core.JCSS_ID;

	/**
	 * @author Jens Struwe 11.01.2011
	 */
	public class JCSS_StyleRuleTreeNode {
		
		public var treeNodeID : uint;
		public var parentTreeNode : JCSS_StyleRuleTreeNode;
		public var descendants : Object;
		public var firstStyleRule : JCSS_StyleRule;
		
		public var registeredComponents : Object;
		
		public function JCSS_StyleRuleTreeNode(theParentTreeNode : JCSS_StyleRuleTreeNode = null) {
			parentTreeNode = theParentTreeNode;
			treeNodeID = JCSS_ID.uniqueID();
		}
		
		// TODO maintain the order of managers with a sorted list
		public function registerComponent(styleManager : JCSS_ComponentStyleManager) : void {
			if (!registeredComponents) registeredComponents = new Object();
			registeredComponents[styleManager.styleManagerID] = styleManager;
		}
		
		public function unregisterComponent(styleManager : JCSS_ComponentStyleManager) : void {
			delete registeredComponents[styleManager.styleManagerID];
		}

		/*
		 * Info
		 */
		
		public function dumpAsString(key : String, prefix : String = "", recursive : Boolean = true) : String {
			var string : String = prefix.replace(/^(\t*)\t/gm, "$1|_____") + "[" + key + " " + treeNodeID + "]";
			string += "\n";
			
			var styleRule : JCSS_StyleRule;

			styleRule = firstStyleRule;
			while (styleRule) {
				string += styleRule.dumpAsString(prefix + "| ");
				styleRule = styleRule.nextRule;
			}
			
			if (recursive) {
				var nodeDump : String;
				var subTrees : Array = [];
				var styleRuleTreeNode : JCSS_StyleRuleTreeNode;
				for (var styleRuleTreeKey : String in descendants) {
					styleRuleTreeNode = descendants[styleRuleTreeKey];
					nodeDump = styleRuleTreeNode.dumpAsString(styleRuleTreeKey, prefix + "\t");
					if (styleRuleTreeKey == "This") { // This before others
						subTrees.unshift(nodeDump); 
					} else {
						subTrees.push(nodeDump); 
					}
				}
	
				string += subTrees.join("");
			}
			return string;
		}
		
	}
}
