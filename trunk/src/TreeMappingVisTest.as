package {
	import cs448b.fp.data.DataLoader;
	import cs448b.fp.tree.SimpleTree;
	import cs448b.fp.tree.TreeEventSynchronizer;
	
	import flare.util.Orientation;
	import flare.vis.data.NodeSprite;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;

	
	// Convenient way to pass in compiler arguments
	// Place after import statements and before first class declaration 
	[SWF(width='1024', height='768', backgroundColor='#ffffff', frameRate='30')]
	
	public class TreeMappingVisTest extends Sprite
	{
		private var dataLoader:DataLoader;
		private var dataLoader2:DataLoader;
		
		private var simpleTree:SimpleTree;
		private var simpleTree2:SimpleTree;
		
		private var tes:TreeEventSynchronizer;
		
		/**
		 * Constructor
		 */		
		public function TreeMappingVisTest()
		{
			stage.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
			
			initComponents();
			buildSprite();
			
			loadData();			
		}
		
		/**
		 * Initializes the components
		 */
		private function initComponents():void
		{
			simpleTree = new SimpleTree(1);
			simpleTree2 = new SimpleTree(2);
			tes = new TreeEventSynchronizer();
			
			tes.addTree(simpleTree);
			tes.addTree(simpleTree2);
		}

		/**
		 * Builds the sprite.
		 */				
		private function buildSprite():void
		{
			addChild(simpleTree);
			
//			simpleTree2.x = 500;
			addChild(simpleTree2);
		}
		
		/**
		 * Load the tree and mapping data from external files
		 */
		private function loadData():void
		{
			var fileList:Array = new Array(2);
			fileList[0] = "../data/tree_dog.xml";
			fileList[1] = "../data/tree_cat.xml";
		
			dataLoader = new DataLoader(2, fileList, "../data/mapping.xml");
			dataLoader.addLoadEventListener(handleLoaded);			
			dataLoader.loadData();
			
//			dataLoader2 = new DataLoader(2, fileList);
//			dataLoader2.addLoadEventListener(handleLoaded2);			
//			dataLoader2.loadData();
		}

		/**
		 * Display the tree
		 */
		private function displayTree(i:Number):void
		{
			if(i == 0) 
			{
				simpleTree.setTree(dataLoader.getTree(0), 0);
				simpleTree2.setTree(dataLoader.getTree(1), 1);
				simpleTree2.setOrientation(Orientation.RIGHT_TO_LEFT);
				
				// position trees
//				simpleTree.x = 0;
//				simpleTree.y = 0;
//				
//				simpleTree2.x = 0;
//				simpleTree2.y = 0;
			}
//			if(i == 1)
//			{
//				simpleTree2.setTree(dataLoader2.getTree(0));
//				simpleTree2.setOrientation(Orientation.RIGHT_TO_LEFT);
//			}
		}

		/**
		 * Print tree.
		 */
		private function printTree(n:NodeSprite, d:int) : void
		{
			trace(n.name+"\t"+n.depth+"\t"+n.childDegree+"\t"+n.w+"\t"+n.h);
			for (var i:uint = 0; i < n.childDegree; ++i) {
				printTree(n.getChildNode(i), d+1);
			}
		}
		
		/**
		 * Handle loaded.
		 */
		private function handleLoaded(event:Event):void
		{
			displayTree(0);
		}
		
		/**
		 * Handle loaded.
		 */
		private function handleLoaded2(event:Event):void
		{
			displayTree(1);
		}
		
		private function handleKeyDown(ke:KeyboardEvent):void
		{
			if(ke.keyCode == Keyboard.LEFT)
			{
//				simpleTree.vis.width = 500;
//				simpleTree.vis.height = 500;
//				simpleTree.vis.setAspectRatio(1, 100, 100);
				simpleTree.updateVis();
			}
			else if(ke.keyCode == Keyboard.RIGHT)
			{
//				simpleTree2.vis.width = 300;
//				simpleTree2.vis.height = 300;
//				simpleTree2.vis.setAspectRatio(1, 300, 300);
				simpleTree2.updateVis();
			}
		}
	}
}