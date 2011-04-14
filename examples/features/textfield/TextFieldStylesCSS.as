package features.textfield {
	public class TextFieldStylesCSS {
		public static var styles : String = <styles><![CDATA[
			Text {
				w: 200;
				h: 26;
				font-size: 20;
				color: #339933;
				border-color: #995500;
				background-color: #F5F5F5;
			}
			
			Text.input {
				type: input;
				font-family: _typewriter;
				background: true;
				border: true;
			}

			Text.input:focus {
				color: #444444 !important;
				border-color: #999999 !important;
				background-color: #FFFFFF !important;
			}

			Text#second {
				x: 60;
				y: 40;
				font-family: _sans;
				color: #DD4400;
				border: false;
			}

			Text#third {
				y: 80;
				w: 300;
				h: 20;
				font-size: 14;
				color: #FFFFFF;
				background-color: #666699;
				border-color: #000033;
			}
		]]></styles>.toString();
	}
}