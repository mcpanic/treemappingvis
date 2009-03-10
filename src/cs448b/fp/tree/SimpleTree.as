package cs448b.fp.tree
{
	import flare.animate.Transitioner;
	import flare.util.Orientation;
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
	
	public class SimpleTree extends AbstractTree
	{	
		public function SimpleTree(i:Number, tree:Tree, x:Number, y:Number)
		{	
			super(i, tree, x, y);
			
			_id = i;
			
			_tree = tree;
			
			initComponents();
			buildSprite();
			
			setTree(_tree);
		}

		/**
		 * Initializes Components
		 */
		private function initComponents():void
		{
			initVis();
			
			nodes = {
				shape: Shapes.CIRCLE,
				fillColor: 0x88aaaaaa,
				lineColor: 0xdddddddd,
				lineWidth: 1,
				size: 1.5,
				alpha: 1,
				visible: true
			}
			
			edges = {
				lineColor: 0xffcccccc,
				lineWidth: 1,
				alpha: 1,
				visible: true
			}
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
		}
		
		/**
		 * Sets the tree data.
		 */ 
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
			vis.operators.add(new SimpleTreeLayout(Orientation.LEFT_TO_RIGHT,20,5,10));
			vis.setOperator("nodes", new PropertyEncoder(nodes, "nodes"));
			vis.setOperator("edges", new PropertyEncoder(edges, "edges"));
			
			vis.controls.add(new HoverControl(NodeSprite,
				HoverControl.MOVE_AND_RETURN, rollOver, rollOut));
				
			vis.controls.add(new ExpandEventControl(NodeSprite,
				function(evt:Event):void { 
					vis.update(1, "nodes","main").play();
					
					fireEvent(evt);
				}));
			
			vis.update();
		}
		
		/**
		 * Sets the orientation of the tree.
		 */
		public function setOrientation(or:String):void
		{
			vis.operators[0] = new SimpleTreeLayout(or,20,5,10);
			vis.update();
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
						n.lineWidth = 2;
						n.lineColor = 0x88ff0000;
					} 
					else if(evt.type == MouseEvent.MOUSE_OUT)
					{
						n.lineWidth = 0;
						n.lineColor = nodes.lineColor;
					}
					else if(evt.type == MouseEvent.MOUSE_UP)
					{
						var nn:NodeSprite = evt.target as NodeSprite; 
						n.expanded = nn.expanded;
						
						vis.update(1, "nodes","main").play();
					}
					
					return true; 
				}
				
				return false;
			});
			
		}
		
		/**
		 * Delegates update vis.
		 */
		public function updateVis(t:Object = null, ...operators):Transitioner
		{
			vis.x = 0;
			vis.y = 0;
			
			return vis.update(t, operators);
		}
		
		private function rollOver(evt:SelectionEvent):void 
		{		
			evt.node.lineWidth = 2;
			evt.node.lineColor = 0x88ff0000;
		}
		
		private function rollOut(evt:SelectionEvent):void 
		{
			evt.node.lineWidth = 0;
			evt.node.lineColor = nodes.lineColor;
		}
	}
}