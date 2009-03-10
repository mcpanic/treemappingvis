package cs448b.fp.tree
{
	import cs448b.fp.utils.*;
	
	import flare.util.Shapes;
	import flare.vis.Visualization;
	import flare.vis.controls.HoverControl;
	import flare.vis.data.Data;
	import flare.vis.data.NodeSprite;
	import flare.vis.data.Tree;
	import flare.vis.events.SelectionEvent;
	import flare.vis.operator.encoder.PropertyEncoder;

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
			nodes = {
				shape: Shapes.BLOCK, // needed for treemap sqaures
				fillColor: 0xff8888FF, 
				lineColor: 0,
				fillAlpha: 1,//depth / 25,
				lineAlpha: 1//depth / 25
			}
			
			edges = {
				visible: false
			}
			
			var data:Data = _tree;
//			data.nodes.setProperties(nodes);
			data.edges.setProperties(edges);
			
			// create the visualization
			vis = new Visualization(_tree);
			
			vis.operators.add(new CascadedTreeLayout(_x, _y));
//			vis.setOperator("nodes", new PropertyEncoder(nodes, "nodes"));
			vis.setOperator("edges", new PropertyEncoder(edges, "edges"));



			//filters = [new DropShadowFilter(1)];
						
//			var e:EdgeSprite, n:NodeSprite;
			vis.data.nodes.visit(function(n:NodeSprite):void {
				n.shape = Shapes.BLOCK; // needed for treemap sqaures
				n.fillColor = 0xff8888FF; n.lineColor = 0;
				n.fillAlpha = n.lineAlpha = (n.depth+1) / 25;
			});
//			vis.data.edges.setProperty("visible", false);

			// create a hover control to highlight nodes on mouse-over
			vis.controls.add(new HoverControl(NodeSprite,
				HoverControl.MOVE_AND_RETURN, rollOver, rollOut));

			bounds = new Rectangle(_x, _y, 1024, 768);
			vis.bounds = bounds;
			vis.update();
			addChild(vis);
		}

		public override function resize():void
		{
			if (vis) {
				vis.bounds = bounds;
				vis.update();
			}
		}
		
		/**
		 * Handles the tree sync event
		 */
		public override function handleSyncEvent(s:String, evt:Event):void
		{
			// TODO: handle event
			var t:Tree = vis.data as Tree;	
				
			t.visit(function (o:Object):Boolean{
				
				var n:NodeSprite = o as NodeSprite;
				if( n == null ) return false; 
				
				if(n.name == s){
					if(evt.type == MouseEvent.MOUSE_OVER)
					{
						n.lineColor = 0xffFF0000; 
						n.lineWidth = 2;
						n.fillColor = 0xffFFFFAAAA;
					} 
					else if(evt.type == MouseEvent.MOUSE_OUT)
					{
						n.lineColor = 0; 
						n.lineWidth = 0;
						n.fillColor = 0xff8888FF;
						n.fillAlpha = n.lineAlpha = 1 / 25;
					}
					
					return true; 
				}
				
				return false;
			});
			
		}
		
		private function rollOver(evt:SelectionEvent):void 
		{
			var n:NodeSprite = evt.node;
			n.lineColor = 0xffFF0000; 
			n.lineWidth = 2;
			n.fillColor = 0xffFFFFAAAA;
		}
		
		private function rollOut(evt:SelectionEvent):void 
		{
			var n:NodeSprite = evt.node;
			n.lineColor = 0; 
			n.lineWidth = 0;
			n.fillColor = 0xff8888FF;
			n.fillAlpha = n.lineAlpha = 1 / 25;
		}
		
	}
}