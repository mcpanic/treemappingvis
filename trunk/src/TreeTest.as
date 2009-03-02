package
{
	import flare.query.methods.update;
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
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.text.TextField;
	
	// Convenient way to pass in compiler arguments
	// Place after import statements and before first class declaration 
	[SWF(width='1024', height='768', backgroundColor='#aaaaaa', frameRate='30')]
	
	public class TreeTest extends Sprite
	{
		private var vis:Visualization;
		
		private var prevX:Number = 0;
		private var prevY:Number = 0;
		
		private var data:Data;
		
		// default values
		private var nodes:Object = {
			shape: Shapes.SQUARE,
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
		
		private var nodeNum:Number = 0;
		
		public function TreeTest()
		{
			initComponents();
			
			buildSprite();
			
			addEventListener(MouseEvent.MOUSE_WHEEL, handleMouseWheel);
				
			addEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
				
		}
		
		private function initComponents():void
		{	
			// create data and set defaults
			data = createTree();
			
			data.nodes.setProperties(nodes);
			data.edges.setProperties(edges);
			for (var j:int=0; j<data.nodes.length; ++j) {
				data.nodes[j].data.label = String(j);
				data.nodes[j].buttonMode = true;
			}
			
			vis = createVis(data, Orientation.LEFT_TO_RIGHT);
		}
		
		private function createVis(d:Data, or:String):Visualization
		{			
			var v:Visualization = new Visualization(d);
			v.operators.add(new NodeLinkTreeLayout(or,20,5,10));
			
			// Set encoders
			v.setOperator("nodes", new PropertyEncoder(nodes, "nodes"));
			v.setOperator("edges", new PropertyEncoder(edges, "edges"));
			
			// set controls
			var expandControl:ExpandControl = new ExpandControl(NodeSprite,
				function():void { v.update(1, "nodes","main").play(); });
				
			var hoverControl:HoverControl = new HoverControl(NodeSprite,
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
				});
			
			v.controls.add(hoverControl);
			v.controls.add(expandControl);
			
			v.update();
			
			return v;
		}
		
		private function buildSprite():void
		{
			vis.x = -100;
			addChild(vis);
		}
		
		private function createTree():Tree
		{
			var b:int = 2;
			var d1:int = 2;
			var d2:int = 2;
			
			var tree:Tree = new Tree();
			var n:NodeSprite = tree.addRoot();
			addImageNode(n); 
			
			var l:NodeSprite = tree.addChild(n);
			addImageNode(l);
			
			var r:NodeSprite = tree.addChild(n);
			addImageNode(r);
            
            deepHelper(tree, l, b, d1-2, true);
        	deepHelper(tree, r, b, d1-2, false);
        
			while (l.firstChildNode != null)
				l = l.firstChildNode;
			while (r.lastChildNode != null)
				r = r.lastChildNode;
        	
        	deepHelper(tree, l, b, d2-1, false);
        	deepHelper(tree, r, b, d2-1, true);
        
        	return tree;
		}
		
		private function deepHelper(t:Tree, n:NodeSprite,
			breadth:int, depth:int, left:Boolean) : void
		{
			var c:NodeSprite = t.addChild(n);
			addImageNode(c);

			if (left && depth > 0)
				deepHelper(t, c, breadth, depth-1, left);
			
			for (var i:uint = 1; i<breadth; ++i) {
				c = t.addChild(n);
				addImageNode(c);
			}
			
			if (!left && depth > 0)
				deepHelper(t, c, breadth, depth-1, left);
		}
		
		private function addImageNode(n:NodeSprite):void
		{
			var image:DisplayObject = addImage(n, ++nodeNum);
			n.addChild(image);
		}
		
		private function addImage(n:NodeSprite, num:Number):DisplayObject
		{
			if(num > 0) 
			{
				var tf:TextField = new TextField();
				tf.text = num.toString();
				return tf;
			}
			else
			{
				var ldr:Loader = new Loader();
				var url:String = "E:\\Code\\CS448B\\maptree\\images\\"+num+".jpg";
	 			var urlReq:URLRequest = new URLRequest(url);
				ldr.load(urlReq);
				
				ldr.contentLoaderInfo.addEventListener(Event.COMPLETE,
					function(evt:Event):void
					{	 
						vis.update();
//						visR.update();
					});
						
				return ldr;
			}
		}
		
		private function handleMouseWheel(me:MouseEvent):void
		{ // handle zoom
			if(me.delta > 0)
			{
				if(vis.scaleX > 0.5*1.5)
				{
					trace("zoom out!");
					vis.scaleX /= 1.5;
					vis.scaleY /= 1.5;
					update();
				}
			} 
			else
			{
				if(vis.scaleX < 4*1.5)
				{
					trace("zoom in!");
					vis.scaleX *= 1.5;
					vis.scaleY *= 1.5;
					update();
				}
			}
		}
		
		private function handleMouseMove(me:MouseEvent):void
		{ 
			if(me.buttonDown)
			{ // TODO: handle pan
				var dX:Number = me.stageX - prevX;
				var dY:Number = me.stageY - prevY;
				
				trace("dX/dY: "+dX+"/"+dY);
				
				vis.x += dX;
				vis.y += dY;
			}
			
			prevX = me.stageX;
			prevY = me.stageY;
		}
	}
}