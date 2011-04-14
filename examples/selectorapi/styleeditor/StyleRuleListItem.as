package selectorapi.styleeditor {

	import com.sibirjak.jakute.framework.stylerules.JCSS_StyleRule;
	import flash.events.Event;
	import flash.events.EventDispatcher;

	public class StyleRuleListItem extends EventDispatcher {
		public var styleRule : JCSS_StyleRule;

		public function StyleRuleListItem(theStyleRule : JCSS_StyleRule) {
			styleRule = theStyleRule;
		}

		public function dispatchUpdate() : void {
			dispatchEvent(new Event(Event.CHANGE));
		}

	}
}
