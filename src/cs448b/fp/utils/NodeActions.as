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

		/**
		 * Add drop shadow effect to the node
		 */ 
		public function addDropShadow(n:NodeSprite):void
		{
			var filter:BitmapFilter = Theme.getDropShadowFilter();
			var myFilters:Array = new Array();
			myFilters.push(filter);
			n.filters = myFilters;
		}
		
		/**
		 * Wrapper for removeFilters
		 */ 
		public function removeDropShadow(n:NodeSprite):void
		{
			removeFilters(n);
		}
		
		/**
		 * Remove the drop shadow effect. All other effects are removed as well.
		 */ 
		private function removeFilters(n:NodeSprite):void
		{
			n.filters = null;
		}
		
		/**
		 * Add glow effect to the node
		 */ 
		public function addGlow(n:NodeSprite, alpha:Number = 0.8, blurX:Number = 7, blurY:Number = 7):void
		{
			var filter:BitmapFilter = Theme.getGlowFilter(alpha, blurX, blurY);
			var myFilters:Array = new Array();
			myFilters.push(filter);
			n.filters = myFilters;
		}
		
		/**
		 * Wrapper for removeFilters
		 */ 
		public function removeGlow(n:NodeSprite):void
		{
			removeFilters(n);
		}		
	}
}