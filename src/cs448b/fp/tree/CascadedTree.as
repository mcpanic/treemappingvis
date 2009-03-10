package cs448b.fp.tree
{
	import cs448b.fp.utils.*;
	
	import flare.util.Shapes;
	import flare.vis.Visualization;
	import flare.vis.controls.HoverControl;
	import flare.vis.data.Data;
	import flare.vis.data.EdgeSprite;
	import flare.vis.data.NodeSprite;
	import flare.vis.data.Tree;
	import flare.vis.events.SelectionEvent;
	import flare.vis.operator.encoder.PropertyEncoder;
	
	import flash.geom.Rectangle;
	
					
	public class CascadedTree extends AbstractTree
	{								
		public function CascadedTree(i:Number, tree:Tree, x:Number, y:Number)
		{
			super(i, tree, x, y);			
		}
		
		public override function init():void
		{			
			nodes = {
				shape: Shapes.BLOCK, // needed for treemap sqaures
				fillColor: 0xff8888FF, 
				lineColor: 0,
				fillAlpha: 0,//depth / 25,
				lineAlpha: 0//depth / 25
			}
			
			edges = {
				visible: false
			}
			
			var data:Data = _tree;
			data.nodes.setProperties(nodes);
			data.edges.setProperties(edges);
			
			// create the visualization
			vis = new Visualization(_tree);
			
			vis.operators.add(new CascadedTreeLayout(_x, _y));
			vis.setOperator("nodes", new PropertyEncoder(nodes, "nodes"));
			vis.setOperator("edges", new PropertyEncoder(edges, "edges"));
			
//			var e:EdgeSprite, n:NodeSprite;
//			vis.data.nodes.visit(function(n:NodeSprite):void {
//				n.shape = Shapes.BLOCK; // needed for treemap sqaures
//				n.fillColor = 0xff8888FF; n.lineColor = 0;
//				n.fillAlpha = n.lineAlpha = n.depth / 25;
//			});
//			vis.data.edges.setProperty("visible", false);

			// create a hover control to highlight nodes on mouse-over
			vis.controls.add(new HoverControl(NodeSprite,
				HoverControl.MOVE_AND_RETURN, rollOver, rollOut));
					
			bounds = new Rectangle(_x, _y, 1024, 768);
			vis.bounds = bounds;
			vis.update();
			addChild(vis);
		}
		
		private function rollOver(evt:SelectionEvent):void {
			var n:NodeSprite = evt.node;
			n.lineColor = 0xffFF0000; 
			n.lineWidth = 2;
			n.fillColor = 0xffFFFFAAAA;
		}
		
		private function rollOut(evt:SelectionEvent):void {
			var n:NodeSprite = evt.node;
			n.lineColor = 0; 
			n.lineWidth = 0;
			n.fillColor = 0xff8888FF;
			n.fillAlpha = n.lineAlpha = n.depth / 25;
		}
		
	}
}