package cs448b.fp.tree
{
	import cs448b.fp.ui.Theme;
	import cs448b.fp.event.TreeEventListener;
	import flare.display.TextSprite;
	import flare.vis.Visualization;
	import flare.vis.data.Data;
	import flare.vis.data.NodeSprite;
	import flare.vis.data.Tree;
	import flare.vis.events.SelectionEvent;
	import flare.vis.operator.encoder.PropertyEncoder;
	import flare.vis.operator.layout.Layout;
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
				
	public class AbstractTree extends Sprite
	{
		protected var _id:Number;
		
		public var vis:Visualization;
		protected var _tree:Tree;		
		public function get tree():Tree{ return _tree; }
		
		protected var _layout:Layout;
		
		protected var _x:Number;
		protected var _y:Number;
		
		protected var _visualToggle:Boolean;
		
		protected var nodes:Object;
		protected var edges:Object;
		
//		private static var MAX_ZOOM:Number = 4;
//		private static var MIN_ZOOM:Number = 0.25;
		
		private var prevX:Number = 0;
		private var prevY:Number = 0;
		
		protected var listeners:Array = new Array(1);
		
		private var _init:Boolean = false;
		private var _bounds:Rectangle;
		
		protected var tf:TextSprite;// = new TextField();
		private var _textFormat:TextFormat;
		
		public function get bounds():Rectangle { return _bounds; }
		public function set bounds(b:Rectangle):void {
			_bounds = b;
			resize();
		}
		// --------------------------------------------------------------------
		
		public function AbstractTree(i:Number, tree:Tree, x:Number, y:Number) 
		{
			_id = i;
			_tree = tree;
			_x = x;
			_y = y;
			_visualToggle = true;
			
			_textFormat = new TextFormat("Verdana,Tahoma,Arial",12,0,false);
			_textFormat.color = "0xFFFFFF";			
			tf = new TextSprite("", _textFormat);
            tf.horizontalAnchor = TextSprite.CENTER;
            
			init();
			
			// add mouse listeners
			addEventListener(MouseEvent.MOUSE_WHEEL, handleMouseWheel);
			addEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
			
			addEventListener(MouseEvent.MOUSE_UP, handleMouseUp);
			addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
			
			addEventListener(MouseEvent.MOUSE_OVER, handleMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, handleMouseOut);
		}
		
		/**
		 * Returns the ID of the tree.
		 */
		public function getId():Number
		{
			return _id;
		}
		
		/** initialize **/
		public function init() : void 
		{
			initComponents();
			
			// initialize tree
			var data:Data = _tree;
			data.nodes.setProperties(nodes);
			data.edges.setProperties(edges);
			
			for (var j:int=0; j<data.nodes.length; ++j) 
			{
				initNode(data.nodes[j], j);
			}
			
			// create the visualization
			vis = new Visualization(_tree);
			
			// set operators
			vis.operators.add(_layout);
			vis.setOperator("nodes", new PropertyEncoder(nodes, "nodes"));
			vis.setOperator("edges", new PropertyEncoder(edges, "edges"));

			// add controls
			
			
		}
		
		/** initialize components - this function should be implemented in sub class */
		protected function initComponents():void {}
		
		/** initialize nodes - this function should be implemented in sub class */
		protected function initNode(n:NodeSprite, i:Number):void {}
		
		public function resize():void 
		{
			if (vis) {
				vis.bounds = bounds;
				vis.update();
			}
		}
		
		public function resetPositions():void
		{
			vis.x = 0;
			vis.y = 0;
			vis.update(1).play();
		}
		
		/**
		 * Sets the visible depth. Override in subclass
		 */
		public function setVisibleDepth(d:Number):void {}
		
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
		
//		// Mouse Handlers
		private function handleMouseWheel(me:MouseEvent):void
		{ // handle zoom
			
			if(me.delta > 0)
			{ // zoom in
				if(vis.scaleX < Theme.MAX_ZOOM)
				{
					vis.scaleX *= 1.1;
					vis.scaleY *= 1.1;
				}
			} 
			else
			{ // zoom out
				if(vis.scaleX > Theme.MIN_ZOOM)
				{
					vis.scaleX /= 1.1;
					vis.scaleY /= 1.1;
				}
			}
		}
		
		private function handleMouseMove(me:MouseEvent):void
		{ 
			if(me.ctrlKey && me.buttonDown)
			{ // handle pan
			
				var sX:Number = me.stageX;
				var sY:Number = me.stageY;

				var dX:Number = sX - prevX;
				var dY:Number = sY - prevY;
				
				//if (vis.y + dY > 0)
				//{
					vis.x += dX;
					vis.y += dY;

				//}		
					prevX = sX;
					prevY = sY;				
			}
			else
			{
				prevX = me.stageX;
				prevY = me.stageY;
					
				// fire event
				fireEvent(me);
			}
		}
		
		private function handleMouseUp(me:MouseEvent):void 
		{
			if(!me.ctrlKey)
			{				
				// fire event
				fireEvent(me);	
			}
		}
		
		private function handleMouseDown(me:MouseEvent):void 
		{	
			if(!me.ctrlKey)
			{						
				// fire event
				fireEvent(me);
			}
		}
		
		private function handleMouseOver(me:MouseEvent):void
		{			
			// fire event
			fireEvent(me);
		}
		
		private function handleMouseOut(me:MouseEvent):void
		{			
			// fire event
			fireEvent(me);
		}
		
		private function handleMouseDrag(me:MouseEvent):void 
		{	
			// fire event
			fireEvent(me);
		}
		
		/**
		 * Return the matching
		 */
		private function matchLoaderWithNode(loader:DisplayObject):NodeSprite
		{
			var root:NodeSprite = _tree.root as NodeSprite;
			var result:NodeSprite;
	        root.visitTreeDepthFirst(function(n:NodeSprite):void {
				if (loader.name == n.name)
				{
					result = n;
				}
			});
			return result;

		}
		
		/**
		 * Fire events.
		 */
		protected function fireEvent(evt:Event):void
		{
			var node:NodeSprite = evt.target as NodeSprite;
			var loader:Loader = evt.target as Loader;
			if(node == null && loader == null) 
				return;
			
			if(node == null)
			{
				node = loader.parent.parent.parent as NodeSprite;
			}
			if(node == null) 
				return;
			
			// this is very bad coding...
			if(evt.type == MouseEvent.MOUSE_DOWN)
			{
//				trace(node.name);
				tf.text = node.name;
			}
			
//			if (evt.type == MouseEvent.MOUSE_OVER)
//			{
//				trace("Mouse over: " + node.name);
//			}
			
			for(var o:Object in listeners)
			{				
				var l:TreeEventListener = listeners[o] as TreeEventListener;
				if(l != null) {
					l.handleEvent(node, evt);
				}
			}
		}
		
		/**
		 * Handles sync event. 
		 * 
		 * @param s - the id of the brushed node
		 * @param evt - the event
		 */
		/**
		 * Handles the tree sync event
		 */
		public function handleSyncEvent(s:String, evt:Event, n:NodeSprite, isSender:Boolean):void
		{
			// handle event
			var t:Tree = vis.data as Tree;
				
			t.visit(function (o:Object):Boolean{
				
				var n:NodeSprite = o as NodeSprite;
				if( n == null ) return false; 
				
				if(n.name == s){
					handleSyncNodeEvent(n, evt, isSender);
					return true; 
				}
				
				return false;
			});
			
		}
		
		/** 
		 * Handles the event for brushing (node sync)
		 * 
		 * @param n - the node to sync
		 * @param evt - the event that was sent 
		 */
		protected function handleSyncNodeEvent(n:NodeSprite, evt:Event, isSender:Boolean):void {}
		
		protected function rollOver(evt:SelectionEvent):void 
		{		
			onMouseOver(evt.node);
		}
		
		protected function rollOut(evt:SelectionEvent):void 
		{
			onMouseOut(evt.node);
		}
		
		protected function onMouseOver(n:NodeSprite):void {}
		
		protected function onMouseOut(n:NodeSprite):void {}
		
		protected function onMouseUp(n:NodeSprite):void {}
		
		protected function onMouseDown(n:NodeSprite, isSender:Boolean = true):void {}
		
		protected function onMouseMove(n:NodeSprite):void {}
	} // end of class Demo
}
