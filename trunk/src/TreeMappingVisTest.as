package {
	import cs448b.fp.data.DataLoader;
	import cs448b.fp.tree.SimpleTree;
	import cs448b.fp.tree.TreeEventSynchronizer;
	import cs448b.fp.utils.ControlsEvent;
	import cs448b.fp.utils.SimpleTreeControls;
	
	import flare.util.Orientation;
	import flare.vis.data.NodeSprite;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;

	
	// Convenient way to pass in compiler arguments
	// Place after import statements and before first class declaration 
	[SWF(width='1250', height='770', backgroundColor='#101010', frameRate='30')]
	
	public class TreeMappingVisTest extends Sprite
	{
		private var dataLoader:DataLoader;
		
		private var simpleTree:SimpleTree;
		private var simpleTree2:SimpleTree;
		
		private var tes:TreeEventSynchronizer;
		private var controls:SimpleTreeControls;
		
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
			
			controls = new SimpleTreeControls();
			controls.addEventListener( ControlsEvent.CONTROLS_UPDATE, onControlsEvent );				
		}

		/**
		 * Builds the sprite.
		 */				
		private function buildSprite():void
		{
			simpleTree.x = 0;
			simpleTree.y = 300;
			addChild(simpleTree);
			
			simpleTree2.x = 1150;
			simpleTree2.y = 300;
			addChild(simpleTree2);
			
			addChild(controls);
			
			var maxDepth:uint = 0;
			maxDepth = (simpleTree.getDepth() > simpleTree2.getDepth())? simpleTree.getDepth(): simpleTree2.getDepth();
			controls.setSliderDepth(maxDepth);
			controls.setSliderValue(maxDepth);

		}
		
		/**
		 * Load the tree and mapping data from external files
		 */
		private function loadData():void
		{
			var mappingID:Number = 1;	// 1: moo, 2: hybrid, 3: cat
			var fileList:Array = new Array(2);
			var imageList:Array = new Array(2);
			var mappingFile:String;
			fileList = new Array(2);
			imageList = new Array(2);
	
			if (mappingID == 1)
			{
				fileList[0] = "../data/tree_content.xml";
				fileList[1] = "../data/tree_moo.xml";			
				imageList[0] = "../data/content/";
				imageList[1] = "../data/moo/";
				mappingFile = "../data/map_moo.xml";			
			}
			else if (mappingID == 2)
			{
				fileList[0] = "../data/tree_content.xml";
				fileList[1] = "../data/tree_hybrid.xml";			
				imageList[0] = "../data/content/";
				imageList[1] = "../data/hybrid/";
				mappingFile = "../data/map_hybrid.xml";			
			}	
			else if (mappingID == 3)
			{
				fileList[0] = "../data/tree_dog.xml";
				fileList[1] = "../data/tree_cat.xml";			
				imageList[0] = "../data/dog/";
				imageList[1] = "../data/cat/";
				mappingFile = "../data/map_cat.xml";			
			}					
			dataLoader = new DataLoader(2, fileList, mappingFile, imageList);
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
		
		/**
		 * Handles key down event
		 */
		private function handleKeyDown(ke:KeyboardEvent):void
		{
			if(ke.keyCode > 48 && ke.keyCode < 54) // numbers
			{
				// set depth
				simpleTree.setVisibleDepth(ke.keyCode - 49);
				simpleTree2.setVisibleDepth(ke.keyCode - 49);
			}
			else if(ke.keyCode == 90) // z
			{ // reset			
				simpleTree.adjustScale(600, 770);
				simpleTree2.adjustScale(600, 770);
			
				simpleTree.resetPosition(1).play();
				simpleTree2.resetPosition(1).play();
			}
			else if(ke.keyCode == 65) // a 
			{ // reset
				simpleTree.resetScale();
				simpleTree2.resetScale();
			}
		}
		
		private function onControlsEvent( event:ControlsEvent ):void
		{
			//trace( event.name );
			if (event.name == "fit")	// fit to screen event
			{
				simpleTree.adjustScale(600, 770);
				simpleTree2.adjustScale(600, 770);
			
				simpleTree.resetPosition(1).play();
				simpleTree2.resetPosition(1).play();
			}
//			else if (event.name == "visual")	// visual toggle
//			{
//				simpleTree.setVisualToggle();
//				simpleTree2.setVisualToggle();				
//			}
			else if (event.name == "slider")
			{
				simpleTree.setVisibleDepth(event.value);
				simpleTree2.setVisibleDepth(event.value);				
			}
		}		
	}
}