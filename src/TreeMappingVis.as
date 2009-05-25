package {
	import cs448b.fp.data.DataList;
	import cs448b.fp.data.DataLoader;
	import cs448b.fp.data.MechanicalTurkManager;
	import cs448b.fp.tree.CascadedTree;
	import cs448b.fp.tree.TreeEventSynchronizer;
	import cs448b.fp.utils.*;
	
	import flare.vis.data.NodeSprite;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.system.Security;
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
		private var mappingManager:MappingManager;
		private var mturkManager:MechanicalTurkManager;
		private var assignmentId:String;
		private var dataList:DataList;
		
		private var sessionNo:Number;
					
		/**
		 * Constructor
		 */		
		public function TreeMappingVis()
		{
			Security.loadPolicyFile("http://www.stanford.edu/~juhokim/treemapping/crossdomain.xml");		
			
			if (Theme.ENABLE_DEBUG == true)
				stage.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);

			dataList = new DataList();
			initComponents();
			buildSprite();
			loadData();			
			//displayTree();			
		}
      		
		private function initComponents():void
		{
			tes = new TreeEventSynchronizer();
			controls = new CascadedTreeControls();		
			controls.addEventListener( ControlsEvent.CONTROLS_UPDATE, onControlsEvent );		
		}
				
		private function buildSprite():void
		{
			addChild(controls);
		}
		
		/**
		 * Initialize data loading
		 */
		private function loadData():void
		{
			// See if the task is at the preview or actual phase
			mturkManager = new MechanicalTurkManager();
			assignmentId = mturkManager.getAssignmentId();
	
			sessionNo = 1;
			loadPair();
		}

		/**
		 * Load the tree and mapping data from external files
		 */		
		private function loadPair():void
		{
			var fileList:Array = new Array(2);
			var imageList:Array = new Array(2);			
			if (assignmentId == "ASSIGNMENT_ID_NOT_AVAILABLE")
			{
				trace("Assignment ID not available - preview mode");
				dataList.getDataList(fileList, imageList, false);
			}
			else if (assignmentId == null)
			{
				trace("error in assignment ID");
				dataList.getDataList(fileList, imageList, false);
			}
			else
			{
				trace("Assignment ID: " + assignmentId);
				dataList.getDataList(fileList, imageList, false);
			}
														
			dataLoader = new DataLoader(2, fileList, null, imageList);
			dataLoader.addLoadEventListener(handleLoaded);			
			dataLoader.loadData();
			
			tes.setDataLoader(dataLoader);

		}

		/**
		 * Display the tree
		 */
		private function displayTree():void
		{
			cascadedTree1 = new CascadedTree(0, dataLoader.getTree(0), Theme.LAYOUT_CTREE_X, Theme.LAYOUT_CTREE_Y, true);
			cascadedTree2 = new CascadedTree(1, dataLoader.getTree(1), Theme.LAYOUT_LTREE_X, Theme.LAYOUT_LTREE_Y, false);

			cascadedTree1.addEventListener(ControlsEvent.STATUS_UPDATE, onControlsStatusEvent);		
			cascadedTree2.addEventListener(ControlsEvent.STATUS_UPDATE, onControlsStatusEvent);		
			
			addChild(cascadedTree1);
			addChild(cascadedTree2);
			
			var maxDepth:uint = 0;
			maxDepth = (cascadedTree1.getMaxTreeDepth() > cascadedTree2.getMaxTreeDepth())? cascadedTree1.getMaxTreeDepth(): cascadedTree2.getMaxTreeDepth();

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
			trace(n.name+"\t"+n.props["order"] +"\t"+n.depth+"\t"+n.childDegree+"\t"+n.w+"\t"+n.h);
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
			
			mappingManager = new MappingManager();	
			mappingManager.setContentTree(cascadedTree1);
			mappingManager.setLayoutTree(cascadedTree2);	
			tes.setMappingManager(mappingManager);
			
			mappingManager.addEventListener(ControlsEvent.STATUS_UPDATE, onControlsStatusEvent);	
			mappingManager.init();	// add root-root mapping
			mappingManager.setAssignmentId(assignmentId);
			trace("Name\tOrder\tDepth\tNumChild\tWidth\tHeight");
			printTree(cascadedTree1.tree.root, 0);
			//mappingManager.showNextStep();	// for the first time	
			
			addChild(mappingManager);
		}

		/**
		 * Event handler for controls
		 */	
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
			else if (event.name == "continue")
			{	
				mappingManager.showNextStep();			
			}
			else if (event.name == "help")
			{	
				mappingManager.showHelp();			
			}			
		}
		
		/**
		 * Event handler for status update
		 */			
		private function onControlsStatusEvent( event:ControlsEvent ):void
		{
			//trace( event.name );
			if (event.name == "stage")	// fit to screen event
			{
				controls.displayStage(event.value);
			}
			else if (event.name == "feedback")
			{
				controls.displayFeedback(event.message);
			}
			else if (event.name == "mappings")
			{
				controls.displayMappings(event.message);
			}
			else if (event.name == "unmap")
			{
				controls.displayFeedback(event.message);
			}	
			else if (event.name == "complete")
			{
				controls.displayFeedback(event.message);
			}
			else if (event.name == "continue")
			{	
				mappingManager.showNextStep();			
			}	
			else if (event.name == "showhelp")
			{	
				trace("showhelp");
				controls.showHelpButton();			
			}
			else if (event.name == "hidehelp")
			{	
				trace("hidehelp");
				controls.hideHelpButton();			
			}
			else if (event.name == "finish")
			{
				trace("finish");
				if (sessionNo == 3)
					trace("all sessions finished!");
				else
				{
					trace("Session " + sessionNo + " complete.");
					sessionNo++;
					cleanup();
					loadPair();
				}
			}			
		}
		
		/**
		 * Cleanup every pair-specific vis components,
		 * so that the next pair can be created continuously.
		 */			
		private function cleanup():void
		{
			cascadedTree1.addEventListener(ControlsEvent.STATUS_UPDATE, onControlsStatusEvent);		
			cascadedTree2.addEventListener(ControlsEvent.STATUS_UPDATE, onControlsStatusEvent);			
			tes.removeTree(cascadedTree1);
			tes.removeTree(cascadedTree2);
			removeChild(cascadedTree1);
			removeChild(cascadedTree2);
			removeChild(mappingManager);	
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
			if(ke.keyCode > 48 && ke.keyCode < 56) // numbers
			{
				// set depth
				cascadedTree1.setVisibleDepth(ke.keyCode - 49);
				cascadedTree2.setVisibleDepth(ke.keyCode - 49);
			}		
		}		
	}
}



