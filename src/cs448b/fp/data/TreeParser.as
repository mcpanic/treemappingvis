package cs448b.fp.data
{
	import fl.containers.UILoader;
	
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
		private var _cb:Function;
		private var _index:Number;
		
		private var _numNodes:Number;
		private var _numNodesLoaded:Number;	// number of trees loaded so far
						
		public function TreeParser(index:Number, fileName:String)
		{
			_tree = new Tree();
			_fileName = fileName;
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
		 * Attach images to the nodes
		 */			
		private function addImageNode(n:NodeSprite, num:Number):void
		{
			var image:DisplayObject = addImage(n, num);
			n.addChild(image);
		}

		/**
		 * Load images
		 */			
		private function addImage(n:NodeSprite, num:Number):DisplayObject
		{
			var ldr:UILoader = new UILoader();

			var url:String = "../data/thumbnails/"+num+".PNG";
 			var urlReq:URLRequest = new URLRequest(url);
			ldr.load(urlReq);
			
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
		 * Retrieve tree data from the given XML structure
		 */		
		private function retrieveData(xml:XMLList, depth:Number, parent:NodeSprite):void
		{
			var nodeSprite:NodeSprite; 			
							
			for each (var el:XML in xml)	// next depth
			{
//				trace(el.label + "/" + depth);
				nodeSprite = _tree.addChild(parent);
				_numNodes++;
				addImageNode(nodeSprite, el.label);
		
		 	    if (el.children.node == null || el.children.node == undefined)
		 	    {}	// do nothing
		 	    else 
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
				addImageNode(nodeSprite, externalXML.label);	    
		 		_numNodes++;
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