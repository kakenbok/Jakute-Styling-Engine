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
	public class JCSS_StyleValueFormat {

		/**
		 * Constant for the string formatter.
		 * 
		 * <p>The string formatter simply casts the given value to String.</p>
		 */
		public static const FORMAT_STRING : String = "jcss_format_string";

		/**
		 * Constant for the string list formatter.
		 * 
		 * <p>If the value is passed as String, the string list formatter splits
		 * the given value on the comma char and returns an array of values.</p>
		 * 
		 * <p>If the value is passed as Array, the formatter returns that array.</p>
		 */
		public static const FORMAT_STRING_LIST : String = "jcss_format_string_list";

		/**
		 * Constant for the number formatter.
		 * 
		 * <p>The number formatter simply casts the given value to Number.</p>
		 */
		public static const FORMAT_NUMBER : String = "jcss_format_number";

		/**
		 * Constant for the boolean formatter.
		 * 
		 * <p>The boolean formatter casts <code>true</code>, 1, "1" and "true" to <code>true</code>
		 * and the rest to false.</p>
		 */
		public static const FORMAT_BOOLEAN : String = "jcss_format_boolan";

		/**
		 * Constant for the color formatter.
		 * 
		 * <p>The color formatter accepts uint values or HTML color values such as "#FF0000".
		 * uint values are simply returned while HTML color values are converted into uint.</p>
		 */
		public static const FORMAT_HTML_COLOR : String = "jcss_format_html_color";

		/**
		 * Constant for the color list formatter.
		 * 
		 * <p>If the value is passed as String, the string list formatter splits
		 * the given value on the comma char and returns an array of uint values.
		 * A valid example value is: <code>color: #FFFFFF, #FF0000, #FF00FF;</code></p>
		 * 
		 * <p>If the value is passed as Array, the formatter returns that array.</p>
		 */
		public static const FORMAT_HTML_COLOR_LIST : String = "jcss_format_html_color_list";

		/**
		 * Constant for the class formatter.
		 * 
		 * <p>If the given value is already of type class, the value is returned. All other
		 * values are tried to convert into a class by using <code>flash.utils.getDefinitionByName()</code>.</p>
		 */
		public static const FORMAT_CLASS : String = "jcss_format_class";

		/**
		 * Constant for the skin formatter.
		 * 
		 * <p>If the given value is already of type <code>JCSS_SkinReference</code>, the value is returned.</p>
		 * 
		 * <p>If the value is of type String, the formatter creates a new <code>JCSS_SkinReference</code> using
		 * the following pattern:</p>
		 * 
		 * <listing>
			com.path.to.the.SkinClass [cache=CACHENAME, construct=CONSTRUCTOR_PARAMETER]
		 * </listing>
		 * 
		 * <p>The parameters in the square brackets are optional. Use use them to create cached
		 * stateful skins where the client is supposed to cache a skin instance using the value
		 * of the cache parameter and to pass the value of the construct parameter right to
		 * the constructor of the skin. This enables different states for skins of the same class.</p>
		 * 
		 * <p>You can set a skin style programatically as shown in the next listing:</p> 
		 * 
		 * <listing>
			myButton.setStyle(":over", "skin", new JCSS_SkinReference(SkinClass, "over", "over"));
		 * </listing>
		 * 
		 * <p>The first parameter of <code>JCSS_SkinReference</code> is a reference to the class
		 * to be instantiated as the skin. The second is a cache identifier, the last parameter is
		 * a value that gets passed to the skin class constructor.</p>
		 */
		public static const FORMAT_SKIN : String = "jcss_format_skin";

	}
}
