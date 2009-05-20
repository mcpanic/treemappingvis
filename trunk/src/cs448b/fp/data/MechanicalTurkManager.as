package cs448b.fp.data
{
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.utils.Timer;

	public class MechanicalTurkManager extends Sprite
	{
		private var assignmentId:String;
		
		public function MechanicalTurkManager()
		{
			super();
			init();
		}
		
		private function init():void
		{
            if (ExternalInterface.available) {
                try {
                    trace("Adding callback...");
                    ExternalInterface.addCallback("sendToActionScript", receivedFromJavaScript);
                    if (checkJavaScriptReady()) {
                        trace("JavaScript is ready.");
                    } else {
                        trace("JavaScript is not ready, creating timer.");
                        var readyTimer:Timer = new Timer(100, 0); 
                        readyTimer.addEventListener(TimerEvent.TIMER, timerHandler);
                        readyTimer.start();
                    }
                } catch (error:SecurityError) {
                    trace("A SecurityError occurred: " + error.message);
                } catch (error:Error) {
                    trace("An Error occurred: " + error.message);
                }
            } else {
                trace("External interface is not available for this container.");
            }
						
		}
		
        private function receivedFromJavaScript(value:String):void 
        {
            trace("JavaScript says: " + value);
        }
        
        private function checkJavaScriptReady():Boolean 
        {
            var isReady:Boolean = ExternalInterface.call("isReady");
            return isReady;
        }
        
        private function timerHandler(event:TimerEvent):void 
        {
            trace("Checking JavaScript status...");
            var isReady:Boolean = checkJavaScriptReady();
            if (isReady) {
                trace("JavaScript is ready.");
                Timer(event.target).stop();
            }
        }
        
        public function getAssignmentId():String 
        {
        	assignmentId = ExternalInterface.call("gup", "assignmentId");
        	trace(assignmentId);
        	return assignmentId;
        }		
	}
}