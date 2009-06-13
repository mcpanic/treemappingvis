package cs448b.fp.data
{
	import cs448b.fp.ui.Theme;
	
	import fl.containers.UILoader;
	
	import flare.vis.data.NodeSprite;
	import flare.vis.data.Tree;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.PixelSnapping;
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
			// original
//			var image:DisplayObject = addImage(n, xml);
//			n.props["image"] = image;
//			n.addChild(image);
			
			if (Theme.ENABLE_INTERPOLATION == false)
			{							
				var image:DisplayObject = addImage(n, xml);
				if (_tree.root == n)
				{				
					n.props["image"] = image;
					n.addChild(image);
				}
			}
			else
			{
				addImageLoader(n, xml);
								
			}
		}

		private function onAddImageLoaderComplete(e:Event):void
		{
//			if (Theme.ENABLE_INTERPOLATION == true)
//			{
//				//var source:IBitmapDrawable = e.target.loader;
//				var source:DisplayObject = e.target as DisplayObject;
//				var original:InterpolatedBitmapData = new InterpolatedBitmapData(source.width, source.height);
//				original.draw(source);
//				 
//				/* The size of the output image */
//				var newWidth:int = 100;
//				var newHeight:int = 200;
//				 
//				var resized:BitmapData = new BitmapData(newWidth, newHeight);
//				 
//				var xFactor:Number = original.width / newWidth;
//				var yFactor:Number = original.height / newHeight;
//				 
//				/* Loop through the pixels of the output image, fetching the equivalent pixel from the input*/
//				for (var x:int = 0; x < newWidth; x++) 
//				{
//				    for (var y:int = 0; y < newHeight; y++) 
//				    {
//				        resized.setPixel(x, y, original.getPixelBilinear(x * xFactor, y * yFactor));
//				    }
//				}
//			}		
				var loader:Loader = Loader(e.target.loader);
				var img:Bitmap = Bitmap(loader.content);
				img.smoothing = true;
				//img.pixelSnapping = PixelSnapping.AUTO;							
				_tree.root.props["image"] = img;
				_tree.root.addChild(img);					
				if (_cb != null) 
					_cb();							
		
		}
		
		private function onAddImageComplete(e:Event):void
		{

			if (_cb != null) 
				_cb();			
		}
		
		/**
		 * Load images with Loader class
		 */			
		private function addImageLoader(n:NodeSprite, xml:XML):void
		{
			var ldr:Loader;
			var url:String;
			var urlReq:URLRequest;
			// load only the root image
			if (Theme.ENABLE_IMAGE_SEGMENT == false)
			{			
				if (n == _tree.root)
				{
					ldr = new Loader();							
					url = _imageLocation + xml.label + ".png";
		 			urlReq = new URLRequest(url);
					ldr.load(urlReq);
					ldr.name = xml.label.toString();
					ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, onAddImageLoaderComplete);					
				}
						
			}
			
		}
				
		/**
		 * Load images
		 */			
		private function addImage(n:NodeSprite, xml:XML):DisplayObject
		{
			var ldr:UILoader;
			var url:String;
			var urlReq:URLRequest;
			// load only the root image
			if (Theme.ENABLE_IMAGE_SEGMENT == false)
			{			
				if (n == _tree.root)
				{	
					ldr = new UILoader();					
					url = _imageLocation + xml.label + ".png";
		 			urlReq = new URLRequest(url);
					ldr.load(urlReq);
					ldr.name = xml.label.toString();
					ldr.addEventListener(Event.COMPLETE, onAddImageComplete);
					return ldr;
				}
				else
				{					
					return null;	
				}			
			}
			// load every image
			else
			{
					ldr = new UILoader();
					url = _imageLocation + xml.label + ".png";
		 			urlReq = new URLRequest(url);
					ldr.load(urlReq);
					ldr.name = xml.label.toString();
					ldr.addEventListener(Event.COMPLETE,
						function(evt:Event):void
						{	
							_numNodesLoaded++;
							if(_numNodes == _numNodesLoaded && _cb != null) 
								_cb();
													
						});
					return ldr;				
			}		
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