package cs448b.fp.utils
{
	import cs448b.fp.tree.AbstractTree;
	
	import flare.vis.data.NodeSprite;
	
	import flash.filters.BitmapFilter;
	
	/**
	 * All node-level actions, including visual effects and status save & loading
	 */ 
	public class NodeActions
	{
		private var _tree:AbstractTree;
		public function NodeActions(tree:AbstractTree)
		{
			_tree = tree;
		}

		public function addDropShadow(n:NodeSprite):void
		{
			var filter:BitmapFilter = Theme.getBitmapFilter();
			var myFilters:Array = new Array();
			myFilters.push(filter);
			n.filters = myFilters;
		}
		
		public function removeDropShadow(n:NodeSprite):void
		{
			n.filters = null;
		}
	}
}