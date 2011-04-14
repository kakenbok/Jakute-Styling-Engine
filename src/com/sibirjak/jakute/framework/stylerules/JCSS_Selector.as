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
	import com.sibirjak.jakute.framework.core.JCSS_ID;

	/**
	 * @author Jens Struwe 03.09.2010
	 */
	public class JCSS_Selector {
		
		public var selectorID : uint;

		public var cssName : String;
		public var cssClass : String;
		public var cssID : String;

		public var states : Object;
		public var numStates : uint;
		
		public var inheritStyles : Boolean = false;

		public var ancestor : JCSS_Selector;
		public var descendant : JCSS_Selector;
		
		public var selectorString : String = "";
		public var selectorStatesString : String = "";

		public function JCSS_Selector() {
			selectorID = JCSS_ID.uniqueID();
		}
		
		public function initialized() : void {
			
			// generate selectorString
			
			selectorString = "";
			if (!inheritStyles) selectorString += ">";
			selectorString += cssName;
			if (cssID) selectorString += "#" + cssID;
			if (cssClass) selectorString += "." + cssClass;
			
			// generate selectorStatesString

			if (states) {
				var array : Array = new Array();
				for (var property : String in states) {
					if (states[property] == "true") {
						array.push(property);
					} else if (states[property] == "false") {
						array.push("!" + property);
					} else {
						array.push(property + "=" + states[property]);
					}
				}
				array.sort();
				selectorStatesString = ":" + array.join(":");
			}
			
		}
		
		public function toString() : String {
			return "[JCSS_Selector] id:" + selectorID + " string:" + selectorString + selectorStatesString;
		}

	}
}
