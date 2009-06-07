package cs448b.fp.data
{
	import fl.containers.UILoader;
	
	import flare.vis.data.DataSprite;
	import flare.vis.data.NodeSprite;
	import flare.vis.data.Tree;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
							
	public class TreeParser
	{
		
		private var _tree:Tree;
		private var _fileName:String;
		private var _imageLocation:String;
		private var _cb:Function;
		private var _index:Number;
		
		private var _numNodes:Number;
		private var _numNodesLoaded:Number;	// number of trees loaded so far
						
		public function TreeParser(index:Number, fileName:String, imageLocation:String)
		{
			_tree = new Tree();
			_fileName = fileName;
			_imageLocation = imageLocation;
			_cb = null;
			_index = index;
			_numNodes = 0;
			_numNodesLoaded = 0;
		}

		/**
		 * Get the parsed tree
		 */		
		public function get tree():Tree
		{
			return _tree;
		}

		/**
		 * Get the index of the current tree
		 */		
		public function get index():Number
		{
			return _index;
		}
		
		/**
		 * Load the XML file for parsing
		 */						
		public function parseXML():void
		{
			var loader:URLLoader = new URLLoader();
			var request:URLRequest = new URLRequest(_fileName);
			loader.load(request);
			loader.addEventListener(Event.COMPLETE, onXMLLoadComplete);			
		}

		/**
		 * Attach data to the nodes
		 */			
		private function addDataNode(n:NodeSprite, xml:XML):void
		{
			
			n.name = xml.label.toString();
			n.props["x"] = Number(xml.position.@x);
			n.props["y"] = Number(xml.position.@y);
			n.props["width"] = Number(xml.position.@width);
			n.props["height"] = Number(xml.position.@height);
//			trace (n.name + " " + 	n.props["width"] + " " + n.props["height"]);	 
		}
				
		/**
		 * Attach images to the nodes
		 */			
		private function addImageNode(n:NodeSprite, xml:XML):void
		{
			var image:DisplayObject = addImage(n, xml);

//			if (n.name == "1")
//			{				
				n.props["image"] = image;
//				if (n.name == "1")
				n.addChild(image);

				//n.props["image"].visible = false;						
//			}
//			else
//			{
//	            var shape:Shape = new Shape();
//	            //shape.graphics.beginFill(0x101010);
//				shape.graphics.lineStyle(3, 0xbbbbbb);
//				shape.graphics.drawRoundRect(n.props["x"], n.props["y"], n.props["width"], n.props["height"], 20);
//				//shape.graphics.endFill();
//				n.props["image"] = shape;				
//				n.addChild(shape);				
//			}
		}

		/**
		 * Load images
		 */			
		private function addImage(n:NodeSprite, xml:XML):DisplayObject
		{
			var ldr:UILoader = new UILoader();

			var url:String = _imageLocation + xml.label + ".png";
			//var url:String = xml.url;
 			var urlReq:URLRequest = new URLRequest(url);
			ldr.load(urlReq);
			ldr.name = xml.label.toString();
			ldr.addEventListener(Event.COMPLETE,
				function(evt:Event):void
				{	
					_numNodesLoaded++;
					if(_numNodes == _numNodesLoaded && _cb != null) 
						_cb( evt );
											
				});
						
			return ldr;
		}
		
		/**
		 * Attach node data to the sprite
		 */	
		private function addNode(nodeSprite:NodeSprite, xml:XML):void
		{
			addDataNode(nodeSprite, xml);				
			addImageNode(nodeSprite, xml);
	 		_numNodes++;			
		} 
				
		/**
		 * Retrieve tree data from the given XML structure
		 */		
		private function retrieveData(xml:XMLList, depth:Number, parent:NodeSprite):void
		{
			var nodeSprite:NodeSprite; 			
							
			for each (var el:XML in xml)	// next depth
			{
				//trace(_index + "/" + el.label + "/" + depth);
				nodeSprite = _tree.addChild(parent);
				addNode(nodeSprite, el);
				
		 	    if (el.children.node != null && el.children.node != undefined) 
		 	    	retrieveData(el.children.node, depth + 1, nodeSprite);	// recursive
		 	}
		
		}

		/**
		 * Event handler for XML load completion
		 */				
		private function onXMLLoadComplete(event:Event):void
		{
		    var loader:URLLoader = event.target as URLLoader;
		    
		    if (loader != null)
		    {
			    var externalXML:XML = new XML(loader.data);
			    var nodeSprite:NodeSprite; 
       
				nodeSprite = _tree.addRoot();	// Add the tree root
				addNode(nodeSprite, externalXML);
		 		retrieveData(externalXML.children.node, 1, nodeSprite);

				
				if(_numNodes == _numNodesLoaded && _cb != null) 
					_cb( event );
		    }
		    else
		    {
		        trace("loader is not a URLLoader!");
		    }

		}

       /**
         * Add a load event listener 
         */
        public function addLoadEventListener(callback:Function):void
        {
        	_cb = callback;
        }
        
        /**
         * Remove a load event listener 
         */
        public function removeLoadEventListener():void
        {
        	_cb = null;
        }

	}
}