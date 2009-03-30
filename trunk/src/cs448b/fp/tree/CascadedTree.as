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
		private var _canvasWidth:Number = 550;
		private var _canvasHeight:Number = 700;
		
//		private var tf:TextField = new TextField();
			
		public function CascadedTree(i:Number, tree:Tree, x:Number, y:Number)
		{
			super(i, tree, x, y);
			this.x = x;
			this.y = y;
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
			n.lineColor = 0xffFF0000; 
			n.lineWidth = 15;
			n.fillColor = 0xffFFFFAAAA;
		}
		
		protected override function onMouseOut(n:NodeSprite):void
		{
			if(n == null) 
				return;
			n.lineColor = nodes.lineColor; 
			n.lineWidth = nodes.lineWidth;
			n.fillColor = nodes.fillColor;//0xff8888FF;
			//n.fillAlpha = n.lineAlpha = 1 / 25;
			
			if(nodePulled)
			{
				unblurOtherNodes();
				pushNodeback(n);
				nodePulled = false;
			}
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
			super.onMouseDown(n);
			blurOtherNodes(n);
//			if(!nodePulled)
//			{
//				blurOtherNodes(n);
//				pullNodeForward(n);
//				nodePulled = true;
//			
//				tf.text = n.name;
//			}
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

		private function blurOtherNodes(n:NodeSprite):void
		{
			var root:NodeSprite = tree.root as NodeSprite;
	        root.visitTreeDepthFirst(function(nn:NodeSprite):void {
				if (n != nn)
				{
					//nn.fillAlpha = 0.5;
					nn.props["image"].alpha = 0.5;
				}
			});
	 	}

		private function unblurOtherNodes():void
		{
			var root:NodeSprite = tree.root as NodeSprite;
	        root.visitTreeDepthFirst(function(nn:NodeSprite):void {
					//nn.fillAlpha = 1;
					nn.props["image"].alpha = 1;
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
		
		private var _currentStep:Number = 0;
		public function showNextStep():void
		{
			_currentStep++;
			var root:NodeSprite = tree.root as NodeSprite;
			var nodeCount:Number = 0;
	        root.visitTreeBreadthFirst(function(nn:NodeSprite):void {
	        	unblurOtherNodes();
	        	if (nodeCount == _currentStep)	// found the current node to look at
	        	{
					if (nn.numChildren == 0) // don't do anything, onto the next node
					{
						return;
					}
					else	// show on the screen
					{
						nn.visible = true;
						nn.lineColor = 0xffFF0000; 
						nn.lineWidth = 15;
						nn.fillColor = 0xffFFFFAAAA;
						blurOtherNodes(nn);								
					}	        		
//					if (_currentStep != nn.depth)
//					{
//						//nn.props["image"].alpha = 0.5;
//						nn.lineColor = nodes.lineColor; 
//						nn.lineWidth = nodes.lineWidth;
//						nn.fillColor = nodes.fillColor;//0xff8888FF;	
//						nn.visible = false;				
//					}
//					else
//					{										
//					}
	        	}
	        	nodeCount++;
			});			
		}
	}
}