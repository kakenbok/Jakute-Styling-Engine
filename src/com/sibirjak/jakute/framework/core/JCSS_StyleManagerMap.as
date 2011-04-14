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
package com.sibirjak.jakute.framework.core {
	import com.sibirjak.jakute.framework.JCSS_ApplicationStyleManager;
	import com.sibirjak.jakute.framework.JCSS_ComponentStyleManager;
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;


	/**
	 * @author Jens Struwe 11.01.2011
	 */
	public class JCSS_StyleManagerMap {
		
		/*
		 * Static context
		 */

		private static var _instance : JCSS_StyleManagerMap;
		
		public static function getInstance() : JCSS_StyleManagerMap {
			if (!_instance) _instance = new JCSS_StyleManagerMap();
			return _instance;
		}

		/*
		 * Instance context
		 */

		private var _applicationStyleManager : JCSS_ApplicationStyleManager;
		private var _map : Dictionary;
		
		public function JCSS_StyleManagerMap() {
			_map = new Dictionary();
		}
		
		public function register(component : DisplayObject, styleManager : JCSS_ComponentStyleManager) : void {
			_map[component] = styleManager;
		}

		public function unregister(component : DisplayObject) : void {
			delete _map[component];
		}

		public function hasStyleManager(component : DisplayObject) : Boolean {
			return _map[component] != null;
		}
		
		public function getComponentStyleManager(component : DisplayObject) : JCSS_ComponentStyleManager {
			return _map[component];
		}
		
		public function set applicationStyleManager(applicationStyleManager : JCSS_ApplicationStyleManager) : void {
			_applicationStyleManager = applicationStyleManager;
		}

		public function get applicationStyleManager() : JCSS_ApplicationStyleManager {
			return _applicationStyleManager;
		}
		
	}
}
