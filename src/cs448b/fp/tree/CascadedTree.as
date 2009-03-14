package cs448b.fp.tree
{
	import cs448b.fp.utils.*;
	
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
		public function CascadedTree(i:Number, tree:Tree, x:Number, y:Number)
		{
			super(i, tree, x, y);
		}
		
		public override function init():void
		{	
			super.init();

			bounds = new Rectangle(_x, _y, 1024, 768);
			vis.bounds = bounds;
			
			vis.update();
			
			addChild(vis);
		}
		
		protected override function initComponents():void
		{
			// init values		
			nodes = {
				shape: Shapes.BLOCK, // needed for treemap sqaures
				fillColor: 0x88D5D5FF, 
				lineColor: 0
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
			if(n == null) return;
			n.lineColor = 0xffFF0000; 
			n.lineWidth = 15;
			n.fillColor = 0xffFFFFAAAA;
		}
		
		protected override function onMouseOut(n:NodeSprite):void
		{
			if(n == null) return;
			n.lineColor = 0; 
			n.lineWidth = 0;
			n.fillColor = nodes.fillColor;//0xff8888FF;
			//n.fillAlpha = n.lineAlpha = 1 / 25;
			
			if(nodePulled)
			{
				unblurOtherNodes(n);
				pushNodeback(n);
				nodePulled = false;
			}
		}
		
		private var nodePulled:Boolean = false;
		
		protected override function onMouseUp(n:NodeSprite):void 
		{
			if(nodePulled)
			{
				unblurOtherNodes(n);
				pushNodeback(n);
				nodePulled = false;
			}
		}
   		
		protected override function onMouseDown(n:NodeSprite):void 
		{
			if(!nodePulled)
			{
				blurOtherNodes(n);
				pullNodeForward(n);
				nodePulled = true;
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

		private function unblurOtherNodes(n:NodeSprite):void
		{
			var root:NodeSprite = tree.root as NodeSprite;
	        root.visitTreeDepthFirst(function(nn:NodeSprite):void {
					//nn.fillAlpha = 1;
					nn.props["image"].alpha = 1;
			});
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
			trace(_visualToggle);
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