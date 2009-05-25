package cs448b.fp.data
{
	import cs448b.fp.utils.Theme;
	
	public class DataList
	{
		public static var NUMPAIRS:Number = 5;
		private var _mappingList:Array;
		 
		public function DataList()
		{
			_mappingList = new Array(NUMPAIRS);
			for(var i:uint=0; i<NUMPAIRS; i++)
				_mappingList[i] = false;
		}

		/**
		 * Get a random number between 0 and n-1
		 */
		private function getRandomNumberWithinRange(n:Number):Number
		{
			var ret:Number = Math.floor(Math.random() * (n)); 
			return ret;
		}

		/**
		 * Check if the current ID is already mapped
		 */
		private function checkDuplicate(id:Number):Boolean
		{
			var ret:Boolean = false;
			for(var i:uint=0; i<NUMPAIRS; i++)
			{
				if (i == id)	
				{
					// already assigned
					if (_mappingList[i] == true)
					{
						ret = true;
					}
					else
					{
						_mappingList[i] = true;
						ret = false;
					}
					break;
				}
			}	
			return ret;		
		}
		
		/**
		 * Populate the data list based on random assignment
		 */				
		public function getDataList(fileList:Array, imageList:Array, isPreview:Boolean):void
		{
			var mappingID:Number;
			// For preview, hard-code the pair for tutorial & instructions
			// For actual sessions, randomly assign a pair
			if (isPreview == true)
			{
				fileList[0] = "../data/tree_dog.xml";
				fileList[1] = "../data/tree_cat.xml";			
				imageList[0] = "../data/dog/";
				imageList[1] = "../data/cat/";				
			}
			else
			{				
				while (1)
				{
					// Get a random number
					mappingID = getRandomNumberWithinRange(NUMPAIRS);
					trace("assigned ID: " + mappingID);
					// If duplicate number assigned, get another one
					if (checkDuplicate(mappingID) == false)
						break;
				}
				
				// When debugging, make everything easy
				if (Theme.ENABLE_DEBUG == true)
				{	
					if (mappingID == 0 || mappingID == 1)
						mappingID = 2;
					else if (mappingID == 4)
						mappingID = 3;
				}
												
				if (mappingID == 0)
				{
					fileList[0] = "../data/tree_content.xml";
					fileList[1] = "../data/tree_moo.xml";			
					imageList[0] = "../data/content/";
					imageList[1] = "../data/moo/";
	//				mappingFile = "../data/map_moo.xml";			
				}
				else if (mappingID == 1)
				{
					fileList[0] = "../data/tree_content.xml";
					fileList[1] = "../data/tree_hybrid.xml";			
					imageList[0] = "../data/content/";
					imageList[1] = "../data/hybrid/";
	//				mappingFile = "../data/map_hybrid.xml";			
				}		
				else if (mappingID == 2)
				{
					fileList[0] = "../data/google.xml";
					fileList[1] = "../data/courseRank.xml";			
					imageList[0] = "../data/google/";
					imageList[1] = "../data/courseRank/";
	//				mappingFile = null;//"../data/map_cat.xml";			
				}		
				else if (mappingID == 3)
				{
					fileList[0] = "../data/courseRank.xml";
					fileList[1] = "../data/allRecipes.xml";			
					imageList[0] = "../data/courseRank/";
					imageList[1] = "../data/allRecipes/";
	//				mappingFile = null;//"../data/map_cat.xml";			
				}	
				else if (mappingID == 4)
				{
					fileList[0] = "../data/allRecipes.xml";
					fileList[1] = "../data/tree_moo.xml";			
					imageList[0] = "../data/allRecipes/";
					imageList[1] = "../data/moo/";
	//				mappingFile = null;//"../data/map_cat.xml";			
				}	
			}
		}
	}
}