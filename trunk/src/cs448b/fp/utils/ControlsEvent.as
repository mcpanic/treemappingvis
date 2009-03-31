package cs448b.fp.utils
{
	import flash.events.Event;	

	public class ControlsEvent extends Event
	{
		public static const MOUSE_DOWN:String = "onMouseDown";
		public static const CONTROLS_UPDATE:String = "onControlsUpdate";
		public static const STATUS_UPDATE:String = "onStatusUpdate";
		public var name:String;
		public var value:Number;
		public var message:String;

		public function ControlsEvent( type:String, str:String, val:Number=0, msg:String="")
		{
			value = val;
			name = str;
			message = msg;
			super( type );
				
		}
	}
}