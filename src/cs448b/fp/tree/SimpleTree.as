package cs448b.fp.tree
{
	import flare.animate.Transitioner;
	import flare.util.Orientation;
	import flare.util.Shapes;
	import flare.vis.controls.HoverControl;
	import flare.vis.data.Data;
	import flare.vis.data.NodeSprite;
	import flare.vis.data.Tree;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	public class SimpleTree extends AbstractTree
	{	
		public function SimpleTree(i:Number, tree:Tree, x:Number, y:Number)
		{
			super(i, tree, x, y);
		}

		/**
		 * Initializes Components
		 */
		public override function init():void
		{	
			super.init();
			
			// add controls
			vis.controls.add(new HoverControl(NodeSprite,
				HoverControl.MOVE_AND_RETURN, rollOver, rollOut));	
			
			vis.controls.add(new ExpandEventControl(NodeSprite,
				function(evt:Event, n:NodeSprite):void { 
					if(n.childDegree > 0)
					{
						n.expanded = !n.expanded;
						vis.update(1, "nodes","main").play();
					
						fireEvent(evt);
					}
				}));
			
			bounds = new Rectangle(_x, _y, 100, 100);
			vis.bounds = bounds;

			vis.update();
			
			addChild(vis);
		}
		
		protected override function initComponents():void
		{
			// init values		
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
			
			_layout = new SimpleTreeLayout(Orientation.LEFT_TO_RIGHT,20,5,10);	
		}
		
		protected override function initNode(n:NodeSprite, i:Number):void
		{
			n.data.label = String(i);
			n.buttonMode = true;
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
		 * Delegates update vis.
		 */
		public function updateVis(t:Object = null, ...operators):Transitioner
		{
			vis.x = 0;
			vis.y = 0;
			
			return vis.update(t, operators);
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
				var nn:NodeSprite = evt.target as NodeSprite; 
				var loader:Loader = evt.target as Loader;
				if(nn == null && loader == null) return;
				if(nn == null)
				{
					nn = loader.parent.parent.parent as NodeSprite;
				}
				if(nn == null) return;
			
				if(n.name == nn.name) return; // returned message
				
				if(n.childDegree > 0)
				{
					n.expanded = nn.expanded;
					vis.update(1, "nodes","main").play();
				}
			}
		}
		
		protected override function onMouseOver(n:NodeSprite):void
		{
			n.lineWidth = 2;
			n.lineColor = 0x88ff0000;
		}
		
		protected override function onMouseOut(n:NodeSprite):void
		{
			n.lineWidth = 0;
			n.lineColor = nodes.lineColor;
		}
		
		public override function setVisibleDepth(d:Number):void 
		{
			var tree:Tree = vis.data as Tree;
			if(tree == null ) return;
			
			tree.visit(function(n:NodeSprite):void
				{
					if(n.depth >= d)
					{
						n.expanded = false;
					}
					else
					{
						n.expanded = true;
					}
				}, Data.NODES);
			
			vis.update(1, "nodes","main").play();
		}
	}
}