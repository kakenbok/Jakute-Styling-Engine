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

	import com.sibirjak.jakute.JCSS;
	import com.sibirjak.jakute.framework.stylerules.JCSS_StyleDeclaration;
	import com.sibirjak.jakute.framework.stylerules.JCSS_StyleRule;
	import com.sibirjak.jakute.framework.stylerules.JCSS_StyleRuleTree;

	/**
	 * @author Jens Struwe 03.09.2010
	 */
	public class JCSS_Parser {

		private static const REGEX_COMMENTS : RegExp = /  \/\*  .*?  \*\/  |  \/\/  [^\n]*$  /xsmg;
		private static const REGEX_BLOCKS : RegExp = /  ([^\}\{]*?)  \{  ([^\}\{]*?)  \}  /xg;
		private static const REGEX_STYLE_DECLARATIONS : RegExp = /  ([\w\-]+)  \s*:\s*  ([^;\n\r]+)  /xg;

		public static function parse(css : String, styleRuleTree : JCSS_StyleRuleTree) : void {

			// throw out comments
			css = css.replace(REGEX_COMMENTS, ""); /* comments */

			var styleRule : JCSS_StyleRule;
			var styleDeclaration : JCSS_StyleDeclaration;
			
			var resultBlocks : Array = REGEX_BLOCKS.exec(css);
			var resultSelectors : Array;
			var resultStyleDeclarations : Array;
			var resultImportant : Array;
			var resultDefault : Array;
			var resultStyleValues : Array;
			
			var selectorMeta : JCSS_SelectorMetaData;
			var selectorString : String;
			
			var styleValue : String;
			var stylePriority : uint;

			while (resultBlocks) {
				// selector
				resultSelectors = String(resultBlocks[1]).split(",");
				
				for each (selectorString in resultSelectors) {
					selectorMeta = JCSS_SelectorParser.parse(selectorString);

					// styles
					if (selectorMeta.firstSelector) {
						styleRule = null;

						// style declarations
						resultStyleDeclarations = REGEX_STYLE_DECLARATIONS.exec(resultBlocks[2]);
						if (resultStyleDeclarations) {

							while (resultStyleDeclarations) {
								
								styleValue = resultStyleDeclarations[2];
								stylePriority = JCSS.PRIORITY_FIX;
								
								// test and remove important flag
								resultImportant = RegExp(/  (^|\s)  !\s*important  (\s|$)  /x).exec(styleValue);
								if (resultImportant)  {
									stylePriority = JCSS.PRIORITY_IMPORTANT; 
									styleValue = styleValue.substring(0, resultImportant["index"] + 1);
								}
								
								// test and remove default flag
								resultDefault = RegExp(/  (^|\s)  default  (\s|$)  /x).exec(styleValue);
								if (resultDefault)  {
									stylePriority = JCSS.PRIORITY_DEFAULT; 
									styleValue = styleValue.substring(0, resultDefault["index"] + 1);
								}
								
								// style values
								resultStyleValues = styleValue.match(/  (  [\w#\.-][\w\.\-]*  )  /xg);
								if (resultStyleValues) {
									styleDeclaration = new JCSS_StyleDeclaration();
									styleDeclaration.propertyName = resultStyleDeclarations[1];
									styleDeclaration.priority = stylePriority;
									styleDeclaration.value = resultStyleValues[0];
									// TODO enable list of values
									//resultStyleValues.length > 1 ? resultStyleValues : resultStyleValues[0];

									if (!styleRule) styleRule = new JCSS_StyleRule(selectorMeta);
									styleRule.styles[resultStyleDeclarations[1]] = styleDeclaration;
								}
								
								resultStyleDeclarations = REGEX_STYLE_DECLARATIONS.exec(resultBlocks[2]);
							}
						}

						if (styleRule) styleRuleTree.addStyleRule(styleRule);
					}
				}
				resultBlocks = REGEX_BLOCKS.exec(css);
			}
		}
	}
}
