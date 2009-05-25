package cs448b.fp.data
{
	import cs448b.fp.utils.Theme;
	
	public class SessionManager
	{
		private var _assignmentId:String;
		private var _curSession:Number;
		private var _results:Array;
		
		public function SessionManager()
		{
			_results = new Array(Theme.NUM_SESSIONS + 1);
			_curSession = 0;
		}
		
		public function get assignmentId():String
		{
			return _assignmentId;
		}
		
		public function set assignmentId(id:String):void
		{
			_assignmentId = id;
		}
		
		public function get curSession():Number
		{
			return _curSession;
		}
		
		public function set curSession(session:Number):void
		{
			_curSession = session;
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