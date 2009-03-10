package cs448b.fp.tree
{
	import cs448b.fp.data.DataLoader;
	
	import flare.vis.data.NodeSprite;
	
	import flash.events.Event;
	
	/**
	 * <code>TreeEventSynchronizer</code> synchronizes the events 
	 */
	public class TreeEventSynchronizer implements TreeEventListener
	{
		private var trees:Array = new Array(2);
		
		private var dataLoader:DataLoader = null;
		
		public function TreeEventSynchronizer()
		{
		}
		
		public function setDataLoader(dl:DataLoader):void
		{
			dataLoader = dl;
		}

		/**
		 * Adds the tree.
		 */
		public function addTree(tree:AbstractTree):void
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
			var sender:AbstractTree = evt.currentTarget as AbstractTree;
			if(sender == null)
			{
				for(var oo:Object in trees)
				{
					var tt:AbstractTree = trees[oo] as AbstractTree;
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
				var t:AbstractTree = trees[o] as AbstractTree;
				if(t != null) {
					if(t != sender && dataLoader != null) {
						// Get mapped value
						var mappedIdx:Number = dataLoader.getMappedIndex(Number(node.name), t.getId());
						
						var mv:String = String(mappedIdx);

						t.handleSyncEvent(mv, evt);
					}
				}
			}
		}
	}
}