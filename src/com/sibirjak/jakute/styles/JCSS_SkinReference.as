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
	 * Skin reference style value.
	 * 
	 * <p>The skin reference not only stores the skin class but also values
	 * for the optional cacheID and constructorArgument properties.</p>
	 * 
	 * <p>Using the <code>JCSS_SkinFormatter</code> and literal style sheet
	 * declarations, the system internally stores an object of this class accociated
	 * to the skin property name. Setting a skin style programatically should
	 * also provide an instance of this class.</p>
	 * 
	 * @author Jens Struwe 06.12.2011
	 */
	public class JCSS_SkinReference {

		/**
		 * JCSS_SkinReference.
		 * 
		 * @param Skin The display list class.
		 * @param cacheID An identifier with that the skin is cached by the component.
		 * @param constructorArgument A constructor argument to be passed to the new Skin instance.
		 */
		public function JCSS_SkinReference(Skin : Class = null, cacheID : String = null, constructorArgument : String = null) {
			this.Skin = Skin;
			this.cacheID = cacheID;
			this.constructorArgument = constructorArgument;
		}

		/**
		 * The display list class.
		 */
		public var Skin : Class;

		/**
		 * An identifier with that the skin is cached by the component.
		 */
		public var cacheID : String;

		/**
		 * A constructor argument to be passed to the new Skin instance.
		 */
		public var constructorArgument : String;

	}
}
