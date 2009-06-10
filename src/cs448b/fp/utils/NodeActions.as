package cs448b.fp.utils
{
	import cs448b.fp.tree.AbstractTree;
	
	import flare.vis.data.NodeSprite;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.filters.BitmapFilter;
	
	/**
	 * All node-level actions, including visual effects and status save & loading
	 */ 
	public class NodeActions
	{
		// interaction lock
		public static var lock:Boolean = false;
		
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
			//return;
			var filter:BitmapFilter = Theme.getDropShadowFilter();
			var myFilters:Array = new Array(filter);
			n.filters = myFilters;
		}
		
		/**
		 * Add glow effect to the node
		 */ 
		public function addGlow(n:NodeSprite, color:Number, alpha:Number = 0.8, blurX:Number = 3, blurY:Number = 3):void
		{
//			return;
			var filter:BitmapFilter = Theme.getGlowFilter(color, alpha, blurX, blurY);
			var myFilters:Array = new Array(filter);
			n.filters = myFilters;
		}

		/**
		 * Add glow and shadow effect to the node
		 */ 
		public function addGlowShadow(n:NodeSprite, color:Number, alpha:Number = 0.8, blurX:Number = 3, blurY:Number = 3):void
		{
//			return;
			var glow:BitmapFilter = Theme.getGlowFilter(color, alpha, blurX, blurY);
			var shadow:BitmapFilter = Theme.getDropShadowFilter();
			var myFilters:Array = new Array(glow, shadow);
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
		public function removeFilters(n:NodeSprite):void
		{
			n.filters = null;			
		}
				
		/**
		 * Wrapper for removeFilters
		 */ 
		public function removeGlow(n:NodeSprite):void
		{
			removeFilters(n);
		//	trace("removeGlow for " + n.name);
		}	
		
		/** 
		 * Apply visual effects for connected node
		 */		 
		private function showConnectedEffects(n:NodeSprite):void
		{
			//return;
			// no effect for already selected nodes
			if (Theme.ENABLE_CONTINUE_BUTTON == true && n.props["selected"] == true)
				return;
				
			n.lineColor = Theme.COLOR_CONNECTED;
			//n.lineWidth = 5;
			//trace(n.lineWidth);
			n.lineWidth = Theme.CONNECTED_LINE_WIDTH;
			n.lineAlpha = Theme.CONNECTED_ALPHA;
			//addGlow(n, Theme.CONNECTED_ALPHA, 5, 5);
		}

		/** 
		 * Remove visual effects for connected node
		 */		 
		private function hideConnectedEffects(n:NodeSprite):void
		{
			// no effect for already selected nodes
			if (Theme.ENABLE_CONTINUE_BUTTON == true && n.props["selected"] == true)
				return;
			hideLine(n);
			removeFilters(n);	
		}
				
		/** 
		 * Show connected nodes
		 */		 
		public function showConnectedNodes(n:NodeSprite):void
		{
			if (n == null)
				return;
			if (n.parentNode != null && n.parentNode != _tree.tree.root)
			{
				// parent
				showConnectedEffects(n.parentNode);
				// siblings
				for (var i:uint=0; i<n.parentNode.childDegree; i++)
				{
					// not me!
					if (n.parentNode.getChildNode(i) != n)
						showConnectedEffects(n.parentNode.getChildNode(i));
				}
			}
			// children
			for (i=0; i<n.childDegree; i++)
			{
				showConnectedEffects(n.getChildNode(i));
			}			
		}

		/** 
		 * Remove effects of showConnectedNodes
		 */		 
		public function hideConnectedNodes(n:NodeSprite):void
		{
			if (n.parentNode != null && n.parentNode != _tree.tree.root)
			{
				// parent
				hideConnectedEffects(n.parentNode);
				// siblings
				for (var i:uint=0; i<n.parentNode.childDegree; i++)
				{
					// not me!
					if (n.parentNode.getChildNode(i) != n)
						hideConnectedEffects(n.parentNode.getChildNode(i));
				}
			}
			// children
			for (i=0; i<n.childDegree; i++)
			{
				hideConnectedEffects(n.getChildNode(i));
			}			
		}		


		/** 
		 * Recursively pull forward all the connected nodes
		 */		 
		public function pullAllConnectedForward(n:NodeSprite):void
		{
			// parent and sibling
			if (n.parentNode != null && n.parentNode != _tree.tree.root)
			{				
				pullAllChildrenForward(n.parentNode);
			}
			// me and children
			pullAllChildrenForward(n);		
		}
		
		/**
		 * Recursively pull forward all children nodes
		 */		 
		public function pullAllChildrenForward(n:NodeSprite):void
		{
			pullNodeForward(n);	
			for (var i:uint=0; i<n.childDegree; i++)
				pullAllChildrenForward(n.getChildNode(i));			
		}
		
		/**
		 * Pull up the node display (higher on the cascaded stack)
		 */		
		public function pullNodeForward(n:DisplayObject):Number
		{
			var index:Number;
			var p:DisplayObjectContainer = n.parent;
			index = p.getChildIndex(n);
			
			p.setChildIndex(n, p.numChildren-1);
			return index;
		}

		/**
		 * Push back the node display (lower on the cascaded stack)
		 */		
		public function pushNodeBack(n:DisplayObject, index:Number):void
		{
			n.parent.setChildIndex(n, index);
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
			// 9605 FIREBUG_LTREE == false means showing only activated nodes 
			// while preserving ancerstor-descendent constraint						
			else 
			{
				hideLine(nn);
				removeFilters(nn);	
			}
		}


		/**
		 * Mark the nodes as activated, both internally and visually
		 */			
		public function markActivated(nn:NodeSprite):void
		{
			nn.visible = true;
			//nn.getChildAt(0).visible = false;
			//nn.visible = false;
			nn.props["activated"] = true;
			nn.lineColor = Theme.COLOR_ACTIVATED;
			showLineWidth(nn);
			if (nn.props["image"] != null)
				nn.props["image"].alpha = 1;

			if (nn.props["mapped"] == Theme.STATUS_MAPPED)
			{
				hideLine(nn);
				removeFilters(nn);	
			}
		}

		/**
		 * Mark the node as selected, both internally and visually
		 */			
		public function markSelected(nn:NodeSprite):void
		{
			nn.props["selected"] = true;
			nn.lineColor = Theme.COLOR_SELECTED;
			//showLineWidth(nn);
			nn.lineWidth = Theme.LINE_WIDTH;
			if (nn.props["image"] != null)
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
				removeFilters(nn);	
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
						//nn.fillColor = Theme.COLOR_FILL_MAPPED;
						hideLine(nn);
						removeFilters(nn);	
						nn.alpha = Theme.ALPHA_MAPPED;
						if (nn.props["image"] != null)
							nn.props["image"].visible = Theme.SHOW_MAPPPED;	
	        		}	 
	        		else if (action == Theme.STATUS_UNMAPPED)
	        		{
	        			nn.props["mapped"] = Theme.STATUS_UNMAPPED;	
						//nn.fillColor = Theme.COLOR_FILL_UNMAPPED;
						hideLine(nn);
						removeFilters(nn);	
						nn.alpha = Theme.ALPHA_MAPPED;
						if (nn.props["image"] != null)
							nn.props["image"].visible = Theme.SHOW_MAPPPED;		        		
	        		}
	        		else
	        		{
	        			nn.props["mapped"] = Theme.STATUS_DEFAULT;	
						nn.alpha = 1;
						if (nn.props["image"] != null)
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
					if (nn.props["image"] != null)
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
					if (nn.props["image"] != null)
					{
						nn.props["image"].visible = true;
						nn.props["image"].alpha = 1;
					}
					nn.visible = true;
					 
					showLineWidth(nn);
					hideLine(nn);
					removeFilters(nn);	
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
				if (n.getChildNode(i).props["image"] != null)
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