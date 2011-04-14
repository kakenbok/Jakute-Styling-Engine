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
package com.sibirjak.jakute {

	import flash.display.DisplayObject;
	import flash.display.Sprite;

	/**
	 * JCSS enabled base ui class (optional and just for convenience).
	 * 
	 * <p>Although it is intended to fully decouple Jaktute Styling Engine code from the
	 * actual component implementations, the probable cleanest and preferred way to work
	 * is to put the style handling in a base ui class, and let all components inherit
	 * from that class. Such a class is JCSS_Sprite.</p>
	 * 
	 * <p><strong>Notes</strong></p>
	 * 
	 * <p>JCSS_Sprite has nearly the same interface as JCSS_Adapter with the
	 * difference, that all properties and methods carry a leading "jcss_" prefix
	 * to avoid collision with component code.</p>
	 * 
	 * <p>A handler for the component registered event is not available. Related code might be
	 * added right to the constructor of the subclass, because the constructor itself performs
	 * the registraion.</p>
	 * 
	 * @author Jens Struwe 11.01.2011
	 */
	public class JCSS_Sprite extends Sprite {
		
		/**
		 * The JCSS adapter.
		 */
		protected var _jcssAdapter : JCSS_Adapter;
		
		/**
		 * JCSS_Sprite.
		 */
		public function JCSS_Sprite() {
			_jcssAdapter = new JCSS_Adapter();
			_jcssAdapter.stylesInitializedHandler = jcss_stylesInitializedHandler;
			_jcssAdapter.stylesChangedHandler = jcss_stylesStylesChangedHandler;
			JCSS.getInstance().registerComponent(this, _jcssAdapter);
		}
		
		/*
		 * Selector Attributes
		 */

		/**
		 * @private
		 */
		public function set jcss_cssName(cssName : String) : void {
			_jcssAdapter.cssName = cssName;
		}
		
		/**
		 * @copy JCSS_Adapter#cssName
		 */
		public function get jcss_cssName() : String {
			return _jcssAdapter.cssName;
		}
		
		/**
		 * @private
		 */
		public function set jcss_cssID(cssID : String) : void {
			_jcssAdapter.cssID = cssID;
		}
		
		/**
		 * @copy JCSS_Adapter#cssID
		 */
		public function get jcss_cssID() : String {
			return _jcssAdapter.cssID;
		}
		
		/**
		 * @private
		 */
		public function set jcss_cssClass(cssClass : String) : void {
			_jcssAdapter.cssClass = cssClass;
		}
		
		/**
		 * @copy JCSS_Adapter#cssClass
		 */
		public function get jcss_cssClass() : String {
			return _jcssAdapter.cssClass;
		}
		
		/**
		 * @copy JCSS_Adapter#setState()
		 */
		public function jcss_setState(stateName : String, value : String) : void {
			_jcssAdapter.setState(stateName, value);
		}
		
		/**
		 * @copy JCSS_Adapter#getState()
		 */
		public function jcss_getState(stateName : String) : String {
			return _jcssAdapter.getState(stateName);
		}
		
		/*
		 * Styles
		 */
		
		/**
		 * @copy JCSS_Adapter#defineStyle()
		 */
		public function jcss_defineStyle(styleName : String, styleValue : *, format : String, priority : uint = 0) : void {
			_jcssAdapter.defineStyle(styleName, styleValue, format, priority);
		}

		/**
		 * @copy JCSS_Adapter#startBulkUpdate()
		 */
		public function jcss_startBulkUpdate() : void {
			_jcssAdapter.startBulkUpdate();
		}

		/**
		 * @copy JCSS_Adapter#commitBulkUpdate()
		 */
		public function jcss_commitBulkUpdate() : void {
			_jcssAdapter.commitBulkUpdate();
		}

		/**
		 * @copy JCSS_Adapter#setStyleSheet()
		 */
		public function jcss_setStyleSheet(styleSheet : String) : void {
			_jcssAdapter.setStyleSheet(styleSheet);
		}

		/**
		 * @copy JCSS_Adapter#setStyle()
		 */
		public function jcss_setStyle(selector : String, styleName : String, styleValue : *, priority : uint = 1) : void {
			_jcssAdapter.setStyle(selector, styleName, styleValue, priority);
		}

		/**
		 * @copy JCSS_Adapter#getStyle()
		 */
		public function jcss_getStyle(styleName : String) : * {
			return _jcssAdapter.getStyle(styleName);
		}

		/*
		 * Properties
		 */
		
		/**
		 * @copy JCSS_Adapter#initialized
		 */
		public function get jcss_initialized() : Boolean {
			return _jcssAdapter.initialized;
		}

		/**
		 * @copy JCSS_Adapter#encloseChildren()
		 */
		public function jcss_encloseChildren() : void {
			_jcssAdapter.encloseChildren();
		}

		/**
		 * @copy JCSS_Adapter#childrenEnclosed()
		 */
		public function jcss_childrenEnclosed() : Boolean {
			return _jcssAdapter.childrenEnclosed();
		}

		/**
		 * @private
		 */
		public function set jcss_virtualParent(parent : DisplayObject) : void {
			_jcssAdapter.virtualParent = parent;
		}
		
		/**
		 * @copy JCSS_Adapter#virtualParent
		 */
		public function get jcss_virtualParent() : DisplayObject {
			return _jcssAdapter.virtualParent;
		}

		/*
		 * JCSS Notifications
		 */

		/**
		 * @copy JCSS_Adapter#onStylesInitialized()
		 */
		protected function jcss_onStylesInitialized(styles : Object) : void {
		}

		/**
		 * @copy JCSS_Adapter#onStylesChanged()
		 */
		protected function jcss_onStylesChanged(styles : Object) : void {
		}
		
		/*
		 * Private
		 */

		/**
		 * Handler for the initialized event.
		 */
		private function jcss_stylesInitializedHandler(styles : Object, adapter : JCSS_Adapter) : void {
			jcss_onStylesInitialized(styles);
		}

		/**
		 * Handler for the styles changed event.
		 */
		private function jcss_stylesStylesChangedHandler(styles : Object, adapter : JCSS_Adapter) : void {
			jcss_onStylesChanged(styles);
		}

		/*
		 * Info
		 */
		
		/**
		 * @copy JCSS_Adapter#stylesAsString()
		 */
		public function jcss_stylesAsString() : String {
			return _jcssAdapter.stylesAsString();
		}

		/**
		 * @copy JCSS_Adapter#styleRuleTreeAsString();
		 */
		public function jcss_styleRuleTreeAsString() : String {
			return _jcssAdapter.styleRuleTreeAsString();
		}

		/**
		 * @copy JCSS_Adapter#componentSelectorAsString()
		 */
		public function jcss_componentSelectorAsString() : String {
			return _jcssAdapter.componentSelectorAsString();
		}

		/**
		 * @copy JCSS_Adapter#parentChainAsString()
		 */
		public function jcss_parentChainAsString() : String {
			return _jcssAdapter.parentChainAsString();
		}

	}
}
