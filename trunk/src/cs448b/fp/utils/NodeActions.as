package cs448b.fp.utils
{
	import cs448b.fp.tree.AbstractTree;
	
	import flare.vis.data.NodeSprite;
	
	import flash.filters.BitmapFilter;
	
	/**
	 * All node-level actions, including visual effects and status save & loading
	 */ 
	public class NodeActions
	{
		private var _tree:AbstractTree;
		private var _isContentTree:Boolean;
		public function NodeActions(tree:AbstractTree, isContentTree:Boolean)
		{
			_tree = tree;
			_isContentTree = isContentTree;
		}

		/**
		 * Add drop shadow effect to the node
		 */ 
		public function addDropShadow(n:NodeSprite):void
		{
			var filter:BitmapFilter = Theme.getDropShadowFilter();
			var myFilters:Array = new Array();
			myFilters.push(filter);
			n.filters = myFilters;
		}
		
		/**
		 * Wrapper for removeFilters
		 */ 
		public function removeDropShadow(n:NodeSprite):void
		{
			removeFilters(n);
		}
		
		/**
		 * Remove the drop shadow effect. All other effects are removed as well.
		 */ 
		private function removeFilters(n:NodeSprite):void
		{
			n.filters = null;
		}
		
		/**
		 * Add glow effect to the node
		 */ 
		public function addGlow(n:NodeSprite, alpha:Number = 0.8, blurX:Number = 7, blurY:Number = 7):void
		{
			var filter:BitmapFilter = Theme.getGlowFilter(alpha, blurX, blurY);
			var myFilters:Array = new Array();
			myFilters.push(filter);
			n.filters = myFilters;
		}
		
		/**
		 * Wrapper for removeFilters
		 */ 
		public function removeGlow(n:NodeSprite):void
		{
			removeFilters(n);
		}	
		

		/** 
		 * Show connected nodes
		 */		 
		public function showConnectedNodes(n:NodeSprite):void
		{
			if (n.parentNode != _tree.tree.root)
			{
				n.parentNode.lineColor = Theme.COLOR_CONNECTED;
				n.parentNode.lineWidth = Theme.LINE_WIDTH / Theme.CONNECTED_LINE_WIDTH;
				n.parentNode.lineAlpha = Theme.CONNECTED_ALPHA;
				addGlow(n.parentNode, Theme.CONNECTED_ALPHA, 5, 5);
			}
			
			for (var i:uint=0; i<n.childDegree; i++)
			{
				n.getChildNode(i).lineColor = Theme.COLOR_CONNECTED;
				n.getChildNode(i).lineWidth = Theme.LINE_WIDTH / Theme.CONNECTED_LINE_WIDTH;
				n.getChildNode(i).lineAlpha = Theme.CONNECTED_ALPHA;
				addGlow(n.getChildNode(i), Theme.CONNECTED_ALPHA, 5, 5);
			}			
		}

		/** 
		 * Remove effects of showConnectedNodes
		 */		 
		public function hideConnectedNodes(n:NodeSprite):void
		{
			hideLine(n.parentNode);
			removeGlow(n.parentNode);			
			for (var i:uint=0; i<n.childDegree; i++)
			{
				hideLine(n.getChildNode(i));
				removeGlow(n.getChildNode(i));
			}			
		}		


		/**
		 * Hide line display, called when cancelling any line change effect
		 */			
		public function hideLine(nn:NodeSprite):void
		{
			nn.lineWidth = 0;			
			nn.lineColor = 0x00000000;
		}
		
		/**
		 * Show line width based on the current theme setting
		 */	
		public function showLineWidth(nn:NodeSprite):void
		{
			if (_isContentTree == true && Theme.FIREBUG_CTREE == false)
				nn.lineWidth = Theme.LINE_WIDTH;
			else if (_isContentTree == false && Theme.FIREBUG_LTREE == false)
				nn.lineWidth = Theme.LINE_WIDTH;
			else 
				hideLine(nn);
		}


		/**
		 * Mark the nodes as activated, both internally and visually
		 */			
		public function markActivated(nn:NodeSprite):void
		{
			nn.visible = true;
			nn.props["activated"] = true;
			nn.lineColor = Theme.COLOR_ACTIVATED;
			showLineWidth(nn);
			nn.props["image"].alpha = 1;
			nn.props["image"].visible = true;
			if (nn.props["mapped"] == Theme.STATUS_MAPPED)
			{
				hideLine(nn);
			}
		}

		/**
		 * Mark the node as selected, both internally and visually
		 */			
		public function markSelected(nn:NodeSprite):void
		{
			nn.props["selected"] = true;
			nn.lineColor = Theme.COLOR_SELECTED;
			showLineWidth(nn);
			nn.props["image"].alpha = 1;
		}

		/**
		 * Mark the nodes as activated given the ID, both internally and visually
		 */			
		public function markActivatedID(id:Number):void
		{
			var root:NodeSprite = _tree.tree.root as NodeSprite;
	        root.visitTreeBreadthFirst(function(nn:NodeSprite):void {
				if (Number(nn.name) == id)
				{
					markActivated(nn);
				}
			});			
		}

		/**
		 * Mark the nodes as selected given the ID, both internally and visually
		 */			
		public function markSelectedID(id:Number):void
		{
			var root:NodeSprite = _tree.tree.root as NodeSprite;
	        root.visitTreeBreadthFirst(function(nn:NodeSprite):void {
				if (Number(nn.name) == id)
				{
					markSelected(nn);
				}
			});		
		}
		
		/**
		 * Mark the node as deactivated, both internally and visually
		 */			
		public function unmarkActivated(nn:NodeSprite):void
		{
			nn.props["activated"] = false;
			nn.lineColor = 0x00000000; //_tree.tree.nodes.lineColor; 
			showLineWidth(nn);
		}

		/**
		 * Mark the node as unselected, both internally and visually
		 */			
		public function unmarkSelected(nn:NodeSprite):void
		{
			nn.props["selected"] = false;
			if (nn.props["activated"] == true)
			{			
				nn.lineColor = Theme.COLOR_ACTIVATED;
				showLineWidth(nn);		
			}
			else
			{
				hideLine(nn);
//				nn.lineColor = _tree.tree.nodes.lineColor; 
//				nn.lineWidth = _tree.tree.nodes.lineWidth;				
			}		
		}

		/**
		 * Mark the node as deactivated given the ID, both internally and visually
		 */			
		public function unmarkActivatedID(id:Number):void
		{
			var root:NodeSprite = _tree.tree.root as NodeSprite;
	        root.visitTreeBreadthFirst(function(nn:NodeSprite):void {
				if (Number(nn.name) == id)
				{
					unmarkActivated(nn);
				}
			});			
		}

		/**
		 * Mark the node as unselected given the ID, both internally and visually
		 */	
		public function unmarkSelectedID(id:Number):void
		{
			var root:NodeSprite = _tree.tree.root as NodeSprite;
	        root.visitTreeBreadthFirst(function(nn:NodeSprite):void {
				if (Number(nn.name) == id)
				{
					unmarkSelected(nn);
				}
			});		
		}



		/**
		 * Mark the nodes that are mapped, both internally and visually
		 */		
		public function markMapping(id:Number, action:Number):void
		{	
			var root:NodeSprite = _tree.tree.root as NodeSprite;				        
	        root.visitTreeBreadthFirst(function(nn:NodeSprite):void {			
	        	if (id == Number(nn.name))
	        	{	
	        		if (action == Theme.STATUS_MAPPED)
	        		{
						nn.props["mapped"] = Theme.STATUS_MAPPED;	
						nn.fillColor = Theme.COLOR_FILL_MAPPED;
						hideLine(nn);
						nn.alpha = Theme.ALPHA_MAPPED;
						nn.props["image"].visible = Theme.SHOW_MAPPPED;	
	        		}	 
	        		else if (action == Theme.STATUS_UNMAPPED)
	        		{
	        			nn.props["mapped"] = Theme.STATUS_UNMAPPED;	
						nn.fillColor = Theme.COLOR_FILL_UNMAPPED;
						hideLine(nn);
						nn.alpha = Theme.ALPHA_MAPPED;
						nn.props["image"].visible = Theme.SHOW_MAPPPED;		        		
	        		}
	        		else
	        		{
	        			nn.props["mapped"] = Theme.STATUS_DEFAULT;	
						nn.alpha = 1;
						nn.props["image"].visible = true;	        	

	        		}       			        		       		
	        	}
	        });
	    }

										
		/**
		 * Blur the node display
		 */
		public function blurOtherNodes(n:NodeSprite):void
		{
			var root:NodeSprite = _tree.tree.root as NodeSprite;
	        root.visitTreeDepthFirst(function(nn:NodeSprite):void {
				if (n != nn && nn.props["activated"] == false)
				{
					//nn.fillAlpha = 0.5;
					nn.props["image"].alpha = 0.5;
				}
			});
	 	}
	 	
		/**
		 * Cancel any blur / hide effects
		 */
		public function unblurOtherNodes():void
		{
			
			var root:NodeSprite = _tree.tree.root as NodeSprite;
	        root.visitTreeDepthFirst(function(nn:NodeSprite):void {
					nn.props["image"].visible = true;
					nn.props["image"].alpha = 1;
					nn.visible = true;
					 
					showLineWidth(nn);
					hideLine(nn);
//					nn.lineColor = nodes.lineColor;
//					nn.fillColor = nodes.fillColor;
					nn.props["activated"] = false;
			});
	 	}		
	 	
		
		/**
		 * Hide all descendents of the given node from the screen
		 */		
		public function hideAllDescendants(n:NodeSprite):void
		{
			for(var i:uint=0; i<n.childDegree; i++)
			{
				n.getChildNode(i).visible = false;
				n.getChildNode(i).props["image"].visible = false;
				hideAllDescendants(n.getChildNode(i));
			}			
		}
		
		/**
		 * Activate all descendents of the given node from the screen
		 */
		public function activateAllDescendants(n:NodeSprite):void
		{
			markActivated(n);
			for(var i:uint=0; i<n.childDegree; i++)
			{
				activateAllDescendants(n.getChildNode(i));
			}						
		}	 						
	}
}