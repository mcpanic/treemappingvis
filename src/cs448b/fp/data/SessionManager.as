package cs448b.fp.data
{
	import cs448b.fp.ui.Theme;
	
	public class SessionManager
	{
		// all files to refer to this variable whenever trying to check preview state
		public static var isPreview:Boolean = true;
		public static var isTutorialRestart:Boolean = false;
		public static var assignmentId:String = "";
		public static var curSession:Number = 0;
		
		//private var _assignmentId:String;
		//private var _curSession:Number;
		private var _results:Array;		
		
		public function SessionManager()
		{
			_results = new Array(Theme.NUM_SESSIONS + 1);
			//_curSession = 0;
		}
				
		/**
		 * Is this a tutorial session?
		 */
		public static function isTutorial():Boolean
		{
			var ret:Boolean;
			if (Theme.ENABLE_MANUAL_PREVIEW == 0)
			{		
				if (assignmentId == null || assignmentId == "ASSIGNMENT_ID_NOT_AVAILABLE")
					ret = true;
				else
					ret = false;
			}
			else if (Theme.ENABLE_MANUAL_PREVIEW == 1)
				ret = true;
			else
				ret = false;
				
			return ret;
			
		}

		/**
		 * Add tree names (before starting a session)
		 */			
		public function addPairName(cName:String, lName:String):void
		{
			_results[curSession] = new Results(cName, lName);
		}

		/**
		 * Add mapping results (after a session is complete)
		 */			
		public function addResult(val:String):void
		{
			_results[curSession].result = val;
		}
		
		public function getCName(id:Number):String
		{
			return _results[id].cName;
		}
		
		public function getLName(id:Number):String
		{
			return _results[id].lName;
		}
		public function getResult(id:Number):String
		{
			return _results[id].result;
		}		
	}
}


//import cs448b.fp.data;		
/**
 * Managing mapping results
 */				
class Results
{
	private var _cName:String;
	private var _lName:String;
	private var _result:String;

	public function Results(cname:String, lname:String)
	{
		_cName = cname;
		_lName = lname;
	}

	public function get cName():String
	{
		return _cName;
	}		
	public function get lName():String
	{
		return _lName;
	}
	public function get result():String
	{
		return _result;
	}
	public function set result(val:String):void
	{
		_result = val;
	}
};	