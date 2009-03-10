package cs448b.fp.tree
{
	import flare.vis.Visualization;
	import flare.vis.data.NodeSprite;
	import flare.vis.data.Tree;
	import flare.vis.events.SelectionEvent;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
			
	public class AbstractTree extends Sprite
	{
		protected var _id:Number;
		
		public var vis:Visualization;
		protected var _tree:Tree;
		
		protected var _x:Number;
		protected var _y:Number;
		
		protected var nodes:Object;
		protected var edges:Object;
		
		private static var MAX_ZOOM:Number = 4;
		private static var MIN_ZOOM:Number = 0.25;
		
		private var prevX:Number = 0;
		private var prevY:Number = 0;
		
		protected var listeners:Array = new Array(1);
		
		private var _init:Boolean = false;
		private var _bounds:Rectangle;
		
		public function get bounds():Rectangle { return _bounds; }
		public function set bounds(b:Rectangle):void {
			_bounds = b;
			resize();
		}
		// --------------------------------------------------------------------
		
		public function AbstractTree(i:Number, tree:Tree, x:Number, y:Number) {
			_id = i;
			_tree = tree;
			_x = x;
			_y = y;

			init();
			
			// add mouse listeners
			addEventListener(MouseEvent.MOUSE_WHEEL, handleMouseWheel);
			addEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
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
		
		public function init() : void {}
		
		public function resize():void 
		{
			if (vis) {
				vis.bounds = bounds;
				vis.update();
			}
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
		
//		// Mouse Handlers
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
			var uil:Loader = me.target as Loader;
			if(ns == null && uil == null) return;
			
			// fire event
			fireEvent(me);
			
		}
		
		private function handleMouseOut(me:MouseEvent):void
		{
			var ns:NodeSprite = me.target as NodeSprite;
			var uil:Loader = me.target as Loader;
			if(ns == null && uil == null) return;
			
			// fire event
			fireEvent(me);
		}
		
		/**
		 * Fire events.
		 */
		protected function fireEvent(evt:Event):void
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
		 * Handles sync event. 
		 * 
		 * @param s - the id of the brushed node
		 * @param evt - the event
		 */
		public function handleSyncEvent(s:String, evt:Event, n:NodeSprite):void {}
		
		protected function rollOver(evt:SelectionEvent):void{}
		
		protected function rollOut(evt:SelectionEvent):void{}
	} // end of class Demo
}
