package cs448b.fp.utils
{
	import flash.events.Event;
	
	public class MappingEvent extends Event
	{
		public static const MOUSE_DOWN:String = "MouseDown";
		
		public function MappingEvent(type:String)
		{
			super( type );	
		}

	}
}