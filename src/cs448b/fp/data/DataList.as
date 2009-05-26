package cs448b.fp.data
{
	import cs448b.fp.utils.Theme;
	
	public class DataList
	{
		public static var NUMPAIRS:Number = 5;
		private var _mappingList:Array;
		private var _cName:String;
		private var _lName:String;
		 
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
		 * Get the name of the content page
		 */				
		public function get cName():String
		{
			return _cName;	
		}		

		/**
		 * Get the name of the layout page
		 */				
		public function get lName():String
		{
			return _lName;	
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
				_cName = "dog";
				_lName = "cat";			
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
					_cName = "kayak";
					_lName = "google";						
					fileList[0] = "../data/" + _cName + ".xml";
					fileList[1] = "../data/" + _lName + ".xml";			
					imageList[0] = "../data/" + _cName + "/";
					imageList[1] = "../data/" + _lName + "/";
	//				mappingFile = "../data/map_" + _lName + ".xml";				
				}
				else if (mappingID == 1)
				{
					_cName = "courseRank";
					_lName = "moo";						
					fileList[0] = "../data/" + _cName + ".xml";
					fileList[1] = "../data/" + _lName + ".xml";			
					imageList[0] = "../data/" + _cName + "/";
					imageList[1] = "../data/" + _lName + "/";
	//				mappingFile = "../data/map_" + _lName + ".xml";			
				}		
				else if (mappingID == 2)
				{
					_cName = "flickr";
					_lName = "mint";						
					fileList[0] = "../data/" + _cName + ".xml";
					fileList[1] = "../data/" + _lName + ".xml";			
					imageList[0] = "../data/" + _cName + "/";
					imageList[1] = "../data/" + _lName + "/";
	//				mappingFile = "../data/map_" + _lName + ".xml";						
				}		
				else if (mappingID == 3)
				{
					_cName = "allRecipes";
					_lName = "nature";						
					fileList[0] = "../data/" + _cName + ".xml";
					fileList[1] = "../data/" + _lName + ".xml";			
					imageList[0] = "../data/" + _cName + "/";
					imageList[1] = "../data/" + _lName + "/";
	//				mappingFile = "../data/map_" + _lName + ".xml";						
				}	
				else if (mappingID == 4)
				{
					_cName = "rockTheVote";
					_lName = "dwell";						
					fileList[0] = "../data/" + _cName + ".xml";
					fileList[1] = "../data/" + _lName + ".xml";			
					imageList[0] = "../data/" + _cName + "/";
					imageList[1] = "../data/" + _lName + "/";
	//				mappingFile = "../data/map_" + _lName + ".xml";				
				}	
			}
		}
	}
}