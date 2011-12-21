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

	import com.sibirjak.jakute.framework.JCSS_ApplicationStyleManager;
	import com.sibirjak.jakute.framework.JCSS_ComponentStyleManager;
	import com.sibirjak.jakute.framework.core.JCSS_StyleManagerMap;
	import com.sibirjak.jakute.framework.core.jcss_internal;
	import com.sibirjak.jakute.framework.styles.JCSS_StyleValueFormatter;
	import com.sibirjak.jakute.styles.JCSS_IValueFormatter;

	import org.as3commons.collections.Map;
	import org.as3commons.collections.framework.IMapIterator;

	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;

	/**
	 * Jakute Styling Engine (JCSS).
	 * 
	 * <p>The single instance of this class provides global settings and
	 * operations that affect all components:</p>
	 * 
	 * <ol>
	 * <li>Initialize JCSS.</li>
	 * <li>Register a component instance in the JCSS system.</li>
	 * <li>Register a type to be recognized by JCSS.</li>
	 * <li>Register a style value formatter.</li>
	 * <li>Set global styles.</li>
	 * <li>Start and commit a bulk update.</li>
	 * </ol>
	 * 
	 * @author Jens Struwe 11.01.2011
	 */
	public class JCSS {
		
		/**
		 * The stage reference.
		 */
		private var _stage : Stage;

		/**
		 * Priority on that JCSS listens to stage events.
		 */
		private var _stageEventPriority : int = 11;

		/**
		 * Style manager registry.
		 */
		private var _styleManagerMap : JCSS_StyleManagerMap;

		/**
		 * The single application style manager.
		 */
		private var _applicationStyleManager : JCSS_ApplicationStyleManager;

		/**
		 * Collection of all registered types to be automatically processed.
		 */
		private var _registeredTypes : Map;
		
		/**
		 * Type check cache.
		 */
		private var _typeCheckCache : Map;
		
		/**
		 * Registered style value formatters.
		 */
		private var _styleValueFormatters : JCSS_StyleValueFormatter;
		
		/**
		 * JCSS.
		 * 
		 * <p>Do not call the private constructor.</p>
		 * 
		 * @param stage The state reference.
		 */
		public function JCSS() {
			_styleManagerMap = new JCSS_StyleManagerMap();

			_applicationStyleManager = new JCSS_ApplicationStyleManager();
			_applicationStyleManager.jcss = this;
			
			_styleValueFormatters = new JCSS_StyleValueFormatter();
		}

		/**
		 * Stage event (add, remove) listening priority.
		 * 
		 * <p>Default is 11.</p>
		 */
		public function set stageEventPriority(stageEventPriority : int) : void {
			_stageEventPriority = stageEventPriority;
		}

		/**
		 * @private
		 */
		public function get stageEventPriority() : int {
			return _stageEventPriority;
		}

		/*
		 * Register
		 */

		/**
		 * Registers a component instance in JCSS.
		 * 
		 * <p>After the registration the component is enabled to receive styles and
		 * style change notifications.</p>
		 * 
		 * <p>Registering a component twice throws an error.</p>
		 * 
		 * <p>Registering the same adapter with different components throws an error.</p>
		 * 
		 * <p>Registering a component that is already in the display list throws an error.</p>
		 * 
		 * @param component The display object to be styled.
		 * @param adapter The JCSS component adapter.
		 */
		public function registerComponent(component : DisplayObject, adapter : JCSS_Adapter) : void {
			if (_styleManagerMap.hasStyleManager(component)) throw new Error("You cannot register a component twice.");
			if (adapter.component) throw new Error("You cannot reuse an adapter.");
			if (component.stage) throw new Error("You cannot register a component that is already in the display list.");

			var styleManager : JCSS_ComponentStyleManager = adapter.jcss_internal::getStyleManager_internal();
			_styleManagerMap.register(component, styleManager);
			styleManager.jcss = this;
			styleManager.component = component;
		}

		/**
		 * Removes a component instance from JCSS.
		 * 
		 * <p>This method cleans up all references to the given component
		 * and makes it eligible for garbage collection.</p>
		 * 
		 * @param component The display object to remove from JCSS.
		 */
		public function unregisterComponent(component : DisplayObject) : void {
			var styleManager : JCSS_ComponentStyleManager = _styleManagerMap.getComponentStyleManager(component);
			if (styleManager) {
				_styleManagerMap.unregister(component);
				styleManager.cleanUp();
			}
		}

		/**
		 * Starts the automatic type registration.
		 * 
		 * <p>You need to call this method before registering a type to be
		 * detected by JCSS. The JCSS type monitoring requires this stage
		 * instance to set a listener to the <code>stage.ADDED_TO_STAGE</code> event.</p>
		 * 
		 * @param stage The state reference.
		 * @param monitorInterfaces Flag, indicates if interfaces should be examined.
		 */
		public function startTypeMonitoring(stage : Stage) : void {
			_stage = stage;
			_registeredTypes = new Map();
			_typeCheckCache = new Map();
			_stage.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler, true, _stageEventPriority);
		}

		/**
		 * Registers an type to be automatically detected by JCSS.
		 * 
		 * <p>JCSS sets a listener to the <code>stage.ADDED_TO_STAGE</code> event.
		 * Any added display object that matches a formerly set type registration,
		 * is automatically initialized.</p>
		 * 
		 * <p>Using the <code>matchExactType</code> flag you can determine whether a
		 * component should exactly be of the specified type (tests
		 * <code>getQualifiedClassName(component) == getQualifiedClassName(Type)</code>)
		 * or is allowed to be a sub class or an implementor (tests <code>component is Type</code>).</p>
		 * 
		 * @param type The type to be watched.
		 * @param Adapter The adapter class to be used with the component that matchs the type.
		 * @param matchExactType Flag to control the component to Type comparision.
		 */
		public function registerType(Type : Class, Adapter : Class, matchExactType : Boolean = false) : void {
			if (!_stage) throw new Error("You need to call startTypeMonitoring(stage) before registering a type in JCSS.");

			if (_registeredTypes.hasKey(Type)) return;
			
			_registeredTypes.add(Type, [Adapter, matchExactType]);
			_typeCheckCache.clear();
		}

		/*
		 * Format
		 */

		/**
		 * Registers a style value formatter function.
		 * 
		 * <p>The given key can be afterwards used to define component style
		 * formats. There is a default list of formatters in JCSS_StyleFormats.</p>
		 *
		 *	<listing>
			public function customFormatter(value : &#42;) : CustomType {
				return doSomeConversion(value);
			}
		 *	</listing>
		 * 
		 * @param formatterKey The key of the custom formatter.
		 * @param formatter The custom formatter function.
		 * @see JCSS_StyleFormat
		 */
		public function registerStyleValueFormatter(formatterKey : String, formatter : JCSS_IValueFormatter) : void {
			_styleValueFormatters.registerFormatter(formatterKey, formatter);
		}

		/*
		 * Styles
		 */
		
		/**
		 * Starts a bulk update procedure.
		 * 
		 * <p>If invoked, affected components are buffered and notified only once
		 * after a later call of <code>commitBulkUpdate()</code>. If there are
		 * different styles or state to set, that might affect a particular multiple
		 * times, it is recommended to wrap the update in the bulk transaction.</p>
		 */
		public function startBulkUpdate() : void {
			_applicationStyleManager.startBulkUpdate();
		}

		/**
		 * Executes a bulk update that was started via <code>startBulkUpdate()</code>.
		 * 
		 * <p>Affected components are notified only once regardless of the specific
		 * changes between <code>startBulkUpdate()</code> and this command.</p>
		 * 
		 * <p>Ancestor components are always notified before their children. A further
		 * order is not specified. It can be possible that children of different branches
		 * are notified alternating, e.g. C-1, C-2, C-2.1, C-2.2, C-1.3, C-2.4, C-1.1
		 */
		public function commitBulkUpdate() : void {
			_applicationStyleManager.commitBulkUpdate();
		}

		/**
		 * Sets a global style sheet.
		 * 
		 * <p>The style sheet usually is loaded from an external source but still may be
		 * created at runtime in the application.</p>
		 *
		 * <listing>
			var styleSheet : String = &lt;styles&gt;&lt;![CDATA[
				Box {
					backgroundColor: 0xFF0000;
				}
			]]&gt;&lt;/styles&gt;.toString()
		 * </listing>
		 * 
		 * <p>It is possible to repeatedly invoke this method with different style sheets.
		 * Equal style rules in different or the same sheet are merged together for performance
		 * reasons, no worries.</p>
		 * 
		 * @param styleSheet The global stylesheet.
		 */
		public function setStyleSheet(styleSheet : String) : void {
			_applicationStyleManager.setStyleSheet(styleSheet);
		}

		/**
		 * Sets a global style.
		 * 
		 * <p>It is possible to repeatedly invoke this method with equal style rules.
		 * They are then merged together for performance reasons, no worries, too.</p>
		 * 
		 * @param selector A selector that matchs a particular component.
		 * @param styleName The name of the style to set.
		 * @param styleValue The value of the style to set.
		 * @param priority The style priority (null, "!important" or "default").
		 */
		public function setStyle(selector : String, styleName : String, styleValue : *, priority : uint = 1) : void {
			_applicationStyleManager.setStyle(selector, styleName, styleValue, priority);
		}
		
		public function clearStyle(selector : String, styleName : String = null) : void {
			_applicationStyleManager.clearStyle(selector, styleName);
		}
		
		/*
		 * Internal
		 */

		jcss_internal function getStyleValueFormatter(key : String) : JCSS_IValueFormatter {
			return _styleValueFormatters.getFormatter(key);
		}

		jcss_internal function get applicationStyleManager() : JCSS_ApplicationStyleManager {
			return _applicationStyleManager;
		}

		jcss_internal function getComponentStyleManager(component : DisplayObject) : JCSS_ComponentStyleManager {
			return _styleManagerMap.getComponentStyleManager(component);
		}

		/*
		 * Private
		 */

		/**
		 * Type added to stage handler.
		 */
		private function addedToStageHandler(event : Event) : void {
			var component : DisplayObject = event.target as DisplayObject;

			// component already registered
			if (_styleManagerMap.hasStyleManager(component)) return;

			var componentClassName : String = getQualifiedClassName(component);
			var Adapter : Class;
			
			if (_typeCheckCache.hasKey(componentClassName)) {
				Adapter = _typeCheckCache.itemFor(componentClassName);

			} else {
				var iterator : IMapIterator = _registeredTypes.iterator() as IMapIterator;
				while (iterator.hasNext()) {
					var adapterAttributes : Array = iterator.next();
					var Type : Class = iterator.key;
					
					if (adapterAttributes[1]) {
						if (componentClassName == getQualifiedClassName(Type)) {
							Adapter = adapterAttributes[0];
						}
					} else {
						if (component is Type) {
							Adapter = adapterAttributes[0];
						}
					}
					
					if (Adapter) break;
				}
				
				_typeCheckCache.add(componentClassName, Adapter);
			}
			
			if (Adapter) {
				var adapter : JCSS_Adapter = new Adapter();
				var styleManager : JCSS_ComponentStyleManager = adapter.jcss_internal::getStyleManager_internal();
				_styleManagerMap.register(component, styleManager);
				styleManager.jcss = this;
				styleManager.component = component;
			}
		}

		/*
		 * Info
		 */
		
		/**
		 * Returns a formatted tree of all currently set style rules.
		 * 
		 * <p>The following example shows a style sheet and its tree representation.</p>
		 * 
		 *	<listing>
			var styleSheet : String = &lt;styles&gt;&lt;![CDATA[
			
			    ToolTip {
			        borderSize: 0;
			    }
			
			    Blue {
			        backgroundColor: #0000CC;
			        borderColor: #000066;
			        color: #FFFFFF;
			    }
			
			    Blue ToolTip {
			        backgroundColor: #6666FF;
			        color: #FFFFFF;
			    }
			
			    Red {
			        backgroundColor: #CC0000;
			        borderColor: #660000;
			        color: #FFFFFF;
			    }
			
			    Red ToolTip {
			        backgroundColor: #FF6666;
			        color: #FFFFFF;
			    }
			
			    Yellow {
			        backgroundColor: #CCCC00;
			        borderColor: #666600;
			    }
			
			    Yellow ToolTip {
			        backgroundColor: #FFFF66;
			    }
			
			]]&gt;&lt;/styles&gt;.toString();
		 *	</listing>
		 *	
		 *	<listing>
			[This 2]
			|_____[Yellow 22]
			    | &gt;This Yellow specifity:2 {
			    |    backgroundColor: #CCCC00 (12);
			    |    borderColor: #666600 (13);
			    | }
			    |_____[ToolTip 26]
			        | &gt;This Yellow ToolTip specifity:3 {
			        |    backgroundColor: #FFFF66 (14);
			        | }
			|_____[Blue 8]
			    | &gt;This Blue specifity:2 {
			    |    backgroundColor: #0000CC (2);
			    |    color: #FFFFFF (4);
			    |    borderColor: #000066 (3);
			    | }
			    |_____[ToolTip 12]
			        | &gt;This Blue ToolTip specifity:3 {
			        |    backgroundColor: #6666FF (5);
			        |    color: #FFFFFF (6);
			        | }
			|_____[ToolTip 5]
			    | &gt;This ToolTip specifity:2 {
			    |    borderSize: 0 (1);
			    | }
			|_____[Red 15]
			    | &gt;This Red specifity:2 {
			    |    backgroundColor: #CC0000 (7);
			    |    color: #FFFFFF (9);
			    |    borderColor: #660000 (8);
			    | }
			    |_____[ToolTip 19]
			        | &gt;This Red ToolTip specifity:3 {
			        |    backgroundColor: #FF6666 (10);
			        |    color: #FFFFFF (11);
			        | }
		 *	</listing>
		 */
		public function styleRuleTreeAsString() : String {
			return _applicationStyleManager.styleRuleTreeAsString();
		}

	}
}
