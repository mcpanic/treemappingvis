package cs448b.fp.data
{
	import flare.vis.data.Tree;
	
	import flash.events.Event;
				
	public class DataLoader
	{
		private var tree1Parser:TreeParser;
		private var tree2Parser:TreeParser;
		private var _tree1:Tree;
		private var _tree2:Tree;
	
		private var tree1Address:String;
		private var tree2Address:String;

		private var _cb:Function;
				
		/**
		 * Constructor
		 */
		public function DataLoader()
		{
			_cb = null;
			tree1Address = "../data/tree_dog.xml";
			tree2Address = "../data/tree_cat.xml";			
//			mappingAddress = "../data/mapping1.txt";
			_tree1 = new Tree();
			_tree2 = new Tree();		 				
			tree1Parser = new TreeParser(tree1Address);
			tree2Parser = new TreeParser(tree2Address);
			tree1Parser.addLoadEventListener(handleLoaded);
			

		}
		
		public function get tree1():Tree
		{
			return _tree1;
		}
		public function get tree2():Tree
		{
			return _tree2;
		}
				
		/**
		 * Load the data
		 */
        public function loadData():void
        {		            			
			tree1Parser.parseXML();
			//tree2Parser.parseXML();
        }
        


		/**
		 * Handles the loaded event
		 */
		public function handleLoaded( evt:Event ):void
		{
		// register data into tree objects
			_tree1 = tree1Parser.tree;
			trace("loadData");
						
			if(_cb != null) 
				_cb( evt );					
		}

		/**
		 * Handles the loaded event
		 */
/*		public function handleLoaded2( evt:Event ):void
		{
		// register data into tree objects
			_tree2 = tree2Parser.tree;
			trace("loadData");
						
			if(_cb2 != null) 
				_cb2( evt );					
		}
*/

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

