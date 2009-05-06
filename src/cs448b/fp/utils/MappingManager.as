package cs448b.fp.utils
{
	import cs448b.fp.data.Mapping;
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
		
		public function MappingManager()
		{
			_mapping = new Mapping();	
			_selectedContentID = 0;
			_selectedLayoutID = 0;
			_currentStage = Theme.STAGE_INITIAL;
		}

		public function init():void
		{
			// Set the traversal order
			_contentTree.setTraversalOrder();
			_contentTree.playPreview();
			
			// add root-root mapping
			_selectedContentID = Number(_contentTree.tree.root.name);
			addMapping(Number(_layoutTree.tree.root.name));
							
			var message:String = _mapping.printMapping();
			dispatchEvent( new ControlsEvent( ControlsEvent.STATUS_UPDATE, "mappings", 0, message) );  	
			resetSelections(_selectedContentID, _selectedLayoutID);	
			//showNextStep();	// for the first time
			//dispatchEvent( new ControlsEvent( ControlsEvent.STATUS_UPDATE, "continue" ) );  		
		}
		
		public function setContentTree(t:CascadedTree):void
		{
			_contentTree = t;
			_contentTree.addEventListener(MappingEvent.MOUSE_DOWN, onContentTreeEvent);
		}
		
		public function setLayoutTree(t:CascadedTree):void
		{
			_layoutTree = t;
			_layoutTree.addEventListener(MappingEvent.MOUSE_DOWN, onLayoutTreeEvent);
		}
		
		private function onContentTreeEvent(e:MappingEvent):void
		{	
			// give feedback to users	
			if (Theme.ENABLE_SERIAL == false)
				showSelectionFeedback(e.value);
			
			// mapping events are only triggered in layout tree			
		}
		
		/**
		 * Show appropriate feedback when a node on the content tree has been selected
		 */
		private function showSelectionFeedback(idx:Number):void
		{
			var message:String; 
			if (_contentTree._traversalOrder == Theme.ORDER_DFS)	// root is not number 1
				message = "Step " + _contentTree._currentStep + " of " + _contentTree.tree.nodes.length + ". Select a mapped segment on the Layout page";
			else
				message = "Step " + (_contentTree._currentStep - 1) + " of " + _contentTree.tree.nodes.length + ". Select a mapped segment on the Layout page";
			dispatchEvent( new ControlsEvent( ControlsEvent.STATUS_UPDATE, "feedback", 0, message) );   			
			_selectedContentID = idx;	
		}

		/**
		 * Wrapper for the index retrieval function
		 */
		public function getMappedIndex(idx:Number, treeId:Number):Number
		{
			if(_mapping == null) 
				return 0;
			
			return _mapping.getMappedIndex(idx, treeId);
		}
			
		private function addMapping(layoutID:Number):void
		{
			// first, remove the old mapping if any
			// case 1: content needs to remove its old mapping
			if (_mapping.getMappedIndex(layoutID, 0) != -1)
			{					
				_contentTree.markMapping(_mapping.getMappedIndex(layoutID, 0), 0);
				_layoutTree.markMapping(layoutID, Theme.STATUS_DEFAULT);		
							
				//trace("case 1: " + _mapping.getMappedIndex(e.value, 0));
				_mapping.removeMapping(false, layoutID);	
			}
			// case 2: layout needs to remove its old mapping
			if (_mapping.getMappedIndex(_selectedContentID, 1) != -1)
			{				
				_contentTree.markMapping(_selectedContentID, Theme.STATUS_DEFAULT);
				_layoutTree.markMapping(_mapping.getMappedIndex(_selectedContentID, 1), Theme.STATUS_DEFAULT);	
				
				//trace("case 2: " + _mapping.getMappedIndex(_selectedContentID, 1));
				_mapping.removeMapping(true, _selectedContentID);					
			}				
			_mapping.addMapping(_selectedContentID, layoutID);	
			_contentTree.markMapping(_selectedContentID, Theme.STATUS_MAPPED);
			_layoutTree.markMapping(layoutID, Theme.STATUS_MAPPED);
			
			_contentTree.unmarkActivatedID(_selectedContentID);
			_layoutTree.unmarkActivatedID(layoutID);

			// Automatically activated children of the mapped node
			if (Theme.ENABLE_REL == false && Theme.ENABLE_SERIAL == false)
			{			
				var node:NodeSprite = _contentTree.getNodeByID(_selectedContentID);
				if (node != null)
				{
					for(var i:uint=0; i<node.childDegree; i++)
					{
						_contentTree.markActivated(node.getChildNode(i));
						//_contentTree.activateAllDescendants(node.getChildNode(i));
					}	
				}
			}	  
		}
		
		private function removeMapping(layoutID:Number):void
		{
			_mapping.removeMapping(false, layoutID);	
			_contentTree.markMapping(_selectedContentID, Theme.STATUS_DEFAULT);
			_layoutTree.markMapping(layoutID, Theme.STATUS_DEFAULT);		
			
			_contentTree.markActivatedID(_selectedContentID);
			_layoutTree.markActivatedID(layoutID);	
		}		
		
		private function onLayoutTreeEvent(e:MappingEvent):void
		{
//			trace("LayoutTree - Mouse Down! " + e.name + " " + e.value);	
			var message:String;
			if (_selectedContentID != 0 && e.name == "add")
			{
				addMapping(e.value);
				_contentTree.blinkNode(_contentTree.getNodeByID(_selectedContentID), onEndBlinkingMapped, 1);	
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
				resetSelections(_selectedContentID, _selectedLayoutID);		
				
			}

			
//			if (_selectedContentID == 0)	// layout is selected alone.
//			{
//				resetSelections(_selectedContentID, _selectedLayoutID);
//			}
//			else	// Reset selections
//			{
//			
//				_selectedLayoutID = e.value;
				

//			}
		}


		/**
		 * When node blinking animation finishes playing for mapped nodes
		 */		
		private function onEndBlinkingMapped(e:TransitionEvent):void
		{
			var message:String = "Mapping added";
			dispatchEvent( new ControlsEvent( ControlsEvent.STATUS_UPDATE, "feedback", 0, message) );   			
			// Check if the whole content tree is completed.
			_contentTree.checkCompleted();

			message = _mapping.printMapping();
			dispatchEvent( new ControlsEvent( ControlsEvent.STATUS_UPDATE, "mappings", 0, message) );  				
			resetSelections(_selectedContentID, _selectedLayoutID);
							
			// Explicitly move to the next step, also called from onUnmapButton in CascadedTree.as
			if (Theme.ENABLE_SERIAL == true)	
				dispatchEvent( new ControlsEvent( ControlsEvent.STATUS_UPDATE, "continue" ) );  	        		
		}
		
		/**
		 * Reset selections
		 */
		private function resetSelections(selectedContentID:Number, selectedLayoutID:Number):void
		{
			_contentTree.unmarkSelectedID(selectedContentID);
			_layoutTree.unmarkSelectedID(selectedLayoutID);
			
			_selectedContentID = 0;
			_selectedLayoutID = 0;
		}
		
		/**
		 * Find the closest ancestor of the given node whose mapping is not null (get 'a')
		 */
		private function getClosestValidAncestor(n:NodeSprite):NodeSprite
		{
			var resultNode:NodeSprite;
			if (_mapping.getMappedIndex(Number(n.name), 1) != -1)	// if mapping is not null
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
					_contentTree.markActivated(nn);			
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
					_layoutTree.markActivated(nn);			
				}
			});			
		}

		/**
		 * Display current activated nodes on the content page for the hierarchical matching process
		 */			
		private function showActivatedContent(n:NodeSprite):void
		{	
			_contentTree.blurOtherNodes(n);		
			
			if (Theme.ENABLE_SERIAL == false)
			{
				for(var i:uint=0; i<n.childDegree; i++)
				{
					_contentTree.markActivated(n.getChildNode(i));
					_contentTree.hideAllDescendants(n.getChildNode(i));
				}
			}
			else
			{
				// Automatically mark the current node as selected & other nodes as unselected
				var root:NodeSprite = _contentTree.tree.root as NodeSprite;		
				root.visitTreeBreadthFirst(function(nn:NodeSprite):void {
					if (nn == _contentTree.getCurrentProcessingNode())  
					{	
						//nn.props["selected"] = true;
						_contentTree.markActivated(nn);
						// to change the color effect
						_contentTree.markSelected(nn);
						showSelectionFeedback(Number(nn.name));
						_contentTree.pullNodeForward(nn);
					}
					else
					{	
						nn.props["selected"] = false;
						_contentTree.unmarkActivated(nn);
					}
				});
				
			}				
		}
		
		/**
		 * Display current activated nodes on the layout page for the hierarchical matching process
		 */			
		private function showActivatedLayout(n:NodeSprite):void
		{	
			_layoutTree.blurOtherNodes(n);	        			
			for(var i:uint=0; i<n.childDegree; i++)
			{
    			_layoutTree.activateAllDescendants(n.getChildNode(i));
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
	        	if (a != null && Number(nn.name) == _mapping.getMappedIndex(Number(a.name), 1))	
	        	{
	        		// nn is M(a)	        		
	        		if (nn.childDegree == 0)	// M(a) is a leaf node
	        			;
	        		else
	        			ret = nn;
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
			trace(_contentTree._currentStep + " " + _contentTree.tree.nodes.length);
			currentContentNode = _contentTree.getCurrentProcessingNode();
			
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
		public function showPreview():void
		{
			
		}															
		/**
		 * Proceed and display the next step in the hierarchical matching process
		 */					
		public function showNextStep():void
		{
			_contentTree._currentStep++;
			_contentTree.unblurOtherNodes();	// initialize visual attributes
        	_layoutTree.unblurOtherNodes();		// initialize visual attributes
        	
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
		        		//showQuasiMatchingLayout();
		        		//showQuasiMatchingContent();
		        		
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
        		
        		/*
        		if (_contentTree.tree.nodes.length <= _contentTree._currentStep)	// whole tree traversed
	        	{
	        		_contentTree.checkCompleted();
	        		//dispatchEvent( new ControlsEvent( ControlsEvent.STATUS_UPDATE, "stage", 2) );   	        		
	        	}     
	        	else		       	
	        	{	        		
					if (showMatching() == false)	// if nothing shown, on to the next
						showNextStep();		
	       		}	        	   		
	       		*/
        	}
		}	
		
		
//		/**
//		 * Display content page for the hierarchical matching process
//		 */			
//		private function showMatchingContent():void
//		{		
//			var root:NodeSprite = _contentTree.tree.root as NodeSprite;
//			var nodeCount:Number = 1;	
//	       	trace(_contentTree._currentStep + " " + _contentTree.tree.nodes.length);
//	       	
//	        root.visitTreeBreadthFirst(function(nn:NodeSprite):void {
//	        	if (nodeCount == _contentTree._currentStep)	// found the current node to look at
//	        	{      		
//					if (nn.childDegree == 0) // don't do anything, onto the next node
//						_contentTree._currentStep++;
//					else	// show on the screen
//					{	
//						_contentTree.blurOtherNodes(nn);		
//						for(var i:uint=0; i<nn.childDegree; i++)
//						{
//							_contentTree.markActivated(nn.getChildNode(i));
//							_contentTree.hideAllDescendants(nn.getChildNode(i));
//						}					
//					}	        		
//	        	}
//	        	nodeCount++;
//    	        	
//			});								
//		}
//
//		/**
//		 * Display layout page for the hierarchical matching process
//		 */				
//		private function showMatchingLayout():void
//		{
//			var cRoot:NodeSprite = _contentTree.tree.root as NodeSprite;
//			var lRoot:NodeSprite = _layoutTree.tree.root as NodeSprite;
//			var isMappingNull:Boolean = true;
//			//var nodeCount:Number = 1;
//			
//			// 1) Get the current node 'n' on the matching process 
//			var currentNodeID:Number = _contentTree.getCurrentProcessingNodeID();
//			var a:NodeSprite = null;
//			
//			// 2) Find the closest ancestor a of n such that M(a) is not null 
//			cRoot.visitTreeBreadthFirst(function(nn:NodeSprite):void {
//				if (Number(nn.name) == currentNodeID)	// n
//				{
//					a = getClosestValidAncestor(nn);	// a
//				} 
//			});
//			
//			// then activate descendants of M(a)
//			//var ma:NodeSprite = null;				
//	        lRoot.visitTreeBreadthFirst(function(nn:NodeSprite):void {
//	        	if (a != null && Number(nn.name) == _mapping.getMappedIndex(Number(a.name), 1))	
//	        	{
//	        		// nn is M(a)	        		
//	        		if (nn.childDegree == 0)	// skip this node on the content
//	        			_contentTree._currentStep++;
//	        		else
//	        		{
//	        			isMappingNull = false;
//						_layoutTree.blurOtherNodes(nn);	        			
//						for(var i:uint=0; i<nn.childDegree; i++)
//						{
//		        			_layoutTree.activateAllDescendants(nn.getChildNode(i));
//						}
//	        		}
//	        	}
//	        	//nodeCount++;
//			});		
//			
//			// handle the case where there is nothing to show
//        	if (isMappingNull == true)	
//        	{
//        		_contentTree._currentStep++;
//        	}
//		}
//		/**
//		 * Proceed and display the next step in the hierarchical matching process
//		 */					
//		public function showNextStepContent():void
//		{
//			_contentTree._currentStep++;
//			_contentTree.unblurOtherNodes();	// initialize visual attributes
//        
//	        if (_currentStage == 0)	// To the hierarchical stage
//	       	{
//	       		_currentStage = 1;
//		        dispatchEvent( new ControlsEvent( ControlsEvent.STATUS_UPDATE, "stage", 1) );   
//		        showMatchingContent();				
//	       	}
//	       	else if (_currentStage == 1)
//	       	{
//	        	if (_contentTree.tree.nodes.length <= _contentTree._currentStep)	// whole tree traversed
//	        	{
//	        		_currentStage = 2;
//		       		dispatchEvent( new ControlsEvent( ControlsEvent.STATUS_UPDATE, "stage", 2) );   	        		
//	        		showQuasiMatchingContent();
//	        	}
//	        	else		       		
//	       			showMatchingContent();
//	       		
//	       	}
//	       	else if (_currentStage == 2)
//	       	{
//	       		showQuasiMatchingContent();
//	       	}
//
//		}		
//				
//		/**
//		 * Dynamically display activated nodes, based on the current content node processing.
//		 */
//		public function showNextStepLayout():void
//		{
//			_layoutTree.unblurOtherNodes();	// initialize visual attributes
//			
//	        if (_currentStage == 0)	// To the hierarchical stage
//	       	{
//	       		// cannot be here		
//	       	}
//	       	else if (_currentStage == 1)
//	       	{
//	       		showMatchingLayout();
//	       	}
//	       	else if (_currentStage == 2)
//	       	{
//	       		showQuasiMatchingLayout();
//	       	}		
//
//		}			
	}
}