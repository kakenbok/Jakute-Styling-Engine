package features.states {
	public class StatesCSS {
		public static var styles : String = <styles><![CDATA[
			Box {
				w: 200; h: 150;
				border-color: #CC9900;
				background-color: #FFBB00;
			}
			
			Box Box {
				w: 100; h: 50; x: 70; y: 70;
				border-color: #DDDDFF;
				background-color: #00BBFF;
			}
			
			Box:over {
				background-color: #FFCC00;
			}
			
			Box:down {
				background-gradient: dark_to_bright;
			}
			
			Box Box:over {
				background-color: #00CCFF;
			}
		]]></styles>.toString();
	}
}