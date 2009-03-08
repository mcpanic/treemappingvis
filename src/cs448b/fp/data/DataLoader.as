package cs448b.fp.data
{
	import flare.vis.data.Tree;
	
	import flash.events.Event;
			
	public class DataLoader
	{
		private var _treeList:Array;
		private var _cb:Function;
		private var _numTrees:Number;
		private var _numTreesLoaded:Number;	// number of trees loaded so far
		
			
		/**
		 * Constructor
		 */
		public function DataLoader(numTrees:Number, fileNameArray:Array)
		{
			_cb = null;
			_numTrees = numTrees;
			_numTreesLoaded = 0;
			_treeList = new Array(_numTrees);
			if (fileNameArray.length != numTrees)
			{	
				trace("ERROR: The number of filenames and trees does not match.");
				return;
			}
			// Add each tree info to the list of trees
			for (var i:uint = 0; i<_numTrees; i++)
			{
				_treeList[i] = new TreeInfo(i, fileNameArray[i]);
				_treeList[i].parser.addLoadEventListener(handleLoaded);
			}
	
//			mappingAddress = "../data/mapping1.txt";


		}
		
		public function getTree(index:Number):Tree
		{
			return _treeList[index].parser.tree;
		}		
		/**
		 * Load the data
		 */
        public function loadData():void
        {		            			
			for (var i:uint = 0; i<_numTrees; i++)
			{
				_treeList[i].parser.parseXML();
			}
        }

		/**
		 * Handles the loaded event for all trees
		 */
		public function handleLoaded( evt:Event ):void
		{
			_numTreesLoaded++;
			if (_numTrees == _numTreesLoaded && _cb != null)
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

		public function TreeInfo(index:Number, fileName:String)
		{
			_fileName = fileName; 
			_parser = new TreeParser(index, _fileName);
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