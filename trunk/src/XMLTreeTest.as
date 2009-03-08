package
{	
	import cs448b.fp.data.DataLoader;
	
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
	
	import flash.display.Graphics;
	import flash.display.InteractiveObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.text.TextField;
	
	// Convenient way to pass in compiler arguments
	// Place after import statements and before first class declaration 
	[SWF(width='1024', height='768', backgroundColor='#ffffff', frameRate='30')]
	
	public class XMLTreeTest extends Sprite
	{
		private var dataLoader:DataLoader;
		
		private static var MAX_ZOOM:Number = 4;
		private static var MIN_ZOOM:Number = 0.25;
		
		private var prevX:Number = 0;
		private var prevY:Number = 0;
				
		private var vis:Visualization;
		
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
		
		public function XMLTreeTest()
		{
			//initComponents();
			
			//buildSprite();
			addEventListener(MouseEvent.MOUSE_WHEEL, handleMouseWheel);
			addEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
			addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
			parseXML();
		}
		
		private function initComponents():void
		{
			Shapes.setShape("RECT", drawRectangle);
			
			// create data and set defaults
//			data = createTree();
			data = tree;
			
			data.nodes.setProperties(nodes);
			data.edges.setProperties(edges);
			for (var j:int=0; j<data.nodes.length; ++j) {
				data.nodes[j].data.label = String(j);
				data.nodes[j].buttonMode = true;
			}
			
			initVis();
		}
		
		private function initVis():void
		{
			vis = new Visualization(data);
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
//			vis.controls.add(new LoaderExpandControl(NodeSprite,
//				function():void { 
//					vis.update(1, "nodes","main").play(); 
//				}));
			vis.controls.add(new ExpandControl(NodeSprite,
				function():void { 
					vis.update(1, "nodes","main").play(); 
				}));
			vis.update();
		}
		
		private function buildSprite():void
		{
			addChild(vis);
		}
/*		
		private function createTree():Tree
		{
			var b:int = 2;
			var d1:int = 2;
			var d2:int = 2;
			
			var tree:Tree = new Tree();
			var n:NodeSprite = tree.addRoot();
			addImageNode(n, 0); 
			
			var l:NodeSprite = tree.addChild(n);
			addImageNode(l, 0);
			
			var r:NodeSprite = tree.addChild(n);
			addImageNode(r, 0);
            
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
			addImageNode(c, 0);

			if (left && depth > 0)
				deepHelper(t, c, breadth, depth-1, left);
			
			for (var i:uint = 1; i<breadth; ++i) {
				c = t.addChild(n);
				addImageNode(c, 0);
			}
			
			if (!left && depth > 0)
				deepHelper(t, c, breadth, depth-1, left);
		}
*/		
		private function addImageNode(n:NodeSprite, num:Number = 0):void
		{
			var image:InteractiveObject = addImage(n, num);
			n.addChild(image);
			
//			image.addEventListener(MouseEvent.CLICK, 
//				function(evt:MouseEvent):void
//				{
//					n.dispatchEvent(evt);
//					trace("Click!");
//				});
		}
		
		private function addImage(n:NodeSprite, num:Number = 0):InteractiveObject
		{
			if(num == 0)
			{
				var tf:TextField = new TextField();
				
				tf.text = "Node";
				return tf;
			}
			var ldr:Loader = new Loader();

			var url:String = "../data/thumbnails/"+num+".PNG";
 			var urlReq:URLRequest = new URLRequest(url);
			ldr.load(urlReq);
			
			ldr.contentLoaderInfo.addEventListener(Event.COMPLETE,
				function(evt:Event):void
				{	
					vis.update();
				});
						
			return ldr;
		}
		
		private static var iw:Number;
		private static var ih:Number;
		
		public static function drawRectangle(g:Graphics, size:Number) : void
		{
			g.drawRect(0,0, iw, ih);	
		}

		private var tree:Tree;
		
		private function retrieveData(xml:XMLList, depth:Number, parent:NodeSprite):void
		{
			var nodeSprite:NodeSprite; 			
							
			for each (var el:XML in xml)	// next depth
			{
				trace(el.label + "/" + depth);
				nodeSprite = tree.addChild(parent);
				addImageNode(nodeSprite, el.label);
		
		 	    if (el.children.node == null || el.children.node == undefined){}
		 	    else retrieveData(el.children.node, depth + 1, nodeSprite);
		 	}
		
		}
		
		private function onXMLLoadComplete(event:Event):void
		{
		    var loader:URLLoader = event.target as URLLoader;
		    
		    if (loader != null)
		    {
			    var externalXML:XML = new XML(loader.data);
			    var nodeSprite:NodeSprite; 
				trace(externalXML.label);
			    //trace(externalXML.url);        
				nodeSprite = tree.addRoot();
				addImageNode(nodeSprite, externalXML.label);	    
		 		retrieveData(externalXML.children.node, 1, nodeSprite);
		//        trace(externalXML.toXMLString());
		        //var total2:Number = 0;
		//		for each (var prop:XML in externalXML.children)
		//		{
		//		    trace(prop.label + " " + prop.url);
		//		}
		
		    }
		    else
		    {
		        trace("loader is not a URLLoader!");
		    }
			initComponents();
			
			buildSprite();    
		    
		}

		
		private function parseXML():void
		{
			tree = new Tree();
			var loader:URLLoader = new URLLoader();
			var request:URLRequest = new URLRequest("../data/tree_cat.xml");
			loader.load(request);
			loader.addEventListener(Event.COMPLETE, onXMLLoadComplete);
		}

		
		private function handleMouseWheel(me:MouseEvent):void
		{ // handle zoom

			if(me.delta > 0)
			{
				if(vis.scaleX < MAX_ZOOM)

				{
//					trace("zoom in!");
					vis.scaleX *= 1.1;
					vis.scaleY *= 1.1;
				}
			} 
			else
			{
				if(vis.scaleX > MIN_ZOOM)
				{
//					trace("zoom out!");
					vis.scaleX /= 1.1;
					vis.scaleY /= 1.1;
				}
			}
		}
		
		private function handleMouseMove(me:MouseEvent):void
		{ 
			if(me.buttonDown)
			{ // TODO: handle pan

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
			prevX = me.stageX;
			prevY = me.stageY;
		}
	}
}