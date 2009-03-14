package cs448b.fp.tree
{
	import flare.vis.Visualization;
	import flare.vis.controls.Control;
	import flare.vis.data.NodeSprite;
	
	import flash.display.InteractiveObject;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * A modified version of <code>ExpandControl</code>. 
	 * This class hands over the MOUSE_UP event to the update function. 
	 */
	public class ExpandEventControl extends Control
	{
		private var _cur:NodeSprite;
		
		/** Update function invoked after expanding or collapsing an item.
		 *  By default, invokes the <code>update</code> method on the
		 *  visualization with a 1-second transitioner. */
		public var update:Function = function(evt:Event, n:NodeSprite):void {
			var vis:Visualization = _object as Visualization;
			if (vis) vis.update(1).play();
		}
		
		// --------------------------------------------------------------------
		
		/**
		 * Creates a new ExpandEventControl.
		 * @param filter a Boolean-valued filter function for determining which
		 *  item this control will expand or collapse
		 * @param update function invokde after expanding or collapsing an
		 *  item.
		 */		
		public function ExpandEventControl(filter:*=null, update:Function=null)
		{
			this.filter = filter;
			if (update != null) this.update = update;
		}
		
		/** @inheritDoc */
		public override function attach(obj:InteractiveObject):void
		{
			if (obj==null) { detach(); return; }
			if (!(obj is Visualization)) {
				throw new Error("This control can only be attached to a Visualization");
			}
			super.attach(obj);
			obj.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		
		/** @inheritDoc */
		public override function detach():InteractiveObject
		{
			if (_object != null) {
				_object.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			}
			return super.detach();
		}
		
		private function onMouseDown(event:MouseEvent) : void {
		
			var s:NodeSprite = event.target as NodeSprite;
			var loader:Loader = event.target as Loader;
			if (s == null && loader == null) return; // exit if not a NodeSprite
			
			if(s == null)
			{
				var n:NodeSprite = loader.parent.parent.parent as NodeSprite; 
				s = n;
			}
			if(s == null) return;
			
			if (_filter==null || _filter(s)) 
			{
				_cur = s;
				_cur.stage.addEventListener(MouseEvent.MOUSE_MOVE, onDrag);
				_cur.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			}
//			event.stopPropagation();
		}
		
		private function onDrag(event:MouseEvent) : void {
			_cur.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			_cur.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onDrag);
			_cur = null;
		}
		
		private function onMouseUp(event:MouseEvent) : void {
			_cur.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			_cur.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onDrag);
//			_cur.expanded = !_cur.expanded;
			
			update(event, _cur);
			
			_cur = null;	
			
			event.stopPropagation();
		}
		
	} // end of class ExpandControl
}