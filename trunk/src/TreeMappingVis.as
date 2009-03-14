package {
	import cs448b.fp.data.DataLoader;
	import cs448b.fp.tree.CascadedTree;
	import cs448b.fp.tree.TreeEventSynchronizer;
	import cs448b.fp.utils.CascadedTreeControls;
	import cs448b.fp.utils.ControlsEvent;
	
	import fl.events.SliderEvent;
	import flare.vis.data.NodeSprite;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	
	// Convenient way to pass in compiler arguments
	// Place after import statements and before first class declaration 
	[SWF(width='1250', height='770', backgroundColor='#101010', frameRate='30')]
	
	public class TreeMappingVis extends Sprite
	{
		private var dataLoader:DataLoader;
		private var cascadedTree1:CascadedTree;
		private var cascadedTree2:CascadedTree;
		private var fileList:Array;
		private var imageList:Array;
		private var controls:CascadedTreeControls;
		private var tes:TreeEventSynchronizer;
		
		/**
		 * Constructor
		 */		
		public function TreeMappingVis()
		{
			stage.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
			
			initComponents();
			buildSprite();
			loadData();			
			//displayTree();
			

		}
		
		private function initComponents():void
		{
			tes = new TreeEventSynchronizer();
			controls = new CascadedTreeControls();
//			controls.addLoadEventListener(handleDepthChange);		
			controls.addEventListener( ControlsEvent.CONTROLS_UPDATE, onControlsEvent );			
		}
				
		private function buildSprite():void
		{
			addChild(controls);
		}
		
		/**
		 * Load the tree and mapping data from external files
		 */
		private function loadData():void
		{
			fileList = new Array(2);
//			fileList[0] = "../data/tree_content.xml";
//			fileList[1] = "../data/tree_moo.xml";			
			fileList[0] = "../data/tree_dog.xml";
			fileList[1] = "../data/tree_cat.xml";
			imageList = new Array(2);
//			imageList[0] = "../data/content/";
//			imageList[1] = "../data/moo/";			
			imageList[0] = "../data/dog/";
			imageList[1] = "../data/cat/";			
			dataLoader = new DataLoader(2, fileList, "../data/Mappings.xml", imageList);
			dataLoader.addLoadEventListener(handleLoaded);			
			dataLoader.loadData();
			
			tes.setDataLoader(dataLoader);
		}

		/**
		 * Display the tree
		 */
		private function displayTree():void
		{
			cascadedTree1 = new CascadedTree(0, dataLoader.getTree(0), 25, 25);
			cascadedTree2 = new CascadedTree(1, dataLoader.getTree(1), 600, 25);

			addChild(cascadedTree1);
			addChild(cascadedTree2);
			
			var maxDepth:uint = 0;
			maxDepth = (cascadedTree1.getDepth() > cascadedTree2.getDepth())? cascadedTree1.getDepth(): cascadedTree2.getDepth();
//			trace(cascadedTree1.getDepth() + " " + cascadedTree2.getDepth() + " " + maxDepth);
			controls.setSliderDepth(maxDepth);
			controls.setSliderValue(maxDepth);
			
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
			displayTree();			
		}
		
		private function handleKeyDown(ke:KeyboardEvent):void
		{
			if(ke.keyCode == Keyboard.LEFT)
			{
				cascadedTree1.resetPosition(1).play();
			}
			else if(ke.keyCode == Keyboard.RIGHT)
			{
				cascadedTree2.resetPosition(1).play();
			}			
			else if(ke.keyCode == 49) // 1
			{
				cascadedTree1.setVisibleDepth(0);
				cascadedTree2.setVisibleDepth(0);
			}
			else if(ke.keyCode == 50) // 2
			{
				cascadedTree1.setVisibleDepth(1);
				cascadedTree2.setVisibleDepth(1);	
			}
			else if(ke.keyCode == 51) // 3
			{
				cascadedTree1.setVisibleDepth(2);
				cascadedTree2.setVisibleDepth(2);
			}
			else if(ke.keyCode == 52) // 4
			{
				cascadedTree1.setVisibleDepth(3);
				cascadedTree2.setVisibleDepth(3);	
			}
			else if(ke.keyCode == 53) // 5
			{
				cascadedTree1.setVisibleDepth(4);
				cascadedTree2.setVisibleDepth(4);
			}			
		}


		private function onControlsEvent( event:ControlsEvent ):void
		{
			//trace( event.name );
			if (event.name == "fit")	// fit to screen event
			{
				cascadedTree1.resetPosition(1).play();
				cascadedTree2.resetPosition(1).play();
			}
			else if (event.name == "visual")	// visual toggle
			{
				cascadedTree1.setVisualToggle();
				cascadedTree2.setVisualToggle();				
			}
			else if (event.name == "slider")
			{
				cascadedTree1.setVisibleDepth(event.value);
				cascadedTree2.setVisibleDepth(event.value);				
			}
		}
//		
//		private function handleDepthChange(e:Event):void
//		{
//			var se:SliderEvent = e as SliderEvent;
//			
//			if (se != null)
//			{
//				cascadedTree1.setVisibleDepth(se.value);
//				cascadedTree2.setVisibleDepth(se.value);
//			}
//		
//		}		
	}
}



