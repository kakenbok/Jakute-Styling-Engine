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
package com.sibirjak.jakute.framework.styles {

	import com.sibirjak.jakute.constants.JCSS_StyleDeclarationPriority;
	import com.sibirjak.jakute.constants.JCSS_StyleValueFormat;
	import com.sibirjak.jakute.events.JCSS_ChangeEvent;
	import com.sibirjak.jakute.framework.JCSS_ComponentStyleManager;
	import com.sibirjak.jakute.framework.core.jcss_internal;
	import com.sibirjak.jakute.framework.stylerules.JCSS_StyleDeclaration;
	import com.sibirjak.jakute.framework.stylerules.JCSS_StyleRule;
	import com.sibirjak.jakute.styles.JCSS_IValueFormatter;
	
	use namespace jcss_internal;

	/**
	 * @author Jens Struwe 11.01.2011
	 */
	public class JCSS_StyleValueManager {
		
		private var _styleManager : JCSS_ComponentStyleManager;
		
		private var _definedStyles : Object;
		
		private var _styleRules : Object;

		private var _styles : Object;
		private var _styleStyleRuleMap : Object;
		private var _stylesTimeStampMap : Object;

		private var _snapshot : Object;
		
		public function JCSS_StyleValueManager(styleManager : JCSS_ComponentStyleManager) {
			_styleManager = styleManager;
			_definedStyles = new Object();
			
			clearAllStyles();
		}
		
		/*
		 * Define styles
		 */
		
		public function defineStyle(styleName : String, styleValue : *, format : String, priority : uint) : void {
			var styleDeclaration : JCSS_StyleDeclaration = new JCSS_StyleDeclaration();
			styleDeclaration.propertyName = styleName;
			styleDeclaration.value = styleValue;
			styleDeclaration.format = format;
			styleDeclaration.priority = priority;
			
			_definedStyles[styleName] = styleDeclaration;
		}

		public function get definedStyles() : Object {
			return _definedStyles;
		}

		/*
		 * Add, update, remove style rules
		 */
		
		public function addStyleRule(styleRule : JCSS_StyleRule) : void {
			_styleRules[styleRule.firstSelector.selectorID] = styleRule;
			
			for (var propertyName : String in styleRule.styles) {
				var shouldSetStyle : Boolean = shouldSetStyleFromRule(styleRule, propertyName);
				//trace ("shouldSetStyleFromRule", styleRule.selectorString, shouldSetStyle);
				if (!shouldSetStyle) continue;
				setStyle(styleRule, propertyName);
			}
		}

		public function updateStyleRule(styleRule : JCSS_StyleRule) : void {
			for (var propertyName : String in styleRule.styles) {
				//trace ("shouldSetStyleFromRule(styleRule, propertyName)", shouldSetStyleFromRule(styleRule, propertyName));
				if (!shouldSetStyleFromRule(styleRule, propertyName)) continue;

				setStyle(styleRule, propertyName);
			}
		}

		public function removeStyleRule(styleRule : JCSS_StyleRule) : void {
			delete _styleRules[styleRule.firstSelector.selectorID];
			
			var tmpStyleRule : JCSS_StyleRule;
			for (var propertyName : String in styleRule.styles) {

				// no change if current style is not from the rule
				if (styleRule != _styleStyleRuleMap[propertyName]) continue;

				delete _styles[propertyName];
				delete _styleStyleRuleMap[propertyName];
				delete _stylesTimeStampMap[propertyName];

				for each (tmpStyleRule in _styleRules) {
					if (!tmpStyleRule.styles[propertyName]) continue; // rule does not define the property
					if (!shouldSetStyleFromRule(tmpStyleRule, propertyName)) continue;
	
					setStyle(tmpStyleRule, propertyName);
				}
			}
		}
		
		public function removeStyle(styleRule : JCSS_StyleRule, propertyName : String) : void {
			// no change if current style is not from the rule
			if (styleRule != _styleStyleRuleMap[propertyName]) return;

			delete _styles[propertyName];
			delete _styleStyleRuleMap[propertyName];
			delete _stylesTimeStampMap[propertyName];

			var tmpStyleRule : JCSS_StyleRule;
			for each (tmpStyleRule in _styleRules) {
				if (!tmpStyleRule.styles[propertyName]) continue; // rule does not define the property
				if (!shouldSetStyleFromRule(tmpStyleRule, propertyName)) continue;

				setStyle(tmpStyleRule, propertyName);
			}
		}
		
		/*
		 * Get styles
		 */
		
		public function get styles() : Object {
			return _styles;
		}

		public function getStyle(name : String) : * {
			return _styles[name];
		}
		
		/*
		 * Snapshot and changed styles
		 */
		
		public function snapshotStyles() : void {
			_snapshot = new Object();
			for (var name : String in _styles) {
				_snapshot[name] = _styles[name];
			}
		}

		public function getChangedStyles() : JCSS_ChangeEvent {
			//info ("getChangedStyles");
			var changedStyles : JCSS_ChangeEvent = new JCSS_ChangeEvent();
			for (var propertyName : String in _styles) {
				//info ("--", propertyName, _styles[propertyName]);
				//info ("--", _styleStyleRuleMap[propertyName], _snapshotStyleRules[propertyName]);
				var formatter : JCSS_IValueFormatter = _styleManager.jcss.getStyleValueFormatter(
					JCSS_StyleDeclaration(_definedStyles[propertyName]).format
				);
				// style changed
				if (!formatter.equals(_styles[propertyName], _snapshot[propertyName])) {
					changedStyles.setValue(propertyName, _styles[propertyName]);
				}
			}

			_snapshot = null;
			return changedStyles;
		}
		
		/*
		 * Reset
		 */

		public function clearAllStyles() : void {
			_styleRules = new Object();

			_styles = new Object();
			_styleStyleRuleMap = new Object();
			_stylesTimeStampMap = new Object();
		}

		/*
		 * Private
		 */
		
		private function setStyle(styleRule : JCSS_StyleRule, propertyName : String) : void {
			var value : * = JCSS_StyleDeclaration(styleRule.styles[propertyName]).value;

			var formatter : JCSS_IValueFormatter = _styleManager.jcss.getStyleValueFormatter(
				JCSS_StyleDeclaration(_definedStyles[propertyName]).format
			);
			value = JCSS_IValueFormatter(formatter).format(value);
			JCSS_StyleDeclaration(styleRule.styles[propertyName]).value = value; // format style rule value
			
			_styles[propertyName] = value;
			_styleStyleRuleMap[propertyName] = styleRule;
			_stylesTimeStampMap[propertyName] = JCSS_StyleDeclaration(styleRule.styles[propertyName]).timeStamp;
		}

		/*
		 * If the given styleRule is already set for the propertyName, the method returns
		 * true, if the style value has changed.
		 */
		private function shouldSetStyleFromRule(styleRule : JCSS_StyleRule, propertyName : String) : Boolean {
			// style not defined
			if (_definedStyles[propertyName] === undefined) return false;
			
			var oldStyleRule : JCSS_StyleRule = _styleStyleRuleMap[propertyName];
			if (!oldStyleRule) {
				//trace ("-- no old rule for property", propertyName);
				return true; // no current value
			}

			var styleDeclaration : JCSS_StyleDeclaration = styleRule.styles[propertyName];
			var oldStyleDeclaration : JCSS_StyleDeclaration = oldStyleRule.styles[propertyName];
			
			/*
			 * If the property value of the style rule to test is already set in _styles,
			 * we have to check if the value has been changed by examine the timestamp of
			 * the current style value.
			 */
			if (styleRule == oldStyleRule) {
				// TODO recheck if it is ok to turn off: return true; // value changed
				if (styleDeclaration.timeStamp === _stylesTimeStampMap[propertyName]) {
					return false; // value not changed
				} else {
					return true; // value changed
				}
			}
			
			var diff : int = styleRule.specifity - oldStyleRule.specifity;
			if (!diff) diff = styleDeclaration.timeStamp - oldStyleDeclaration.timeStamp;
			
			/*
			 * both styles declared in the same component and with equal priority
			 */
			if (styleRule.ownerDepth == oldStyleRule.ownerDepth) {
				if (styleDeclaration.priority == oldStyleDeclaration.priority) {
					/*
					 * a less specific default style does not override a more specific default
					 * style when declared both in the same component instance.
					 */
					if (styleDeclaration.priority == JCSS_StyleDeclarationPriority.PRIORITY_DEFAULT) {
						return diff < 0 ? false : true;
					}
					/*
					 * a less specific default style does not override a more specific default
					 * style when declared both in the same component instance.
					 */
					if (styleDeclaration.priority == JCSS_StyleDeclarationPriority.PRIORITY_IMPORTANT) {
						return styleDeclaration.timeStamp < oldStyleDeclaration.timeStamp ? false : true;
					}
				}
			}

			/*
			 * styles declared in different components or with different priority
			 */
			if (diff < 0) { // new style is lesser specific
				// a less specific style of any priority overrides a more specific default style
				if (oldStyleDeclaration.priority == JCSS_StyleDeclarationPriority.PRIORITY_DEFAULT) {
					return true;
				}
				// a less specific style with higher priority overrides a more specific style
				return styleDeclaration.priority > oldStyleDeclaration.priority ? true : false;
				
			} else { // new style is more specific
				// a more specific default style does not override a lesser specific style of any priority
				if (styleDeclaration.priority == JCSS_StyleDeclarationPriority.PRIORITY_DEFAULT) {
					return false;
				}
				// a more specific style with lesser priority does not override a lesser specific style
				return styleDeclaration.priority < oldStyleDeclaration.priority ? false : true;
			}
		}
		
		/*
		 * Info
		 */

		public function stylesAsString(styles : Object = null) : String {
			if (!styles) styles = _styles;
			var string : String = "";
			var styleRule : JCSS_StyleRule;
			var styleDeclaration : JCSS_StyleDeclaration;
			var styleValue : *;
			for (var propertyName : String in styles) {
				styleRule = _styleStyleRuleMap[propertyName];
				styleDeclaration = styleRule.styles[propertyName];
				styleValue = styles[propertyName];
				
				if (JCSS_StyleDeclaration(_definedStyles[propertyName]).format == JCSS_StyleValueFormat.FORMAT_HTML_COLOR) styleValue = hexToString(styleValue);
				if (styleDeclaration.priority == JCSS_StyleDeclarationPriority.PRIORITY_DEFAULT) styleValue += " default";
				if (styleDeclaration.priority == JCSS_StyleDeclarationPriority.PRIORITY_IMPORTANT) styleValue += " !important";
				
				string += fillToSize(propertyName + ":", 30) + fillToSize(styleValue + ";", 30);
				string += fillToSize("[specifity: " + styleRule.specifity, 24);
				string += "timestamp: " + styleDeclaration.timeStamp + "]\n";
			}
			return string;

			function hexToString(hex : Number) : String {
				var hexString : String = hex.toString(16);
				hexString = "#" + ("000000").substr(0, 6 - hexString.length) + hexString; 
				return hexString.toUpperCase();
			}
			
			function fillToSize(string : String, size : uint) : String {
				for (var i : uint = string.length; i < size; i++) string += " ";
				return string;
			}
		}

	}
}
