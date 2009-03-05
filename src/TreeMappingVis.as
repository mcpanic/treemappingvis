package {
	import cs448b.fp.data.DataLoader;
	import cs448b.fp.tree.CascadedTree;
	
	import flare.vis.data.NodeSprite;
	
	import flash.display.Sprite;
	import flash.events.Event;

	
	// Convenient way to pass in compiler arguments
	// Place after import statements and before first class declaration 
	[SWF(width='1024', height='768', backgroundColor='#ffffff', frameRate='30')]
	
	public class TreeMappingVis extends Sprite
	{
		private var dataLoader:DataLoader;
		private var cascadedTree:CascadedTree;
		
		/**
		 * Constructor
		 */		
		public function TreeMappingVis()
		{
			initComponents();
			buildSprite();
			loadData();			
			displayTree();
			

		}
		
		private function initComponents():void
		{
		
		}
				
		private function buildSprite():void
		{
		}
		
		/**
		 * Load the tree and mapping data from external files
		 */
		private function loadData():void
		{
			dataLoader = new DataLoader();
			dataLoader.addLoadEventListener(handleLoaded);			
			dataLoader.loadData();
		}

		/**
		 * Display the tree
		 */
		private function displayTree():void
		{
			//cascadedTree = new CascadedTree();
			//cascadedTree.init(dataLoader.tree1);
		}

		private function printTree(n:NodeSprite, d:int) : void
		{
			/*
			var s:String = "";
			for (var k:uint = 0; k < d; k++) {
				s += "  ";
			}
			trace(s+n.name+" ("+n.x+", "+n.y+", "+n.w+", "+n.h+")");
			*/
			trace(n.name+"\t"+n.depth+"\t"+n.childDegree+"\t"+n.w+"\t"+n.h);
			for (var i:uint = 0; i < n.childDegree; ++i) {
				printTree(n.getChildNode(i), d+1);
			}
		}
		
		private function handleLoaded(event:Event):void
		{
			trace("hello");
			printTree(dataLoader.tree1.root, 3);
			displayTree();			
		}
	}
}



