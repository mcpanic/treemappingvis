package cs448b.fp.tree
{
	import flash.events.Event;
	
	/**
	 * <code>TreeEventSynchronizer</code> synchronizes the events 
	 */
	public class TreeEventSynchronizer implements TreeEventListener
	{
		private var trees:Array = new Array(2);
		
		public function TreeEventSynchronizer()
		{
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
//			trace(evt);

			// send this to all trees except sender
			var sender:SimpleTree = evt.currentTarget as SimpleTree; 
			if(sender == null) return;
			
			for(var o:Object in trees)
			{
				var t:SimpleTree = trees[o] as SimpleTree;
				if(t != null) {
					// Set mapping value
					if(t != sender) t.handleSyncEvent(evt);
				}
			}
		}
	}
}