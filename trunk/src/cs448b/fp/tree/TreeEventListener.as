package cs448b.fp.tree
{
	import flare.vis.data.NodeSprite;
	
	import flash.events.Event;
	
	public interface TreeEventListener
	{
		function handleEvent(n:NodeSprite, evt:Event):void;
	}
}