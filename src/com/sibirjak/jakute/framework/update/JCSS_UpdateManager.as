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
package com.sibirjak.jakute.framework.update {
	import com.sibirjak.jakute.framework.JCSS_ComponentStyleManager;
	import com.sibirjak.jakute.framework.stylerules.JCSS_StyleRule;
	import org.as3commons.collections.LinkedMap;
	import org.as3commons.collections.framework.IMapIterator;


	/**
	 * @author Jens Struwe 11.01.2011
	 */
	public class JCSS_UpdateManager {
		
		public static var STYLE_RULE_ACTIVATED : String = "styleRule_activated";
		public static var STYLE_RULE_DEACTIVATED : String = "styleRule_deactivated";
		public static var STYLE_RULE_ADDED : String = "styleRule_added";
		public static var STYLE_CHANGED : String = "styleRule_changed";
		
		private static var _transaction : JCSS_UpdateManager;
		
		public static function getInstance() : JCSS_UpdateManager {
			if (!_transaction) _transaction = new JCSS_UpdateManager();
			return _transaction;
		}
		
		private var _updateStack : LinkedMap;
		private var _bulkUpdateStarted : Boolean;
		
		public function JCSS_UpdateManager() {
			_updateStack = new LinkedMap();
		}
		
		public function updateStyleRule(styleManager : JCSS_ComponentStyleManager, styleRule : JCSS_StyleRule, reason : String) : void {
			//trace ("update", styleManager, styleRule.selectorString, reason);
			var updateInfo : JCSS_UpdateInfo = getTransactionItem(styleManager);
			updateInfo.updateStyleRule(styleRule, reason);
		}
		
		public function updateAll(styleManager : JCSS_ComponentStyleManager) : void {
			//trace ("updateAll", styleManager);
			var updateInfo : JCSS_UpdateInfo = getTransactionItem(styleManager);
			updateInfo.updateAll = true;
		}

		public function startBulkUpdate() : void {
			_bulkUpdateStarted = true;
		}

		public function commitBulkUpdate() : void {
			_bulkUpdateStarted = false;
			commit();
		}

		public function removeFromUpdates(styleManager : JCSS_ComponentStyleManager) : void {
			_updateStack.removeKey(styleManager);
		}

		public function commit() : void {
			if (_bulkUpdateStarted) return;
			
			_updateStack.sort(new StyleManagerComparator());
			
			var iterator : IMapIterator = _updateStack.iterator() as IMapIterator;
			var styleManager : JCSS_ComponentStyleManager;
			var updateInfo : JCSS_UpdateInfo;
			while (iterator.hasNext()) {
				updateInfo = iterator.next();
				styleManager = iterator.key;
				//trace ("COMMIT", styleManager);
				styleManager.commitStyleChanged(updateInfo);
			}
			
			_updateStack.clear();
		}
		
		private function getTransactionItem(styleManager : JCSS_ComponentStyleManager) : JCSS_UpdateInfo {
			var updateInfo : JCSS_UpdateInfo = _updateStack.itemFor(styleManager);
			if (!updateInfo) {
				updateInfo = new JCSS_UpdateInfo(styleManager.depth);
				_updateStack.add(styleManager, updateInfo);
			}
			return updateInfo;
		}

	}
}


import com.sibirjak.jakute.framework.update.JCSS_UpdateInfo;
import org.as3commons.collections.framework.IComparator;


internal class StyleManagerComparator implements IComparator {
	public function compare(item1 : *, item2 : *) : int {
		
		var depth1 : uint = JCSS_UpdateInfo(item1).depth;
		var depth2 : uint = JCSS_UpdateInfo(item2).depth;
		
		if (depth1 < depth2) return -1;
		if (depth1 > depth2) return 1;
		return 0;
	}
	
} 
