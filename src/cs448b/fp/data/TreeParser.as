package cs448b.fp.data
{
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.events.Event;
	
	import flare.vis.data.NodeSprite;
	import flare.vis.data.Tree;
	
					
	public class TreeParser
	{
		
		private var _tree:Tree;
		private var _fileName:String;
		private var _cb:Function;
						
		public function TreeParser(fileName:String)
		{
			_tree = new Tree();
			_fileName = fileName;
			_cb = null;
		}

		/**
		 * Get the parsed tree
		 */		
		public function get tree():Tree
		{
			return _tree;
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
		 * Retrieve tree data from the given XML structure
		 */		
		private function retrieveData(xml:XMLList, depth:Number, parent:NodeSprite):void
		{
			var nodeSprite:NodeSprite; 			
							
			for each (var el:XML in xml)	// next depth
			{
				trace(el.label + "/" + depth);
				nodeSprite = _tree.addChild(parent);
//				addImageNode(nodeSprite, el.label);
		
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
				trace(externalXML.label);
       
				nodeSprite = _tree.addRoot();	// Add the tree root
//				addImageNode(nodeSprite, externalXML.label);	    
		 		retrieveData(externalXML.children.node, 1, nodeSprite);

				
				if(_cb != null) 
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