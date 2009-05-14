package cs448b.fp.data
{
	import flare.vis.data.Tree;
	
	import flash.events.Event;
			
	public class DataLoader
	{
		private var _treeList:Array;
		private var _cb:Function;
		private var _numFiles:Number;
		private var _numFilesLoaded:Number;	// number of trees loaded so far
		private var _mappingParser:MappingParser;
			
		/**
		 * Constructor
		 */
		public function DataLoader(numTrees:Number, fileNameArray:Array, mappingFileName:String, imageNameArray:Array)
		{
			_cb = null;
			//_numFiles = numTrees + 1;	// 1 is for the mapping
			_numFiles = numTrees;
			_numFilesLoaded = 0;
			_treeList = new Array(_numFiles);
			if (fileNameArray.length != numTrees)
			{	
				trace("ERROR: The number of filenames and trees does not match.");
				return;
			}
			// Add each tree info to the list of trees
			for (var i:uint = 0; i<_numFiles; i++)
			{
				_treeList[i] = new TreeInfo(i, fileNameArray[i], imageNameArray[i]);
				_treeList[i].parser.addLoadEventListener(handleLoaded);
			}
	
			//_mappingParser = new MappingParser(mappingFileName);
			//_mappingParser.addLoadEventListener(handleLoaded);
		}
		
		/**
		 * Get the tree with the index
		 */
		public function getTree(index:Number):Tree
		{
			return _treeList[index].parser.tree;
		}	
			
		/**
		 * Wrapper for the index retrieval function
		 */
		public function getMappedIndex(idx:Number, treeId:Number):Array
		{
			if(_mappingParser == null) 
				return null;
			
			return _mappingParser.mapping.getMappedIndex(idx, treeId);
		}
		
		/**
		 * Load the data
		 */
        public function loadData():void
        {		            			
			//for (var i:uint = 0; i<_numFiles-1; i++)
			for (var i:uint = 0; i<_numFiles; i++)
			{
				_treeList[i].parser.parseXML();
			}
			//_mappingParser.parseXML();
        }

		/**
		 * Handles the loaded event for all trees
		 */
		public function handleLoaded( evt:Event ):void
		{
			_numFilesLoaded++;
			if (_numFiles == _numFilesLoaded && _cb != null)
				_cb( evt );					
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

	//import flare.vis.data.Tree;	
	import cs448b.fp.data.TreeParser;		
	/**
	 * Managing a list of trees to be loaded from the visualization
	 */				
	class TreeInfo
	{
		private var _fileName:String;
		private var _parser:TreeParser;		
		private var _isLoadComplete:Boolean;

		public function TreeInfo(index:Number, fileName:String, imageLocation:String)
		{
			_fileName = fileName; 
			_parser = new TreeParser(index, _fileName, imageLocation);
		}

		public function get fileName():String
		{
			return _fileName;
		}		
		public function get parser():TreeParser
		{
			return _parser;
		}
	};	