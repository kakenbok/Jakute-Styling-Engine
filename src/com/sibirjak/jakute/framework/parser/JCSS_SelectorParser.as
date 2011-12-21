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
package com.sibirjak.jakute.framework.parser {
	import com.sibirjak.jakute.framework.stylerules.JCSS_Selector;

	/**
	 * @author Jens Struwe 03.09.2010
	 */
	public class JCSS_SelectorParser {
		
		//private static const REGEX_SINGLE_SELECTORS : RegExp = /  (?:^|\s)  (\w+)  ([^\s\*\:]*)  (\*?)  ((?:\:[\S]*)?)  |  ^\s*  (\:[\S]*)  /xg;
		private static const REGEX_SINGLE_SELECTORS : RegExp = /  (?:^|\s)   ((?:>\s*?)?)  (\w+)  ([^\s\*\:]*)  ((?:\:[\S]*)?)  |  ^\s*  (\:[\S]*)  /xg;
		private static const REGEX_ID_AND_CLASS : RegExp = /  ([\#\.])  (\w+)  /xg;
		private static const REGEX_STATES : RegExp = /  :  (!?)  (\w+)  (?:=(\w+))?  /xg;
		
		public static function parse(selectorString : String) : JCSS_SelectorMetaData {
			
			var metaData : JCSS_SelectorMetaData = new JCSS_SelectorMetaData();
			
//			trace ("JCSS_SelectorParser2-----------------------------------------------------");
//			trace (selectorString.replace(/^\s+|\s+$/g, ''));

			/*
			 * valid selectors are in the format of:
			 * 
			 * - A ... { name: value; }
			 * - This ... { name: value; }
			 * - :state ... { name: value; }
			 */

			var resultSelector : Array = REGEX_SINGLE_SELECTORS.exec(selectorString);
			
			/*
			 * no selector declared
			 * assume "This" is meant.
			 * 
			 * - { name: value; }
			 * - .a { name: value; }
			 * - #a { name: value; }
			 * - setStyle("", "color", "red");
			 */

			if (!resultSelector) {
				addSelector(metaData, "This");

			} else {
				/*
				 * first selector is not "This" but should be
				 * 
				 * - A ... { name: value; }
				 */
	
				if (resultSelector[2]) {
					if (resultSelector[2] == "this") resultSelector[2] = "This";
					if (resultSelector[2] != "This") addSelector(metaData, "This");
	
				/*
				 * first selector is ":state"
				 * 
				 * - :state ... { name: value; }
				 */
	
				} else {
					addSelector(metaData, "This", "", "", resultSelector[5]);
					resultSelector = REGEX_SINGLE_SELECTORS.exec(selectorString);
				}
			}
			
			
			/*
			 * next selectors all in common format
			 * 
			 * - A#a.a:a
			 */

			while (resultSelector) {
				//trace ("Result", resultSelector);
			
				addSelector(metaData, resultSelector[2], resultSelector[3], resultSelector[1], resultSelector[4]);
				resultSelector = REGEX_SINGLE_SELECTORS.exec(selectorString);
			}

			//trace (selector.selectorString.replace("This ", ''));
			//trace (this.selectorString);
			
			return metaData;
		}
		
		private static function addSelector(
			metaData : JCSS_SelectorMetaData,
			cssName : String,
			cssAttributes : String = "",
			stopInheritStylesString : String = "",
			statesString : String = ""
		) : void {
			
			var selector : JCSS_Selector = new JCSS_Selector();
			
			// Attributes

			selector.cssName = cssName;
			// The first selector can only be "This" and may have states but no class and id attributes
			if (metaData.firstSelector) {
				parseIDAndClass(metaData, selector, cssAttributes);
				selector.inheritStyles = stopInheritStylesString ? false : true;
			}
			parseStates(metaData, selector, statesString);
			selector.initialized();

			// Order

			if (metaData.firstSelector) {
				metaData.lastSelector.descendant = selector;
				selector.ancestor = metaData.lastSelector;
			} else {
				metaData.firstSelector = selector;
			}
			metaData.lastSelector = selector;
			
			// Meta

			metaData.numSelectors++;
			
			if (metaData.numSelectors > 1) {
				metaData.selectorString += " ";
				metaData.styleRuleTreeString += " ";
			}
			metaData.selectorString += selector.selectorString + selector.selectorStatesString;
			metaData.styleRuleTreeString += selector.selectorString;
		}

		private static function parseIDAndClass(
			metaData : JCSS_SelectorMetaData,
			selector : JCSS_Selector,
			attributesString : String
		) : void {

			var resultAttributes : Array = REGEX_ID_AND_CLASS.exec(attributesString);

			while (resultAttributes) {
				if (resultAttributes[1] == "#") { // #id
					//numIDAttributes += 1000;
					metaData.numIDAttributes++;
					selector.cssID = resultAttributes[2];
	
				} else if (resultAttributes[1] == ".") { // .class
					//numClassAttributes += 100;
					metaData.numClassAttributes++;
					selector.cssClass = resultAttributes[2];
				}
				
				resultAttributes = REGEX_ID_AND_CLASS.exec(attributesString);
			}
		}
		
		private static function parseStates(
			metaData : JCSS_SelectorMetaData,
			selector : JCSS_Selector,
			attributesString : String
		) : void {

			var resultStates : Array = REGEX_STATES.exec(attributesString);
			
			if (resultStates) {
				if (!selector.states) selector.states = new Object();

				while (resultStates) {
					if (selector.states[resultStates[2]] === undefined) {
						selector.numStates++;
						metaData.numStates++;
						//selector.specifity += 10;
					}
	
					selector.states[resultStates[2]] = resultStates[3] ? // value
						resultStates[3] // :state=value
						: resultStates[1] ? // !
							"false" // :!state
							: "true"; // :state
	
					resultStates = REGEX_STATES.exec(attributesString);
				}
			}
		}
		
	}
}
