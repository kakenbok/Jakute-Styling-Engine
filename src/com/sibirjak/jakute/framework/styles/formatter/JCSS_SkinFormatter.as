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
package com.sibirjak.jakute.framework.styles.formatter {

	import com.sibirjak.jakute.styles.JCSS_IValueFormatter;
	import com.sibirjak.jakute.styles.JCSS_SkinReference;
	import flash.utils.getDefinitionByName;


	/**
	 * @author Jens Struwe 07.12.2011
	 */
	public class JCSS_SkinFormatter implements JCSS_IValueFormatter {

		public function format(value : *) : * {
			if (value is JCSS_SkinReference) return value;

			if (value is Class) return new JCSS_SkinReference(value);

			var classReference : JCSS_SkinReference = new JCSS_SkinReference();

			if (value is String) {
				var pattern : RegExp = /  ([\w\.]+)   (?:  \s*\[([^\]]+)\]  )?    /x;
				var result : Array = pattern.exec(value);
				
				if (result[1] != "null") {
					try {
						classReference.Skin = getDefinitionByName(result[1]) as Class;
					} catch (e : Error) {
						throw new Error("Class " + value + " not found in project.");
					}
				}
				
				if (result[2]) {
					pattern = / cache\s*=\s*([\w\-]+) /x;
					var result2 : Array = pattern.exec(result[2]);
					if (result2) classReference.cacheID = result2[1];
					
					pattern = / construct\s*=\s*([\w\-]+) /x;
					result2 = pattern.exec(result[2]);
					if (result2) classReference.constructorArgument = result2[1];
				}

			}

			return classReference;
		}

		public function equals(value1 : *, value2 : *) : Boolean {
			var classR1 : JCSS_SkinReference = value1;
			var classR2 : JCSS_SkinReference = value2;
			
			return (
				classR1.Skin === classR2.Skin
				&& classR1.cacheID === classR2.cacheID
				&& classR1.constructorArgument == classR2.constructorArgument
			);
		}

	}
}
