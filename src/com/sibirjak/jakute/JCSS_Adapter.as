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

	import com.sibirjak.jakute.framework.JCSS_ComponentStyleManager;
	import com.sibirjak.jakute.framework.core.jcss_internal;

	import flash.display.DisplayObject;

	/**
	 * JCSS component adapter.
	 * 
	 * <p>A JCSS adapter (or sublcass) instance realizes the necessary connection between
	 * the independent ui component and the JCSS framework. Each component needs to be registered
	 * to JCSS with its own adapter. In the case of a type registration, the adapter is created
	 * from the given class template by JCSS automatically.</p>
	 * 
	 * <p><strong>JCSS callbacks</strong></p>
	 * 
	 * <p>An adapter provides different settings and operations to control the
	 * styling of a component and its children. In addition, the adapter implements
	 * three callbacks that are triggered during the component life cycle:</p>
	 * 
	 * <ul>
	 * <li>When the component is registered in JCSS.</li>
	 * <li>When the initial component styles are calculated and available. This is the case
	 * right after the component has been added to the display list.</li>
	 * <li>When the component styles have been changed. This may occur in those cases:
	 * 		<ol>
	 * 		<li>The component is re-added to the display list.</li>
	 * 		<li>A new style rule has been set (to an ancestor or to the component).</li>
	 * 		<li>A style of an existing rule has been changed.</li>
	 * 		<li>A state is gained or lost (from an ancestor or the component itself)
	 * 		for that a style rule applies to the component.</li>
	 * 		<li>The css class of an ancestor or the component has changed.</li>
	 * 		<li>An ancestor or the component got a new virtual parent.</li>
	 * 		<li>The virtual parent of a component has been removed from the display list.</li>
	 * 		</ol>
	 * </li>
	 * </ul>
	 * 
	 * <p><strong>Defining styles</strong></p>
	 * 
	 * <p>Styles need to be defined using <code>defineStyle()</code> before they are available to the component.</p>
	 * 
	 * @author Jens Struwe 11.01.2011
	 */
	public class JCSS_Adapter {
		
		/**
		 * The component style manager.
		 */
		private var _styleManager : JCSS_ComponentStyleManager;

		/**
		 * Callback for the registered event.
		 */
		private var _componentRegisteredHandler : Function;

		/**
		 * Callback for the initialized event.
		 */
		private var _stylesInitializedHandler : Function;

		/**
		 * Callback for the changed event.
		 */
		private var _stylesChangedHandler : Function;

		/**
		 * JCSS_Adapter
		 */
		public function JCSS_Adapter() {
			_styleManager = new JCSS_ComponentStyleManager(this);
		}
		
		/**
		 * Returns the component with that the adapter is registered in JCSS.
		 * 
		 * @return The adapted component.
		 */
		public function get component() : DisplayObject {
			return _styleManager.component;
		}

		/**
		 * Returns true if style already have been initialized.
		 * 
		 * @return <code>true</code> if styles initialized.
		 */
		public function get initialized() : Boolean {
			return _styleManager.initialized;
		}

		/*
		 * Selector Attributes
		 */

		/**
		 * @private
		 */
		public function set cssName(cssName : String) : void {
			_styleManager.cssName = cssName;
		}

		/**
		 * Sets and returns the component selector name.
		 * 
		 * <p>Can be set only initially (before the initialized event). Otherwise throws an error.</p>
		 */
		public function get cssName() : String {
			return _styleManager.cssName;
		}
		
		/**
		 * @private
		 */
		public function set cssID(cssID : String) : void {
			_styleManager.cssID = cssID;
		}
		
		/**
		 * Sets and returns the component selector ID.
		 * 
		 * <p>Can be set only initially (before the initialized event). Otherwise throws an error.</p>
		 */
		public function get cssID() : String {
			return _styleManager.cssID;
		}
		
		/**
		 * @private
		 */
		public function set cssClass(cssClass : String) : void {
			_styleManager.cssClass = cssClass;
		}
		
		/**
		 * Sets and returns the component css class.
		 * 
		 * <p>Can be set initially or at runtime.</p>
		 */
		public function get cssClass() : String {
			return _styleManager.cssClass;
		}
		
		/**
		 * Sets a component state.
		 * 
		 * <p>Can be set initially or at runtime.</p>
		 * 
		 * @param stateName The name of the state.
		 * @param value The value of the state.
		 * 
		 */
		public function setState(stateName : String, value : String) : void {
			_styleManager.setState(stateName, value);
		}
		
		/**
		 * Returns the value of a component state.
		 * 
		 * @return The state value.
		 */
		public function getState(stateName : String) : String {
			return _styleManager.getState(stateName);
		}
		
		/*
		 * Styles
		 */
		
		/**
		 * Defines a style prior to be used with JCSS.
		 * 
		 * <p>Styles need to be defined initially. Not initially defined styles are ignored
		 * and never affect the particular component.</p>
		 * 
		 * <p>Styles can be defined only initially (before the initialized event).
		 * Otherwise an error is thrown.</p>
		 * 
		 * @param styleName The name of the style of a component.
		 * @param styleValue The initial value of the component style.
		 * @param format The key of the formatter of the style value.
		 * @param isDefault Indicates if the initial style value may be overriden.
		 */
		public function defineStyle(styleName : String, styleValue : *, format : String, priority : uint = 0) : void {
			_styleManager.defineStyle(styleName, styleValue, format, priority);
		}

		/**
		 * @copy JCSS#startBulkUpdate()
		 */
		public function startBulkUpdate() : void {
			_styleManager.startBulkUpdate();
		}

		/**
		 * @copy JCSS#commitBulkUpdate()
		 */
		public function commitBulkUpdate() : void {
			_styleManager.commitBulkUpdate();
		}

		/**
		 * Sets a style sheet to a component instance.
		 * 
		 * <p>The style sheet can be loaded from an external source or created at runtime.</p>
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
		 * @param styleSheet The stylesheet to set.
		 */
		public function setStyleSheet(styleSheet : String) : void {
			_styleManager.setStyleSheet(styleSheet);
		}

		/**
		 * Sets a style to a component instance.
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

		/**
		 * Returns the current value of the given style name.
		 * 
		 * <p>Returns initially (before the initialized event) <code>null<code>, for sure.</p>
		 */
		public function getStyle(styleName : String) : * {
			return _styleManager.getStyle(styleName);
		}
		
		/*
		 * Properties
		 */

		/**
		 * Declares all child component to be selectable only via this component selector.
		 * 
		 * <p>Enclosing children is useful when setting up stateful default styles that
		 * should not be overriden by accident. In example, we create a Button with several
		 * states and default styles that affect the contained label color. Setting now a
		 * global label color would override the Button declarations and make the label
		 * state insensitive. Invoking <code>encloseChildren()<code> lets match only styles rules
		 * that include this component in the selector chain.:</p>
		 * 
		 *	<listing>
			Without encloseChildren();
			-----------------------------------------------
			myButton.setStyle(":over Label", "color", "red", "default"); // Button Label is red on mouse over by default.
			JCSS.getInstance().setStyle("Label", "color", "blue"); // Button Label is now blue even on mouse over.
			
			With encloseChildren();
			-----------------------------------------------
			myButton.setStyle(":over Label", "color", "red", "default"); // Button Label is red on mouse over by default.
			myButton.encloseChildren();
			JCSS.getInstance().setStyle("Label", "color", "blue"); // Does not affect the Button Label.
			JCSS.getInstance().setStyle("Button Label", "color", "blue"); // Button Label is now blue, since the selector includes Button.
		 *	</listing>
		 *	
		 * <p>This method can be called only initially (before the initialized event).
		 * Otherwise an error is thrown.</p>
		 */
		public function encloseChildren() : void {
			_styleManager.encloseChildren();
		}

		/**
		 * Returns <code>true</code>, if <code>encloseChildren()</code> is set, else false.
		 */
		public function childrenEnclosed() : Boolean {
			return _styleManager.childrenEnclosed();
		}

		/**
		 * @private
		 */
		public function set virtualParent(parent : DisplayObject) : void {
			_styleManager.virtualParent = parent;
		}

		/**
		 * Sets and gets the virtual parent of a component.
		 * 
		 * <p>If a virtual parent is set, the component styles are calculated using
		 * the virtual parent's display list instead of the physical parent's display
		 * list. A virtual parent is a great possibility to connect components that
		 * do not have a physical parent-child relation such as tooltips or popups,
		 * which usually live in a separated container.</p>
		 * 
		 *	<listing>
			CSS
			-----------------------------------------------
			Button.red ToolTip {
				color: red;
			}

			Button.blue ToolTip {
				color: blue;
			}

			Pseudo code
			-----------------------------------------------
			redButton.onMouseOver = {
				tooltip.virtualParent = redButton;
				tooltip.show(redButton.position.toGlobal());
			}

			blueButton.onMouseOver = {
				tooltip.virtualParent = blueButton;
				tooltip.show(blueButton.position.toGlobal());
			}
		 *	</listing>
		 *	
		 * <p>Can be set initially or at runtime.</p>
		 */
		public function get virtualParent() : DisplayObject {
			return _styleManager.virtualParent;
		}

		/*
		 * Handlers
		 */

		/**
		 * Sets a custom callback for the registered event.
		 * 
		 * <p>The callback is triggered right after the component has been
		 * registered in JCSS. The goal of the callback is to enable initial
		 * setting for components that are registered with their type. In the
		 * case of instance registration, we usually have the full control over
		 * the time, the component gets registered, so we could here place
		 * the related code right before or after the <code>JCSS::registerComponent()</code>
		 * command.</p>
		 * 
		 * <p>A custom registered handler may be set if the implementation of an adapter
		 * can not or should not be changed. Using a custom callback makes
		 * the same adapter implementation reusable for different component
		 * types.</p>
		 * 
		 * <p>If not set, <code>onComponentRegistered()</code> is called by default.</p>
		 * 
		 * <p>A custom registered handler has the following signature. Note, that
		 * the current adapter is also passed to the method, which might be confusing.
		 * However, this enables to reuse the same handler with different adapters.</p> 
		 * 
		 *	<listing>
			theAdapter.componentRegisteredHandler = function(adapter : JCSS_Adapter) : void {
				trace ("registered", Box(adapter.component));
			};
		 *	</listing>
		 *	
		 * @param handler The callback for the registered event.
		 */
		public function set componentRegisteredHandler(handler : Function) : void {
			_componentRegisteredHandler = handler;
		}

		/**
		 * Sets a custom callback for the initialized event.
		 * 
		 * <p>The callback is triggered once for a component and after the styles of
		 * a component have been calculated the first time. Starting from here, all
		 * further changes in JCSS will update the component (incrementally) using
		 * notifying the component by the styles changed callback.</p>
		 * 
		 * <p>A custom initialized handler may be set if the implementation of an adapter
		 * can not or should not be changed. Using a custom callback makes
		 * the same adapter implementation reusable for different component
		 * types.</p>
		 * 
		 * <p>If not set, <code>onStylesInitialized()</code> is called by default.</p> 
		 * 
		 * <p>A custom initialized handler has the following signature. Note, that
		 * the current adapter is also passed to the method, which might be confusing.
		 * However, this enables to reuse the same handler with different adapters.</p> 
		 * 
		 *	<listing>
			theAdapter.stylesInitializedHandler = function(allInitialStyles : Object, adapter : JCSS_Adapter) : void {
				Box(adapter.component).draw();
			};
		 *	</listing>
		 * 
		 * @param handler The callback for the initialized event.
		 */
		public function set stylesInitializedHandler(handler : Function) : void {
			_stylesInitializedHandler = handler;
		}
		
		/**
		 * Sets a custom callback for the styles changed event.
		 * 
		 * <p>The callback is triggered always a component style has been
		 * changed.</p>
		 * 
		 * <p>A custom changed handler may be set if the implementation of an adapter
		 * can not or should not be changed. Using a custom callback makes
		 * the same adapter implementation reusable for different component
		 * types.</p>
		 * 
		 * <p>A custom styles changed handler has the following signature. Note, that
		 * the current adapter is also passed to the method, which might be confusing.
		 * However, this enables to reuse the same handler with different adapters.</p> 
		 * 
		 *	<listing>
			theAdapter.stylesChangedHandler = function(allChangedStyles : Object, adapter : JCSS_Adapter) : void {
				if (allChangedStyles["backgroundColor"] != undefined) {
					Box(adapter.component).updateBackground();
				}
			};
		 *	</listing>
		 * 
		 * <p>If not set, <code>onStylesChanged()</code> is called by default.</p> 
		 * 
		 * @param handler The callback for the styles changed event.
		 */
		public function set stylesChangedHandler(handler : Function) : void {
			_stylesChangedHandler = handler;
		}

		/*
		 * jcss_internal
		 */
		
		/**
		 * Returns the private style manager instance.
		 * 
		 * @return The style manager.
		 * @private
		 */
		jcss_internal function getStyleManager_internal() : JCSS_ComponentStyleManager {
			return _styleManager;
		}

		/**
		 * Registered callback.
		 * 
		 * @private
		 */
		jcss_internal function registered_internal() : void {
//			trace ("component registered", component, componentName);
			if (_componentRegisteredHandler != null) {
				_componentRegisteredHandler(this);
			} else {
				onComponentRegistered();
			}
		}
		
		/**
		 * Initialized callback.
		 * 
		 * @param styles All styles of the component.
		 * @private
		 */
		jcss_internal function stylesInitialized_internal(styles : Object) : void {
			//trace ("---- styles initialized", componentSelectorAsString());
			if (_stylesInitializedHandler != null) {
				_stylesInitializedHandler(styles, this);
			} else {
				onStylesInitialized(styles);
			}
		}
		
		/**
		 * Styles changed callback.
		 * 
		 * @param styles All recently changed styles.
		 * @private
		 */
		jcss_internal function stylesChanged_internal(styles : Object) : void {
			//trace ("-------- styles changed", componentSelectorAsString());
			if (_stylesChangedHandler != null) {
				_stylesChangedHandler(styles, this);
			} else {
				onStylesChanged(styles);
			}
		}

		/*
		 * Protected
		 */

		/**
		 * Default handler for the registered event.
		 * 
		 * <p>Template method, to be overridden in a sub class.</p>
		 * 
		 * @see #componentRegisteredHandler
		 */
		protected function onComponentRegistered() : void {
			// template method
		}
		
		/**
		 * Default handler for the initialized event.
		 * 
		 * <p>Template method, to be overridden in a sub class.</p>
		 * 
		 * @param styles All initial styles of the component.
		 * @see #stylesInitializedHandler
		 */
		protected function onStylesInitialized(styles : Object) : void {
			// template method
		}
		
		/**
		 * Default handler for the styles changed event.
		 * 
		 * <p>Template method, to be overridden in a sub class.</p>
		 * 
		 * @param styles All recently changed styles.
		 * @see #stylesChangedHandler
		 */
		protected function onStylesChanged(styles : Object) : void {
			// template method
		}
		
		/*
		 * Info
		 */
		
		/**
		 * Returns a formatted String with all currently set styles.
		 * 
		 *	<listing>
			Styles for Box#mini.highlight(64) < Box(56) < Box(48) < Box.blue(39)

			borderColor: 255;
			------------------------------ specifity:103 timestamp:7
			backgroundColor: 16777215;
			------------------------------ specifity:3 timestamp:11
			borderAlpha: 0.5;
			------------------------------ specifity:2 timestamp:2
			color: 0 default;
			------------------------------ specifity:40001 timestamp:35
			borderSize: 1;
			------------------------------ specifity:2 timestamp:1
		 *	</listing>
		 *	
		 * @return Currently set styles in a formatted string.
		 */
		public function stylesAsString() : String {
			return _styleManager.stylesAsString();
		}

		/**
		 * @copy JCSS#styleRuleTreeAsString();
		 */
		public function styleRuleTreeAsString() : String {
			return _styleManager.styleRuleTreeAsString();
		}

		/**
		 * Returns the full selector of a component.
		 * 
		 * <p>E.g. <code>Box#mini.highlight</code></p>
		 * 
		 * @return The component selector.
		 */
		public function componentSelectorAsString() : String {
			return _styleManager.componentSelectorAsString();
		}

		/**
		 * Returns the JCSS parent chain of a componet.
		 * 
		 * <p>E.g. <code>Box#mini.highlight(64) < Box(56) < Box(48) < Box.blue(39)</code></p>
		 * 
		 * @return The parent chain of a component.
		 */
		public function parentChainAsString() : String {
			return _styleManager.parentChainAsString();
		}
		
	}
}
