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

	import com.sibirjak.jakute.constants.JCSS_StyleDeclarationPriority;
	import com.sibirjak.jakute.framework.parser.JCSS_SelectorMetaData;

	/**
	 * @author Jens Struwe 06.09.2010
	 */
	public class JCSS_StyleRule {

		public var styleRuleTreeNode : JCSS_StyleRuleTreeNode;
		
		public var firstSelector : JCSS_Selector;
		public var lastSelector : JCSS_Selector;
		public var numStates : uint;

		public var selectorString : String;
		public var styleRuleTreeString : String;

		private var _selectorSpecifity : uint;
		public var ownerDepth : uint;
		public var specifity : uint;
		
		public var styles : Object;

		public var nextRule : JCSS_StyleRule;
		
		public function JCSS_StyleRule(metaData : JCSS_SelectorMetaData) {
			firstSelector = metaData.firstSelector;
			lastSelector = metaData.lastSelector;
			selectorString = metaData.selectorString;
			styleRuleTreeString = metaData.styleRuleTreeString;
			numStates = metaData.numStates;

			_selectorSpecifity = (
				metaData.numSelectors
				+ metaData.numStates * 10
				+ metaData.numClassAttributes * 100
				+ metaData.numIDAttributes * 1000
			);

			styles = new Object();
		}
		
		public function setOwnerDepth(depth : uint) : void {
			ownerDepth = depth;
			specifity = _selectorSpecifity + ownerDepth * 10000;
		}
		
		public function update(newStyleRule : JCSS_StyleRule) : void {
			var oldStyleDeclaration : JCSS_StyleDeclaration;

			for each (var styleDeclaration : JCSS_StyleDeclaration in newStyleRule.styles) {
				oldStyleDeclaration = styles[styleDeclaration.propertyName];
				if (oldStyleDeclaration) {
					if (styleDeclaration.priority < oldStyleDeclaration.priority) continue;
				}
				styles[styleDeclaration.propertyName] = styleDeclaration;
			}
		}
		
		public function reset(defaultStyles : Object) : void {
			for each (var styleDeclaration : JCSS_StyleDeclaration in defaultStyles) {
				var newStyleDeclaration : JCSS_StyleDeclaration = new JCSS_StyleDeclaration();
				newStyleDeclaration.propertyName = styleDeclaration.propertyName;
				newStyleDeclaration.value = styleDeclaration.value;
				newStyleDeclaration.priority = styleDeclaration.priority;
				styles[styleDeclaration.propertyName] = newStyleDeclaration;
			}
		}
		
		public function resetStyle(defaultStyles : Object, propertyName : String) : void {
			var styleDeclaration : JCSS_StyleDeclaration = defaultStyles[propertyName];
			var newStyleDeclaration : JCSS_StyleDeclaration = new JCSS_StyleDeclaration();
			newStyleDeclaration.propertyName = propertyName;
			newStyleDeclaration.value = styleDeclaration.value;
			newStyleDeclaration.priority = styleDeclaration.priority;
			styles[propertyName] = newStyleDeclaration;
		}
		
		/*
		 * Info
		 */

		public function toString() : String {
			return "[StyleRule] " + selectorString + " specifity:" + specifity;
		}

		public function dumpAsString(prefix : String = "") : String {
			var stylesString : String = "";
			var styleDeclaration : JCSS_StyleDeclaration;
			for (var name : String in styles) {
				styleDeclaration = styles[name];
				stylesString += prefix + "   " + name + ": " + styleDeclaration.value;
				if (styleDeclaration.priority == JCSS_StyleDeclarationPriority.PRIORITY_IMPORTANT) stylesString += " !important";
				if (styleDeclaration.priority == JCSS_StyleDeclarationPriority.PRIORITY_DEFAULT) stylesString += " default";
				stylesString += " (" + styleDeclaration.timeStamp + ")";
				stylesString += ";\n";
			}
			
			return prefix + selectorString + " specifity:" + specifity + " {\n" + stylesString + prefix + "}\n";
		}

	}
}
