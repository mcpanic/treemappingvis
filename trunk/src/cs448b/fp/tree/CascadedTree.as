package cs448b.fp.tree
{
	import cs448b.fp.data.SessionManager;
	import cs448b.fp.utils.*;
	import cs448b.fp.ui.*;
	import cs448b.fp.event.ControlsEvent;
	import cs448b.fp.event.MappingEvent;
	
	import flare.animate.Parallel;
	import flare.animate.Pause;
	import flare.animate.Sequence;
	import flare.animate.TransitionEvent;
	import flare.animate.Transitioner;
	import flare.animate.Tween;
	import flare.util.Shapes;
	import flare.vis.Visualization;
	import flare.vis.data.Data;
	import flare.vis.data.NodeSprite;
	import flare.vis.data.Tree;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
						
	public class CascadedTree extends AbstractTree
	{		
		private var _isContentTree:Boolean;		
		private var _isTutorial:Boolean;			
		private var _canvasWidth:Number;
		private var _canvasHeight:Number;

		private var _controls:SingleCascadedTreeControls;
		private var _node:NodeActions;
		private var _panel:Sprite;
//		private var _previewManager:PreviewManager;
		// Order of tree traversal
		public var _traversalOrder:Number = Theme.ORDER_PREORDER;
		
		public var _currentStep:Number = 0;
			
		public function CascadedTree(i:Number, tree:Tree, x:Number, y:Number, canvasWidth:Number, canvasHeight:Number, bContentTree:Boolean)
		{
			this._isContentTree = bContentTree;			
			this._isTutorial = SessionManager.isTutorial();

			this.x = x;
			this.y = y;
			this._canvasWidth = canvasWidth;
			this._canvasHeight = canvasHeight;
			_node = new NodeActions(this, bContentTree);
			_controls = new SingleCascadedTreeControls(_isContentTree);
			super(i, tree, x, y);				
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
						
			//bounds = new Rectangle(_x, _y, 1024, 768);
			bounds = new Rectangle(_x, _y, _canvasWidth, _canvasHeight);
			
			_panel = new Sprite();
			_panel.graphics.beginFill(0x000000);
			// smaller pane for tutorial session
		    if (_isTutorial == true)
		    	_panel.graphics.drawRect(_x, _y, _canvasWidth+30, _canvasHeight/2+30);
		    else
				_panel.graphics.drawRect(_x, _y, _canvasWidth+30, _canvasHeight+30);
			_panel.mouseEnabled = false;
			
//			if (Theme.ENABLE_FULL_PREVIEW == false)
			this.addChild(_panel);			
			if (_isTutorial == true)
		    	_panel.scrollRect = new Rectangle(_x, _y, _canvasWidth+30, _canvasHeight/2+30);
		    else
		    	_panel.scrollRect = new Rectangle(_x, _y, _canvasWidth+30, _canvasHeight+30);
			
			vis.bounds = bounds;
			vis.x = _x+20;
			vis.y = _y+20;
			vis.update();
			
			if (_isTutorial == true)
			{
				vis.scaleX = 0.7;
				vis.scaleY = 0.7;
			}
			else if (SessionManager.isPreview == true)
			{
				vis.scaleX = 1;
				vis.scaleY = 1;
			}
			else
			{
				updateScale(_canvasWidth, _canvasHeight);					          						
			}


			if (Theme.ENABLE_DEBUG == true)
			{
				tf.x = Theme.LAYOUT_NODENAME_X;
				tf.y = Theme.LAYOUT_NODENAME_Y;
				addChild(tf);					
			}
			_controls.addEventListener( ControlsEvent.CONTROLS_UPDATE, onControlsEvent );							
//			if (Theme.ENABLE_FULL_PREVIEW == false)
//			{
				addChild(_controls);						
//				addChild(vis);				
//			}
			_panel.addChild(vis);
		}

		/**
		 * Add all display objects
		 */					
		public function displayTree():void
		{
//			trace(_panel.numChildren + " " +  _panel.getChildIndex(vis));
//			trace("children " + this.numChildren);
//			trace("panel " + this.getChildIndex(_panel));
//			trace("control " + this.getChildIndex(_controls));
//			addChild(_panel);
//			vis.x = 200;
//			vis.y = 200;
//			vis.update();
//trace(_panel.x + "," + _panel.y);
trace(_x + "," + _y);
			trace("here" + this);
			if (this.contains(_panel))
				removeChild(_panel);
			_panel = new Sprite();
			_panel.graphics.beginFill(0xbbbbbb);
			// smaller pane for tutorial session
		    if (_isTutorial == true)
		    	_panel.graphics.drawRect(_x, _y, _canvasWidth+30, _canvasHeight/2+30);
		    else
				_panel.graphics.drawRect(_x, _y, _canvasWidth+30, _canvasHeight+30);
			_panel.mouseEnabled = false;

			
			this.addChild(_panel);			
			if (_isTutorial == true)
		    	_panel.scrollRect = new Rectangle(_x, _y, _canvasWidth+30, _canvasHeight/2+30);
		    else
		    	_panel.scrollRect = new Rectangle(_x, _y, _canvasWidth+30, _canvasHeight+30);
			_panel.addChild(vis);			
		}
		
		/**
		 * Initialize nodes, edges, and layout
		 */					
		protected override function initComponents():void
		{
			// init values		
			nodes = {
				shape: Shapes.BLOCK, // needed for treemap sqaures
				//fillColor: 0x88D5D5ff, 
				fillColor:0xffffffff,
				fillAlpha:0,
				lineColor: 0x00000000,
				lineWidth: 0
			}
			//trace(_isContentTree + " fillAlpha: " + nodes.fillAlpha + " fillHue: " + nodes.fillHue + " fillColor: " + nodes.fillColor.toString(16) + " fillSat: " + nodes.fillSaturation + " fillVal: " + nodes.fillValue);						
			edges = {
				visible: false
			}
			
			_layout = new CascadedTreeLayout(_x, _y, _isContentTree);
			
		}
		
		/**
		 * Initialize node property
		 */					
		protected override function initNode(n:NodeSprite, i:Number):void
		{
			n.fillColor = 0xffffffff;
			n.fillAlpha = 1/100;
			//trace(_isContentTree + " fillAlpha: " + n.fillAlpha + " fillHue: " + n.fillHue + " fillColor: " + n.fillColor.toString(16) + " fillSat: " + n.fillSaturation + " fillVal: " + n.fillValue);			
			n.lineAlpha = 0;//1/25;	
		}

		/**
		 * Mouse event handler main
		 */					
		protected override function handleSyncNodeEvent(n:NodeSprite, evt:Event, isSender:Boolean):void
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
				onMouseDown(n, isSender);
			}
			else if(evt.type == MouseEvent.MOUSE_MOVE)
			{
				onMouseMove(n);
			}
		}

		/**
		 * Event handler for controls
		 */	
		private function onControlsEvent( event:ControlsEvent ):void
		{
			if (event.name == "zoom_in")	
			{
				onZoomInButton();
			}
			else if (event.name == "zoom_out")	
			{
				onZoomOutButton();	
			}
			else if (event.name == "zoom_reset")	
			{
				onZoomResetButton();	
			}				
		}	
		
		/**
		 * Enable button controls
		 */		
		public function enableZoomButtons():void
		{
			_controls.enableZoomButtons();
		}


		/**
		 * Disable button controls
		 */		
		public function disableZoomButtons():void
		{
			_controls.disableZoomButtons();	
		}

		/**
		 * Enable button controls
		 */		
		public function visibleZoomButtons():void
		{
			_controls.visibleZoomButtons();
		}

		/**
		 * Enable button controls
		 */		
		public function invisibleZoomButtons():void
		{
			_controls.invisibleZoomButtons();
		}
								
		/**
		 * Mark the selected node as unmapped
		 */
		public function onUnmapButton():void
		{
			var selectedID:Number = 0;
			var root:NodeSprite = tree.root as NodeSprite;
			// get the selected node
		    root.visitTreeDepthFirst(function(nn:NodeSprite):void {
				if (nn.props["selected"] == true)	// find the selected node
				{	
					selectedID = Number(nn.name);
					_node.markMapping(selectedID, Theme.STATUS_UNMAPPED);					
					//blurOtherNodes(nn);		
					if (Theme.ENABLE_SERIAL == false)
					{
						for(var i:uint=0; i<nn.childDegree; i++)
						{
							_node.markActivated(nn.getChildNode(i));
							//activateAllDescendants(nn.getChildNode(i));
						}		
					}			
					_node.unmarkActivated(nn);
				}			
			});

			blinkNode(getNodeByID(selectedID), onEndBlinkingUnmapped, 2);	
			
			if (_isTutorial == true)
				dispatchEvent(new ControlsEvent( ControlsEvent.STATUS_UPDATE, "tutorial_advance") );			
		}


		/**
		 * Zoom in
		 */
		private function onZoomInButton():void
		{
			if(vis.scaleX < Theme.MAX_ZOOM)
			{
				vis.scaleX *= 1.1;
				vis.scaleY *= 1.1;
			}
		}

		/**
		 * Zoom out
		 */
		private function onZoomOutButton():void
		{
			if(vis.scaleX > Theme.MIN_ZOOM)
			{
				vis.scaleX /= 1.1;
				vis.scaleY /= 1.1;
			}		
		}
		
		/**
		 * Zoom reset
		 */
		private function onZoomResetButton():void
		{
			updateScale(_canvasWidth, _canvasHeight);	
		}
				
		/**
		 * Get an appropriate scale for the tree size based on the inserted width and height
		 */		 	
		public function getScale(canvasWidth:Number, canvasHeight:Number):Number
		{
			var zoomScale:Number;			
			// compute the scale of the original web page vs. canvas
			var wScale:Number =  canvasWidth / tree.root.width;
			var hScale:Number = canvasHeight / tree.root.height;

			// choose the smaller scale and apply
			zoomScale = (wScale > hScale) ? hScale : wScale;
			return zoomScale;
		}

		/**
		 * Update the vis scale based on the inserted width and height
		 */			
		public function updateScale(canvasWidth:Number, canvasHeight:Number):void
		{
			vis.scaleX = getScale(canvasWidth, canvasHeight);
			vis.scaleY = getScale(canvasWidth, canvasHeight);
		}
		
		/**
		 * Mouse cursor over handler
		 */						
		protected override function onMouseOver(n:NodeSprite):void
		{
			// Check if the lock is enforced. It is enforced when popup is open.
			if (NodeActions.lock == true)
				return;
							
			if(n == null || n == tree.root) 
				return;
			if (n.props["selected"] == true && isContentTree == true)
			;
			// Brushing and linking for mapped nodes
			else if (n.props["mapped"] == Theme.STATUS_MAPPED)
			{
				if (Theme.ENABLE_MERGE == true && n.props["selected"] == true)
				{
					n.lineColor = Theme.COLOR_SELECTED;
					n.lineWidth = Theme.LINE_WIDTH;
					if (isContentTree == false)
					{
						//_node.addDropShadow(n);
						_node.addGlow(n, Theme.COLOR_SELECTED);	
						_node.showConnectedNodes(n);	
					}	
					//_node.pullAllChildrenForward(n);
					_node.pullAllConnectedForward(n);						
				}
				else
				{
					n.lineColor = Theme.COLOR_MAPPED;
					n.lineWidth = Theme.LINE_WIDTH;
					if (isContentTree == false)
					{
						//_node.addDropShadow(n);
						_node.addGlow(n, Theme.COLOR_MAPPED);	
						_node.showConnectedNodes(n);	
					}	
					//_node.pullAllChildrenForward(n);
					_node.pullAllConnectedForward(n);						
				}			
			
			}
			else if (n.props["mapped"] == Theme.STATUS_UNMAPPED)
			{
				n.lineColor = Theme.COLOR_UNMAPPED;
				n.lineWidth = Theme.LINE_WIDTH;
				if (isContentTree == false)
				{
					//_node.addDropShadow(n);
					_node.addGlow(n, Theme.COLOR_UNMAPPED);	
					_node.showConnectedNodes(n);	
				}	
				//_node.pullAllChildrenForward(n);
				_node.pullAllConnectedForward(n);				
			}
			// Border change on connected nodes for activated nodes
			else if (n.props["activated"] == true)	// only when activated
			{
				n.lineColor = Theme.COLOR_SELECTED;
				n.lineWidth = Theme.LINE_WIDTH;	
				if (isContentTree == false)
				{
					//_node.addDropShadow(n);
					_node.addGlow(n, Theme.COLOR_SELECTED);	
					_node.showConnectedNodes(n);	
				}	
				//_node.pullAllChildrenForward(n);
				_node.pullAllConnectedForward(n);
			}
		}

		/**
		 * Public version of onMouseOver
		 */
		public function forceOnMouseOver(n:NodeSprite):void
		{
			onMouseOver(n);
		}	
							
		/**
		 * Mouse cursor out handler
		 */			
		protected override function onMouseOut(n:NodeSprite):void
		{
			// Check if the lock is enforced. It is enforced when popup is open.
			if (NodeActions.lock == true)
				return;
							
			if(n == null) 
				return;
			if (n.props["selected"] == true && isContentTree == true)
			;
			else if (n.props["mapped"] == Theme.STATUS_MAPPED)
			{
				// apply the same code as the 'activated' case
				if (Theme.ENABLE_MERGE == true && n.props["selected"] == true)
					_node.hideConnectedNodes(n);
				else
				{
					//n.lineAlpha = 1;					
					_node.hideLine(n);	
					_node.removeFilters(n);
					if (isContentTree == false)
						_node.hideConnectedNodes(n);
					// do not hide if the node is connected to the current selected content node
					if (isContentTree == true)
						_node.showConnectedNodes(getCurrentProcessingNode());	
				}				
			}	
			else if (n.props["mapped"] == Theme.STATUS_UNMAPPED)
			{
				//n.lineAlpha = 1;
				_node.hideLine(n);	
				_node.removeFilters(n);
				if (isContentTree == false)
					_node.hideConnectedNodes(n);				
			}
			else if (n.props["activated"] == true)
			{
				// do not remove selected effects for selected nodes in the 2-click interface
				if (Theme.ENABLE_CONTINUE_BUTTON == true && n.props["selected"] == true)
				{
					//trace("mouse over - selected");
					//_node.markSelected(n);
					//_node.hideLine(n);
					_node.hideConnectedNodes(n);					
				}
				else
				{
					//n.lineColor = Theme.COLOR_ACTIVATED;
					//_node.showLineWidth(n);
					_node.hideLine(n);
					_node.hideConnectedNodes(n);
					_node.removeFilters(n);
				}
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
		 * Process 1 click mapping
		 */	   		
		private function process1Click(n:NodeSprite):void 
		{
			// 1) if mapped, open a popup, get user input, and apply 
					if (n.props["mapped"] == Theme.STATUS_MAPPED)
					{
						if (Theme.ENABLE_MERGE_POPUP == true)
						{
							super.onMouseDown(n);
							//blurOtherNodes(n);
							_node.markSelected(n);
							// dispatch mapping event
							dispatchEvent(new MappingEvent(MappingEvent.MOUSE_DOWN, "add", Number(n.name)));
						}
						else
							return;							
					}
					// 2) not possible; layout nodes do not have 'unmapped' status.
					else if (n.props["mapped"] == Theme.STATUS_UNMAPPED)
						return;	
					// 3) if new, map.
					else
					{
						super.onMouseDown(n);
						//blurOtherNodes(n);
						_node.markSelected(n);
						// dispatch mapping event
						dispatchEvent(new MappingEvent(MappingEvent.MOUSE_DOWN, "add", Number(n.name)));	
						onMouseOver(n);				
					}			
		}
	
		/**
		 * Process 2 click mapping
		 */	   		
		private function process2Click(n:NodeSprite):void 
		{
			var root:NodeSprite = tree.root as NodeSprite;
					// 1) if mapped, open a popup, get user input, and apply 
					if (n.props["mapped"] == Theme.STATUS_MAPPED)
					{
						// unselect previously selected node
						root.visitTreeBreadthFirst(function(nn:NodeSprite):void {
							if (n != nn && nn.props["selected"] == true)	
							{									
								_node.unmarkSelected(nn);
								//onMouseOver(n);
							}			
						});									
						// Under 2-click condition, we allow merge without popups
						if (Theme.ENABLE_MERGE == true)
						{							
							super.onMouseDown(n);
							//blurOtherNodes(n);
							_node.addGlow(n, Theme.COLOR_SELECTED);
							_node.markSelected(n);
							dispatchEvent(new MappingEvent(MappingEvent.MOUSE_DOWN, "select_layout", Number(n.name)));
							// dispatch mapping event
							//dispatchEvent(new MappingEvent(MappingEvent.MOUSE_DOWN, "add", Number(n.name)));																		
						}
//						if (Theme.ENABLE_MERGE_POPUP == true)
//						{							
//							super.onMouseDown(n);
//							//blurOtherNodes(n);
//							_node.markSelected(n);
//							// dispatch mapping event
//							dispatchEvent(new MappingEvent(MappingEvent.MOUSE_DOWN, "add", Number(n.name)));
//						}
//						else
//							return;							
					}
					// 2) not possible; layout nodes do not have 'unmapped' status.
					else if (n.props["mapped"] == Theme.STATUS_UNMAPPED)
						return;	
					// 3) if new, map.
					else
					{
						// unselect previously selected node
						root.visitTreeBreadthFirst(function(nn:NodeSprite):void {
							if (n != nn && nn.props["selected"] == true)	
							{									
								_node.unmarkSelected(nn);
								//onMouseOver(n);
							}			
						});			
						// unselect current if selected twice
						if (n.props["selected"] == true)
						{	
							// uncomment the following three lines to enable 'unselect'						
							//_node.unmarkSelected(n);						
							//dispatchEvent(new MappingEvent(MappingEvent.MOUSE_DOWN, "unselect_layout"));
							//onMouseOver(n);
							
							
							// dispatch mapping event
							//dispatchEvent(new MappingEvent(MappingEvent.MOUSE_DOWN, "remove", Number(n.name)));				
						}
						else if (n.props["activated"] == true)
						{
							super.onMouseDown(n);
							//blurOtherNodes(n);
							_node.markSelected(n);
							dispatchEvent(new MappingEvent(MappingEvent.MOUSE_DOWN, "select_layout", Number(n.name)));
							// dispatch mapping event
							//dispatchEvent(new MappingEvent(MappingEvent.MOUSE_DOWN, "add", Number(n.name)));						
						}											
					}				
		}

	
		/**
		 * Process mapping when content node is NOT serially presented (free-selection)
		 */	   		
		private function processNotSerialMapping(n:NodeSprite):void 
		{
			// 1-click assumed
			// 2-click needs to be implemented if needed
			
				var root:NodeSprite = tree.root as NodeSprite;				
		        root.visitTreeBreadthFirst(function(nn:NodeSprite):void {
					if (n != nn && nn.props["selected"] == true)	
					{	
						// unselect previously selected node
						_node.unmarkSelected(nn);
					}
	//				if (nn.props["activated"] == true)
	//				{
	//					markActivated(nn);
	//				}			
				});			
				
				if (n.props["selected"] == true)
				{
					// unselect current if selected twice
					_node.unmarkSelected(n);
					// dispatch mapping event
					dispatchEvent(new MappingEvent(MappingEvent.MOUSE_DOWN, "remove", Number(n.name)));				
				}
				else if (n.props["activated"] == true)
				{
					super.onMouseDown(n);
					//blurOtherNodes(n);
					_node.markSelected(n);
					// dispatch mapping event
					dispatchEvent(new MappingEvent(MappingEvent.MOUSE_DOWN, "add", Number(n.name)));						
				}				
		}	
					
		/**
		 * Mouse button down handler
		 */	   		
		protected override function onMouseDown(n:NodeSprite, isSender:Boolean = true):void 
		{
//			trace(n.x + " " + n.y + " " + n.width + " " + n.height);
//			trace(n.u + " " + n.v + " " + n.w + " " + n.h);
//			trace(n.props["x"] + " " + n.props["y"] + " " + n.props["width"] + " " + n.props["height"]);
//			if (n.props["image"] != null)
//				trace(n.props["image"].x + " " + n.props["image"].y + " " + n.props["image"].width + " " + n.props["image"].height);
//			if (n.getChildAt(0) != null)
//				trace(n.getChildAt(0).x + " " + n.getChildAt(0).y + " " + n.getChildAt(0).width + " " + n.getChildAt(0).height);
			// no linking effect for mouse click. only mouse-over and out gets linking
			if (isSender == false)
				return;

			// Check if the lock is enforced. It is enforced when popup is open.
			if (NodeActions.lock == true)
				return;
				
			if (Theme.ENABLE_SERIAL == true && isContentTree == true)
				return;
				
			
			if (Theme.ENABLE_SERIAL == true)
			{
				if (Theme.ENABLE_CONTINUE_BUTTON == false)	// 1-click interface
				{
					process1Click(n);
				}
				else	// continue button (2-click interface)
				{
					process2Click(n);			        					
				}
			}
			else
			{	
				processNotSerialMapping(n);
			}			

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
			
			// Blank message shown so that page is clean while loading the next pair
			if (ret == true)
			{
				var message:String = "";
				dispatchEvent(new ControlsEvent( ControlsEvent.STATUS_UPDATE, "complete", 0, message) );				
			}
			return ret;
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
		 * Delegates update vis.
		 */
		public function resetPosition(t:Object = null, ...operators):Transitioner
		{
			vis.x = 0;
			vis.y = 0;
			updateScale(_canvasWidth, _canvasHeight);		
			return vis.update(t, operators);
		}		
				


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

        		
		private var previewSeq:Sequence = new Sequence();
		
		/**
		 * Save a preview sequence with visual effects. Need to be played once all nodes are added. 
		 */
		private function addPreviewNode(node:NodeSprite):void
		{
			//trace("added");
			if (node == null || node == tree.root)	// do not play the root node
				return;	
			
			node.filters = [new GlowFilter(Theme.COLOR_SELECTED, 0.8, 0, 0)];
			var g1:Tween = new Tween(node,Theme.DURATION_PREVIEW,{"filters[0].blurX":5,"filters[0].blurY":5});
			var g2:Tween = new Tween(node,Theme.DURATION_PREVIEW,{"filters[0].blurX":0,"filters[0].blurY":0});
				
			var t1:Tween = new Tween(node, Theme.DURATION_PREVIEW, {lineColor:Theme.COLOR_SELECTED});
			var t2:Tween = new Tween(node, Theme.DURATION_PREVIEW, {lineColor:0x00000000});
			var t3:Tween = new Tween(node, Theme.DURATION_PREVIEW, {lineWidth:Theme.LINE_WIDTH});
			var t4:Tween = new Tween(node, Theme.DURATION_PREVIEW, {lineWidth:0});			
//			var t5:Tween = new Tween(node, Theme.DURATION_PREVIEW, {fillColor:Theme.COLOR_FILL_MAPPED});
//			var t6:Tween = new Tween(node, Theme.DURATION_PREVIEW, {fillColor:0x00000000});
		    
		    previewSeq.add(new Parallel(t1, t3, g1)); 
		    previewSeq.add(new Parallel(t2, t4, g2));       
		}
				
		/**
		 * Preview: play an animation with the current traversal order, 
		 * to give users an overview of the segments they will find correspondences for
		 */
		public function playPreview():void
		{
			if (!_isContentTree)	// nothing if layout tree
				return;
						
			var root:NodeSprite = tree.root as NodeSprite;
			var nodeCount:Number = 1;
			var node:NodeSprite = null;	
			var message:String = "Now showing a preview of mapping order for the task.";
			dispatchEvent( new ControlsEvent( ControlsEvent.STATUS_UPDATE, "feedback", 0, message) );

	        // turn off visibility so that borders do not overlap
	        root.visitTreeDepthFirst(function(nn:NodeSprite):void {
				if (nn != root && nn.props["image"] != null)
					nn.props["image"].visible = false;
	        });			
	        
			while (nodeCount <= tree.nodes.length)
			{
		        root.visitTreeDepthFirst(function(nn:NodeSprite):void {
					if (nn.props["order"] == nodeCount)
					{
						addPreviewNode(nn);
						nodeCount++;
					}	
		        });
	  		}
	        //trace("COUNT:" + nodeCount);
	        // longer delay for users to read instructions
	        if (_isTutorial == true)
	        	previewSeq.delay = 2;
	        else
	        	previewSeq.delay = 1;
	        
		    previewSeq.play(); 
		    		    
		    previewSeq.addEventListener(TransitionEvent.END, onEndPreview);	
		}

		/**
		 * When preview animation finishes playing
		 */		
		private function onEndPreview(e:TransitionEvent):void
		{
			// pause before automatically advancing a step
//		    if (_isTutorial == true)
//		    	new Pause(2);

			// out of the preview mode now
			SessionManager.isPreview = false;
					    	
			// remove all filters
			var root:NodeSprite = tree.root as NodeSprite;
	        root.visitTreeDepthFirst(function(nn:NodeSprite):void {
				_node.removeGlow(nn);
	        });
				
			//dispatchEvent( new ControlsEvent( ControlsEvent.STATUS_UPDATE, "show_tree", 0) );
			dispatchEvent( new ControlsEvent( ControlsEvent.STATUS_UPDATE, "visible_button") );  
			dispatchEvent( new ControlsEvent( ControlsEvent.STATUS_UPDATE, "stage", Theme.STAGE_HIERARCHICAL) );  
			if (Theme.ENABLE_SERIAL == true) 
	       		dispatchEvent( new ControlsEvent( ControlsEvent.STATUS_UPDATE, "continue" ) );  
			
			if (_isTutorial == false)  		
	     		dispatchEvent( new ControlsEvent( ControlsEvent.STATUS_UPDATE, "enable_button", 0) );  
	     	else
	     		dispatchEvent ( new ControlsEvent( ControlsEvent.STATUS_UPDATE, "tutorial_advance", 0) );
		}

//		/**
//		 * return the current vis. 
//		 * used in preview display
//		 */
//		public function getVis():Visualization
//		{
//			return vis;
//		}
		
		/**
		 * When full page preview is over
		 */
		public function onEndFullPreview():void
		{		
			if (!_isContentTree)
				return;			
			// now make the panel and controls visible

			// pause before automatically advancing a step
//		    if (_isTutorial == true)
//		    	new Pause(2);

			// out of the preview mode now
			SessionManager.isPreview = false;		    	
//			// remove all filters
//			var root:NodeSprite = tree.root as NodeSprite;
//	        root.visitTreeDepthFirst(function(nn:NodeSprite):void {
//				_node.removeGlow(nn);
//	        });
			
	     		
	     	dispatchEvent( new ControlsEvent( ControlsEvent.STATUS_UPDATE, "visible_button", 0) );				
			dispatchEvent( new ControlsEvent( ControlsEvent.STATUS_UPDATE, "stage", Theme.STAGE_HIERARCHICAL) );  
			if (Theme.ENABLE_SERIAL == true) 
	       		dispatchEvent( new ControlsEvent( ControlsEvent.STATUS_UPDATE, "continue" ) );  
			
			if (_isTutorial == false)  	
			{	
	     		dispatchEvent( new ControlsEvent( ControlsEvent.STATUS_UPDATE, "enable_button", 0) );  
	  		}
	  		else
	  		{
	     		dispatchEvent ( new ControlsEvent( ControlsEvent.STATUS_UPDATE, "tutorial_advance", 0) );	
	    	}
	     	// should be the last step because everything is re-initialized as the result of show_tree
	     	if (_isTutorial == false)
	     		dispatchEvent( new ControlsEvent( ControlsEvent.STATUS_UPDATE, "show_tree", 0) );				
		}
				
		/**
		 * Play a node blinking visual effects.  
		 */
		public function blinkNode(node:NodeSprite, handler:Function, type:Number):void
		{
			if (node == null)
				return;	
			var t1:Tween;
			if (type == 1)	// mapped
				t1 = new Tween(node, Theme.DURATION_BLINKING, {lineColor:Theme.COLOR_ACTIVATED});
			else			// unmapped
				t1 = new Tween(node, Theme.DURATION_BLINKING, {lineColor:Theme.COLOR_SELECTED});
			var t2:Tween = new Tween(node, Theme.DURATION_BLINKING, {lineColor:0x00000000});
//			var t3:Tween = new Tween(node, Theme.DURATION_BLINKING, {alpha:0});
//			var t4:Tween = new Tween(node, Theme.DURATION_BLINKING, {alpha:1});			
//			var t5:Tween;
//			if (type == 1)	// mapped
//				t5 = new Tween(node, Theme.DURATION_BLINKING, {fillColor:Theme.COLOR_FILL_MAPPED});
//			else 			// unmapped
//				t5 = new Tween(node, Theme.DURATION_BLINKING, {fillColor:Theme.COLOR_FILL_UNMAPPED});
//			var t6:Tween = new Tween(node, Theme.DURATION_BLINKING, {fillColor:0x00000000});
			var t7:Tween = new Tween(node, Theme.DURATION_BLINKING, {lineWidth:Theme.LINE_WIDTH});
			var t8:Tween = new Tween(node, Theme.DURATION_BLINKING, {lineWidth:0});
		    var seq:Sequence = new Sequence(
			    new Parallel(t1, t7), 
			    new Parallel(t2, t8)      
		    );
		    seq.play();
		    
		    // it is null for layout node animation
		    if (handler != null)
		    	seq.addEventListener(TransitionEvent.END, handler);	
		}


		/**
		 * When node blinking animation finishes playing for unmapped nodes
		 */		
		private function onEndBlinkingUnmapped(e:TransitionEvent):void
		{
			var message:String = "Assigned as no mapping";
			dispatchEvent( new ControlsEvent( ControlsEvent.STATUS_UPDATE, "unmap", 0, message) );    
			
			// Check if the whole content tree is completed.
			checkCompleted();
			
			// Explicitly move to the next step, also called from onUnmapButton in CascadedTree.as
			if (Theme.ENABLE_SERIAL == true)	
				dispatchEvent( new ControlsEvent( ControlsEvent.STATUS_UPDATE, "continue" ) );  	        		
		}

										
		private var _nodeCount:Number;
		
		/**
		 * Assign the traversal order of the tree
		 */
		public function setTraversalOrder(isTutorial:Boolean):void
		{
			if (!_isContentTree)	// nothing if layout tree
				return;
			_nodeCount = 1;
			// initialize the tree
			var root:NodeSprite = tree.root as NodeSprite;
			if (isTutorial == true || _traversalOrder == Theme.ORDER_BFS)
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
		 	else if (_traversalOrder == Theme.ORDER_PREORDER_RANDOM)
		 	{
		        root.visitTreeBreadthFirst(function(nn:NodeSprite):void {
		        	nn.props["traversed"] = false;
		        });		 
		        preorderRandom(tree.root);		
		 	}	        				
		}


		/**
		 * Preorder traversal algorithm with child selection in order
		 */		
		private function preorder(nn:NodeSprite):void
		{
			var nextNode:NodeSprite = null;
			nn.props["order"] = _nodeCount;
			nn.props["traversed"] = true;
			 
			// if any child is not traversed, randomly pick one and recursively call preorder
			while (1)
			{
				// if all children are traversed, then return
				if (isAllChildrenTraversed(nn) == true)
					break;
				for (var i:uint = 0; i < nn.childDegree; i++)
				{				
					nextNode = nn.getChildNode(i);
					if (nextNode.props["traversed"] == false)	// if not traversed, break. Otherwise, get another one.
					{
						_nodeCount++;
						preorder(nextNode);
					}
				}					
			}			
		}
		
		/**
		 * Preorder traversal algorithm with random child selection
		 */		
		private function preorderRandom(nn:NodeSprite):void
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
					preorderRandom(randomNode);
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
				if (n.props["image"] != null)
					n.props["image"].visible = _visualToggle;				
			}, Data.NODES);
		
			vis.update(1, "nodes").play();
		}	    				
	}
}