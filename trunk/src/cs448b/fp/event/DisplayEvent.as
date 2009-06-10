package cs448b.fp.event
{
	import flash.events.Event;

	public class DisplayEvent extends Event
	{
		public static const DISPLAY_UPDATE:String = "onDisplayUpdate";
		public var name:String;
		public var value:Number;
		public var message:String;

		public function DisplayEvent( type:String, str:String, val:Number=0, msg:String="")
		{
			value = val;
			name = str;
			message = msg;
			super( type );
				
		}
	}
}
