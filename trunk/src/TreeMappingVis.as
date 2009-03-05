package {
	import cs448b.fp.data.DataLoader;
	
	import flash.display.Sprite;
	
	// Convenient way to pass in compiler arguments
	// Place after import statements and before first class declaration 
	[SWF(width='1024', height='768', backgroundColor='#ffffff', frameRate='30')]
	
	public class TreeMappingVis extends Sprite
	{
		private var dataLoader:DataLoader;
		
		/**
		 * Constructor
		 */		
		public function TreeMappingVis()
		{
			initComponents();
			loadData();			
			buildSprite();

		}
		
		private function initComponents():void
		{
		}

		/**
		 * Load the tree and mapping data from external files
		 */
		private function loadData():void
		{
			dataLoader = new DataLoader();
			dataLoader.loadData();			
		}
		
		private function buildSprite():void
		{
		}
	}
}



