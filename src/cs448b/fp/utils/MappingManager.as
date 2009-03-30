package cs448b.fp.utils
{
	import cs448b.fp.data.Mapping;
	import cs448b.fp.tree.CascadedTree;
	
	import flash.events.Event;
	
	public class MappingManager
	{
		private var _mapping:Mapping;
		private var _contentTree:CascadedTree = null;
		private var _layoutTree:CascadedTree = null;
		
		public function MappingManager()
		{
			_mapping = new Mapping();	
		}

		public function setContentTree(t:CascadedTree):void
		{
			_contentTree = t;
			_contentTree.addEventListener(MappingEvent.MOUSE_DOWN, onContentTreeEvent);
		}
		
		public function setLayoutTree(t:CascadedTree):void
		{
			_layoutTree = t;
			_layoutTree.addEventListener(MappingEvent.MOUSE_DOWN, onLayoutTreeEvent);
		}
		
		private function onContentTreeEvent(e:Event):void
		{
			// TODO: handle mapping event here
			trace("ContentTree - Mouse Down!");	
		}
		
		private function onLayoutTreeEvent(e:Event):void
		{
			// TODO: handle mapping event here
			trace("LayoutTree - Mouse Down!");	
		}
	}
}