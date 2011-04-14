package features.displaylist {
	public class MovingDisplayObject4CSS {
		public static var styles : String = <styles><![CDATA[
			/* Box general */
			
			Box {
				w: 100; h: 100;
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
				x: 110;
				background-color: #0099FF;
			}
	
			Box#yellow {
				x: 220;
				background-color: #DDDD00;
			}
	
			Box#green {
				x: 330;
				background-color: #66DD66;
			}
	
			/* Nested Box */

			Box Box {
				x: 20; y: 20; w: 60; h: 60;
			}
	
			Box Box:moving {
				border-size: 1;
				alpha: .8;
			}

			Box#red Box {
				background-color: #FFCC66;
			}
	
			Box#blue Box {
				background-color: #66CCFF;
			}
	
			Box#yellow Box {
				background-color: #EEEE66;
			}
	
			Box#green Box {
				background-color: #99FF99;
			}
		]]></styles>.toString();
	}
}