package cs448b.fp.display
{
	import cs448b.fp.utils.ControlsEvent;
	import cs448b.fp.utils.Theme;
	
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
		private var _inst:TextSprite;
		private var _message:TextSprite;
		private var _output:TextField;
		
		private var _assignmentId:String;
		private var _results:String;
		private var _isConfirmed:Boolean;
		
		public function ResultManager()
		{
			this.graphics.beginFill(0x101010);
			this.graphics.lineStyle(3, 0xbbbbbb);
			this.graphics.drawRoundRect(0, 0, Theme.LAYOUT_POPUP_WIDTH, Theme.LAYOUT_POPUP_HEIGHT, 20);
			this.graphics.endFill();
			_isConfirmed = false;
		}

		/**
		 * 
		 */			
		public function init():void
		{
			addConfirmButton();		
			addInstruction();
			addMessage();
		}
		
		public function setAssignmentId(id:String):void
		{
			_assignmentId = id;
		}

		/**
		 * 
		 */			
		public function showPopup():void
		{
			//addChild(this);
		}

		/**
		 * 
		 */			
		public function hidePopup():void
		{
			//removeChild(this);
		}

		/**
		 * Add a confirm button
		 */					
		private function addConfirmButton():void
		{	   
			_confirmButton = new Button();
			_confirmButton.label = "Confirm";
			_confirmButton.toggle = true;
			_confirmButton.x = Theme.LAYOUT_POPUP_WIDTH / 2;
			_confirmButton.y = Theme.LAYOUT_POPUP_HEIGHT - 40;
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
            variables.assignmentId = _assignmentId;
            variables.result = _results;
			var request:URLRequest = new URLRequest();
			request.url = "http://www.mturk.com/mturk/externalSubmit";
			request.method = URLRequestMethod.POST;
			request.data = variables;
//			var loader:URLLoader = new URLLoader();
//			loader.dataFormat = URLLoaderDataFormat.VARIABLES;
//			loader.addEventListener(Event.COMPLETE, onSendComplete);
			trace("result: " + _results);
            trace("send: " + request.url + "?" + request.data);
            _output.appendText("Sending results to Mechanical Turk server.\n");
            //_output.appendText("send: " + request.url + "?" + request.data + "\n");			
			try
			{
				navigateToURL(request);
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
        	if (_isConfirmed == false)
        	{   					
				sendToServer();
				dispatchEvent( new ControlsEvent( ControlsEvent.STATUS_UPDATE, "confirm") );     
        		_isConfirmed = true;
        		_confirmButton.label = "Close";
        	}
        	else
				dispatchEvent( new ControlsEvent( ControlsEvent.STATUS_UPDATE, "close") );             	
		}		
				
		/**
		 * Add an instruction for mapping completion
		 */	        
		private function addInstruction():void
		{
            _inst = new TextSprite("", Theme.FONT_MESSAGE);//_textFormat);
            _inst.horizontalAnchor = TextSprite.LEFT;
            _inst.text = Theme.MSG_RESULT;
            _inst.x = 50;
            _inst.y = 30;
            addChild( _inst );        
        }  
        				
		/**
		 * Event handler for cancel button click
		 */	        
		private function addMessage():void
		{
            _output = new TextField();
            _output.x = 50;
            _output.y = 70;
            _output.textColor = 0xbbbbbb;
            _output.width = 300;
            _output.height = 130;
            _output.multiline = true;
            _output.wordWrap = true;
            _output.border = false;
            _output.text = "";
            addChild(_output);

			
            _message = new TextSprite("", Theme.FONT_MESSAGE);//_textFormat);
            _message.horizontalAnchor = TextSprite.LEFT;
            _message.text = "";
            _message.x = 50;
            _message.y = 70;
            //addChild( _message );        
        }  
        
        public function showMessage(message:String):void
        {
        	_output.appendText(message + "\n");
        }     
         
        public function addResults(results:String):void
        {
        	_results = results;
        }  
	}
}