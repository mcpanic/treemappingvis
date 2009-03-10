package {
	import cs448b.fp.data.DataLoader;
	import cs448b.fp.tree.CascadedTree;
	import cs448b.fp.tree.TreeEventSynchronizer;
	
	import flare.vis.data.NodeSprite;
	
	import flash.display.Sprite;
	import flash.events.Event;

	
	// Convenient way to pass in compiler arguments
	// Place after import statements and before first class declaration 
	[SWF(width='1024', height='768', backgroundColor='#ffffff', frameRate='30')]
	
	public class TreeMappingVis extends Sprite
	{
		private var dataLoader:DataLoader;
		private var cascadedTree1:CascadedTree;
		private var cascadedTree2:CascadedTree;
		private var fileList:Array;
		
		private var tes:TreeEventSynchronizer;
		
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
			tes = new TreeEventSynchronizer();
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
			dataLoader = new DataLoader(2, fileList, "../data/Mappings.xml");
			dataLoader.addLoadEventListener(handleLoaded);			
			dataLoader.loadData();
			
			tes.setDataLoader(dataLoader);
		}

		/**
		 * Display the tree
		 */
		private function displayTree():void
		{
			cascadedTree1 = new CascadedTree(0, dataLoader.getTree(0), 0, 0);
//			cascadedTree1.init();
			addChild(cascadedTree1);
			cascadedTree2 = new CascadedTree(1, dataLoader.getTree(1), 550, 200);
//			cascadedTree2.init();
			addChild(cascadedTree2);
			
			
			tes.addTree(cascadedTree1);
			tes.addTree(cascadedTree2);
		}

		/**
		 * Print the tree in the console
		 */
		private function printTree(n:NodeSprite, d:int) : void
		{
//			trace(n.dataLabel+"\t"+n.name+"\t"+n.depth+"\t"+n.childDegree+"\t"+n.w+"\t"+n.h);
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



