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

	import com.sibirjak.jakute.JCSS;

	import flash.utils.getDefinitionByName;

	/**
	 * @author Jens Struwe 11.01.2011
	 */
	public class JCSS_StyleValueFormatter {
		
		/*
		 * Static context
		 */

		private static var _instance : JCSS_StyleValueFormatter;
		
		public static function getInstance() : JCSS_StyleValueFormatter {
			if (!_instance) _instance = new JCSS_StyleValueFormatter();
			return _instance;
		}

		/*
		 * Instance context
		 */

		private var _formatters : Object;
		
		public function JCSS_StyleValueFormatter() {
			_formatters = new Object();
			
			_formatters[JCSS.FORMAT_STRING] = formatString;
			_formatters[JCSS.FORMAT_NUMBER] = formatNumber;
			_formatters[JCSS.FORMAT_BOOLEAN] = formatBoolean;
			_formatters[JCSS.FORMAT_COLOR] = formatColor;
			_formatters[JCSS.FORMAT_CLASS] = formatClass;
		}
		
		public function registerFormatter(key : String, formatter : Function) : void {
			_formatters[key] = formatter;
		}

		public function getFormatter(key : String) : Function {
			return _formatters[key];
		}

		public function formatString(value : *) : String {
			return String(value);
		}

		public function formatNumber(value : *) : Number {
			return Number(value);
		}

		public function formatBoolean(value : *) : Boolean {
			if (value is Boolean) return value;
			switch (value) {
				case 1:
				case "1":
				case "true":
					return true;
			}
			return false;
		}

		/**
		 * The value here is supposed to be already a number or in
		 * the form of #RRGGBB.
		 */
		public function formatColor(value : *) : uint {
			if (value is uint) return value;
			return uint("0x" + String(value).replace("#", ""));
		}

		public function formatClass(value : *) : Class {
			if (value is Class) return value;
			if (value is String) {
				try {
					return getDefinitionByName(value) as Class;
				} catch (e : Error) {
					// do nothing
				}
			}
			return null;
		}

	}
}
