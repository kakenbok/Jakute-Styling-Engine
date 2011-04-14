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
package com.sibirjak.jakute.framework.states {
	import com.sibirjak.jakute.framework.JCSS_ComponentStyleManager;
	import com.sibirjak.jakute.framework.stylerules.JCSS_Selector;
	import com.sibirjak.jakute.framework.stylerules.JCSS_StyleRule;

	/**
	 * @author Jens Struwe 11.01.2011
	 */
	public class JCSS_StateDispatcher extends JCSS_StateListener {

		private var _styleRule : JCSS_StyleRule;
		private var _selector : JCSS_Selector;

		private var _listeners : Object;
		private var _numListeners : uint;
		
		private var _active : Boolean;
		private var _numActiveStates : uint;

		private var _hasParent : Boolean;
		private var _numActiveParents : uint;

		public function JCSS_StateDispatcher(
			styleManager : JCSS_ComponentStyleManager, 
			styleRule : JCSS_StyleRule,
			selector : JCSS_Selector
		) {
			super(styleManager);
			
			_styleRule = styleRule;
			_selector = selector;
			
			_listeners = new Object();

			for (var key : String in _selector.states) {
				if (_styleManager.getState(key) == _selector.states[key]) _numActiveStates++;
			}
			
			_active = _numActiveStates == _selector.numStates;
		}
		
		/*
		 * JCSS_DynamicStyleRuleListener
		 */
		
		override public function registered(dispatcher : JCSS_StateDispatcher) : void {
			_hasParent = true;
			if (dispatcher._active) _numActiveParents += 1;
			activeChanged();
		}

		override public function notifyParentStateChanged(dispatcher : JCSS_StateDispatcher) : void {
			_numActiveParents += dispatcher._active ? 1 : -1;
			if (activeChanged()) stateChanged_private();
		}

		/*
		 * JCSS_DynamicStyleRuleDispatcher
		 */

		public function isActive() : Boolean {
			return _active;
		}

		public function notifyComponentStateChanged(stateName : String, oldValue : String, value : String) : void {
			if (!_selector.numStates) return; // not a stateful selector
			if (_selector.states[stateName] === undefined) return; // state not defined			

			var activated : Boolean = _selector.states[stateName] === value;
			if (!activated && _selector.states[stateName] !== oldValue) return; // not deactivated, e.g. undefined before
			
			//trace ("State changed for", this, stateName, oldValue, value, "               - ", _selector.selectorString);

			_numActiveStates += activated ? 1 : -1;
			if (activeChanged()) stateChanged_private();
		}

		public function registerListener(listener : JCSS_StateListener) : void {
			if (!_listeners[listener.listenerID]) {
//				trace("register listener LISTENER:", listener, "DISPATCHER:", this);
				_listeners[listener.listenerID] = listener;
				_numListeners++;
				listener.registered(this);
				//trace ("---- register LISTENER:", listener, "DISPATCHER:", this);
			} else {
				//trace ("---- tried to register the same listener again LISTENER:", listener, "DISPATCHER:", this);
			}
		}

		public function unregisterListener(listener : JCSS_StateListener) : void {
			if (_listeners[listener.listenerID]) {
//				trace("unregister listener LISTENER:", listener, "DISPATCHER:", this);
				delete _listeners[listener.listenerID];
				_numListeners--;
			} else {
				//trace ("try to remove the same listener again LISTENER:", listener, "DISPATCHER:", this);
				//infoListeners();
			}

		}
		
		public function get styleRule() : JCSS_StyleRule {
			return _styleRule;
		}

		public function hasListener() : Boolean {
			return _numListeners > 0;
		}

		/*
		 * Private
		 */
		
		private function activeChanged() : Boolean {
			var oldActive : Boolean = _active;
			_active = _numActiveStates == _selector.numStates;
			if (_hasParent) _active = _active && _numActiveParents > 0;
			return oldActive != _active;
		}
		
		private function stateChanged_private() : void {
			var listener : JCSS_StateListener;
			for each (listener in _listeners) {
				listener.notifyParentStateChanged(this);
			}
		}
		
	}
}
