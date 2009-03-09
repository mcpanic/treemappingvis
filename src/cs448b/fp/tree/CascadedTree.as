package cs448b.fp.tree
{
	import cs448b.fp.utils.*;
	
	import flare.util.Shapes;
	import flare.vis.Visualization;
	import flare.vis.controls.HoverControl;
	import flare.vis.data.EdgeSprite;
	import flare.vis.data.NodeSprite;
	import flare.vis.data.Tree;
	import flare.vis.events.SelectionEvent;
	
	import flash.display.StageQuality;
	import flash.geom.Rectangle;
	
					
	public class CascadedTree extends AbstractTree
	{
		private var vis:Visualization;
		
		private var _tree:Tree;
		private var _x:Number;
		private var _y:Number;
				
		public function CascadedTree(tree:Tree, x:Number, y:Number)
		{
			_tree = tree;
			_x = x;
			_y = y;
//			_tree = GraphUtil.balancedTree(4,5);
		}
		
		public override function init():void
		{
			var e:EdgeSprite, n:NodeSprite;
			
			// create the visualization
			vis = new Visualization(_tree);
			vis.tree.nodes.visit(function(n:NodeSprite):void {
				n.size = Math.random();
				n.shape = Shapes.BLOCK; // needed for treemap sqaures
				n.fillColor = 0xff8888FF; n.lineColor = 0;
				n.fillAlpha = n.lineAlpha = n.depth / 25;
			});
			vis.data.edges.setProperty("visible", false);
			vis.operators.add(new CascadedTreeLayout(_x, _y));
// mcpanic 9307 commented out since bounds is null for unknown reason			
			bounds = new Rectangle(_x, _y, 1024, 768);
			vis.bounds = bounds;
			vis.update();
			addChild(vis);
			
			// create a hover control to highlight nodes on mouse-over
			vis.controls.add(new HoverControl(NodeSprite,
				HoverControl.MOVE_AND_RETURN, rollOver, rollOut));
		}
		
		private function rollOver(evt:SelectionEvent):void {
			var n:NodeSprite = evt.node;
			n.lineColor = 0xffFF0000; n.lineWidth = 2;
			n.fillColor = 0xffFFFFAAAA;
		}
		
		private function rollOut(evt:SelectionEvent):void {
			var n:NodeSprite = evt.node;
			n.lineColor = 0; n.lineWidth = 0;
			n.fillColor = 0xff8888FF;
			n.fillAlpha = n.lineAlpha = n.depth / 25;
		}
		
		public override function resize():void
		{
			if (vis) {
				vis.bounds = bounds;
				vis.update();
			}
		}
		
		public override function play():void
		{
			stage.quality = StageQuality.LOW;
		}
		
		public override function stop():void
		{
			stage.quality = StageQuality.HIGH;
		}
		
	}
}