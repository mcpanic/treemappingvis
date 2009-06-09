package cs448b.fp.utils
{
	import cs448b.fp.data.Mapping;
	import cs448b.fp.data.SessionManager;
	import cs448b.fp.display.DisplayEvent;
	import cs448b.fp.display.DisplayManager;
	import cs448b.fp.tree.CascadedTree;
	
	import flare.animate.TransitionEvent;
	import flare.vis.data.NodeSprite;
	
	import flash.display.Sprite;
	import flash.events.*;
	import flash.utils.*;
		
	public class MappingManager extends Sprite
	{
		private var _mapping:Mapping;
		private var _contentTree:CascadedTree = null;
		private var _layoutTree:CascadedTree = null;
		private var _selectedContentID:Number;
		private var _selectedLayoutID:Number;
		private var _currentStage:Number;
		private var _isRootMapped:Boolean = false;
		private var _cNode:NodeActions;
		private var _lNode:NodeActions;
		private var _isTutorial:Boolean;
//		private var _assignmentId:String;
		private var _displayManager:DisplayManager;
		
		private var _nextStepLock:Boolean;
				
		public function MappingManager()
		{
			_mapping = new Mapping();	
			_selectedContentID = 0;
			_selectedLayoutID = 0;
			_currentStage = Theme.STAGE_INITIAL;
			
			_displayManager = new DisplayManager();
			_nextStepLock = true;
		}

		public function init(isTutorial:Boolean):void
		{
			
			_isTutorial = isTutorial;
			// Tutorial session
			if (_isTutorial == true)			
				_displayManager.showTutorial();						
			else
				startSession();
				
			_displayManager.addEventListener(DisplayEvent.DISPLAY_UPDATE, onDisplayUpdateEvent);	
			_displayManager.addEventListener(ControlsEvent.STATUS_UPDATE, onStatusUpdateEvent);					
			_displayManager.init(_isTutorial);	

			addChild(_displayManager);
		}
		
		/**
		 * Get the current selected ID
		 */							
		public function get selectedContentID():Number
		{
			return _selectedContentID;
		}

		/**
		 * Set the current selected ID
		 */							
		public function set selectedContentID(id:Number):void
		{
			_selectedContentID = id;
		}
		
		/**
		 * Get the current selected ID
		 */							
		public function get selectedLayoutID():Number
		{
			return _selectedLayoutID;
		}

		/**
		 * Set the current selected ID
		 */							
		public function set selectedLayoutID(id:Number):void
		{
			_selectedLayoutID = id;
		}

		/**
		 * Get the current tutorial step
		 */	
		public function get currentTutorialStep():Number
		{			
			return _displayManager.currentTutorialStep;
		}
						
		/**
		 * Start the mapping session by playing a preview 
		 */							
		public function startSession():void
		{
			// Disable all buttons
			if (Theme.ENABLE_FULL_PREVIEW == false)
				dispatchEvent( new ControlsEvent( ControlsEvent.STATUS_UPDATE, "hidebutton", 0) ); 
			
			// Set the traversal order
			_contentTree.setTraversalOrder(_isTutorial);
			
			// Play the review of web page segments to be mapped, in the traversal order specified.
			if (Theme.ENABLE_FULL_PREVIEW == true)
				;//_contentTree.playFullPreview();
			else
				_contentTree.playPreview();	
			
		}

		public function setSessionManager(sessionManager:SessionManager):void
		{
//			_assignmentId = id;
			_displayManager.setSessionManager(sessionManager);
		}
		
		public function setContentTree(t:CascadedTree):void
		{
			_contentTree = t;
			_displayManager.setContentTree(_contentTree);
			_contentTree.addEventListener(MappingEvent.MOUSE_DOWN, onContentTreeEvent);
			_cNode = new NodeActions(_contentTree, true);
		}
		
		public function setLayoutTree(t:CascadedTree):void
		{
			_layoutTree = t;
			_displayManager.setLayoutTree(_layoutTree);
			_layoutTree.addEventListener(MappingEvent.MOUSE_DOWN, onLayoutTreeEvent);
			_lNode = new NodeActions(_layoutTree, false);
		}


		/**
		 * Event handler for content tree click event.
		 * Mapping events are only triggered in layout tree
		 */					
		private function onContentTreeEvent(e:MappingEvent):void
		{	
			// give feedback to users	
			if (Theme.ENABLE_SERIAL == false)
				showSelectionFeedback(e.value);			
		}

		/**
		 * Add the mapping that is currently selected
		 */			
		public function addCurrentSelection():void
		{
			if (_selectedContentID != 0)
			{
				processMapping(_selectedLayoutID);
			}
		}
			
		/**
		 * Event handler for the layout tree click event
		 */			
		private function onLayoutTreeEvent(e:MappingEvent):void
		{
//			trace("LayoutTree - Mouse Down! " + e.name + " " + e.value);	
			var message:String;
			if (_selectedContentID != 0 && e.name == "add")
			{
				processMapping(e.value);

				// give feedback to users	
				//var message:String = "Mapping added: " + _selectedContentID + "--" + e.value;
//				var message:String = "Mapping added";
//				dispatchEvent( new ControlsEvent( ControlsEvent.STATUS_UPDATE, "feedback", 0, message) );   
//				
//				// check if the whole tree is done
//				_contentTree.checkCompleted();
			}
			// remove is not needed anymore since we do not have any undo function for the interface
			else if (_selectedContentID != 0 && e.name == "remove")
			{
				removeMapping(e.value);
				// give feedback to users	
				//message = "Mapping removed: " + _selectedContentID + "--" + e.value;
				message = "Mapping removed";
				dispatchEvent( new ControlsEvent( ControlsEvent.STATUS_UPDATE, "feedback", 0, message) );   	
				
				message = _mapping.printMapping();
				dispatchEvent( new ControlsEvent( ControlsEvent.STATUS_UPDATE, "mappings", 0, message) );  				
				resetSelections();		
				
			}		
			// when two-click mapping is applied
			// update the layout ID when unselect requested	
			else if (_selectedContentID != 0 && e.name == "unselect_layout")
			{
				trace("unselect");
				_selectedLayoutID = 0;
			}
			// when two-click mapping is applied
			// update the layout ID when select requested
			else if (_selectedContentID != 0 && e.name == "select_layout")
			{
				trace("select: " + e.value);
				_selectedLayoutID = e.value;
			}	

		}

		/**
		 * Invoke event received from displayManager for status update event.
		 */					
		private function onStatusUpdateEvent(e:ControlsEvent):void
		{	
			dispatchEvent( new ControlsEvent( ControlsEvent.STATUS_UPDATE, e.name, e.value, e.message) );
		}	
		
		/**
		 * Event handler for display update event.
		 */					
		private function onDisplayUpdateEvent(e:DisplayEvent):void
		{	
			if (e.name == "add")
				addMapping();
			else if (e.name == "blink")
				blinkNode();	
			else if (e.name == "remove")
				removeMapping(_selectedLayoutID);	
			else if (e.name == "start")
				startSession();
			// tutorial related
			else if (e.name == "tutorial_preview")
				startSession();	
//			else if (e.name == "tutorial_highlight")
//				showNextStep();
			else if (e.name == "tutorial_click")
			{
				showNextStep();
				NodeActions.lock = false;
			}	
			else if (e.name == "tutorial_unmap")
			{
				
			}		
			else if (e.name == "preview_complete")	
			{
				// content tree takes care of both trees, so only need to call one
				_contentTree.onEndFullPreview();	
			}	
			else if (e.name == "preview_show_content")	
			{
				dispatchEvent( new ControlsEvent( ControlsEvent.STATUS_UPDATE, "show_preview", Theme.ID_PREVIEW_CONTENT) );
				//_contentTree.updateScale(Theme.LAYOUT_FULL_PREVIEW_WIDTH, Theme.LAYOUT_FULL_PREVIEW_HEIGHT);	
				//_displayManager.displayPage(_contentTree.getVis());	
			}							
			else if (e.name == "preview_show_layout")	
			{
				dispatchEvent( new ControlsEvent( ControlsEvent.STATUS_UPDATE, "show_preview", Theme.ID_PREVIEW_LAYOUT) );
				//_layoutTree.updateScale(Theme.LAYOUT_FULL_PREVIEW_WIDTH, Theme.LAYOUT_FULL_PREVIEW_HEIGHT);
				//_displayManager.displayPage(_layoutTree.getVis());	
			}	
			else if (e.name == "preview_invisible_button")	
			{
				dispatchEvent( new ControlsEvent( ControlsEvent.STATUS_UPDATE, "invisible_button") );
			}																	
		}		

		/**
		 * Advance a step in tutorial
		 */					
		public function showTutorialNextStep():void
		{
			_displayManager.showTutorialNextStep();
		}	
		
		/**
		 * Wrapper for opening a help popup
		 */		
		public function showHelp():void
		{
			_displayManager.showHelp();
		}
		
		/**
		 * Show appropriate feedback when a node on the content tree has been selected
		 */
		private function showSelectionFeedback(idx:Number):void
		{
			var message:String; 
			if (_isTutorial == false)				
				message = Theme.MSG_MAPPING_INST;
			if (_contentTree._traversalOrder == Theme.ORDER_DFS)	// root is not number 1
				message += " (" + _contentTree._currentStep;
			else
				message += " (" + (_contentTree._currentStep - 1);
			// -1 for the length since root is automatically mapped.
			message += " of " + (_contentTree.tree.nodes.length - 1) + ")"; 
			dispatchEvent( new ControlsEvent( ControlsEvent.STATUS_UPDATE, "feedback", 0, message) );   			
			_selectedContentID = idx;	
		}

		/**
		 * Wrapper for the index retrieval function
		 */
		public function getMappedIndex(idx:Number, treeId:Number):Array
		{
			if(_mapping == null) 
				return null;
			
			return _mapping.getMappedIndex(idx, treeId);
		}

		
		/**
		 * 	Add a root-root mapping. 
		 *  This is a special case because it should be done internally without any user interaction.
		 *  It is the specific version of addMapping, without user input.
		 */
		private function addRootMapping():void
		{
			// add root-root mapping
			_selectedContentID = Number(_contentTree.tree.root.name);
			_selectedLayoutID = Number(_layoutTree.tree.root.name);
			//processMapping(Number(_layoutTree.tree.root.name));
			addMapping();
							
			var message:String = _mapping.printMapping();
			dispatchEvent( new ControlsEvent( ControlsEvent.STATUS_UPDATE, "mappings", 0, message) );  	
			resetSelections();	
			//showNextStep();	// for the first time
			//dispatchEvent( new ControlsEvent( ControlsEvent.STATUS_UPDATE, "continue" ) );  	
		}

		/**
		 * Add a mapping based on the current user selection
		 */					
		private function addMapping():void
		{
			trace("add " + _selectedContentID + " " + _selectedLayoutID);
			
			_mapping.addMapping(_selectedContentID, _selectedLayoutID);	
			_cNode.markMapping(_selectedContentID, Theme.STATUS_MAPPED);
			_lNode.markMapping(_selectedLayoutID, Theme.STATUS_MAPPED);
			
			_cNode.unmarkActivatedID(_selectedContentID);
			_lNode.unmarkActivatedID(_selectedLayoutID);

			// Remove all filters for the layout
			_lNode.removeFilters(_layoutTree.getNodeByID(_selectedLayoutID));
			_lNode.hideConnectedNodes(_layoutTree.getNodeByID(_selectedLayoutID));
			
			// Automatically activated children of the mapped node
			if (Theme.ENABLE_REL == false && Theme.ENABLE_SERIAL == false)
			{			
				var node:NodeSprite = _contentTree.getNodeByID(_selectedContentID);
				if (node != null)
				{
					for(var i:uint=0; i<node.childDegree; i++)
					{
						_cNode.markActivated(node.getChildNode(i));
						//_contentTree.activateAllDescendants(node.getChildNode(i));
					}	
				}
			}				
		}

		/**
		 * Check the mapping possibility for the given layout node. 
		 */					
		private function processMapping(layoutID:Number):void
		{
			// First, update _selectedLayoutID. This is used in all *mapping functions.
			_selectedLayoutID = layoutID;
			
			// if no layout node selected, just return
			if (_selectedLayoutID == 0)
				return;
			
			// (in the tutorial session) If a node other than the header is selected, return
			if (_isTutorial == true && _displayManager.currentTutorialStep == 3 && _selectedContentID == 16)
			{
				if (_selectedLayoutID != 121)
					return;
			}
				
			// case 1:  content node already has a mapping: remove its old mapping
			//			cannot happen in the current configuration.
			if (_mapping.getMappedIndex(_selectedContentID, 1).length > 0)
			{			
				_cNode.markMapping(_selectedContentID, Theme.STATUS_DEFAULT);
				var result:Array = _mapping.getMappedIndex(_selectedContentID, 1);
				for (var i:uint = 0; i<result.length; i++)
				{
					_lNode.markMapping(result[i], Theme.STATUS_DEFAULT);					
					trace("case 1 - content conflict: " + result[i]);
					_mapping.removeMapping(true, _selectedContentID);					
				}
			}
			// case 2: layout node already has a mapping: open a popup - merge, replace, cancel possible	
			else if (_mapping.getMappedIndex(_selectedLayoutID, 0).length > 0)
			{	
				trace("case 2 - layout conflict: " + _mapping.getMappedIndex(_selectedContentID, 1));
				
				if (Theme.ENABLE_MERGE == true)
					_displayManager.mergeMappingWithoutPopup();
					
				if (Theme.ENABLE_MERGE_POPUP == true)
					_displayManager.showPopup();
			}	
			// case 3: normal mapping case
			else
			{
				addMapping();
				blinkNode();
			}		 

			// post-processing for preview click
			if (_isTutorial == true && _displayManager.currentTutorialStep == 3)
			{
				//showNextStep();
				_displayManager.showTutorialNextStep();	
			}			 
		}

		/**
		 * Blink the node. Wrapper for the cascaded tree's equivalent one.
		 */			
		private function blinkNode():void
		{	
			_layoutTree.blinkNode(_layoutTree.getNodeByID(_selectedLayoutID), null, 1);				
			_contentTree.blinkNode(_contentTree.getNodeByID(_selectedContentID), onEndBlinkingMapped, 1);				
		}
		
		/**
		 * Remove a mapping based on the current user selection
		 */			
		private function removeMapping(layoutID:Number):void
		{			
			_mapping.removeMapping(false, layoutID);	
			_cNode.markMapping(_selectedContentID, Theme.STATUS_DEFAULT);
			_lNode.markMapping(layoutID, Theme.STATUS_DEFAULT);		
			
			_cNode.markActivatedID(_selectedContentID);
			_lNode.markActivatedID(layoutID);	
		}		


		/**
		 * When node blinking animation finishes playing for mapped nodes
		 */		
		private function onEndBlinkingMapped(e:TransitionEvent):void
		{
			var oldLayoutID:Number = _selectedLayoutID;
			var message:String = "Mapping added";
			dispatchEvent( new ControlsEvent( ControlsEvent.STATUS_UPDATE, "feedback", 0, message) );   			
			// Check if the whole content tree is completed.
			_contentTree.checkCompleted();

			message = _mapping.printMapping();
			dispatchEvent( new ControlsEvent( ControlsEvent.STATUS_UPDATE, "mappings", 0, message) );  				
			resetSelections();
							
			// Explicitly move to the next step, also called from onUnmapButton in CascadedTree.as
			if (Theme.ENABLE_SERIAL == true)	
				dispatchEvent( new ControlsEvent( ControlsEvent.STATUS_UPDATE, "continue" ) );  	 
			
			// Force mouse over event to prevent mouse out and over again for mouse-over effect
			// only reasonable in 1-click interface
			if (Theme.ENABLE_CONTINUE_BUTTON == false)
				_layoutTree.forceOnMouseOver(_layoutTree.getNodeByID(oldLayoutID));    		
		}
		
		/**
		 * Reset selections
		 */
		private function resetSelections():void
		{
			_cNode.unmarkSelectedID(_selectedContentID);
			_lNode.unmarkSelectedID(_selectedLayoutID);
			
			_selectedContentID = 0;
			_selectedLayoutID = 0;
		}
		
		/**
		 * Find the closest ancestor of the given node whose mapping is not null (get 'a')
		 */
		private function getClosestValidAncestor(n:NodeSprite):NodeSprite
		{
			var resultNode:NodeSprite;
			if (_mapping.getMappedIndex(Number(n.name), 1).length > 0)	// if mapping is not null
				resultNode = n;
			else
			{
				if (n.parentNode == null)
					resultNode = null;
				else
					getClosestValidAncestor(n.parentNode);
			}
			return resultNode;
		}
		
		/**
		 * Display content page for the quasi-hierarchical matching process
		 */			
		private function showQuasiMatchingContent():void
		{
			var root:NodeSprite = _contentTree.tree.root as NodeSprite;		
			root.visitTreeBreadthFirst(function(nn:NodeSprite):void {
				if (nn.props["mapped"] == null || nn.props["mapped"] == Theme.STATUS_DEFAULT) // null 
				{
					_cNode.markActivated(nn);			
				}
			});
				
		}

		/**
		 * Display layout page for the quasi-hierarchical matching process
		 */	
		private function showQuasiMatchingLayout():void
		{
			var root:NodeSprite = _layoutTree.tree.root as NodeSprite;		
			root.visitTreeBreadthFirst(function(nn:NodeSprite):void {
				if (nn.props["mapped"] == null || nn.props["mapped"] == Theme.STATUS_DEFAULT) // null 
				{
					_lNode.markActivated(nn);			
				}
			});			
		}
        
		/**
		 * Display current activated nodes on the content page for the hierarchical matching process
		 */			
		private function showActivatedContent(n:NodeSprite):void
		{	
			// blur only when image segments are loaded. When only background is loaded, it should not be blurred.
			if (Theme.ENABLE_IMAGE_SEGMENT == true)			
				_cNode.blurOtherNodes(n);		
			
			if (Theme.ENABLE_SERIAL == false)
			{
				for(var i:uint=0; i<n.childDegree; i++)
				{
					_cNode.markActivated(n.getChildNode(i));
					_cNode.hideAllDescendants(n.getChildNode(i));
				}
			}
			else
			{	
				for(i=0; i<n.childDegree; i++)
				{
    				_lNode.activateAllDescendants(n.getChildNode(i));
				}				
				// Automatically mark the current node as selected & other nodes as unselected
				var root:NodeSprite = _contentTree.tree.root as NodeSprite;		
				root.visitTreeBreadthFirst(function(nn:NodeSprite):void {
					if (nn == _contentTree.getCurrentProcessingNode())  
					{	
						//nn.props["selected"] = true;
						_cNode.markActivated(nn);
						// to change the color effect
						_cNode.markSelected(nn);
						showSelectionFeedback(Number(nn.name));
						_cNode.pullNodeForward(nn);
						 
						//_cNode.addDropShadow(nn);
						//_cNode.addGlow(nn);
						_cNode.addGlowShadow(nn, Theme.COLOR_SELECTED);
						_cNode.showConnectedNodes(nn);
						
					}
					else
					{	
						nn.props["selected"] = false;
						//_cNode.unmarkActivated(nn);
						_cNode.removeFilters(nn);
					}
				});
				
			}				
		}
		
		/**
		 * Display current activated nodes on the layout page for the hierarchical matching process
		 */			
		private function showActivatedLayout(n:NodeSprite):void
		{	
			// blur only when image segments are loaded. When only background is loaded, it should not be blurred.
			if (Theme.ENABLE_IMAGE_SEGMENT == true)
				_lNode.blurOtherNodes(n);	
    			
			for(var i:uint=0; i<n.childDegree; i++)
			{
    			_lNode.activateAllDescendants(n.getChildNode(i));
			}			
		}

		/**
		 * Check if the current content node has something to display on the content page for the hierarchical matching process
		 */			
		private function checkContent(n:NodeSprite):Boolean
		{		
			var ret:Boolean = true;
			
			if (Theme.ENABLE_SERIAL == false)
			{
				if (n.childDegree == 0 || n == null)
					ret = false;
			}
			else 
			{
				if (n == null)
					ret = false;
			}
			
			return ret;							
		}

		/**
		 * Check if the current content node has something to display on the layout page for the hierarchical matching process
		 * Returns null        if there is nothing to display
		 *         layout node if there is something to display 
		 */			
		private function checkLayout(n:NodeSprite):NodeSprite
		{		
			var ret:NodeSprite = null;
			var lRoot:NodeSprite = _layoutTree.tree.root as NodeSprite;
			
			// Just return everything
			if (Theme.ENABLE_SERIAL == true)
				return lRoot;
				
			var a:NodeSprite = null;	
			
			// Find the closest ancestor a of n such that M(a) is not null 
			a = getClosestValidAncestor(n);	// a	
			
			// Then activate descendants of M(a)
			
	        lRoot.visitTreeBreadthFirst(function(nn:NodeSprite):void {
	        	// Find a node where M(a) is not null
	        	if (a != null)	
	        	{
	        		var result:Array = _mapping.getMappedIndex(Number(a.name), 1);
	        		for (var i:uint=0; i<result.length; i++)
	        		{
	        			if (nn.name != String(result[i]))
	        				continue;
		        		// nn is M(a)	        		
		        		if (nn.childDegree == 0)	// M(a) is a leaf node
		        			;
		        		else
		        			ret = nn;
	        		}
	        	}
			});		
			
			return ret;			
		}
						

		/**
		 * Display activated nodes for the hierarchical matching process
		 * Returns true  if something is displayed
		 *         false if nothing is displayed
		 */			
		private function showMatching():Boolean
		{		
			var currentContentNode:NodeSprite;
			var currentLayoutNode:NodeSprite; 
			var ret:Boolean = false;
			
			currentContentNode = _contentTree.getCurrentProcessingNode();
			trace("[" + currentContentNode.name + "] " + _contentTree._currentStep + "/" + _contentTree.tree.nodes.length);
			
			if (currentContentNode == _contentTree.tree.root)
				return false;			
				
			// Check the display conditions
			if (checkContent(currentContentNode))
			{
				currentLayoutNode = checkLayout(currentContentNode);
				
				// All conditions are met. Display on the screen.
				if (currentLayoutNode != null)
				{
					showActivatedContent(currentContentNode);
					showActivatedLayout(currentLayoutNode);
					ret = true;
				}
			}
			return ret;
		}
														
		/**
		 * Proceed and display the next step in the hierarchical matching process
		 */					
		public function showNextStep():void
		{
			_contentTree._currentStep++;
			_cNode.unblurOtherNodes();	// initialize visual attributes
        	_lNode.unblurOtherNodes();		// initialize visual attributes
        	
        	if (Theme.ENABLE_REL == true)
        	{
		        if (_currentStage == Theme.STAGE_INITIAL)	// To the hierarchical stage
		       	{
		       		_currentStage = Theme.STAGE_HIERARCHICAL;
			        dispatchEvent( new ControlsEvent( ControlsEvent.STATUS_UPDATE, "stage", Theme.STAGE_HIERARCHICAL) );   
			        if (showMatching() == false)	// if nothing shown, on to the next 
			        	showNextStep();			
		       	}
		       	else if (_currentStage == Theme.STAGE_HIERARCHICAL)
		       	{
		        	if (_contentTree.tree.nodes.length <= _contentTree._currentStep)	// whole tree traversed
		        	{
		        		_currentStage = Theme.STAGE_QUASI;
			       		dispatchEvent( new ControlsEvent( ControlsEvent.STATUS_UPDATE, "stage", Theme.STAGE_QUASI) );   	        		
		        		showQuasiMatchingLayout();
		        		showQuasiMatchingContent();
		        		
		        	}
		        	else		       	
		        	{	        		
						if (showMatching() == false)	// if nothing shown, on to the next
							showNextStep();		
		       		}
		       		
		       	}
		       	else if (_currentStage == Theme.STAGE_QUASI)
		       	{
		       		showQuasiMatchingLayout();
		       		showQuasiMatchingContent();
		       		
		       	}
        	}
        	else		// Single phase, no ancestor-descendent relationship enforced
        	{
        		if (_isTutorial == true && _nextStepLock == true)
        			_nextStepLock = false;
        		else
        		{
			        if (_currentStage == Theme.STAGE_INITIAL)	// To the hierarchical stage
			       	{
			       		_currentStage = Theme.STAGE_HIERARCHICAL;
			       		// stage event is now called by preview function in CascadedTree.as
	//			        dispatchEvent( new ControlsEvent( ControlsEvent.STATUS_UPDATE, "stage", Theme.STAGE_HIERARCHICAL) );   
				        if (showMatching() == false)	// if nothing shown, on to the next 
				        	showNextStep();			
			       	}
			       	else if (_currentStage == Theme.STAGE_HIERARCHICAL)
			       	{
			        	if (_contentTree.tree.nodes.length < _contentTree._currentStep)	// whole tree traversed
			        	{
			        		_currentStage = Theme.STAGE_QUASI;
				       		dispatchEvent( new ControlsEvent( ControlsEvent.STATUS_UPDATE, "stage", Theme.STAGE_QUASI) );   	        		
			        		_contentTree.checkCompleted();
			        		// Now everything is done. Send the mapping result somewhere!
			       			var result:String = _mapping.printMapping();
			     	  		_displayManager.showResults(result);
			        		//showQuasiMatchingLayout();
			        		//showQuasiMatchingContent();		        		
			        	}
			        	else		       	
			        	{	    		
			        		if (_isRootMapped == false) 	// if root has not been mapped, map the root first.
			        		{
			        			addRootMapping();
			        			_isRootMapped = true;
			        		}						
							if (showMatching() == false)	// if nothing shown, on to the next
								showNextStep();								
			       		}
			       		
			       	}
			       	else if (_currentStage == Theme.STAGE_QUASI)
			       	{
			       		showQuasiMatchingLayout();
			       		showQuasiMatchingContent();
			       		
			       	}     
		       	}   		
        	}
		}	
			
	}
}