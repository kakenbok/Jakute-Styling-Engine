package features.displaylist {
	public class MovingDisplayObjectCSS {
		public static var styles : String = <styles><![CDATA[
			/* Box general */
			
			Box {
				w: 200; h: 200;
				border-size: 0;
			}
	
			/* Container Box */

			Box.container:over {
				border-size: 1;
			}
	
			Box#red {
				background-color: #FF9900;
			}
	
			Box#blue {
				x: 210;
				background-color: #0099FF;
			}
	
			/* Nested Box */
	
			Box Box:moving {
				border-size: 1;
				alpha: .8;
			}

			Box#red Box {
				x: 20; y: 20; w: 160; h: 160;
				background-color: #FFCC66;
			}
	
			Box#blue Box {
				x: 50; y: 50; w: 100; h: 100;
				background-color: #66CCFF;
			}
		]]></styles>.toString();
	}
}