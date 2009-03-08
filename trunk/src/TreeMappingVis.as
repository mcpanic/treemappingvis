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
		private var fileList:Array;
		
		/**
		 * Constructor
		 */		
		public function TreeMappingVis()
		{
			initComponents();
			buildSprite();
			loadData();			
			//displayTree();
			

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
			fileList = new Array(2);
			fileList[0] = "../data/tree_dog.xml";
			fileList[1] = "../data/tree_cat.xml";
			dataLoader = new DataLoader(2, fileList);
			dataLoader.addLoadEventListener(handleLoaded);			
			dataLoader.loadData();
		}

		/**
		 * Display the tree
		 */
		private function displayTree():void
		{
			cascadedTree = new CascadedTree(dataLoader.getTree(1));
			cascadedTree.init();
			addChild(cascadedTree);
		}

		/**
		 * Print the tree in the console
		 */
		private function printTree(n:NodeSprite, d:int) : void
		{
			trace(n.name+"\t"+n.depth+"\t"+n.childDegree+"\t"+n.w+"\t"+n.h);
			for (var i:uint = 0; i < n.childDegree; ++i) {
				printTree(n.getChildNode(i), d+1);
			}
		}

		/**
		 * Upon data load complete, display the tree
		 */		
		private function handleLoaded(event:Event):void
		{
			printTree(dataLoader.getTree(0).root, 3);
			displayTree();			
		}
	}
}


