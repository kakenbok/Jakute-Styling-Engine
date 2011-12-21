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
package com.sibirjak.jakute.constants {

	/**
	 * @author jes 20.12.2011
	 */
	public class JCSS_StyleDeclarationPriority {

		/**
		 * Constant for the style priority "default".
		 * 
		 * <p>The following rules apply to a default style:</p>
		 * 
		 * <ul>
		 * <li>A default style declared in a component instance is being overridden from
		 * styles of any priority declared in the global style manager or in an ancestor
		 * component.</li>
		 * <li>If the component or the global style manager (JCSS) that has declared the default style
		 * now specifies another rule for this style, then:
		 * 		<ol>
		 * 		<li>If the new style is a default style, the style with the higher specifity applies.</li>
		 * 		<li>If the new style is a fix or an important style, that style applies.</li>
		 * 		</ol>
		 * </li>  
		 * </ul>
		 */
		public static const PRIORITY_DEFAULT : uint = 0;

		/**
		 * Constant for the style priority "important".
		 * 
		 * <p>The following rules apply to an important style:</p>
		 * 
		 * <ul>
		 * <li>An important style declared in the global style manager or in an ancestor
		 * component overrides all styles of default or fix (but not important) priority in child components.</li>
		 * <li>If the component or the global style manager (JCSS) that has declared the important style
		 * now specifies another rule for this style, then:
		 * 		<ol>
		 * 		<li>If the new style is also an important style, the later declared style applies.</li>
		 * 		<li>If the new style is a fix or an default style, it is being ignored.</li>
		 * 		</ol>
		 * </li>  
		 * </ul>
		 */
		public static const PRIORITY_IMPORTANT : uint = 2;

		/**
		 * Constant for the style priority "fix".
		 * 
		 * <p>The following rules apply to a fix style:</p>
		 * 
		 * <ul>
		 * <li>A fix style declared in a component instance can not be overridden from
		 * fix or default styles declared in the global style manager or in an ancestor
		 * component.</li>
		 * <li>A fix style is being overridden from important styles declared anywhere in
		 * the same display list subtree.</li>
		 * <li>If the component or the global style manager (JCSS) that has declared the fix style
		 * now specifies another rule for this style, then:
		 * 		<ol>
		 * 		<li>If the new style is also a fix style, the style with the higher specifity applies.</li>
		 * 		<li>If the new style is a default style, it is being ignored.</li>
		 * 		<li>If the new style is an important style, that style applies.</li>
		 * 		</ol>
		 * </li>  
		 * </ul>
		 */
		public static const PRIORITY_FIX : uint = 1;

	}
}
