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
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	public class SimpleTree extends AbstractTree
	{	
		public static var EXPANDABLE_COLOR:uint = 0xaa6767ff;
		public static var HIGHLIGHT_COLOR:uint = 0x88ff0000;
		
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
						expandNode(!n.expanded, n);
					
						fireEvent(evt);
					}
				}));
			
			bounds = new Rectangle(_x, _y, 100, 100);
			vis.bounds = bounds;

			vis.update();
			
			// post node setting
			var data:Data = _tree;
			
			for (var j:int=0; j<data.nodes.length; ++j) 
			{
				setBorderColor(data.nodes[j]);
			}
			
			addChild(vis);
		}
		
		protected override function initComponents():void
		{
			// init values		
			nodes = {
				shape: Shapes.CIRCLE,
				fillColor: 0xffaaaaaa,
				lineColor: 0xdddddddd,
				lineWidth: 1,
				size: 0.1,
				alpha: 1,
				visible: true
			}
			
			edges = {
				lineColor: 0xff555555,
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
		public function resetPosition(t:Object = null, ...operators):Transitioner
		{
			vis.x = 0;
			vis.y = 0;
			
			return vis.update(t, operators);
		}

		/**
		 * Return the matching
		 */
		private function matchLoaderWithNode(loader:Loader):NodeSprite
		{
			var root:NodeSprite = tree.root as NodeSprite;
			var result:NodeSprite;
	        root.visitTreeDepthFirst(function(n:NodeSprite):void {
				if (loader.name == n.name)
				{
					result = n;
				}
			});
			return result;

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
				
				expandNode(nn.expanded, n);
			}
		}
		
		protected override function onMouseOver(n:NodeSprite):void
		{
			n.lineWidth = 2;
			n.lineColor = HIGHLIGHT_COLOR;
			
			var image:Sprite = n.props["image"];
			
			image.graphics.clear();
			image.graphics.lineStyle(10, n.lineColor, 0.8);
			image.graphics.drawRect(0, 0, image.width, image.height);
		}
		
		protected override function onMouseOut(n:NodeSprite):void
		{
			n.lineWidth = 0;
			n.lineColor = nodes.lineColor;
			
			setBorderColor(n);
		}
		
		private function setBorderColor(n:NodeSprite):void
		{
			var image:Sprite = n.props["image"];
			
			image.graphics.clear();
			if(n.childDegree > 0)
			{
				image.graphics.lineStyle(7, EXPANDABLE_COLOR, 0.8);
				image.graphics.drawRect(0, 0, image.width, image.height);
			}
			else
			{
				image.graphics.lineStyle(3, n.lineColor, 0.5);
				image.graphics.drawRect(0, 0, image.width, image.height);	
			}
		}
		
		private function expandNode(e:Boolean, n:NodeSprite):void
		{
			if(n.childDegree > 0)
			{
				n.expanded = e;
				vis.update(1, "nodes","main").play();
				
				setBorderColor(n);
			}
		}
		
		public override function setVisibleDepth(d:Number):void 
		{
			var tree:Tree = vis.data as Tree;
			if(tree == null ) return;
			
			tree.visit(function(n:NodeSprite):void
				{
					if(n.childDegree > 0)
					{
						if(n.depth >= d)
						{
							n.expanded = false;
						}
						else
						{
							n.expanded = true;
						}
					}
				}, Data.NODES);
			
			vis.update(1, "nodes","main").play();
			
			tree.visit(function(n:NodeSprite):void
				{
					setBorderColor(n);
				}, Data.NODES);
		}
	}
}