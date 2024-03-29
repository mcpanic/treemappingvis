package cs448b.fp.display
{
	import cs448b.fp.data.SessionManager;
	import cs448b.fp.event.ControlsEvent;
	import cs448b.fp.ui.Theme;
	
	import fl.controls.Button;
	
	import flare.display.TextSprite;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.net.navigateToURL;
	import flash.text.TextField;
		
	public class ResultManager extends Sprite
	{
		private var _confirmButton:Button;
		private var _inst:TextField;
//		private var _message:TextSprite;
		private var _output:TextField;
		
		private var _sessionManager:SessionManager;
//		private var _assignmentId:String;
//		private var _results:String;
		private var _isConfirmed:Boolean;
		
		public function ResultManager()
		{
			this.graphics.beginFill(0x101010);
			this.graphics.lineStyle(3, 0xbbbbbb);
			this.graphics.drawRoundRect(0, 0, Theme.LAYOUT_RESULT_WIDTH, Theme.LAYOUT_RESULT_HEIGHT, 20);
			this.graphics.endFill();
			_isConfirmed = false;
		}

		/**
		 * 
		 */			
		public function init():void
		{
			addConfirmButton();		
			//addInstruction();
			addMessage();
			showMessage(Theme.MSG_RESULT);
		}
		
		public function setSessionManager(sessionManager:SessionManager):void
		{
			_sessionManager = sessionManager;
		}

		/**
		 * Add a confirm button
		 */					
		private function addConfirmButton():void
		{	   
			_confirmButton = new Button();
			if (SessionManager.isTutorial() == true)
				_confirmButton.label = "Continue";
			else
				_confirmButton.label = "Submit";
			_confirmButton.toggle = true;
			_confirmButton.width = 100;
			_confirmButton.x = Theme.LAYOUT_RESULT_WIDTH / 2 - _confirmButton.width / 2;
			_confirmButton.y = Theme.LAYOUT_RESULT_HEIGHT - 40;
           	_confirmButton.addEventListener(MouseEvent.CLICK, onConfirmButton);
           	_confirmButton.setStyle("textFormat", Theme.FONT_BUTTON);
           	_confirmButton.useHandCursor = true;
           	addChild(_confirmButton);         	
		}

		private function onSendComplete(event:Event):void
		{
			_output.appendText("HIT successfully submitted. Thank you.\n");
		}
		
        private function sendToServer():void 
        {
        	
			var variables:URLVariables = new URLVariables();
            variables.assignmentId = SessionManager.assignmentId;
            for (var i:uint=1; i<=Theme.NUM_SESSIONS; i++)
            {
            	variables["cname"+i] 	= _sessionManager.getCName(i);
            	variables["lname"+i] 	= _sessionManager.getLName(i);
            	variables["result"+i] 	= _sessionManager.getResult(i);
            	trace("Result" + i + ": " + _sessionManager.getCName(i) + "--" + _sessionManager.getLName(i) + ":" + _sessionManager.getResult(i));
            }
            
            var request:URLRequest = new URLRequest();
			request.url = "http://www.mturk.com/mturk/externalSubmit";
			request.method = URLRequestMethod.POST;
			request.data = variables;
//			var loader:URLLoader = new URLLoader();
//			loader.dataFormat = URLLoaderDataFormat.VARIABLES;
//			loader.addEventListener(Event.COMPLETE, onSendComplete);

            trace("send: " + request.url + "?" + request.data);
            _output.appendText(Theme.MSG_RESULT_SENDING);
            //_output.appendText("send: " + request.url + "?" + request.data + "\n");			
			try
			{
				navigateToURL(request, "_self");
			    //loader.load(request);
			}
            catch (e:SecurityError) {
                _output.appendText("A SecurityError occurred: " + e.message + "\n");
                trace("A SecurityError occurred: " + e.message);
            }
            catch (e:Error) {
            	_output.appendText("sendToURL error \n");
                trace("sendToURL error");
            }


        	
        	
//            var url:String = "http://www.mturk.com/mturk/externalSubmit";
//            var variables:URLVariables = new URLVariables();
//            variables.assignmentId = _assignmentId;
//            variables.result = _results;
//
//            var request:URLRequest = new URLRequest(url);
//            request.data = variables;
//            trace("sendToURL: " + request.url + "?" + request.data);
//            _output.appendText("sendToURL: " + request.url + "?" + request.data + "\n");
//            try {
//                sendToURL(request);
//            }
//            catch (e:SecurityError) {
//                _output.appendText("A SecurityError occurred: " + e.message + "\n");
//                trace("A SecurityError occurred: " + e.message);
//            }
//            catch (e:Error) {
//            	_output.appendText("sendToURL error \n");
//                trace("sendToURL error");
//            }
        }
        
        
		/**
		 * Event handler for confirm button click
		 */	
        private function onConfirmButton( mouseEvent:MouseEvent ):void
        {  	
        	if (SessionManager.isTutorial() == true)
        	{
        		dispatchEvent( new ControlsEvent( ControlsEvent.STATUS_UPDATE, "tutorial_submit") );     
        	}
        	else
        	{
	        	if (SessionManager.curSession < Theme.NUM_SESSIONS)
	        	{
	        		
		            trace("Result" + SessionManager.curSession + ": " + _sessionManager.getCName(SessionManager.curSession) + "--" + _sessionManager.getLName(SessionManager.curSession) + ":" + _sessionManager.getResult(SessionManager.curSession));		            
	        		dispatchEvent( new ControlsEvent( ControlsEvent.STATUS_UPDATE, "confirm") );
	        	}
	        	else if (_isConfirmed == false && SessionManager.curSession == Theme.NUM_SESSIONS)
	        	{   					
					sendToServer();
					dispatchEvent( new ControlsEvent( ControlsEvent.STATUS_UPDATE, "confirm") );     
	        		_isConfirmed = true;
	        		_confirmButton.label = "Close";
	        	}
	        	else
					dispatchEvent( new ControlsEvent( ControlsEvent.STATUS_UPDATE, "close") );             	
        	}
        }
				
//		/**
//		 * Add an instruction for mapping completion
//		 */	        
//		private function addInstruction():void
//		{
//            //_inst = new TextSprite("", Theme.FONT_MESSAGE);//_textFormat);
//            _inst = new TextField();
//            //_inst.horizontalAnchor = TextSprite.LEFT;
//            _inst.defaultTextFormat = Theme.FONT_MESSAGE;
//            _inst.text = Theme.MSG_RESULT;
//            _inst.x = 50;
//            _inst.y = 30;
//            //_inst.textMode = TextSprite.DEVICE;
//            addChild( _inst );        
//        }  
        				
		/**
		 * Event handler for cancel button click
		 */	        
		private function addMessage():void
		{
            _output = new TextField();
            _output.x = 50;
            _output.y = 30;
            _output.textColor = 0xffffff;
            _output.defaultTextFormat = Theme.FONT_MESSAGE;
            _output.width = Theme.LAYOUT_POPUP_WIDTH - 100;
            _output.height = 50;
            _output.multiline = true;
            _output.wordWrap = true;
            _output.border = false;
            _output.text = "";
            addChild(_output);

//            _message = new TextSprite("", Theme.FONT_MESSAGE);//_textFormat);
//            _message.horizontalAnchor = TextSprite.LEFT;
//            _message.text = "";
//            _message.x = 50;
//            _message.y = 70;
            //addChild( _message );        
        }  
        
        public function showMessage(message:String):void
        {
        	_output.appendText(message + "\n");
        }     
         
        public function addResults(results:String):void
        {
        	if (SessionManager.isTutorial() == true)
        		showMessage(Theme.MSG_RESULT_TUTORIAL);
        	else
        	{
	        	//showMessage("Task " + SessionManager.curSession + " of " + Theme.NUM_SESSIONS + " complete.");
	        	//showMessage("Task complete.");
	        	// Task not over yet
	        	if (SessionManager.curSession < Theme.NUM_SESSIONS)
	        	{
	        		showMessage(Theme.MSG_RESULT_CONTINUE);
	        	}
	        	else
	        	{
	        		showMessage(Theme.MSG_RESULT_FINISH);
	        	}
	        	_sessionManager.addResult(results);
        	}
        }  
	}
}