package cs448b.fp.data
{
	import cs448b.fp.utils.Theme;
	
	import flash.geom.Point;
	
	public class DataList
	{
		private var _pairList:Array;
		private var _cId:Number;
		private var _lId:Number;
		private var _cName:String;
		private var _lName:String;
		private var _contentArray:Array;
		private var _layoutArray:Array;
		 
		public function DataList()
		{
			_pairList = new Array();
				
			_contentArray 	= new Array("rockTheVote_content", 
			"courseRank_content", "moo_content", 
			"yelp_content", "nymbler_content", 
			"zopa_content", "allRecipes_content", 
			"breastCancer_content", "dwell_content", 
			"flickr_content", "google_content", 
			"weekendSherpa_content", "mint_content", 
			"nature_content", "paloAlto_content");
			
			_layoutArray 	= new Array("rockTheVote_layout", 
			"courseRank_layout", "moo_layout", 
			"yelp_layout", "nymbler_layout", 
			"zopa_layout", "allRecipes_layout", 
			"breastCancer_layout", "dwell_layout", 
			"flickr_layout", "google_layout", 
			"weekendSherpa_layout", "mint_layout", 
			"nature_layout", "paloAlto_layout");											
		}

		/**
		 * Add a pair
		 */
		private function addPair(cId:Number, lId:Number):void
		{
			 _pairList.push(new Point(cId, lId));
		}

		/**
		 * Print assigned pairs
		 */
		private function printPairs():void
		{
			 trace(_pairList);
		}
		
		/**
		 * Get the name of the content page
		 */				
		public function getContentName(cId:Number):String
		{
			return _contentArray[cId];	
		}	

		/**
		 * Get the name of the layout page
		 */				
		public function getLayoutName(lId:Number):String
		{
			return _layoutArray[lId];	
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
		private function checkDuplicate(cId:Number, lId:Number):Boolean
		{
			var ret:Boolean = false;
//			for(var i:uint=0; i<Theme.NUM_PAIRS; i++)
//			{
//				if (i == id)	
//				{
//					// already assigned
//					if (_mappingList[i] == true)
//					{
//						ret = true;
//					}
//					else
//					{
//						_mappingList[i] = true;
//						ret = false;
//					}
//					break;
//				}
//			}	
			
			var pair:Point;
			// if the identical pair, consider as a duplicate
			if (cId == lId)
				ret = true;
			// see if the given pair matches any of the existing pairs 
			for(var obj:Object in _pairList)
			{
				pair = _pairList[obj] as Point;				
				if (pair.x == cId)
					ret = true;
				if (pair.y == lId)
					ret = true
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
		public function getDataList(fileList:Array, imageList:Array, isPreview:Boolean, pair:Point=null):Point
		{
			var cId:Number = -1;
			var lId:Number = -1;
			// For preview, hard-code the pair for tutorial & instructions
			// For actual sessions, randomly assign a pair
			if (isPreview == true)
			{
				_cName = "dog";
				_lName = "cat";			
			}
			else
			{	
				// when a pair is fixed
				if (pair != null)
				{
					cId = pair.x;
					lId = pair.y;
				}
				// when a new random pair is needed
				else
				{			
					while (1)
					{
						// Get a random number
						cId = getRandomNumberWithinRange(Theme.NUM_PAIRS);
						lId = getRandomNumberWithinRange(Theme.NUM_PAIRS);
						trace("assigned pair: " + cId + "--" + lId);
						// If duplicate number assigned, get another one
						if (checkDuplicate(cId, lId) == false)
							break;
					}
					// add this pair, and get the names
					addPair(cId, lId);					
				}

				printPairs();
				_cName = getContentName(cId);
				_lName = getLayoutName(lId);					
			}
				
			fileList[0] = "../data/" + _cName + ".xml";
			fileList[1] = "../data/" + _lName + ".xml";			
			imageList[0] = "../data/" + _cName + "/";
			imageList[1] = "../data/" + _lName + "/";
//			mappingFile = "../data/map_" + _lName + ".xml";						
			return (new Point(cId, lId));
		}
	}
}