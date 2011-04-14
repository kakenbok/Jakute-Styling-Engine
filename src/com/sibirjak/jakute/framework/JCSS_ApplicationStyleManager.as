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
package com.sibirjak.jakute.framework {

	import com.sibirjak.jakute.framework.roles.JCSS_RoleManager;
	import com.sibirjak.jakute.framework.stylerules.JCSS_StyleRule;
	import com.sibirjak.jakute.framework.stylerules.JCSS_StyleRuleTree;
	import com.sibirjak.jakute.framework.update.JCSS_UpdateManager;

	/**
	 * @author Jens Struwe 11.01.2011
	 */
	public class JCSS_ApplicationStyleManager extends JCSS_StyleManager {
		
		public static const STYLE_RULE_ADDED : String = "stylerule_added";
		public static const STYLE_RULE_UPDATED : String = "stylerule_updated";
		public static const STYLE_RULE_REMOVED : String = "stylerule_removed";
		public static const ALL_STYLE_RULES_REMOVED : String = "reset";
		
		private var _jcssStyleRuleEventCallback : Function;
		
		public function JCSS_ApplicationStyleManager() {
			_roleManager = new JCSS_RoleManager(this);
			_roleManager.initRoles();
		}
		
		/**
		 * Removes a style rule from the global style manager.
		 * 
		 * <p>This should be used only for debugging purposes.</p>
		 * 
		 * @private
		 */
		public function removeStyleRule(styleRule : JCSS_StyleRule) : void {
			
			var oldStyleRuleTree : JCSS_StyleRuleTree = _styleRuleTree;
			
			_styleRuleTree = new JCSS_StyleRuleTree(this);
			
			_updatesEnabled = false;
			
			oldStyleRuleTree.foreachStyleRule(readdStyleRuleCallback);
			function readdStyleRuleCallback(oldStyleRule : JCSS_StyleRule) : void {
				if (styleRule == oldStyleRule) return;
				_styleRuleTree.addStyleRule(oldStyleRule);
			}
			
			_roleManager.initRoles();

			foreachChildComponentStyleManager(resetAllCallback);
			function resetAllCallback(styleManager : JCSS_ComponentStyleManager) : Boolean {
				JCSS_UpdateManager.getInstance().updateAll(styleManager);
				return true;
			}

			JCSS_UpdateManager.getInstance().commit();

			_updatesEnabled = true;

			if (_jcssStyleRuleEventCallback != null) _jcssStyleRuleEventCallback({
				info: STYLE_RULE_REMOVED,
				stylerule: styleRule
			});
		}
		
		override public function styleRuleTree_notifyStyleRuleAdded(styleRule : JCSS_StyleRule, clientsNotRegisteredYet : Boolean) : void {
			super.styleRuleTree_notifyStyleRuleAdded(styleRule, clientsNotRegisteredYet);

			if (_jcssStyleRuleEventCallback != null) _jcssStyleRuleEventCallback({
				info: STYLE_RULE_ADDED,
				stylerule: styleRule
			});
		}
		
		override public function styleRuleTree_notifyStyleChanged(styleRule : JCSS_StyleRule) : void {
			super.styleRuleTree_notifyStyleChanged(styleRule);

			if (_jcssStyleRuleEventCallback != null) _jcssStyleRuleEventCallback({
				info: STYLE_RULE_UPDATED,
				stylerule: styleRule
			});
		}
		
		/**
		 * Registers an event handler that is notified when style rules have been
		 * added or updated.
		 * 
		 * <p>This is only for debugging purposes.</p>
		 * 
		 * @param handler The event callback.
		 */
		public function set jcssStyleRuleEventCallback(callback : Function) : void {
			_jcssStyleRuleEventCallback = callback;
		}
		
	}
}
