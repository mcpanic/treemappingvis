package cs448b.fp.tree
{
	import cs448b.fp.utils.*;
	
	import fl.controls.Button;
	
	import flare.animate.Parallel;
	import flare.animate.Sequence;
	import flare.animate.TransitionEvent;
	import flare.animate.Transitioner;
	import flare.animate.Tween;
	import flare.display.TextSprite;
	import flare.util.Shapes;
	import flare.vis.data.Data;
	import flare.vis.data.NodeSprite;
	import flare.vis.data.Tree;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
						
	public class CascadedTree extends AbstractTree
	{		
		private var _isContentTree:Boolean;					
		private var _canvasWidth:Number = Theme.LAYOUT_CANVAS_WIDTH;
		private var _canvasHeight:Number = Theme.LAYOUT_CANVAS_HEIGHT;
		private var _title:TextSprite;
		private var _unmapButton:Button;
		// Order of tree traversal
		private var _traversalOrder:Number = Theme.ORDER_DFS;
			
		public function CascadedTree(i:Number, tree:Tree, x:Number, y:Number, bContentTree:Boolean)
		{
			this._isContentTree = bContentTree;			
			super(i, tree, x, y);
			this.x = x;
			this.y = y;
		}

		/**
		 * is this content or layout tree?
		 */			
		public function get isContentTree():Boolean
		{
			return _isContentTree;
		}

		/**
		 * Vis and tree-specific controls initialization - general controls are in CascadedTreeControls.as
		 */			
		public override function init():void
		{	
			super.init();

			bounds = new Rectangle(_x, _y, 1024, 768);
			vis.bounds = bounds;		
			vis.update();
			
			vis.scaleX = getScale();
			vis.scaleY = getScale();          						
			tf.x = Theme.LAYOUT_NODENAME_X;
			tf.y = Theme.LAYOUT_NODENAME_Y;

			addChild(tf);			
			addLabel();
			addUnmapButton();									
			addChild(vis);
		}

		/**
		 * Add tree name labels
		 */				
		private function addLabel():void
		{
            _title = new TextSprite("", Theme.FONT_LABEL); 
            _title.horizontalAnchor = TextSprite.CENTER;
            if (_isContentTree == true)
            	_title.text = Theme.LABEL_CONTENT;
            else
            	_title.text = Theme.LABEL_LAYOUT;
            	
            _title.x = Theme.LAYOUT_TREENAME_X;
            _title.y = Theme.LAYOUT_TREENAME_Y;
            addChild( _title );			
		}
		
		/**
		 * Add unmap button for each tree layout
		 */		
		private function addUnmapButton():void
		{
			if (isContentTree == false)
				return;			
			_unmapButton = new Button();
			_unmapButton.label = Theme.LABEL_NOMAPPING;
			_unmapButton.toggle = true;
			_unmapButton.x = Theme.LAYOUT_UNMAP_X;
			_unmapButton.y = Theme.LAYOUT_UNMAP_Y;
			_unmapButton.width = Theme.LAYOUT_UNMAP_WIDTH;			
           	_unmapButton.addEventListener(MouseEvent.CLICK, onUnmapButton);
           	_unmapButton.setStyle("textFormat", Theme.FONT_BUTTON); 
           	addChild(_unmapButton);  			
		}

		private var previewSeq:Sequence = new Sequence();
		
		/**
		 * Save a preview sequence with visual effects. Need to be played once all nodes are added. 
		 */
		private function addPreviewNode(node:NodeSprite):void
		{
			if (node == null)
				return;	
			var t1:Tween = new Tween(node, 0.5, {lineColor:Theme.COLOR_SELECTED});
			var t2:Tween = new Tween(node, 0.5, {lineColor:0x00000000});
			var t3:Tween = new Tween(node, 0.5, {lineWidth:Theme.LINE_WIDTH});
			var t4:Tween = new Tween(node, 0.5, {lineWidth:0});			
			var t5:Tween = new Tween(node, 0.5, {fillColor:Theme.COLOR_FILL_MAPPED});
			var t6:Tween = new Tween(node, 0.5, {fillColor:0x00000000});
			//var t7:Tween = new Tween(node, 0.5, {fillColor:Theme.COLOR_FILL_MAPPED});
			//var t6:Tween = new Tween(node, 0.5, {fillColor:0x00000000});
//		    var seq:Sequence = new Sequence(
		    previewSeq.add(new Parallel(t1, t3, t5)); 
		    previewSeq.add(new Parallel(t2, t4, t6));      
//		    );
		}
		
		/**
		 * Preview: play an animation with the current traversal order, 
		 * to give users an overview of the segments they will find correspondences for
		 */
		public function playPreview():void
		{
			if (!_isContentTree)	// nothing if layout tree
				return;
			
			var message:String = "Watch this preview of segments for the mapping task";
			dispatchEvent( new ControlsEvent( ControlsEvent.STATUS_UPDATE, "feedback", 0, message) );    
							
			var root:NodeSprite = tree.root as NodeSprite;
			var nodeCount:Number = 1;
			var node:NodeSprite = null;	

	        root.visitTreeDepthFirst(function(nn:NodeSprite):void {
				if (nn.props["order"] == nodeCount)
				{
					message = "Watch this preview of segments for the mapping task. Now displaying " + nodeCount + " of " + tree.nodes.length;
					dispatchEvent( new ControlsEvent( ControlsEvent.STATUS_UPDATE, "feedback", 0, message) );
					addPreviewNode(nn);
				}		
	        	nodeCount++;
	        });
		    previewSeq.play();  
		    previewSeq.addEventListener(TransitionEvent.END, onEndPreview);	
		}

		/**
		 * When preview animation finishes playing
		 */		
		private function onEndPreview(e:TransitionEvent):void
		{
			//trace("here");
			dispatchEvent( new ControlsEvent( ControlsEvent.STATUS_UPDATE, "stage", Theme.STAGE_HIERARCHICAL) );  
			if (Theme.ENABLE_SERIAL == true) 
	       		dispatchEvent( new ControlsEvent( ControlsEvent.STATUS_UPDATE, "continue" ) );  
	        		
		}
		
		/**
		 * Play a node blinking visual effects.  
		 */
		public function blinkNode(node:NodeSprite, handler:Function):void
		{
			if (node == null)
				return;	
			var t1:Tween = new Tween(node, 0.5, {lineColor:Theme.COLOR_SELECTED});
			var t2:Tween = new Tween(node, 0.5, {lineColor:0x00000000});
			var t3:Tween = new Tween(node, 0.5, {alpha:0});
			var t4:Tween = new Tween(node, 0.5, {alpha:1});			
			var t5:Tween = new Tween(node, 0.5, {fillColor:Theme.COLOR_FILL_MAPPED});
			var t6:Tween = new Tween(node, 0.5, {fillColor:0x00000000});
			
		    var seq:Sequence = new Sequence(
			    new Parallel(t1, t5), new Parallel(t2, t6)      
		    );
		    seq.play();
		    seq.addEventListener(TransitionEvent.END, handler);	
		}


		/**
		 * When node blinking animation finishes playing for unmapped nodes
		 */		
		private function onEndBlinkingUnmapped(e:TransitionEvent):void
		{
			//trace("here");
 
			//var message:String = "Assigned as no mapping: " + selectedID;	
			var message:String = "Assigned as no mapping";
			dispatchEvent( new ControlsEvent( ControlsEvent.STATUS_UPDATE, "unmap", 0, message) );    
			
			// Check if the whole content tree is completed.
			checkCompleted();
			
			// Explicitly move to the next step, also called from onUnmapButton in CascadedTree.as
			if (Theme.ENABLE_SERIAL == true)	
				dispatchEvent( new ControlsEvent( ControlsEvent.STATUS_UPDATE, "continue" ) );  	        		
		}

										
		/**
		 * Mark the selected node as unmapped
		 */
		private function onUnmapButton(event:MouseEvent):void
		{
			var selectedID:Number = 0;
			var root:NodeSprite = tree.root as NodeSprite;
			// get the selected node
		    root.visitTreeDepthFirst(function(nn:NodeSprite):void {
				if (nn.props["selected"] == true)	// find the selected node
				{	
					selectedID = Number(nn.name);
					markMapping(selectedID, Theme.STATUS_UNMAPPED);					
					//blurOtherNodes(nn);		
					if (Theme.ENABLE_SERIAL == false)
					{
						for(var i:uint=0; i<nn.childDegree; i++)
						{
							markActivated(nn.getChildNode(i));
							//activateAllDescendants(nn.getChildNode(i));
						}		
					}			
					unmarkActivated(nn);
				}			
			});

			blinkNode(getNodeByID(selectedID), onEndBlinkingUnmapped);			
		}

		
		/**
		 * Check if the whole content tree mapping is completed.
		 * Sends a 'complete' event if mapping is completed.
		 */
		public function checkCompleted():Boolean
		{
			var ret:Boolean = true;
			// Only valid for content tree
			if (isContentTree == false)
				return false;
			var root:NodeSprite = tree.root as NodeSprite;
	        root.visitTreeDepthFirst(function(nn:NodeSprite):void {
				if (nn.props["mapped"] == null || nn.props["mapped"] == Theme.STATUS_DEFAULT)	// see if unmapped
				{	
					ret = false;
				}			
			});
			
			if (ret == true)
			{
				var message:String = "Mapping completed!";
				dispatchEvent(new ControlsEvent( ControlsEvent.STATUS_UPDATE, "complete", 0, message) );				
			}
			return ret;
		}

		/**
		 * Adjust the tree size based on the scale of canvas size and actual page size
		 */		 	
		private function getScale():Number
		{
			var zoomScale:Number;			
			// compute the scale of the original web page vs. canvas
			var wScale:Number = _canvasWidth / tree.root.width;
			var hScale:Number = _canvasHeight / tree.root.height;

			// choose the smaller scale and apply
			zoomScale = (wScale > hScale) ? hScale : wScale;
			return zoomScale;
		}

		/**
		 * Initialize nodes, edges, and layout
		 */					
		protected override function initComponents():void
		{
			// init values		
			nodes = {
				shape: Shapes.BLOCK, // needed for treemap sqaures
				fillColor: 0x88D5D5ff, 
				lineColor: 0x00000000,
				lineWidth: 0
			}
			
			edges = {
				visible: false
			}
			
			_layout = new CascadedTreeLayout(_x, _y);
			
		}
		
		/**
		 * Initialize node property
		 */					
		protected override function initNode(n:NodeSprite, i:Number):void
		{
			n.fillAlpha = 1/25;
			n.lineAlpha = 1/25;	
		}

		/**
		 * Mouse event handler main
		 */					
		protected override function handleSyncNodeEvent(n:NodeSprite, evt:Event):void
		{
			if(evt.type == MouseEvent.MOUSE_OVER)
			{
				onMouseOver(n);
			} 
			else if(evt.type == MouseEvent.MOUSE_OUT)
			{
				onMouseOut(n);
			}
			else if(evt.type == MouseEvent.MOUSE_UP)
			{
				onMouseUp(n);
			}
			else if(evt.type == MouseEvent.MOUSE_DOWN)
			{
				onMouseDown(n);
			}
			else if(evt.type == MouseEvent.MOUSE_MOVE)
			{
				onMouseUp(n);
			}
		}
		
		private var oldNode:NodeSprite = null;
		
		/**
		 * Mouse cursor over handler
		 */						
		protected override function onMouseOver(n:NodeSprite):void
		{
			if(n == null || n == tree.root)// || oldNode == n) 
				return;
			if (n.props["selected"] == true)
			;
			// Brushing and linking for mapped nodes
			else if (n.props["mapped"] == Theme.STATUS_MAPPED)
			{
				n.lineColor = Theme.COLOR_ACTIVATED;
				n.lineWidth = Theme.LINE_WIDTH;			
				pullAllChildrenForward(n);
//				pullNodeForward(n);	
//					for (var i:uint=0; i<n.childDegree; i++)
//						pullNodeForward(n.getChildNode(i));					
			}
			else if (n.props["mapped"] == Theme.STATUS_UNMAPPED)
			{
				n.lineColor = Theme.COLOR_SELECTED;
				n.lineWidth = Theme.LINE_WIDTH;			
				pullAllChildrenForward(n);				
			}
			// Border change on connected nodes for activated nodes
			else if (n.props["activated"] == true)	// only when activated
			{
				//n.lineColor = 0xffFF0000; 
				//n.lineWidth = 15;
				n.lineColor = Theme.COLOR_SELECTED;
				n.lineWidth = Theme.LINE_WIDTH;					
				//n.fillColor = 0xffFFFFAAAA;
				showConnectedNodes(n);
				pullAllChildrenForward(n);
////				if (nodePulled == false)
////				{
////					trace("hello");
//					pullNodeForward(n);	
//					for (i=0; i<n.childDegree; i++)
//						pullNodeForward(n.getChildNode(i));
////					nodePulled = true;
////				}
			}

			//oldNode = n;
		}
						
		/**
		 * Mouse cursor out handler
		 */			
		protected override function onMouseOut(n:NodeSprite):void
		{
			if(n == null) 
				return;
			if (n.props["selected"] == true)
			;
			else if (n.props["mapped"] == Theme.STATUS_MAPPED || n.props["mapped"] == Theme.STATUS_UNMAPPED)
			{
				hideLine(n);					
			}	
			else if (n.props["activated"] == true)
			{
//				n.lineColor = 0xff0000FF; 
//				n.lineWidth = 15;
				n.lineColor = Theme.COLOR_ACTIVATED;
				showLineWidth(n);
				hideConnectedNodes(n);
//				if (nodePulled == true)
//				{
//					pushNodeBack(n);	
//					for (var i:uint=0; i<n.childDegree; i++)
//						pushNodeBack(n.getChildNode(i));
//					nodePulled = false;
//				}
				//n.lineWidth = Theme.LINE_WIDTH;		
//				n.fillColor = 0xffFFFFAAAA;				
			}
		
//			n.lineColor = nodes.lineColor;
//			n.lineWidth = nodes.lineWidth;
//			n.fillColor = nodes.fillColor;//0xff8888FF;
			//n.fillAlpha = n.lineAlpha = 1 / 25;
			
//			if(nodePulled)
//			{
//				unblurOtherNodes();
//				pushNodeback(n);
//				nodePulled = false;
//			}
		}

		/** 
		 * Show connected nodes
		 */		 
		private function showConnectedNodes(n:NodeSprite):void
		{
			n.parentNode.lineColor = Theme.COLOR_SELECTED;
			n.parentNode.lineWidth = Theme.LINE_WIDTH / Theme.CONNECTED_LINE_WIDTH;
			n.parentNode.lineAlpha = Theme.CONNECTED_ALPHA;
			
			for (var i:uint=0; i<n.childDegree; i++)
			{
				n.getChildNode(i).lineColor = Theme.COLOR_SELECTED;
				n.getChildNode(i).lineWidth = Theme.LINE_WIDTH / Theme.CONNECTED_LINE_WIDTH;
				n.getChildNode(i).lineAlpha = Theme.CONNECTED_ALPHA;
			}			
		}

		/** 
		 * Remove effects of showConnectedNodes
		 */		 
		private function hideConnectedNodes(n:NodeSprite):void
		{
			hideLine(n.parentNode);
						
			for (var i:uint=0; i<n.childDegree; i++)
			{
				hideLine(n.getChildNode(i));
			}			
		}
				
		private var nodePulled:Boolean = false;

		/**
		 * Recursively pull forward the nodes
		 */		 
		private function pullAllChildrenForward(n:NodeSprite):void
		{
			pullNodeForward(n);	
			for (var i:uint=0; i<n.childDegree; i++)
				pullAllChildrenForward(n.getChildNode(i));			
		}
		
		/**
		 * Mouse button up handler
		 */			
		protected override function onMouseUp(n:NodeSprite):void 
		{
//			if(nodePulled)
//			{
//				unblurOtherNodes(n);
//				pushNodeback(n);
//				nodePulled = false;
//			}
		}

		/**
		 * Mouse button down handler
		 */	   		
		protected override function onMouseDown(n:NodeSprite):void 
		{
			if (Theme.ENABLE_SERIAL == true && isContentTree == true)
			{
				// do nothing
			}
			else
			{
				//var isUnselect:Boolean = false;
				var root:NodeSprite = tree.root as NodeSprite;
		        root.visitTreeBreadthFirst(function(nn:NodeSprite):void {
					if (n != nn && nn.props["selected"] == true)	
					{	
						// unselect previously selected node
						unmarkSelected(nn);
					}
	//				if (nn.props["activated"] == true)
	//				{
	//					markActivated(nn);
	//				}			
				});			
				
				if (n.props["selected"] == true)
				{
					// unselect current if selected twice
					unmarkSelected(n);
					// dispatch mapping event
					dispatchEvent(new MappingEvent(MappingEvent.MOUSE_DOWN, "remove", Number(n.name)));				
				}
				else if (n.props["activated"] == true)
				{
					super.onMouseDown(n);
					//blurOtherNodes(n);
					markSelected(n);
					// dispatch mapping event
					dispatchEvent(new MappingEvent(MappingEvent.MOUSE_DOWN, "add", Number(n.name)));						
				}
			}			

		}
		
		private var _idx:Number;

		/**
		 * Pull up the node display (higher on the cascaded stack)
		 */		
		public function pullNodeForward(n:DisplayObject):void
		{
			var p:DisplayObjectContainer = n.parent;
			_idx = p.getChildIndex(n);
			
			p.setChildIndex(n, p.numChildren-1);
		}

		/**
		 * Push back the node display (lower on the cascaded stack)
		 */		
		public function pushNodeBack(n:DisplayObject):void
		{
			n.parent.setChildIndex(n, _idx);
		}	

		/**
		 * Blur the node display
		 */
		public function blurOtherNodes(n:NodeSprite):void
		{
			var root:NodeSprite = tree.root as NodeSprite;
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
			var root:NodeSprite = tree.root as NodeSprite;
	        root.visitTreeDepthFirst(function(nn:NodeSprite):void {
					nn.props["image"].visible = true;
					nn.props["image"].alpha = 1;
					nn.visible = true;
					 
					showLineWidth(nn);
					nn.lineColor = nodes.lineColor;
					nn.fillColor = nodes.fillColor;
					nn.props["activated"] = false;
			});
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
			var root:NodeSprite = tree.root as NodeSprite;
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
			var root:NodeSprite = tree.root as NodeSprite;
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
			nn.lineColor = nodes.lineColor; 
			showLineWidth(nn);
			//nn.lineWidth = nodes.lineWidth;
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
				nn.lineColor = nodes.lineColor; 
				nn.lineWidth = nodes.lineWidth;				
			}		
		}

		/**
		 * Mark the node as deactivated given the ID, both internally and visually
		 */			
		public function unmarkActivatedID(id:Number):void
		{
			var root:NodeSprite = tree.root as NodeSprite;
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
			var root:NodeSprite = tree.root as NodeSprite;
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
			var root:NodeSprite = tree.root as NodeSprite;				        
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
		 * Hide line display, called when cancelling any line change effect
		 */			
		private function hideLine(nn:NodeSprite):void
		{
			nn.lineWidth = 0;			
			nn.lineColor = 0x00000000;
		}
		
		/**
		 * Show line width based on the current theme setting
		 */	
		private function showLineWidth(nn:NodeSprite):void
		{
			if (isContentTree == true && Theme.FIREBUG_CTREE == false)
				nn.lineWidth = Theme.LINE_WIDTH;
			else if (isContentTree == false && Theme.FIREBUG_LTREE == false)
				nn.lineWidth = Theme.LINE_WIDTH;
			else 
				hideLine(nn);
		}

		/**
		 * Get the maximum tree depth
		 */				    
		public function getMaxTreeDepth():uint
		{
			var maxDepth:uint = 0;
			var root:NodeSprite = tree.root as NodeSprite;
	        root.visitTreeDepthFirst(function(nn:NodeSprite):void {
				if (maxDepth < nn.depth)
					maxDepth = nn.depth;
			});			
			return maxDepth;
		}

		/**
		 * Apply the visible depth effect
		 */				
		public override function setVisibleDepth(d:Number):void 
		{
			var tree:Tree = vis.data as Tree;
			if(tree == null ) return;
			
			tree.visit(function(n:NodeSprite):void
			{
				if(n.depth > d)
				{
					n.visible = false;
				}
				else 
				{
					n.visible = true;
				}
				
			}, Data.NODES);
			
			vis.update(1, "nodes").play();
		}

		/**
		 * Apply the visual toggle effect
		 */		
		public function setVisualToggle():void 
		{	
			var tree:Tree = vis.data as Tree;
			_visualToggle = !_visualToggle;
			if(tree == null ) return;
			
			tree.visit(function(n:NodeSprite):void
			{
				n.props["image"].visible = _visualToggle;
				//n.props["image"].alpha = 0.5;					
			}, Data.NODES);
		
			vis.update(1, "nodes").play();
		}
		
		/**
		 * Delegates update vis.
		 */
		public function resetPosition(t:Object = null, ...operators):Transitioner
		{
			vis.x = 0;
			vis.y = 0;
			vis.scaleX = getScale();
			vis.scaleY = getScale();			
			return vis.update(t, operators);
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

				
		public var _currentStep:Number = 0;

		/**
		 * Get the current node ID shown in the hierarchical matching
		 */					
		public function getCurrentProcessingNodeID():Number
		{
			if (!_isContentTree)	// nothing if layout tree
				return -1;
			var ret:NodeSprite = null;
			ret = getCurrentProcessingNode();
			if (ret == null)
				return -1;
			return Number(ret.name);	
		}
		
		/**
		 * Get the current node shown in the hierarchical matching
		 */					
		public function getCurrentProcessingNode():NodeSprite
		{
			if (!_isContentTree)	// nothing if layout tree
				return null;
			var root:NodeSprite = tree.root as NodeSprite;
//			var nodeCount:Number = 1;
			var node:NodeSprite = null;	

	        root.visitTreeDepthFirst(function(nn:NodeSprite):void {
				if (nn.props["order"] == _currentStep)
					node = nn;
//	        	if (nodeCount == _currentStep)
//	        		node = nn;
//	        	nodeCount++;
	        });

	        return node;			
		}		

		private var _nodeCount:Number;
		
		/**
		 * Assign the traversal order of the tree
		 */
		public function setTraversalOrder():void
		{
			if (!_isContentTree)	// nothing if layout tree
				return;
			_nodeCount = 1;
			// initialize the tree
			var root:NodeSprite = tree.root as NodeSprite;
			if (_traversalOrder == Theme.ORDER_BFS)
			{	
		        root.visitTreeBreadthFirst(function(nn:NodeSprite):void {
		        	nn.props["traversed"] = false;
		        	nn.props["order"] = _nodeCount; 
		        	_nodeCount++;
		        });
		 	}
		 	else if (_traversalOrder == Theme.ORDER_DFS)
		 	{
		        root.visitTreeDepthFirst(function(nn:NodeSprite):void {
		        	nn.props["traversed"] = false;
		        	nn.props["order"] = _nodeCount; 
		        	_nodeCount++;
		        });		 		
		 	}    
		 	else if (_traversalOrder == Theme.ORDER_PREORDER)
		 	{
		        root.visitTreeBreadthFirst(function(nn:NodeSprite):void {
		        	nn.props["traversed"] = false;
		        });		 
		        preorder(tree.root);		
		 	}
	        				
		}

		/**
		 * Preorder traversal algorithm with random child selection
		 */		
		private function preorder(nn:NodeSprite):void
		{
			var randomNode:NodeSprite = null;
			nn.props["order"] = _nodeCount;
			nn.props["traversed"] = true;
			 
			// if any child is not traversed, randomly pick one and recursively call preorder
			while (1)
			{
				// if all children are traversed, then return
				if (isAllChildrenTraversed(nn) == true)
					break;
				randomNode = nn.getChildNode(getRandomNumberWithinRange(nn.childDegree));
				if (randomNode.props["traversed"] == false)	// if not traversed, break. Otherwise, get another one.
				{
					_nodeCount++;
					preorder(randomNode);
				}	
				
			}
			
		}
		
		/**
		 * See if all children nodes have been traversed
		 */				
		private function isAllChildrenTraversed(nn:NodeSprite):Boolean
		{
			var ret:Boolean = true;
			if (nn.childDegree == 0)	// if no child, it means everything is traversed
				return true;
			for (var i:uint=0; i<nn.childDegree; i++)
			{
				if (nn.getChildNode(i).props["traversed"] == false)
					ret = false;
			}
			return ret;
		}
		
		/**
		 * Get a random number between 0 and n
		 */
		private function getRandomNumberWithinRange(n:Number):Number
		{
			var ret:Number = Math.floor(Math.random() * (n)); 
			return ret;
		}
		
		/**
		 * Get the node with the given ID
		 */					
		public function getNodeByID(id:Number):NodeSprite
		{
			var root:NodeSprite = tree.root as NodeSprite;
			var node:NodeSprite = null;	
	        root.visitTreeBreadthFirst(function(nn:NodeSprite):void {
	        	if (Number(nn.name) == id)
	        		node = nn;
	        });

	        return node;			
		}	
		
		/**
		 * Get the ID of the given node 
		 */					
		public function getIDByNode(nn:NodeSprite):Number
		{
			return Number(nn.name);
	    }					
	}
}