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
		
		private var simpleTree:SimpleTree;
		private var simpleTree2:SimpleTree;
		
		private var tes:TreeEventSynchronizer;
		
		/**
		 * Constructor
		 */		
		public function TreeMappingVisTest()
		{
			stage.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
			
			loadData();			
		}
		
		/**
		 * Initializes the components
		 */
		private function initComponents():void
		{
			simpleTree = new SimpleTree(0, dataLoader.getTree(0), 0, 0);
			simpleTree2 = new SimpleTree(1, dataLoader.getTree(1), 0, 0);
			simpleTree2.setOrientation(Orientation.RIGHT_TO_LEFT);
			
			tes = new TreeEventSynchronizer();
			tes.setDataLoader(dataLoader);
			
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
		
			dataLoader = new DataLoader(2, fileList, "../data/Mappings.xml");
			dataLoader.addLoadEventListener(handleLoaded);			
			dataLoader.loadData();
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
			initComponents();
			buildSprite();
		}
		
		private function handleKeyDown(ke:KeyboardEvent):void
		{
			if(ke.keyCode == Keyboard.LEFT)
			{
				simpleTree.updateVis();
			}
			else if(ke.keyCode == Keyboard.RIGHT)
			{
				simpleTree2.updateVis();
			}
			else if(ke.keyCode == 48) // 0(zero)
			{
				simpleTree.setVisibleDepth(0);
				simpleTree2.setVisibleDepth(0);
			}
			else if(ke.keyCode == 49) // 1
			{
				simpleTree.setVisibleDepth(1);
				simpleTree2.setVisibleDepth(1);	
			}
			else if(ke.keyCode == 50) // 2
			{
				simpleTree.setVisibleDepth(2);
				simpleTree2.setVisibleDepth(2);
			}
		}
	}
}