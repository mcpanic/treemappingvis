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
			// init values		
			nodes = {
				shape: Shapes.BLOCK, // needed for treemap sqaures
				fillColor: 0xff8888FF, 
				lineColor: 0
			}
			
			edges = {
				visible: false
			}
			
			// initialize tree
			var data:Data = _tree;
			data.nodes.setProperties(nodes);
			data.edges.setProperties(edges);
			
			for (var j:int=0; j<data.nodes.length; ++j) 
			{
				data.nodes[j].fillAlpha = 1/25;
				data.nodes[j].lineAlpha = 1/25;
			}
			
			// create the visualization
			vis = new Visualization(_tree);
			
			// set operators
			vis.operators.add(new CascadedTreeLayout(_x, _y));
			vis.setOperator("nodes", new PropertyEncoder(nodes, "nodes"));
			vis.setOperator("edges", new PropertyEncoder(edges, "edges"));

			// add controls
			vis.controls.add(new HoverControl(NodeSprite,
				HoverControl.MOVE_AND_RETURN, rollOver, rollOut));

			bounds = new Rectangle(_x, _y, 1024, 768);
			vis.bounds = bounds;
			
			vis.update();
			
			addChild(vis);
		}
		
		/**
		 * Handles the tree sync event
		 */
		public override function handleSyncEvent(s:String, evt:Event, n:NodeSprite):void
		{
			// handle event
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
		
		protected override function rollOver(evt:SelectionEvent):void 
		{
			var n:NodeSprite = evt.node;
			n.lineColor = 0xffFF0000; 
			n.lineWidth = 2;
			n.fillColor = 0xffFFFFAAAA;
		}
		
		protected override function rollOut(evt:SelectionEvent):void 
		{
			var n:NodeSprite = evt.node;
			n.lineColor = 0; 
			n.lineWidth = 0;
			n.fillColor = 0xff8888FF;
			n.fillAlpha = n.lineAlpha = 1 / 25;
		}
	}
}