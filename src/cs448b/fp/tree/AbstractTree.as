package cs448b.fp.tree
{
	import cs448b.fp.utils.LinkGroup;
	
	import flare.vis.Visualization;
	import flare.vis.data.NodeSprite;
	import flare.vis.data.Tree;
	
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
		
		public static var LINK_X:Number;
		public static var LINK_Y:Number;
		
		private var _init:Boolean = false;
		private var _bounds:Rectangle;
		private var _links:LinkGroup;
		
		public function get bounds():Rectangle { return _bounds; }
		public function set bounds(b:Rectangle):void {
			_bounds = b;
			if (_links) {
				_links.x = LINK_X;
				_links.y = LINK_Y;
				setChildIndex(_links, numChildren-1);
			}
			resize();
		}
		
		protected function get links():LinkGroup { return _links; }
		protected function set links(links:LinkGroup):void
		{
			if (_links) removeChild(_links);
			_links = links;
			if (links != null) addChildAt(_links, numChildren);
		}
		
		// --------------------------------------------------------------------
		
		public function AbstractTree(i:Number, tree:Tree, x:Number, y:Number) {
			_id = i;
			_tree = tree;
			_x = x;
			_y = y;
			
			this.links = new LinkGroup();
			
			addEventListener(MouseEvent.MOUSE_WHEEL, handleMouseWheel);
			addEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
			addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
			
			addEventListener(MouseEvent.MOUSE_OVER, handleMouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, handleMouseOut);
		}
		
//		public function start():void
//		{
//			if (!_init) { init(); _init = true; }
//			play();
//			if (_links) {
//				_links.x = LINK_X;
//				_links.y = LINK_Y;
//				setChildIndex(_links, numChildren-1);
//			}
//		}
		
		/**
		 * Returns the ID of the tree.
		 */
		public function getId():Number
		{
			return _id;
		}
		
		public function init() : void {}
		
		public function resize():void {}
		
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
		
		public function handleSyncEvent(s:String, evt:Event):void {}
		
	} // end of class Demo
}
