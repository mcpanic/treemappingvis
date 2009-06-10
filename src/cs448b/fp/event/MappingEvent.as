package cs448b.fp.event
{
	import flash.events.Event;
	
	public class MappingEvent extends Event
	{
		public static const MOUSE_DOWN:String = "MouseDown";
		public var name:String;
		public var value:Number;

		public function MappingEvent( type:String, str:String, val:Number=0 )
		{
			value = val;
			name = str;
			super( type );	
		}		

	}
}