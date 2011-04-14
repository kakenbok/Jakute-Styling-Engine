package features.selectors {
	public class SelectorsCSS {
		public static var styles : String = <styles><![CDATA[
			/* Layout */
			
			Box.big {
				w: 200; h: 200;
			}
			
			Box.big#second {
				x: 220;
			}
			
			Box.small {
				x: 30; y: 30; w: 140; h: 60;
			}
			
			Box.small#second {
				y: 120;
			}
			
			/* Colors */
			
			Box#first {
				background-color: #FFFFFF;
			}
			
			Box.small {
				border-size: 2;
				border-color: #006699;
				background-color: #00BBFF;
			}
		]]></styles>.toString();
	}
}