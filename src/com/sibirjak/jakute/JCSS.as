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

	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.utils.describeType;
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
		
		/*
		 * Constants
		 */

		/**
		 * Constant for the string formatter.
		 * 
		 * <p>The string formatter simply casts the given value to String.</p>
		 */
		public static const FORMAT_STRING : String = "jcss_format_string";

		/**
		 * Constant for the number formatter.
		 * 
		 * <p>The number formatter simply casts the given value to Number.</p>
		 */
		public static const FORMAT_NUMBER : String = "jcss_format_number";

		/**
		 * Constant for the boolean formatter.
		 * 
		 * <p>The boolean formatter casts <code>true</code>, 1, "1" and "true" to <code>true</code>
		 * and the rest to false.</p>
		 */
		public static const FORMAT_BOOLEAN : String = "jcss_format_boolan";

		/**
		 * Constant for the color formatter.
		 * 
		 * <p>The color formatter accepts uint values or HTML color values such as "#FF0000".
		 * uint values are simply returned while HTML color values are converted into uint.</p>
		 */
		public static const FORMAT_COLOR : String = "jcss_format_color";

		/**
		 * Constant for the class formatter.
		 * 
		 * <p>If the given value is already of type class, the value is returned. All other
		 * values are tried to convert into a class by using <code>flash.utils.getDefinitionByName()</code>.</p>
		 */
		public static const FORMAT_CLASS : String = "jcss_format_class";

		/**
		 * Constant for the style priority "default".
		 * 
		 * <p>The following rules apply to a default style:</p>
		 * 
		 * <ul>
		 * <li>A default style declared in a component instance is being overridden from
		 * styles of any priority declared in the global style manager or in an ancestor
		 * component.</li>
		 * <li>If the component or the global style manager (JCSS) that has declared the default style
		 * now specifies another rule for this style, then:
		 * 		<ol>
		 * 		<li>If the new style is a default style, the style with the higher specifity applies.</li>
		 * 		<li>If the new style is a fix or an important style, that style applies.</li>
		 * 		</ol>
		 * </li>  
		 * </ul>
		 */
		public static const PRIORITY_DEFAULT : uint = 0;

		/**
		 * Constant for the style priority "important".
		 * 
		 * <p>The following rules apply to an important style:</p>
		 * 
		 * <ul>
		 * <li>An important style declared in the global style manager or in an ancestor
		 * component overrides all styles of default or fix (but not important) priority in child components.</li>
		 * <li>If the component or the global style manager (JCSS) that has declared the important style
		 * now specifies another rule for this style, then:
		 * 		<ol>
		 * 		<li>If the new style is also an important style, the later declared style applies.</li>
		 * 		<li>If the new style is a fix or an default style, it is being ignored.</li>
		 * 		</ol>
		 * </li>  
		 * </ul>
		 */
		public static const PRIORITY_IMPORTANT : uint = 2;

		/**
		 * Constant for the style priority "fix".
		 * 
		 * <p>The following rules apply to a fix style:</p>
		 * 
		 * <ul>
		 * <li>A fix style declared in a component instance can not be overridden from
		 * fix or default styles declared in the global style manager or in an ancestor
		 * component.</li>
		 * <li>A fix style is being overridden from important styles declared anywhere in
		 * the same display list subtree.</li>
		 * <li>If the component or the global style manager (JCSS) that has declared the fix style
		 * now specifies another rule for this style, then:
		 * 		<ol>
		 * 		<li>If the new style is also a fix style, the style with the higher specifity applies.</li>
		 * 		<li>If the new style is a default style, it is being ignored.</li>
		 * 		<li>If the new style is an important style, that style applies.</li>
		 * 		</ol>
		 * </li>  
		 * </ul>
		 */
		public static const PRIORITY_FIX : uint = 1;

		/*
		 * Static context
		 */

		/**
		 * Single instance.
		 */
		private static var _instance : JCSS;

		/**
		 * Returns the single instance of the JCSS service.
		 * 
		 * <p>The JCSS service will be created with the first call to this method.</p>
		 * 
		 * @return The single JCSS instance.
		 */
		public static function getInstance() : JCSS {
			if (!_instance) _instance = new JCSS();
			return _instance;
		}

		/*
		 * Instance context
		 */

		/**
		 * The stage reference.
		 */
		private var _stage : Stage;



		/**
		 * The single application style manager.
		 */
		private var _styleManager : JCSS_ApplicationStyleManager;

		/**
		 * Collection of all registered types to be automatically processed.
		 */
		private var _registeredTypes : Object;


		/**
		 * Whether interfaces should be monitored too
		 */
		private var _monitorInterfaces:Boolean;


		
		/**
		 * JCSS.
		 * 
		 * <p>Do not call the private constructor.</p>
		 * 
		 * @param stage The state reference.
		 */
		public function JCSS() {
			_styleManager = new JCSS_ApplicationStyleManager();

			JCSS_StyleManagerMap.getInstance().applicationStyleManager = _styleManager;
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
			if (JCSS_StyleManagerMap.getInstance().hasStyleManager(component)) throw new Error("You cannot register a component twice.");
			if (adapter.component) throw new Error("You cannot reuse an adapter.");
			if (component.stage) throw new Error("You cannot register a component that is already in the display list.");

			var styleManager : JCSS_ComponentStyleManager = adapter.jcss_internal::getStyleManager_internal();
			JCSS_StyleManagerMap.getInstance().register(component, styleManager);
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
			JCSS_StyleManagerMap.getInstance().unregister(component);
		}

		/**
		 * Starts the automatic type registration.
		 * 
		 * <p>You need to call this method before registering a type to be
		 * detected by JCSS. The JCSS type monitoring requires this stage
		 * instance to set a listener to the <code>stage.ADDED_TO_STAGE</code> event.</p>
		 * 
		 * @param stage The stage reference.
		 * @param monitorInterfaces Whether interfaces implemented by a component should be monitored too.
		 */
		public function startTypeMonitoring(stage : Stage, monitorInterfaces:Boolean = false) : void {
			_stage = stage;
			_monitorInterfaces = monitorInterfaces;
		}

		/**
		 * Registers an type to be automatically detected by JCSS.
		 * 
		 * <p>JCSS sets a listener to the <code>stage.ADDED_TO_STAGE</code> event.
		 * Any added display object that matches a formerly set type registration,
		 * is automatically initialized.</p>
		 * 
		 * @param type The type to be watched for.
		 * @param Adapter The adapter class to be used in initialization.
		 */
		public function registerType(type : Class, Adapter : Class) : void {
			if (!_stage) throw new Error("You need to call startTypeMonitoring(stage) before registering a type in JCSS.");

			var className : String = getQualifiedClassName(type);

			if (!_registeredTypes) {
				_registeredTypes = new Object();
				_stage.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler, true);

			} else {
				if (_registeredTypes[className]) return;
			}

			_registeredTypes[className] = Adapter;
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
		public function registerStyleValueFormatter(formatterKey : String, formatter : Function) : void {
			JCSS_StyleValueFormatter.getInstance().registerFormatter(formatterKey, formatter);
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
			_styleManager.startBulkUpdate();
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
			_styleManager.commitBulkUpdate();
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
			_styleManager.setStyleSheet(styleSheet);
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
			_styleManager.setStyle(selector, styleName, styleValue, priority);
		}
		
		/*
		 * Private
		 */

		/**
		 * Type added to stage handler.
		 */
		private function addedToStageHandler(event : Event) : void {
			var component : DisplayObject = event.target as DisplayObject;

			// component not registered yet
			if (!JCSS_StyleManagerMap.getInstance().hasStyleManager(component)) {
				// check if a type adapter for that component is present
				var Adapter : Class = _registeredTypes[getQualifiedClassName(component)];
				if (Adapter) {
					bindAdapterToComponent(Adapter, component);
				}
				else if(_monitorInterfaces) {
					var interfaceInfo:XMLList = describeType(component).implementsInterface;

					var interfaceName:String;
					for each (var thisInterface:XML in interfaceInfo)
					{
						interfaceName = thisInterface.@type.toString();
						var InterfaceAdapter : Class = _registeredTypes[interfaceName];
						bindAdapterToComponent(InterfaceAdapter, component);
					}
				}
			}
		}


		private function bindAdapterToComponent(Adapter:Class, component:DisplayObject):void{

			if(!Adapter) {
				return;
			}

			var adapter:JCSS_Adapter = new Adapter();

			var styleManager:JCSS_ComponentStyleManager = adapter.jcss_internal::getStyleManager_internal();
			JCSS_StyleManagerMap.getInstance().register(component, styleManager);
			styleManager.component = component;
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
			return _styleManager.styleRuleTreeAsString();
		}

	}
}
