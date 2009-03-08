package cs448b.fp.tree
{
	import flare.util.Orientation;
	import flare.util.Shapes;
	import flare.vis.Visualization;
	import flare.vis.controls.ExpandControl;
	import flare.vis.controls.HoverControl;
	import flare.vis.data.Data;
	import flare.vis.data.NodeSprite;
	import flare.vis.data.Tree;
	import flare.vis.events.SelectionEvent;
	import flare.vis.operator.encoder.PropertyEncoder;
	import flare.vis.operator.layout.NodeLinkTreeLayout;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class SimpleTree extends Sprite
	{
		private static var MAX_ZOOM:Number = 4;
		private static var MIN_ZOOM:Number = 0.25;
		
		private var prevX:Number = 0;
		private var prevY:Number = 0;
		
		private var vis:Visualization;
		
		// default values
		private var nodes:Object = {
			shape: Shapes.CIRCLE,
			fillColor: 0x88aaaaaa,
			lineColor: 0xdddddddd,
			lineWidth: 1,
			size: 1.5,
			alpha: 1,
			visible: true
		}
		
		private var edges:Object = {
			lineColor: 0xffcccccc,
			lineWidth: 1,
			alpha: 1,
			visible: true
		}
		
		public function SimpleTree()
		{						
			initComponents();
			buildSprite();
		}

		/**
		 * Initializes Components
		 */
		private function initComponents():void
		{
			initVis();
		}
		
		/**
		 * Builds the sprite
		 */
		private function buildSprite():void
		{
			this.addChild(vis);
		}
		
		/**
		 * Initializes the vis component
		 */
		private function initVis():void
		{
			vis = new Visualization();
			
			vis.addEventListener(MouseEvent.MOUSE_WHEEL, handleMouseWheel);
			vis.addEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
			vis.addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
		}
		
		public function setTree(t:Tree):void
		{
			// set data
			vis.data = t;
			
			var data:Data = vis.data;
			
			data.nodes.setProperties(nodes);
			data.edges.setProperties(edges);
			for (var j:int=0; j<data.nodes.length; ++j) {
				data.nodes[j].data.label = String(j);
				data.nodes[j].buttonMode = true;
			}
			
			// add operators
			vis.operators.add(new NodeLinkTreeLayout(Orientation.LEFT_TO_RIGHT,20,5,10));
			vis.setOperator("nodes", new PropertyEncoder(nodes, "nodes"));
			vis.setOperator("edges", new PropertyEncoder(edges, "edges"));
			
			vis.controls.add(new HoverControl(NodeSprite,
				// by default, move highlighted items to front
				HoverControl.MOVE_AND_RETURN,
				// highlight node border on mouse over
				function(e:SelectionEvent):void {
					e.node.lineWidth = 2;
					e.node.lineColor = 0x88ff0000;
				},
				// remove highlight on mouse out
				function(e:SelectionEvent):void {
					e.node.lineWidth = 0;
					e.node.lineColor = nodes.lineColor;
				}));
			vis.controls.add(new ExpandControl(NodeSprite,
				function():void { 
					vis.update(1, "nodes","main").play(); 
				}));
			vis.update();
		}
		
		public function setOrientation(or:String):void
		{
			vis.operators[0] = new NodeLinkTreeLayout(or,20,5,10);
			vis.update();
		}
		
		// Mouse Handlers
		private function handleMouseWheel(me:MouseEvent):void
		{ // handle zoom
			// TODO: check targets
			
			if(me.delta > 0)
			{
				if(vis.scaleX < MAX_ZOOM)
				{
					vis.scaleX *= 1.1;
					vis.scaleY *= 1.1;
				}
			} 
			else
			{
				if(vis.scaleX > MIN_ZOOM)
				{
					vis.scaleX /= 1.1;
					vis.scaleY /= 1.1;
				}
			}
		}
		
		private function handleMouseMove(me:MouseEvent):void
		{ 
			// TODO: check targets
			
			if(me.buttonDown)
			{ // handle pan
				var sX:Number = me.stageX;
				var sY:Number = me.stageY;

				var dX:Number = sX - prevX;
				var dY:Number = sY - prevY;
	
				vis.x += dX;
				vis.y += dY;
		
				prevX = sX;
				prevY = sY;
//				trace("prevX2/prevY2: "+prevX+"/"+prevY);
			}
		}		
		
		private function handleMouseDown(me:MouseEvent):void
		{
			// TODO: check targets
			
			prevX = me.stageX;
			prevY = me.stageY;
		}
	}
}