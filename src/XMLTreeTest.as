package
{
	import flare.query.methods.update;
	import flare.util.Orientation;
	import flare.util.Shapes;
	import flare.vis.Visualization;
	import flare.vis.controls.ExpandControl;
	import flare.vis.controls.HoverControl;
	import flare.vis.controls.IControl;
	import flare.vis.data.Data;
	import flare.vis.data.NodeSprite;
	import flare.vis.data.Tree;
	import flare.vis.events.SelectionEvent;
	import flare.vis.operator.encoder.PropertyEncoder;
	import flare.vis.operator.layout.NodeLinkTreeLayout;
	
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.events.MouseEvent;
	
	// Convenient way to pass in compiler arguments
	// Place after import statements and before first class declaration 
	[SWF(width='1024', height='768', backgroundColor='#ffffff', frameRate='30')]
	
	public class XMLTreeTest extends Sprite
	{
		
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
		
		private var ctrl:IControl;
		
		private var nodeNum:Number = 0;
		
		public function XMLTreeTest()
		{
			//initComponents();
			
			//buildSprite();
			addEventListener(MouseEvent.MOUSE_WHEEL, handleMouseWheel);
				
			addEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
			parseXML();
		}
		
		private function initComponents():void
		{
			Shapes.setShape("RECT", drawRectangle);
			
			// create data and set defaults
//			data = createTree();//GraphUtil.diamondTree(3,4,4);
			data = tree;
			
			data.nodes.setProperties(nodes);
			data.edges.setProperties(edges);
			for (var j:int=0; j<data.nodes.length; ++j) {
				data.nodes[j].data.label = String(j);
				data.nodes[j].buttonMode = true;
			}
			
			ctrl = new ExpandControl(NodeSprite,
				function():void { vis.update(1, "nodes","main").play(); });
			
			initVis();
		}
		
		private function initVis():void
		{
			vis = new Visualization(data);
//			vis.bounds = new Rectangle(stage.width/2, stage.height/2, stage.width/2, stage.height/2);
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
			vis.controls.add(ctrl);
			vis.update();
		}
		
		private function buildSprite():void
		{
			addChild(vis);
		}
		
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
		
		private function addImageNode(n:NodeSprite, num:Number = 0):void
		{
			var image:DisplayObject = addImage(n, num);
			n.addChild(image);
		}
		
		private function addImage(n:NodeSprite, num:Number = 0):DisplayObject
		{
			if(num == 0)
			{
				var tf:TextField = new TextField();
				
				tf.text = "Node";
				return tf;
			}
			var ldr:Loader = new Loader();
			var url:String = "thumbnails\\"+num+".PNG";
 			var urlReq:URLRequest = new URLRequest(url);
			ldr.load(urlReq);
			
			ldr.contentLoaderInfo.addEventListener(Event.COMPLETE,
				function(evt:Event):void
				{	
					iw = ldr.width;
					ih = ldr.height;
//					n.shape = "RECT"; // Trying to make the node shaped like the image 
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


import flash.events.Event;
import flash.net.URLLoader;
import flash.net.URLRequest;
private var tree:Tree;

private function retrieveData(xml:XMLList, depth:Number, parent:NodeSprite):void
{
	var nodeSprite:NodeSprite; 
	
//			
//			var n:NodeSprite = tree.addRoot();
//			addImageNode(n); 
//			
//			var l:NodeSprite = tree.addChild(n);
//			addImageNode(l);
//			
//			var r:NodeSprite = tree.addChild(n);
//			addImageNode(r);
	
					
	for each (var el:XML in xml)	// next depth
	{
		trace(el.label + "/" + depth);
		nodeSprite = tree.addChild(parent);
		addImageNode(nodeSprite, el.label);

 	}
 	    if (xml.children.node == null || xml.children.node == undefined)
    		return;
    	//trace("hello");
    	retrieveData(xml.children.node, depth + 1, nodeSprite);	

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
			var request:URLRequest = new URLRequest("tree_cat.xml");
			loader.load(request);
			loader.addEventListener(Event.COMPLETE, onXMLLoadComplete);			
//			//Build the JavaScript objects representing the tree
//			function createObjects(element, depth)
//			{
//				element.label = element.getElementsByTagName("label")[0].firstChild.nodeValue;
//				element.url = element.getElementsByTagName("url")[0].firstChild.nodeValue;
//				element.depth = depth;
//				if(treeWidths[depth] == undefined){
//					treeWidths[depth] = 1;
//				} else {
//					treeWidths[depth]++;
//				}
//				element.children = new Array();
//				allNodes.push(element);
//				
//				var children = element.getElementsByTagName("children")[0].childNodes;
//				for(var i=0; i<children.length; i++){
//					if(children[i].nodeType != 3 && children[i].tagName == "node"){  //TextNode = type 3
//						element.children.push(createObjects(children[i], depth+1));  //Recurse on children
//					}
//				}
//
//				return element;
//			}
			
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