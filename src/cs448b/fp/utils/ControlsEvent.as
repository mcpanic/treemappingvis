package cs448b.fp.utils
{
	import flash.events.Event;	

	public class ControlsEvent extends Event
	{
		public static const MOUSE_DOWN:String = "onMouseDown";
		public static const CONTROLS_UPDATE:String = "onControlsUpdate";
		public var name:String;
		public var value:Number;

		public function ControlsEvent( type:String, str:String, val:Number=0 )
		{
			value = val;
			name = str;
			super( type );	
		}
	}
}