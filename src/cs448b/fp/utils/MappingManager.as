package cs448b.fp.utils
{
	import cs448b.fp.data.Mapping;
	import cs448b.fp.tree.CascadedTree;
	
	import flare.vis.data.NodeSprite;
		
	public class MappingManager
	{
		private var _mapping:Mapping;
		private var _contentTree:CascadedTree = null;
		private var _layoutTree:CascadedTree = null;
		private var _selectedContentID:Number;
		private var _selectedLayoutID:Number;
		
		public function MappingManager()
		{
			_mapping = new Mapping();	
			_selectedContentID = 0;
			_selectedLayoutID = 0;
		}

		public function init():void
		{
			// add root-root mapping
			_mapping.addMapping(Number(_contentTree.tree.root.name), Number(_layoutTree.tree.root.name));
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
			// TODO: handle mapping event here
			trace("ContentTree - Mouse Down! " + e.name + " " + e.value);	
			
			if (_selectedLayoutID != 0 && e.name == "add")
			{
				// relinking only happens in layout selection
				//_mapping.removeMapping(true, _selectedContentID);
				//_mapping.addMapping(e.value, _selectedLayoutID);		
			}
			else if (_selectedLayoutID != 0 && e.name == "remove")
			{
				//_mapping.removeMapping(true, e.value);	
			}
			_selectedContentID = e.value;			
			//_mapping.printMapping();
		}
		
		private function onLayoutTreeEvent(e:MappingEvent):void
		{
			// TODO: handle mapping event here
			trace("LayoutTree - Mouse Down! " + e.name + " " + e.value);	
			
			if (_selectedContentID != 0 && e.name == "add")
			{
				// first, remove the old mapping if any
				if (_mapping.getMappedIndex(e.value, 0) != -1)
					_mapping.removeMapping(false, e.value);	
				if (_mapping.getMappedIndex(_selectedContentID, 1) != -1)
					_mapping.removeMapping(true, _selectedContentID);
								
				_mapping.addMapping(_selectedContentID, e.value);	
				
				// TODO: give feedback to users	
			}
			else if (_selectedContentID != 0 && e.name == "remove")
			{
				_mapping.removeMapping(false, e.value);	
			}
			_selectedLayoutID = e.value;
			_mapping.printMapping();
		}
		
		/**
		 * Proceed and display the next step in the hierarchical matching process
		 */					

		public function showNextStepContent():void
		{
			_contentTree._currentStep++;
			_contentTree.unblurOtherNodes();	// initialize visual attributes
			
			var root:NodeSprite = _contentTree.tree.root as NodeSprite;
			var nodeCount:Number = 1;
				
	        root.visitTreeBreadthFirst(function(nn:NodeSprite):void {
	        	if (nodeCount == _contentTree._currentStep)	// found the current node to look at
	        	{
					if (nn.childDegree == 0) // don't do anything, onto the next node
					{
						_contentTree._currentStep++;
						//nodeCount++;
					}
					else	// show on the screen
					{
						nn.visible = true;
						nn.lineColor = 0xff0000FF; 
						nn.lineWidth = 15;
						nn.fillColor = 0xffFFFFAAAA;
						nn.props["activated"] = true;
						_contentTree.blurOtherNodes(nn);		
						for(var i:uint=0; i<nn.childDegree; i++)
						{
							nn.getChildNode(i).props["activated"] = true;
							nn.getChildNode(i).lineColor = 0xff0000FF; 
							nn.getChildNode(i).lineWidth = 15;
							nn.getChildNode(i).fillColor = 0xffFFFFAAAA;
							nn.getChildNode(i).props["image"].alpha = 1;
							_contentTree.hideAllDescendants(nn.getChildNode(i));

						}					
					}	        		
	        	}
	        	nodeCount++;
			});			
		}

		/**
		 * Find the closest ancestor of the given node whose mapping is not null (get 'a')
		 */
		public function getClosestValidAncestor(n:NodeSprite):NodeSprite
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
		 * Dynamically display activated nodes, based on the current content node processing.
		 */
		public function showNextStepLayout():void
		{
			_layoutTree.unblurOtherNodes();	// initialize visual attributes
			
			var cRoot:NodeSprite = _contentTree.tree.root as NodeSprite;
			var lRoot:NodeSprite = _layoutTree.tree.root as NodeSprite;
			//var nodeCount:Number = 1;
			
			// 1) Get the current node 'n' on the matching process 
			var currentNodeID:Number = _contentTree.getCurrentProcessingNode();
			var a:NodeSprite = null;
			
			// 2) Find the closest ancestor a of n such that M(a) is not null 
			cRoot.visitTreeBreadthFirst(function(nn:NodeSprite):void {
				if (Number(nn.name) == currentNodeID)	// n
				{
					a = getClosestValidAncestor(nn);	// a
				} 
			});
			
			// then activate descendants of M(a)
			//var ma:NodeSprite = null;				
	        lRoot.visitTreeBreadthFirst(function(nn:NodeSprite):void {
	        	if (a != null && Number(nn.name) == _mapping.getMappedIndex(Number(a.name), 1))	
	        	{
	        		// nn is M(a)
					_layoutTree.blurOtherNodes(nn);	        		
	        		_layoutTree.activateAllDescendants(nn);
	        	}
	        	//nodeCount++;
			});				

		}
		
		
	}
}