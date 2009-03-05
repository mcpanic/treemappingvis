package cs448b.fp.data
{
	import flare.vis.data.Tree;
	
	import flash.events.Event;
				
	public class DataLoader
	{
		private var tree1Parser:TreeParser;
		private var tree2Parser:TreeParser;
		private var tree1:Tree;
		private var tree2:Tree;
	
		private var tree1Address:String;
		private var tree2Address:String;
		
		/**
		 * Constructor
		 */
		public function DataLoader()
		{
			tree1Address = "../data/tree_dog.xml";
			tree2Address = "../data/tree_cat.xml";			
//			mappingAddress = "../data/mapping1.txt";
			tree1 = new Tree();
			tree2 = new Tree();		 				
			tree1Parser = new TreeParser(tree1Address);
			tree2Parser = new TreeParser(tree2Address);
			tree1Parser.addLoadEventListener(handleLoaded);
		}
		
		/**
		 * Load the data
		 */
        public function loadData():void
        {		            			
			tree1Parser.parseXML();
			tree2Parser.parseXML();
			tree1 = tree1Parser.tree;
			tree2 = tree2Parser.tree;	
        }
        


		/**
		 * Handles the loaded event
		 */
		public function handleLoaded( evt:Event ):void
		{
		// register data into tree objects
		}
		 
	}
}

