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
package com.sibirjak.jakute.styles {

	/**
	 * Definition of a style value formatter.
	 * 
	 * @author Jens Struwe 07.12.2011
	 */
	public interface JCSS_IValueFormatter {

		/**
		 * Returns a formatted style value.
		 * 
		 * <p>The method is meant to convert a literal style sheet declaration
		 * into the type that is expected by the component.</p>
		 * 
		 * <p>The method argument is either a String coming from a style sheet
		 * declaration or already a formatted value. You should therefore always test,
		 * whether the value is already formatted or not. See the different
		 * formatters included in this project.</p>
		 * 
		 * @param value The value to format.
		 * @return The formatted value.
		 */
		function format(value : *) : *;
		
		/**
		 * Compares two different style values.
		 * 
		 * <p>Note, the given values are already formatted.</p>
		 */
		function equals(value1 : *, value2 : *) : Boolean;

	}
}
