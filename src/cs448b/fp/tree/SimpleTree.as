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
	import flare.vis.events.VisualizationEvent;
	import flare.vis.operator.encoder.PropertyEncoder;
	import flare.vis.operator.layout.NodeLinkTreeLayout;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class SimpleTree extends Sprite
	{
		private var id:Number;
		
		private static var MAX_ZOOM:Number = 4;
		private static var MIN_ZOOM:Number = 0.25;
		
		private var prevX:Number = 0;
		private var prevY:Number = 0;
		
		public var vis:Visualization;
		
		private var listeners:Array = new Array(1);
		
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
		
		public function SimpleTree(i:Number = 0)
		{	
			id = i;
			
			addEventListener(MouseEvent.MOUSE_WHEEL, handleMouseWheel);
			addEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
			addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
			
			addEventListener(MouseEvent.MOUSE_OVER, handleMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, handleMouseOut);
			
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
			
			vis.addEventListener(VisualizationEvent.UPDATE, handleVisUpdate);
		}
		
		/**
		 * 
		 */
		public function getId():Number
		{
			return id;
		}
		
		/**
		 * Sets the tree data.
		 */ 
		public function setTree(t:Tree, i:Number):void
		{
			id = i;
			
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
			vis.operators[0] = new NodeLinkTreeLayout(or,20,5,10);
			vis.update();
		}
		
		/**
		 * Adds a tree event handler.
		 */
		public function addTreeEventListener(l:TreeEventListener):void
		{
			listeners.push(l);
		}
		
		/**
		 * Removes a tree event handler.
		 */
		public function removeTreeEventListener(l:TreeEventListener):void
		{
			listeners.splice(listeners.indexOf(l), 1);
		}
		
		// Mouse Handlers
		private function handleMouseWheel(me:MouseEvent):void
		{ // handle zoom
			
			if(me.delta > 0)
			{ // zoom in
				if(vis.scaleX < MAX_ZOOM)
				{
					vis.scaleX *= 1.1;
					vis.scaleY *= 1.1;
				}
			} 
			else
			{ // zoom out
				if(vis.scaleX > MIN_ZOOM)
				{
					vis.scaleX /= 1.1;
					vis.scaleY /= 1.1;
				}
			}
		}
		
		private function handleMouseMove(me:MouseEvent):void
		{ 
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
			}
			else
			{
				prevX = me.stageX;
				prevY = me.stageY;
			}
		}
		
		private function handleMouseDown(me:MouseEvent):void
		{			
//			prevX = me.stageX;
//			prevY = me.stageY;
		}
		
		private function handleMouseOver(me:MouseEvent):void
		{
			var ns:NodeSprite = me.target as NodeSprite;
			if(ns != null) 
			{
				// fire event
				fireEvent(me);
			}
		}
		
		private function handleMouseOut(me:MouseEvent):void
		{
			var ns:NodeSprite = me.target as NodeSprite;
			if(ns != null) 
			{
				// fire event
				fireEvent(me);
			}
		}
		
		/**
		 * Fire events.
		 */
		private function fireEvent(evt:Event):void
		{
			for(var o:Object in listeners)
			{
				var l:TreeEventListener = listeners[o] as TreeEventListener;
				if(l != null) {
					l.handleEvent(evt);
				}
			}
		}
		
		/**
		 * Handles the tree sync event
		 */
		public function handleSyncEvent(s:String, evt:Event):void
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
		
		public override function toString():String
		{
			return super.toString()+" ID : "+id;
		}
		
		/**
		 * Handles vis update.
		 */
		public function handleVisUpdate(ve:VisualizationEvent):void
		{
//			trace(ve);
//			vis.graphics.clear();
//			vis.graphics.beginFill(0xaaaaaa, 0.5);
//			vis.graphics.drawRect(vis.x, vis.y, vis.width, vis.height);
//			vis.graphics.endFill();
//			vis.bounds = new Rectangle(0, 0, 500, 500);
//			trace("x/y/width/height: "+vis.x+"/"+vis.y+"/"+vis.width+"/"+vis.height);
		}
		
		/**
		 * Delegates update vis.
		 */
		public function updateVis(t:Object = null, ...operators):Transitioner
		{
			vis.x = 0;
			vis.y = 0;
			
//			trace("x/y/width/height: "+vis.x+"/"+vis.y+"/"+vis.width+"/"+vis.height);
			
//			vis.bounds = new Rectangle(0, 0, 500, 500);
			
			return vis.update(t, operators);
		}
	}
}