package cs448b.fp.tree
{
	import cs448b.fp.data.Mapping;
	
	import flare.vis.data.NodeSprite;
	
	import flash.events.Event;
	
	/**
	 * <code>TreeEventSynchronizer</code> synchronizes the events 
	 */
	public class TreeEventSynchronizer implements TreeEventListener
	{
		private var trees:Array = new Array(2);
		
		private var mapping:Mapping;
		
		public function TreeEventSynchronizer()
		{
			mapping = new Mapping();
		}

		/**
		 * Adds the tree.
		 */
		public function addTree(tree:SimpleTree):void
		{
			trees.push(tree);
			
			tree.addTreeEventListener(this);
		}
		
		/**
		 * Removes the tree.
		 */
		public function removeTree(tree:SimpleTree):void
		{
			trees.splice(trees.indexOf(tree), 1);
			
			tree.removeTreeEventListener(this);
		}
		
		/**
		 * Handles event
		 */
		public function handleEvent(evt:Event):void
		{
			// check if it was sent by a NodeSprite
			var node:NodeSprite = evt.target as NodeSprite;
			if(node == null) return;
			
			// find the sender
			var sender:SimpleTree = evt.currentTarget as SimpleTree;
			if(sender == null)
			{
				for(var oo:Object in trees)
				{
					var tt:SimpleTree = trees[oo] as SimpleTree;
					if(tt != null && tt.contains(node)) {
						sender = tt;
						break;
					}
				}
			}
			if(sender == null) return;
			
			// send this to all trees except sender
			for(var o:Object in trees)
			{
				var t:SimpleTree = trees[o] as SimpleTree;
				if(t != null) {
					if(t != sender) {
						// Get mapped value
						var mappedIdx:Number = mapping.getMappedIndex(Number(node.name), t.getId());
						
						var mv:String = String(mappedIdx);

						t.handleSyncEvent(mv, evt);
					}
				}
			}
		}
	}
}