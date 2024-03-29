package cs448b.fp.display
{
	import cs448b.fp.data.SessionManager;
	import cs448b.fp.event.ControlsEvent;
	import cs448b.fp.ui.Theme;
	
	import fl.controls.Button;
	
	import flare.display.TextSprite;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
//	import flash.display.DisplayObject;
//	import flash.display.DisplayObjectContainer;
//	import flash.events.Event;
		
	public class TutorialManager extends Sprite
	{
		private var _prevButton:Button;
		private var _nextButton:Button;
		private var _step:TextSprite;
		private var _message:TextSprite;
		private var _curStep:Number;
		private var _numStep:Number = Theme.NUM_TUTORIAL_STEPS;
		private var _output:TextField;
		
		public function TutorialManager()
		{
			this.graphics.beginFill(0x101010);
			this.graphics.lineStyle(3, 0xbbbbbb);
			this.graphics.drawRoundRect(0, 0, Theme.LAYOUT_TUTORIAL_WIDTH, Theme.LAYOUT_TUTORIAL_HEIGHT, 20);
			this.graphics.endFill();
		}

		/**
		 * 
		 */			
		public function init():void
		{
			_curStep = 1;
			//addPrevButton();
			addNextButton();	
			//addStep();
			addMessage();
			// straigtly to step 2 when restarted
			if (SessionManager.isTutorialRestart == true)
			{
				dispatchEvent( new ControlsEvent( ControlsEvent.STATUS_UPDATE, "next") );      
			}
		}

		/**
		 * Get the current tutorial step
		 */        
        public function get curStep():Number
        {
        	return _curStep;
        }  
        
		/**
		 * Add a previous button
		 */					
		private function addPrevButton():void
		{	   
			_prevButton = new Button();
			_prevButton.label = "Prev";
			_prevButton.toggle = true;
			_prevButton.enabled = false;
			_prevButton.x = Theme.LAYOUT_TUTORIAL_WIDTH - 120;
			_prevButton.y = Theme.LAYOUT_TUTORIAL_HEIGHT - 60;
			_prevButton.width = 50;
           	_prevButton.addEventListener(MouseEvent.CLICK, onPrevButton);
           	_prevButton.setStyle("textFormat", Theme.FONT_BUTTON);
           	_prevButton.useHandCursor = true;
           	addChild(_prevButton);         	
		}
		
		/**
		 * Add a next button
		 */					
		private function addNextButton():void
		{	   
			_nextButton = new Button();
			_nextButton.label = "Start";
			_nextButton.toggle = false;
			_nextButton.x = Theme.LAYOUT_TUTORIAL_WIDTH - Theme.LAYOUT_TUTORIAL_BUTTON_WIDTH - 10;
			_nextButton.y = Theme.LAYOUT_TUTORIAL_Y + Theme.LAYOUT_TUTORIAL_HEIGHT/2 - 20;
			_nextButton.width = Theme.LAYOUT_TUTORIAL_BUTTON_WIDTH;
           	_nextButton.addEventListener(MouseEvent.CLICK, onNextButton);
           	_nextButton.setStyle("textFormat", Theme.FONT_BUTTON);
           	_nextButton.useHandCursor = true;
           	addChild(_nextButton);         	
		}

		/**
		 * Event handler for close button click
		 */	
        private function onPrevButton( mouseEvent:MouseEvent ):void
        {			      
			dispatchEvent( new ControlsEvent( ControlsEvent.STATUS_UPDATE, "prev") );        	 			  			 
        }	
        
		/**
		 * Event handler for close button click
		 */	
        private function onNextButton( mouseEvent:MouseEvent ):void
        {			      
        	if (_curStep == _numStep)
        		dispatchEvent( new ControlsEvent( ControlsEvent.STATUS_UPDATE, "restart") );
        	else
				dispatchEvent( new ControlsEvent( ControlsEvent.STATUS_UPDATE, "next") );        	 			  			 
        }	

 
		/**
		 * Add help message
		 */	        
		private function addMessage():void
		{
//            _message = new TextSprite("", Theme.FONT_TUTORIAL);//_textFormat);
//            _message.horizontalAnchor = TextSprite.LEFT;
//            _message.text = Theme.MSG_TUT1;
//            _message.x = 25;
//            _message.y = 35;
//            _message.textColor = 0xbbbbbb;
//            _output.width = Theme.LAYOUT_POPUP_WIDTH - 100;
//            _output.height = 130;
//            _message.multiline = true;
//            _message.wordWrap = true;
//            _message.border = false;           
            //addChild( _message );
            
            _output = new TextField();
            _output.x = Theme.LAYOUT_TUTORIAL_MSG_X;
            _output.y = Theme.LAYOUT_TUTORIAL_MSG_Y;
            _output.textColor = 0xffffff;
            _output.defaultTextFormat = Theme.FONT_TUTORIAL;
            _output.width = Theme.LAYOUT_TUTORIAL_WIDTH - 130;
//            _output.height = 130;
            _output.multiline = true;
            _output.wordWrap = true;
            _output.border = false;
            _output.text = Theme.MSG_TUT1;
            addChild(_output);                    
        }    

		/**
		 * Add current step display
		 */	        
		private function addStep():void
		{
            _step = new TextSprite("", Theme.FONT_TUTORIAL_STEP);//_textFormat);
            _step.textMode = TextSprite.DEVICE;
            _step.horizontalAnchor = TextSprite.LEFT;           	
            _step.x = Theme.LAYOUT_TUTORIAL_STEP_X;
            _step.y = Theme.LAYOUT_TUTORIAL_STEP_Y;        
            showStep();
            addChild( _step );        
        }    
        
		/**
		 * Show the message
		 */        
        public function showMessage(message:String):void
        {
        	//_message.text = message + "\n";
        	_output.text = message;
        }  

		/**
		 * Show the step
		 */        
        public function showStep():void
        {
        	_step.text = "Tutorial Step " + _curStep + " of " + _numStep;
        } 

		/**
		 * Show the previous tutorial step
		 */        
        public function showPrev():void
        {
        	if (_curStep != 1)
        		_curStep--;
        	if (_curStep == 1)
        		_prevButton.enabled = false;
        	showStep();
        	showMessage(Theme["MSG_TUT" + _curStep]);
        } 
                        
		/**
		 * Show the next tutorial step
		 */        
        public function showNext():void
        {
        	_curStep++;

        	//showStep();
        	showMessage(Theme["MSG_TUT" + _curStep]);
        	
        	if (_curStep == 2)	// play preview
        	{
//        		if (Theme.ENABLE_FULL_PREVIEW == true)	// we don't show preview in the tutorial with the full page version
//        			showNext();
//        		else
//        		{
        			_nextButton.visible = false;
        			dispatchEvent( new ControlsEvent( ControlsEvent.STATUS_UPDATE, "tutorial_preview") );
//        		}
        	}
//        	else if (_curStep == 3)	// highlight the first node
//        		dispatchEvent( new ControlsEvent( ControlsEvent.STATUS_UPDATE, "tutorial_highlight") );
        	else if (_curStep == 3)	// enable clicking the first node
        	{
        		//_nextButton.enabled = false;
        		_nextButton.visible = false;
        		dispatchEvent( new ControlsEvent( ControlsEvent.STATUS_UPDATE, "tutorial_click") );
        	}
        	else if (_curStep == 4)	// assign no mapping practice
        	{        		
        		dispatchEvent( new ControlsEvent( ControlsEvent.STATUS_UPDATE, "tutorial_unmap") );
        	}	   
        	else if (_curStep == 5)	// submitting results after a session completes
        	{
        		//_nextButton.enabled = false;
        		dispatchEvent( new ControlsEvent( ControlsEvent.STATUS_UPDATE, "tutorial_result") );
        	}	
        	else if (_curStep == 6)	// final step
        	{
        		_nextButton.visible = true;
        		_nextButton.label = "Restart";
        	}		         		         		           		        		
        }                               	
	}
}