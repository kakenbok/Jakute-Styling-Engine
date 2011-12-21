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
package com.sibirjak.jakute.events {

	import com.sibirjak.jakute.framework.core.jcss_internal;

	import org.as3commons.collections.StringMap;

	/**
	 * Style change info object.
	 * 
	 * <p>An instance of this object is passed to the adapter's <code>onStyleChanged</code>
	 * event handler.</p>
	 * 
	 * @author Jens Struwe 06.12.2011
	 */
	public class JCSS_ChangeEvent {
		
		private var _changedValues : StringMap;

		public function JCSS_ChangeEvent() {
			_changedValues = new StringMap();
		}
		
		public function valueHasChanged(propertyName : String) : Boolean {
			return _changedValues.hasKey(propertyName);
		}
		
		public function value(propertyName : String) : Boolean {
			return _changedValues.itemFor(propertyName);
		}
		
		public function changedPropertiesToArray() : Array {
			return _changedValues.keysToArray();
		}
		
		jcss_internal function setValue(propertyName : String, value : *) : void {
			_changedValues.add(propertyName, value);
		}
		
		jcss_internal function hasChangedValue() : Boolean {
			return _changedValues.size > 0;
		}
		
	}
}
