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
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
						
	public class CascadedTree extends AbstractTree
	{		
		private var _isContentTree:Boolean;		
		private var _isPreview:Boolean;			
		private var _canvasWidth:Number = Theme.LAYOUT_CANVAS_WIDTH;
		private var _canvasHeight:Number = Theme.LAYOUT_CANVAS_HEIGHT;
		private var _title:TextSprite;
		private var _unmapButton:Button;
		private var _zoomInButton:Button;
		private var _zoomOutButton:Button;
		private var _zoomResetButton:Button;
		private var _node:NodeActions;
		// Order of tree traversal
		public var _traversalOrder:Number = Theme.ORDER_PREORDER;
		
		public var _currentStep:Number = 0;
			
		public function CascadedTree(i:Number, tree:Tree, x:Number, y:Number, bContentTree:Boolean, bPreview:Boolean)
		{
			this._isContentTree = bContentTree;			
			this._isPreview = bPreview;
			super(i, tree, x, y);
			this.x = x;
			this.y = y;
			_node = new NodeActions(this, bContentTree);
//			
//			var _popupManager:PopupManager = new PopupManager();
//			_popupManager.init();
//			addChild(_popupManager);
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
			
			if (_isPreview == true)
			{
				vis.scaleX = 0.7;
				vis.scaleY = 0.7;
			}
			else
			{
				vis.scaleX = getScale();
				vis.scaleY = getScale();          						
			}
			tf.x = Theme.LAYOUT_NODENAME_X;
			tf.y = Theme.LAYOUT_NODENAME_Y;

			if (Theme.ENABLE_DEBUG == true)
				addChild(tf);			
			addLabel();
			addUnmapButton();	
			addZoomInButton();
			addZoomOutButton();
			addZoomResetButton();								
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
            _title.textMode = TextSprite.DEVICE;	
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
           	_unmapButton.enabled = false;
           	_unmapButton.useHandCursor = true;
           	addChild(_unmapButton);  			
		}
		
		/**
		 * Enable button controls
		 */		
		public function enableUnmapButton():void
		{
			_unmapButton.enabled = true;
		}

		/**
		 * Disable button controls
		 */		
		public function disableUnmapButton():void
		{
			_unmapButton.enabled = false;		
		}

		/**
		 * Enable button controls
		 */		
		public function enableZoomButtons():void
		{
			_zoomInButton.enabled = true;
			_zoomOutButton.enabled = true;
			_zoomResetButton.enabled = true;
		}


		/**
		 * Disable button controls
		 */		
		public function disableZoomButtons():void
		{
			_zoomInButton.enabled = false;
			_zoomOutButton.enabled = false;
			_zoomResetButton.enabled = false;			
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
			
			if (_isPreview == true)
				dispatchEvent(new ControlsEvent( ControlsEvent.STATUS_UPDATE, "tutorial_advance") );			
		}

		
		/**
		 * Add zoom-in button for each tree layout
		 */		
		private function addZoomInButton():void
		{		
			_zoomInButton = new Button();
			_zoomInButton.label = Theme.LABEL_ZOOM_IN;
			_zoomInButton.toggle = true;
			_zoomInButton.x = Theme.LAYOUT_ZOOM_X;
			_zoomInButton.y = Theme.LAYOUT_ZOOM_Y;
			_zoomInButton.width = Theme.LAYOUT_ZOOM_WIDTH;			
           	_zoomInButton.addEventListener(MouseEvent.CLICK, onZoomInButton);
           	_zoomInButton.setStyle("textFormat", Theme.FONT_BUTTON); 
           	_zoomInButton.enabled = false;
           	_zoomInButton.useHandCursor = true;
           	addChild(_zoomInButton);  			
		}

		/**
		 * Add zoom-out button for each tree layout
		 */		
		private function addZoomOutButton():void
		{		
			_zoomOutButton = new Button();
			_zoomOutButton.label = Theme.LABEL_ZOOM_OUT;
			_zoomOutButton.toggle = true;
			_zoomOutButton.x = Theme.LAYOUT_ZOOM_X + Theme.LAYOUT_ZOOM_WIDTH + 10 + Theme.LAYOUT_ZOOM_RESET_WIDTH + 10;
			_zoomOutButton.y = Theme.LAYOUT_ZOOM_Y;
			_zoomOutButton.width = Theme.LAYOUT_ZOOM_WIDTH;			
           	_zoomOutButton.addEventListener(MouseEvent.CLICK, onZoomOutButton);
           	_zoomOutButton.setStyle("textFormat", Theme.FONT_BUTTON); 
           	_zoomOutButton.enabled = false;
           	_zoomOutButton.useHandCursor = true;
           	addChild(_zoomOutButton);  			
		}

		/**
		 * Add zoom-reset button for each tree layout
		 */		
		private function addZoomResetButton():void
		{		
			_zoomResetButton = new Button();
			_zoomResetButton.label = Theme.LABEL_ZOOM_RESET;
			_zoomResetButton.toggle = true;
			_zoomResetButton.x = Theme.LAYOUT_ZOOM_X + Theme.LAYOUT_ZOOM_WIDTH + 10;
			_zoomResetButton.y = Theme.LAYOUT_ZOOM_Y;
			_zoomResetButton.width = Theme.LAYOUT_ZOOM_RESET_WIDTH;			
           	_zoomResetButton.addEventListener(MouseEvent.CLICK, onZoomResetButton);
           	_zoomResetButton.setStyle("textFormat", Theme.FONT_BUTTON); 
           	_zoomResetButton.enabled = false;
           	_zoomResetButton.useHandCursor = true;
           	addChild(_zoomResetButton);  			
		}

		/**
		 * Zoom in
		 */
		private function onZoomInButton(event:MouseEvent):void
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
		private function onZoomOutButton(event:MouseEvent):void
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
		private function onZoomResetButton(event:MouseEvent):void
		{
			vis.scaleX = getScale();
			vis.scaleY = getScale();		
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
				//fillColor: 0x88D5D5ff, 
				//fillColor:0x00000000,
				lineColor: 0x00000000,
				lineWidth: 0
			}
			
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
			n.fillAlpha = 0;//1/25;
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
		
		private var oldNode:NodeSprite = null;

		/**
		 * Mouse cursor move handler
		 */	
//		protected function onMouseMove(n:NodeSprite):void 
//		{
//			Rectangle.contains( Point )	
//		}		
		/**
		 * Mouse cursor over handler
		 */						
		protected override function onMouseOver(n:NodeSprite):void
		{
			// Check if the lock is enforced. It is enforced when popup is open.
			if (NodeActions.lock == true)
				return;
							
			if(n == null || n == tree.root)// || oldNode == n) 
				return;
			if (n.props["selected"] == true && isContentTree == true)
			;
			// Brushing and linking for mapped nodes
			else if (n.props["mapped"] == Theme.STATUS_MAPPED)
			{
				n.lineColor = Theme.COLOR_ACTIVATED;
				n.lineWidth = Theme.LINE_WIDTH;
				//n.lineAlpha = Theme.ALPHA_MAPPED;	
				//n.fillColor = Theme.COLOR_FILL_MAPPED;	
				if (isContentTree == false)
				{
					//_node.addDropShadow(n);
					//_node.addGlow(n);	
					_node.showConnectedNodes(n);	
				}	
				pullAllChildrenForward(n);
//				pullNodeForward(n);	
//					for (var i:uint=0; i<n.childDegree; i++)
//						pullNodeForward(n.getChildNode(i));					
			}
			else if (n.props["mapped"] == Theme.STATUS_UNMAPPED)
			{
				n.lineColor = Theme.COLOR_SELECTED;
				n.lineWidth = Theme.LINE_WIDTH;
				//n.lineAlpha = Theme.ALPHA_MAPPED;			
				//n.fillColor = Theme.COLOR_FILL_UNMAPPED;
				if (isContentTree == false)
					_node.showConnectedNodes(n);
				pullAllChildrenForward(n);				
			}
			// Border change on connected nodes for activated nodes
			else if (n.props["activated"] == true)	// only when activated
			{
				//n.lineColor = 0xffFF0000; 
				//n.lineWidth = 15;
				n.lineColor = Theme.COLOR_SELECTED;
				n.lineWidth = Theme.LINE_WIDTH;	
				_node.addDropShadow(n);
				_node.addGlow(n);			
				
				_node.showConnectedNodes(n);
				//pullNodeForward(n);	
				pullAllChildrenForward(n);
////				if (nodePulled == false)
////				{
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
			// Check if the lock is enforced. It is enforced when popup is open.
			if (NodeActions.lock == true)
				return;
							
			if(n == null) 
				return;
			if (n.props["selected"] == true && isContentTree == true)
			;
			else if (n.props["mapped"] == Theme.STATUS_MAPPED || n.props["mapped"] == Theme.STATUS_UNMAPPED)
			{
				//n.lineAlpha = 1;
				_node.hideLine(n);	
				if (isContentTree == false)
					_node.hideConnectedNodes(n);				
			}	
			else if (n.props["activated"] == true)
			{
				n.lineColor = Theme.COLOR_ACTIVATED;
				_node.showLineWidth(n);
				_node.hideConnectedNodes(n);
				_node.removeFilters(n);
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
		 * Mouse button down handler
		 */	   		
		protected override function onMouseDown(n:NodeSprite, isSender:Boolean = true):void 
		{
			// no linking effect for mouse click. only mouse-over and out gets linking
			if (isSender == false)
				return;

			// Check if the lock is enforced. It is enforced when popup is open.
			if (NodeActions.lock == true)
				return;
				
			if (Theme.ENABLE_SERIAL == true && isContentTree == true)
				return;
				
			var root:NodeSprite = tree.root as NodeSprite;
			if (Theme.ENABLE_SERIAL == true)
			{
				// 1) if mapped, open a popup, get user input, and apply 
				if (n.props["mapped"] == Theme.STATUS_MAPPED)
				{
					if (Theme.ENABLE_MERGE == true)
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
				}
			}
			else
			{					
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

		}
		
		private var _idx:Number;
				
//		private var nodePulled:Boolean = false;

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
			vis.scaleX = getScale();
			vis.scaleY = getScale();			
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
			
			node.filters = [new GlowFilter(0xff0000, 0.8, 0, 0)];
			var g1:Tween = new Tween(node,Theme.DURATION_PREVIEW,{"filters[0].blurX":15,"filters[0].blurY":15});
			var g2:Tween = new Tween(node,Theme.DURATION_PREVIEW,{"filters[0].blurX":0,"filters[0].blurY":0});
				
			var t1:Tween = new Tween(node, Theme.DURATION_PREVIEW, {lineColor:Theme.COLOR_SELECTED});
			var t2:Tween = new Tween(node, Theme.DURATION_PREVIEW, {lineColor:0x00000000});
			var t3:Tween = new Tween(node, Theme.DURATION_PREVIEW, {lineWidth:Theme.LINE_WIDTH});
			var t4:Tween = new Tween(node, Theme.DURATION_PREVIEW, {lineWidth:0});			
			var t5:Tween = new Tween(node, Theme.DURATION_PREVIEW, {fillColor:Theme.COLOR_FILL_MAPPED});
			var t6:Tween = new Tween(node, Theme.DURATION_PREVIEW, {fillColor:0x00000000});
		    
//		    previewSeq.add(test(node, new Transitioner(0.1)));
		    previewSeq.add(new Parallel(t1, t3, g1)); 
		    previewSeq.add(new Parallel(t2, t4, g2));      
		}
		
		private function test(n:NodeSprite, t:Transitioner):Transitioner
		{
//			pullNodeForward(n);
//			for (var i:int=0; i<s.numChildren; ++i) {
//				var b:DisplayObject = s.getChildAt(i);
//				t.$(b).x = (w+a) * (xb + points[2*i]);
//				t.$(b).y = (h+a) * (yb + points[2*i+1]);
//			}

			var p:DisplayObjectContainer = n.parent;
			_idx = p.getChildIndex(n);
			t.$(p).setChildIndex(n, p.numChildren-1);		
			return t;
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
				if (nn != root)
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
	        previewSeq.delay = 1;
		    previewSeq.play();  
		    previewSeq.addEventListener(TransitionEvent.END, onEndPreview);	
		}

		/**
		 * When preview animation finishes playing
		 */		
		private function onEndPreview(e:TransitionEvent):void
		{
			// remove all filters
			var root:NodeSprite = tree.root as NodeSprite;
	        root.visitTreeDepthFirst(function(nn:NodeSprite):void {
				_node.removeGlow(nn);
	        });
				
			dispatchEvent( new ControlsEvent( ControlsEvent.STATUS_UPDATE, "stage", Theme.STAGE_HIERARCHICAL) );  
			if (Theme.ENABLE_SERIAL == true) 
	       		dispatchEvent( new ControlsEvent( ControlsEvent.STATUS_UPDATE, "continue" ) );  
			
			if (_isPreview == false)  		
	     		dispatchEvent( new ControlsEvent( ControlsEvent.STATUS_UPDATE, "showbutton", 0) );  
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
			var t3:Tween = new Tween(node, Theme.DURATION_BLINKING, {alpha:0});
			var t4:Tween = new Tween(node, Theme.DURATION_BLINKING, {alpha:1});			
			var t5:Tween;
			if (type == 1)	// mapped
				t5 = new Tween(node, Theme.DURATION_BLINKING, {fillColor:Theme.COLOR_FILL_MAPPED});
			else 			// unmapped
				t5 = new Tween(node, Theme.DURATION_BLINKING, {fillColor:Theme.COLOR_FILL_UNMAPPED});
			var t6:Tween = new Tween(node, Theme.DURATION_BLINKING, {fillColor:0x00000000});
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
		public function setTraversalOrder(isPreview:Boolean):void
		{
			if (!_isContentTree)	// nothing if layout tree
				return;
			_nodeCount = 1;
			// initialize the tree
			var root:NodeSprite = tree.root as NodeSprite;
			if (isPreview == true || _traversalOrder == Theme.ORDER_BFS)
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
	}
}