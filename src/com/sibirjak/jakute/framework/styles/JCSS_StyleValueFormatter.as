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
package com.sibirjak.jakute.framework.styles {

	import com.sibirjak.jakute.constants.JCSS_StyleValueFormat;
	import com.sibirjak.jakute.framework.styles.formatter.JCSS_BooleanFormatter;
	import com.sibirjak.jakute.framework.styles.formatter.JCSS_ClassFormatter;
	import com.sibirjak.jakute.framework.styles.formatter.JCSS_HTMLColorFormatter;
	import com.sibirjak.jakute.framework.styles.formatter.JCSS_HTMLColorListFormatter;
	import com.sibirjak.jakute.framework.styles.formatter.JCSS_NumberFormatter;
	import com.sibirjak.jakute.framework.styles.formatter.JCSS_SkinFormatter;
	import com.sibirjak.jakute.framework.styles.formatter.JCSS_StringFormatter;
	import com.sibirjak.jakute.framework.styles.formatter.JCSS_StringListFormatter;
	import com.sibirjak.jakute.styles.JCSS_IValueFormatter;

	/**
	 * @author Jens Struwe 11.01.2011
	 */
	public class JCSS_StyleValueFormatter {
		
		/*
		 * Instance context
		 */

		private var _formatters : Object;
		
		public function JCSS_StyleValueFormatter() {
			_formatters = new Object();
			
			_formatters[JCSS_StyleValueFormat.FORMAT_STRING] = new JCSS_StringFormatter();
			_formatters[JCSS_StyleValueFormat.FORMAT_STRING_LIST] = new JCSS_StringListFormatter();

			_formatters[JCSS_StyleValueFormat.FORMAT_NUMBER] = new JCSS_NumberFormatter();

			_formatters[JCSS_StyleValueFormat.FORMAT_BOOLEAN] = new JCSS_BooleanFormatter();

			_formatters[JCSS_StyleValueFormat.FORMAT_HTML_COLOR] = new JCSS_HTMLColorFormatter();
			_formatters[JCSS_StyleValueFormat.FORMAT_HTML_COLOR_LIST] = new JCSS_HTMLColorListFormatter();

			_formatters[JCSS_StyleValueFormat.FORMAT_CLASS] = new JCSS_ClassFormatter();

			_formatters[JCSS_StyleValueFormat.FORMAT_SKIN] = new JCSS_SkinFormatter();
		}
		
		public function registerFormatter(key : String, formatter : JCSS_IValueFormatter) : void {
			_formatters[key] = formatter;
		}

		public function getFormatter(key : String) : JCSS_IValueFormatter {
			return _formatters[key];
		}

	}
}
