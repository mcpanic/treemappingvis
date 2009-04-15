package cs448b.fp.tree
{
	import cs448b.fp.utils.*;
	
	import fl.controls.Button;
	
	import flare.animate.Transitioner;
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
	import flash.text.TextFormat;
						
	public class CascadedTree extends AbstractTree
	{		
		private var _isContentTree:Boolean;					
		private var _canvasWidth:Number = 550;
		private var _canvasHeight:Number = 700;
		private var _title:TextSprite;
//		private var _textFormat:TextFormat;
		private var _unmapButton:Button;
				
//		private var tf:TextField = new TextField();
			
		public function CascadedTree(i:Number, tree:Tree, x:Number, y:Number, bContentTree:Boolean)
		{
			this._isContentTree = bContentTree;			
			super(i, tree, x, y);
			this.x = x;
			this.y = y;

		}
		
		public function get isContentTree():Boolean
		{
			return _isContentTree;
		}
		
		public override function init():void
		{	
			super.init();

			bounds = new Rectangle(_x, _y, 1024, 768);
			vis.bounds = bounds;
			
			vis.update();
			
			vis.scaleX = getScale();
			vis.scaleY = getScale();
			
//			_textFormat = new TextFormat("Verdana,Tahoma,Arial",14,0,false);
//			_textFormat.color = "0xFFFFFF";

            						
			tf.x = 10;
			tf.y = -20;
			//tf.scaleX = 2;
			//tf.scaleY = 2;
			//tf.height = 30;
			addChild(tf);
			
			addLabel();
			addUnmapButton();
										
			addChild(vis);
		}
		
		private function addLabel():void
		{
            _title = new TextSprite("", Theme.FONT_LABEL); //_textFormat);
            _title.horizontalAnchor = TextSprite.CENTER;
            if (_isContentTree == true)
            	_title.text = Theme.LABEL_CONTENT;
            else
            	_title.text = Theme.LABEL_LAYOUT;
            	
            _title.x = 270;
            _title.y = -20;
            addChild( _title );			
		}
		
		/**
		 * Add unmap button for each tree layout
		 */		
		private function addUnmapButton():void
		{
//			var tf:TextFormat;
//			tf = new TextFormat("Verdana,Tahoma,Arial",12,0,false);
//			tf.color = "0xFFFFFF";
						
			_unmapButton = new Button();
			_unmapButton.label = Theme.LABEL_NOMAPPING;
			_unmapButton.toggle = true;
			_unmapButton.x = 200;
			_unmapButton.y = 500;
			_unmapButton.width = 150;			
           	_unmapButton.addEventListener(MouseEvent.CLICK, onUnmapButton);
           	_unmapButton.setStyle("textFormat", Theme.FONT_BUTTON); //tf);
           	addChild(_unmapButton);  			
		}

		
		/**
		 * Mark the selected node as unmapped
		 */
		private function onUnmapButton(event:MouseEvent):void
		{
			var selectedID:Number = 0;
			// get the selected node
			var root:NodeSprite = tree.root as NodeSprite;
	        root.visitTreeDepthFirst(function(nn:NodeSprite):void {
				if (nn.props["selected"] == true)	// find the selected node
				{	
					selectedID = Number(nn.name);
					markMapping(selectedID, 2);					
					blurOtherNodes(nn);		
					for(var i:uint=0; i<nn.childDegree; i++)
					{
						//markActivated(nn.getChildNode(i));
						activateAllDescendants(nn.getChildNode(i));
					}					
				}			
			});								
			var message:String = "Assigned as no mapping: " + selectedID;	
			dispatchEvent( new ControlsEvent( ControlsEvent.STATUS_UPDATE, "unmap", selectedID, message) );    
		}
				
		private function getScale():Number
		{
			var zoomScale:Number;			
			// compute the scale of the original web page vs. canvas
			var wScale:Number = _canvasWidth / tree.root.width;
			var hScale:Number = _canvasHeight / tree.root.height;
			trace (wScale +  " " + hScale);
			// choose the smaller scale and apply
			zoomScale = (wScale > hScale) ? hScale : wScale;
			return zoomScale;
		}
		
		protected override function initComponents():void
		{
			// init values		
			nodes = {
				shape: Shapes.BLOCK, // needed for treemap sqaures
				fillColor: 0x88D5D5ff, 
				lineColor: 0x00000000,
				lineWidth: 1
			}
			
			edges = {
				visible: false
			}
			
			_layout = new CascadedTreeLayout(_x, _y);
			
		}
		
		protected override function initNode(n:NodeSprite, i:Number):void
		{
			n.fillAlpha = 1/25;
			n.lineAlpha = 1/25;	
		}
		
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
		
		protected override function onMouseOver(n:NodeSprite):void
		{
			if(n == null) 
				return;
			if (n.props["selected"] == true)
			;
			else if (n.props["activated"] == true)	// only when activated
			{
				//n.lineColor = 0xffFF0000; 
				//n.lineWidth = 15;
				n.lineColor = Theme.COLOR_SELECTED;
				n.lineWidth = Theme.LINE_WIDTH;
				
				//n.fillColor = 0xffFFFFAAAA;
			}
		}
		
		protected override function onMouseOut(n:NodeSprite):void
		{
			if(n == null) 
				return;
			if (n.props["selected"] == true)
			;
			else if (n.props["activated"] == true)
			{
//				n.lineColor = 0xff0000FF; 
//				n.lineWidth = 15;
				n.lineColor = Theme.COLOR_ACTIVATED;
				n.lineWidth = Theme.LINE_WIDTH;				
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
		
		private var nodePulled:Boolean = false;
		
		protected override function onMouseUp(n:NodeSprite):void 
		{
//			if(nodePulled)
//			{
//				unblurOtherNodes(n);
//				pushNodeback(n);
//				nodePulled = false;
//			}
		}
   		
		protected override function onMouseDown(n:NodeSprite):void 
		{
			//var isUnselect:Boolean = false;
			var root:NodeSprite = tree.root as NodeSprite;
	        root.visitTreeBreadthFirst(function(nn:NodeSprite):void {
				if (n != nn && nn.props["selected"] == true)	
				{	
					// unselect previously selected node
					unmarkSelected(nn);
				}
				if (nn.props["activated"] == true)
				{
					markActivated(nn);
				}			
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
				blurOtherNodes(n);
				markSelected(n);
				// dispatch mapping event
				dispatchEvent(new MappingEvent(MappingEvent.MOUSE_DOWN, "add", Number(n.name)));						
			}
			

		}
		
		private var _idx:Number;
		
		private function pullNodeForward(n:DisplayObject):void
		{
			var p:DisplayObjectContainer = n.parent;
			_idx = p.getChildIndex(n);
			p.setChildIndex(n, p.numChildren-1);
		}
		
		private function pushNodeback(n:DisplayObject):void
		{
			n.parent.setChildIndex(n, _idx);
		}	

		public function blurOtherNodes(n:NodeSprite):void
		{
			var root:NodeSprite = tree.root as NodeSprite;
	        root.visitTreeDepthFirst(function(nn:NodeSprite):void {
				if (n != nn && nn.props["activated"] == false)
				//if (n != nn)
				{
					//nn.fillAlpha = 0.5;
					nn.props["image"].alpha = 0.5;
				}
			});
	 	}

		public function unblurOtherNodes():void
		{
			var root:NodeSprite = tree.root as NodeSprite;
	        root.visitTreeDepthFirst(function(nn:NodeSprite):void {
					//nn.fillAlpha = 1;
					nn.props["image"].visible = true;
					nn.props["image"].alpha = 1;
					nn.visible = true;
					nn.lineColor = nodes.lineColor; 
					nn.lineWidth = nodes.lineWidth;
					nn.fillColor = nodes.fillColor;
					nn.props["activated"] = false;
			});
	 	}

		// Mark the nodes as activated, both internally and visually
		public function markActivated(nn:NodeSprite):void
		{
			nn.props["activated"] = true;
//			nn.lineColor = 0xff0000FF; 
//			nn.lineWidth = 15;
			nn.lineColor = Theme.COLOR_ACTIVATED;
			nn.lineWidth = Theme.LINE_WIDTH;
			//nn.fillColor = 0xffFFFFAAAA;
			nn.props["image"].alpha = 1;
		}

		// Mark the node as selected, both internally and visually
		public function markSelected(nn:NodeSprite):void
		{
			nn.props["selected"] = true;
//			nn.lineColor = 0xffFF0000; 
//			nn.lineWidth = 15;
			nn.lineColor = Theme.COLOR_SELECTED;
			nn.lineWidth = Theme.LINE_WIDTH;
			//nn.fillColor = 0xffFFFFAAAA;
			nn.props["image"].alpha = 1;
		}

		// Mark the nodes as activated given the ID, both internally and visually
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

		// Mark the nodes as selected given the ID, both internally and visually
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
		
		// Unmark the nodes as activated, both internally and visually
		public function unmarkActivated(nn:NodeSprite):void
		{
			nn.props["activated"] = false;
			nn.lineColor = nodes.lineColor; 
			nn.lineWidth = nodes.lineWidth;
		}

		// Unmark the nodes as selected, both internally and visually
		public function unmarkSelected(nn:NodeSprite):void
		{
			nn.props["selected"] = false;
			if (nn.props["activated"] == true)
			{
//				nn.lineColor = 0xff0000FF; 
//				nn.lineWidth = 15;			
				nn.lineColor = Theme.COLOR_ACTIVATED;
				nn.lineWidth = Theme.LINE_WIDTH;					
			}
			else
			{
				nn.lineColor = nodes.lineColor; 
				nn.lineWidth = nodes.lineWidth;				
			}		

		}

		// Unmark the nodes as activated given the ID, both internally and visually
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

		// Unmark the nodes as selected given the ID, both internally and visually
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
										
		// Mark the nodes that are mapped, both internally and visually
		public function markMapping(id:Number, action:Number):void
		{	
			var root:NodeSprite = tree.root as NodeSprite;				        
	        root.visitTreeBreadthFirst(function(nn:NodeSprite):void {			
	        	if (id == Number(nn.name))
	        	{	
	        		if (action == 1)
	        		{
						nn.props["mapped"] = 1;	// 1: mapped, 2: unmapped, 0: null (default)
						//nn.fillColor = 0xffFFAAAAFF;
						nn.fillColor = Theme.COLOR_FILL_MAPPED;
						nn.props["image"].visible = false;	        		
	        		}	 
	        		else if (action == 2)
	        		{
	        			nn.props["mapped"] = 2;	// 1: mapped, 2: unmapped, 0: null (default)
						//nn.fillColor = 0xffFFFFAAAA;
						nn.fillColor = Theme.COLOR_FILL_UNMAPPED;
						nn.props["image"].visible = false;	        		
	        		}
	        		else
	        		{
	        			nn.props["mapped"] = 0;	// 1: mapped, 2: unmapped, 0: null (default)
						nn.props["image"].visible = true;	        	

	        		}       			        		       		
	        	}
	        });
	    }
	    
		public function getDepth():uint
		{
			var maxDepth:uint = 0;
			var root:NodeSprite = tree.root as NodeSprite;
	        root.visitTreeDepthFirst(function(nn:NodeSprite):void {
				if (maxDepth < nn.depth)
					maxDepth = nn.depth;
			});			
			return maxDepth;
		}
		
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
			n.visible = true;
//			n.lineColor = 0xff0000FF; 
//			n.lineWidth = 15;
			n.lineColor = Theme.COLOR_ACTIVATED;
			n.lineWidth = Theme.LINE_WIDTH;
			//n.fillColor = 0xffFFFFAAAA;
			n.props["activated"] = true;
			n.props["image"].visible = true;
			n.props["image"].alpha = 1;			
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
			var root:NodeSprite = tree.root as NodeSprite;
			var nodeCount:Number = 1;
			var ret:Number = -1;	
	        root.visitTreeBreadthFirst(function(nn:NodeSprite):void {
	        	if (nodeCount == _currentStep)
	        		ret = Number(nn.name);
	        	nodeCount++;
	        });
	        trace("getCurrentProcessingNodeID: " + ret);
	        return ret;			
		}
		
		/**
		 * Get the current node shown in the hierarchical matching
		 */					
		public function getCurrentProcessingNode():NodeSprite
		{
			if (!_isContentTree)	// nothing if layout tree
				return null;
			var root:NodeSprite = tree.root as NodeSprite;
			var nodeCount:Number = 1;
			var node:NodeSprite = null;	
	        root.visitTreeBreadthFirst(function(nn:NodeSprite):void {
	        	if (nodeCount == _currentStep)
	        		node = nn;
	        	nodeCount++;
	        });

	        return node;			
		}		
	}
}