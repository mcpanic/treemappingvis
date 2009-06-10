package {
	import cs448b.fp.data.DataList;
	import cs448b.fp.data.DataLoader;
	import cs448b.fp.data.MechanicalTurkManager;
	import cs448b.fp.data.SessionManager;
	import cs448b.fp.tree.CascadedTree;
	import cs448b.fp.tree.TreeEventSynchronizer;
	import cs448b.fp.utils.*;
	
	import flare.vis.data.NodeSprite;
	
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
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
		private var cascadedTree3:CascadedTree;
		private var cascadedTree4:CascadedTree;		
		private var fileList:Array;
		private var imageList:Array;
		private var controls:CascadedTreeControls;
		private var tes:TreeEventSynchronizer;		
		private var mappingManager:MappingManager;
		private var mturkManager:MechanicalTurkManager;
		private var sessionManager:SessionManager;
		private var dataList:DataList;
		private var currentPair:Point;
//		private var isRandom:Boolean;	// load random pages or current pages
					
		/**
		 * Constructor
		 */		
		public function TreeMappingVis()
		{
			Security.loadPolicyFile("http://www.stanford.edu/~juhokim/treemapping/crossdomain.xml");		
			
			if (Theme.ENABLE_DEBUG == true)
				stage.addEventListener(KeyboardEvent.KEY_DOWN, handleKeyDown);
			
			currentPair = new Point(-1, -1);	// invalid
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
			dataList = new DataList();
			sessionManager = new SessionManager();
						
			// See if the task is at the preview or actual phase
			mturkManager = new MechanicalTurkManager();
			SessionManager.assignmentId = mturkManager.getAssignmentId();
			SessionManager.curSession = 1; 
			
			loadPair();
		}

		/**
		 * Load the tree and mapping data from external files
		 */		
		private function loadPair():void
		{
			var fileList:Array = new Array(2);
			var imageList:Array = new Array(2);			
			if (SessionManager.isTutorial() == true)
			{
				trace("Assignment ID: " + SessionManager.assignmentId);
				//dataList.getDataList(fileList, imageList, true);
				dataList.getDataList(fileList, imageList);
			}
			// load a new pair
//			else if (isRandom == true)
			else if (SessionManager.isPreview == true)
			{
				trace("Assignment ID: " + SessionManager.assignmentId);
				
				if (Theme.ENABLE_DEBUG == true)
					currentPair = dataList.getDataList(fileList, imageList, new Point(12, 12));
					//currentPair = dataList.getDataList(fileList, imageList, false, new Point(12, 12));
				else
					currentPair = dataList.getDataList(fileList, imageList);
//					currentPair = dataList.getDataList(fileList, imageList, false);				
			}
			// load the current pair
			else
			{
//				currentPair = dataList.getDataList(fileList, imageList, false, currentPair);
				currentPair = dataList.getDataList(fileList, imageList, currentPair);
			}
			
			sessionManager.addPairName(dataList.cName, dataList.lName);
														
			dataLoader = new DataLoader(2, fileList, null, imageList);
//			if (Theme.ENABLE_FULL_PREVIEW == true)
//				dataLoader.addLoadEventListener(handlePreviewLoaded);
//			else
				dataLoader.addLoadEventListener(handleLoaded);			
			dataLoader.loadData();
			
			tes.setDataLoader(dataLoader);

		}
//
//		/**
//		 * Display the preview tree
//		 */
//		private function displayPreviewTree():void
//		{
//				cascadedTree3 = new CascadedTree(Theme.ID_PREVIEW_CONTENT, dataLoader.getTree(0), Theme.LAYOUT_CTREE_X, Theme.LAYOUT_CTREE_Y, Theme.LAYOUT_FULL_PREVIEW_WIDTH, Theme.LAYOUT_FULL_PREVIEW_HEIGHT, true, sessionManager.isTutorial());
//				cascadedTree4 = new CascadedTree(Theme.ID_PREVIEW_LAYOUT, dataLoader.getTree(1), Theme.LAYOUT_CTREE_X, Theme.LAYOUT_CTREE_Y, Theme.LAYOUT_FULL_PREVIEW_WIDTH, Theme.LAYOUT_FULL_PREVIEW_HEIGHT, false, sessionManager.isTutorial());
//				addChild(cascadedTree3);
//				addChild(cascadedTree4);
//				cascadedTree3.addEventListener(ControlsEvent.STATUS_UPDATE, onControlsStatusEvent);		
//				cascadedTree4.addEventListener(ControlsEvent.STATUS_UPDATE, onControlsStatusEvent);					
//
//				cascadedTree3.visible = false;
//				cascadedTree4.visible = false;
//		}
//		
		/**
		 * Display the tree
		 */
		private function displayTree():void
		{
			// adjust the layout for the tutorial window
			controls.update();
			
//			if (Theme.ENABLE_FULL_PREVIEW == true)
//				displayPreviewTree();
//			trace(SessionManager.isPreview);
			if (SessionManager.isTutorial() == true)
			{				
				cascadedTree1 = new CascadedTree(Theme.ID_CONTENT, dataLoader.getTree(0), Theme.LAYOUT_CTREE_X, Theme.LAYOUT_CTREE_Y+Theme.LAYOUT_TUTORIAL_OFFSET, Theme.LAYOUT_CANVAS_WIDTH, Theme.LAYOUT_CANVAS_HEIGHT, true);
				cascadedTree2 = new CascadedTree(Theme.ID_LAYOUT, dataLoader.getTree(1), Theme.LAYOUT_LTREE_X, Theme.LAYOUT_LTREE_Y+Theme.LAYOUT_TUTORIAL_OFFSET, Theme.LAYOUT_CANVAS_WIDTH, Theme.LAYOUT_CANVAS_HEIGHT, false);
			}
			// for preview session
			else if (Theme.ENABLE_FULL_PREVIEW == true && SessionManager.isPreview == true)
			{						
				cascadedTree1 = new CascadedTree(Theme.ID_CONTENT, dataLoader.getTree(0), Theme.LAYOUT_CTREE_X, Theme.LAYOUT_CTREE_Y, Theme.LAYOUT_FULL_PREVIEW_WIDTH, Theme.LAYOUT_FULL_PREVIEW_HEIGHT, true);
				cascadedTree2 = new CascadedTree(Theme.ID_LAYOUT, dataLoader.getTree(1), Theme.LAYOUT_CTREE_X, Theme.LAYOUT_CTREE_Y, Theme.LAYOUT_FULL_PREVIEW_WIDTH, Theme.LAYOUT_FULL_PREVIEW_HEIGHT, false);								
			}		
			// normal cases
			else	
			{
				cascadedTree1 = new CascadedTree(Theme.ID_CONTENT, dataLoader.getTree(0), Theme.LAYOUT_CTREE_X, Theme.LAYOUT_CTREE_Y, Theme.LAYOUT_CANVAS_WIDTH, Theme.LAYOUT_CANVAS_HEIGHT, true);
				cascadedTree2 = new CascadedTree(Theme.ID_LAYOUT, dataLoader.getTree(1), Theme.LAYOUT_LTREE_X, Theme.LAYOUT_LTREE_Y, Theme.LAYOUT_CANVAS_WIDTH, Theme.LAYOUT_CANVAS_HEIGHT, false);												
			}
			cascadedTree1.addEventListener(ControlsEvent.STATUS_UPDATE, onControlsStatusEvent);		
			cascadedTree2.addEventListener(ControlsEvent.STATUS_UPDATE, onControlsStatusEvent);		
			
			addChild(cascadedTree1);
			addChild(cascadedTree2);
			
//			if (Theme.ENABLE_FULL_PREVIEW == true)
//			{
//				cascadedTree1.visible = false;
//				cascadedTree2.visible = false;
//			}
//			var maxDepth:uint = 0;
//			maxDepth = (cascadedTree1.getMaxTreeDepth() > cascadedTree2.getMaxTreeDepth())? cascadedTree1.getMaxTreeDepth(): cascadedTree2.getMaxTreeDepth();
//
//			controls.setSliderDepth(maxDepth);
//			controls.setSliderValue(maxDepth);
		
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
		private function handleLoaded():void
		{		
			displayTree();	
			
			mappingManager = new MappingManager();	
			mappingManager.setContentTree(cascadedTree1);
			mappingManager.setLayoutTree(cascadedTree2);	
			tes.setMappingManager(mappingManager);
			
			mappingManager.addEventListener(ControlsEvent.STATUS_UPDATE, onControlsStatusEvent);	
			mappingManager.init();	// add root-root mapping
			mappingManager.setSessionManager(sessionManager);
			trace("Name\tOrder\tDepth\tNumChild\tWidth\tHeight");
			printTree(cascadedTree1.tree.root, 0);
			//mappingManager.showNextStep();	// for the first time	

			addChild(mappingManager);
		}

//
//		/**
//		 * Upon data load complete, display the tree
//		 */		
//		private function handlePreviewLoaded():void
//		{		
//			displayPreviewTree();
//			
//			mappingManager = new MappingManager();	
//			mappingManager.setContentTree(cascadedTree3);
//			mappingManager.setLayoutTree(cascadedTree4);	
//			//tes.setMappingManager(mappingManager);
//			
//			mappingManager.addEventListener(ControlsEvent.STATUS_UPDATE, onControlsStatusEvent);	
//			mappingManager.init(sessionManager.isTutorial());	// add root-root mapping
//			//mappingManager.setSessionManager(sessionManager);
//			trace("Name\tOrder\tDepth\tNumChild\tWidth\tHeight");
//			printTree(cascadedTree3.tree.root, 0);
//			//mappingManager.showNextStep();	// for the first time	
//
//			addChild(mappingManager);
//		}
		
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
			else if (event.name == "next")
			{	
				mappingManager.addCurrentSelection();			
			}
			else if (event.name == "help")
			{	
				mappingManager.showHelp();			
			}	
			else if (event.name == "unmap")
			{	
				cascadedTree1.onUnmapButton();			
			}				
			else if (event.name == "restart")
			{
				//trace("restart");
				cleanup();
//				isRandom = false;
				loadPair();
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
			else if (event.name == "tutorial_advance")
			{	
				// for step 5, only way to advance is through completion of the task
				if (SessionManager.isTutorial() == true && mappingManager.currentTutorialStep != 5)
					mappingManager.showTutorialNextStep();			
			}
			// Show the tree for mapping
			else if (event.name == "show_tree")
			{	
				cleanup();
				loadPair();
				
//				controls.visibleButtons();	
//				cascadedTree3.visible = false;
//				cascadedTree4.visible = false;
//				removeChild(mappingManager);
//				handleLoaded();	
//				if (Theme.ENABLE_FULL_PREVIEW == true)
//				{		
//					if (this.contains(cascadedTree3))
//						removeChild(cascadedTree3);
//					if (this.contains(cascadedTree4))
//						removeChild(cascadedTree4);	
//				}	
////				addChild(cascadedTree1);
////				addChild(cascadedTree2);	
//				
//				trace("main " + this.numChildren);
//				trace("tree1 " + this.getChildIndex(cascadedTree1));
//				trace("tree2 " + this.getChildIndex(cascadedTree2));
//				trace("control " + this.getChildIndex(controls));
//				trace("mm " + this.getChildIndex(mappingManager));
//				cascadedTree1.visible = true;
//				cascadedTree2.visible = true;
//				cascadedTree1.displayTree();
//				cascadedTree2.displayTree();
				
			}		
			// Show the tree for mapping
			else if (event.name == "show_preview")
			{	
//				return;
//				if (this.contains(cascadedTree3))
//					removeChild(cascadedTree3);
//				if (this.contains(cascadedTree4))
//					removeChild(cascadedTree4);	
				
				
				if (event.value == Theme.ID_PREVIEW_CONTENT)	// content					
				{
					cascadedTree2.visible = false;
					cascadedTree1.visible = true;				
					//cascadedTree1.displayTree();
					cascadedTree1.enableZoomButtons();					
//					cascadedTree4.visible = false;
//					cascadedTree3.visible = true;
//					cascadedTree3.displayTree();
//					cascadedTree3.enableZoomButtons();
				}	
				else if (event.value == Theme.ID_PREVIEW_LAYOUT)
				{	
					cascadedTree1.visible = false;
					cascadedTree2.visible = true;				
					//cascadedTree2.displayTree();
					cascadedTree2.enableZoomButtons();
						
//					cascadedTree3.visible = false;
//					cascadedTree4.visible = true;				
//					cascadedTree4.displayTree();
//					cascadedTree4.enableZoomButtons();
				}	
			}											
			else if (event.name == "enable_button")
			{	
				controls.enableButtons();
				cascadedTree1.enableZoomButtons();
				cascadedTree2.enableZoomButtons();	
			}
			else if (event.name == "disable_button")
			{	
				controls.disableButtons();
				cascadedTree1.disableZoomButtons();					
				cascadedTree2.disableZoomButtons();
			}	
			else if (event.name == "visible_button")
			{	
				controls.visibleButtons();				
				cascadedTree1.visibleZoomButtons();					
				cascadedTree2.visibleZoomButtons();
			}
			else if (event.name == "invisible_button")
			{	
				controls.invisibleButtons();
//				cascadedTree1.invisibleZoomButtons();					
//				cascadedTree2.invisibleZoomButtons();
			}				
			else if (event.name == "show_unmap")
			{	
				controls.enableButton(Theme.ID_BUTTON_UNMAP);	
			}		
			else if (event.name == "hide_unmap")
			{	
				controls.disableButton(Theme.ID_BUTTON_UNMAP);	
			}	
			else if (event.name == "show_map")
			{					
				controls.enableButton(Theme.ID_BUTTON_CONTINUE);	
			}		
			else if (event.name == "hide_map")
			{	
				controls.disableButton(Theme.ID_BUTTON_CONTINUE);	
			}										
			else if (event.name == "finish")
			{
				if (SessionManager.curSession == Theme.NUM_SESSIONS)
					trace("all sessions finished!");
				else
				{
					trace("Session " + SessionManager.curSession + " complete.");
					SessionManager.curSession++;
					cleanup();
					SessionManager.isPreview = true;
					loadPair();
				}
			}	
			else if (event.name == "restart")
			{
				// remember the restart click - to be used in tutorialManager, to go back to step 2 instead of step 1
				if (SessionManager.isTutorial() == true)
					SessionManager.isTutorialRestart = true;
				cleanup();
//				isRandom = false;
				loadPair();
			}							
		}
		
		/**
		 * Cleanup every pair-specific vis components,
		 * so that the next pair can be created continuously.
		 */			
		private function cleanup():void
		{
			cascadedTree1.removeEventListener(ControlsEvent.STATUS_UPDATE, onControlsStatusEvent);		
			cascadedTree2.removeEventListener(ControlsEvent.STATUS_UPDATE, onControlsStatusEvent);			
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



