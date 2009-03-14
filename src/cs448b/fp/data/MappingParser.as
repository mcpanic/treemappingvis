package cs448b.fp.data
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;		
							
	public class MappingParser
	{
		private var _mapping:Mapping;		
		private var _fileName:String;
		private var _cb:Function;
		
		private var _numNodes:Number;
		private var _numNodesLoaded:Number;	// number of trees loaded so far
						
		public function MappingParser(fileName:String)
		{
			_mapping = new Mapping();
			_fileName = fileName;
			_cb = null;
		}

		/**
		 * Get the index of the current tree
		 */		
		public function get mapping():Mapping
		{
			return _mapping;
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
		 * Event handler for XML load completion
		 */				
		private function onXMLLoadComplete(event:Event):void
		{
		    var loader:URLLoader = event.target as URLLoader;
		    
		    if (loader != null)
		    {
			    var externalXML:XML = new XML(loader.data);
				var contentID:Number;
				var layoutID:Number;
       			for (var i:uint=0; i<Number(externalXML.info.@numMappings); i++)
       			{
       				if (externalXML.mapping[i] != null && externalXML.mapping[i] != undefined)
       					contentID = Number(externalXML.mapping[i].@content);
       				else
       				{
       					trace("MappingParser.onXMLLoadComplete error: number of mappings and entities do not match");
       					trace(Number(externalXML.info.@numMappings)+"/"+i);
       				}
       					
       				if (externalXML.mapping[i] != null && externalXML.mapping[i] != undefined)
       					layoutID = Number(externalXML.mapping[i].@layout);
       				else
       				{
       					trace("MappingParser.onXMLLoadComplete error: number of mappings and entities do not match");
       					trace(Number(externalXML.info.@numMappings)+"/"+i);
       				}
       					 
       				_mapping.createMap(contentID, layoutID);
       			}
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