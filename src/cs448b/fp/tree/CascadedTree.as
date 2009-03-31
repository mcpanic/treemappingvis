package cs448b.fp.tree
{
	import cs448b.fp.utils.*;
	
	import flare.animate.Transitioner;
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
		private var _canvasWidth:Number = 550;
		private var _canvasHeight:Number = 700;
		
//		private var tf:TextField = new TextField();
			
		public function CascadedTree(i:Number, tree:Tree, x:Number, y:Number, isContentTree:Boolean)
		{
			super(i, tree, x, y);
			this.x = x;
			this.y = y;
			this._isContentTree = isContentTree;
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
			
			tf.y = -30;
			tf.textColor = 0xffffffff;
			tf.scaleX = 2;
			tf.scaleY = 2;
			tf.height = 30;
			addChild(tf);
										
			addChild(vis);
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
				n.lineColor = 0xffFF0000; 
				n.lineWidth = 15;
				n.fillColor = 0xffFFFFAAAA;
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
				n.lineColor = 0xff0000FF; 
				n.lineWidth = 15;
				n.fillColor = 0xffFFFFAAAA;				
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
	        root.visitTreeDepthFirst(function(nn:NodeSprite):void {
				if (n != nn && nn.props["selected"] == true)	// unselect previously selected node
				{	
					nn.props["selected"] = false;
				}
				if (nn.props["activated"] == true)
				{
					nn.lineColor = 0xff0000FF;
					nn.lineWidth = 15;
					nn.fillColor = 0xffFFFFAAAA;		
				}			
			});			
			
			if (n.props["selected"] == true)
			{
				n.props["selected"] = false;
				// dispatch mapping event
				dispatchEvent(new MappingEvent(MappingEvent.MOUSE_DOWN, "remove", Number(n.name)));				
			}
			else if (n.props["activated"] == true)
			{
				super.onMouseDown(n);
				blurOtherNodes(n);
				n.lineColor = 0xffFF0000; 
				n.lineWidth = 15;
				n.fillColor = 0xffFFFFAAAA;
				n.props["image"].alpha = 1;
				n.props["selected"] = true;
				// dispatch mapping event
				dispatchEvent(new MappingEvent(MappingEvent.MOUSE_DOWN, "add", Number(n.name)));				
//				if(!nodePulled)
//				{
//					//blurOtherNodes(n);
//					//pullNodeForward(n);
//					//nodePulled = true;
//				
//					tf.text = n.name;
//				}				
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
//			trace(_visualToggle);
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
			n.lineColor = 0xff0000FF; 
			n.lineWidth = 15;
			n.fillColor = 0xffFFFFAAAA;
			n.props["activated"] = true;
			n.props["image"].alpha = 1;			
			for(var i:uint=0; i<n.childDegree; i++)
			{
				activateAllDescendants(n.getChildNode(i));
			}				
		}
		
		public var _currentStep:Number = 0;

		/**
		 * Get the current node shown in the hierarchical matching
		 */					
		public function getCurrentProcessingNode():Number
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
	        trace(ret);
	        return ret;			
		}
	}
}