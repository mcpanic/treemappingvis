package cs448b.fp.utils
{
	import fl.controls.Button;
	import fl.controls.CheckBox;
	import fl.controls.Slider;
	import fl.controls.SliderDirection;
	import fl.events.SliderEvent;
	
	import flare.display.TextSprite;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.*;
					        			
	public class CascadedTreeControls extends Sprite
	{		
		//private var _controlListener:ControlListener;		
		private var _depthSlider:Slider;
		private var _depthText:TextSprite;
		private var _depthTitle:TextSprite;
		private var _visualToggle:CheckBox;
		private var _fitToScreen:Button;
		private var _continueButton:Button;
		private var _helpButton:Button;
		private var _restartButton:Button;
		private var _unmapButton:Button;		
		private var _notice:TextSprite;
		private var _feedback:TextSprite;
		private var _mappings:TextSprite;
//		private var _textFormat:TextFormat;
		private var _isTutorial:Boolean;
									
		public function CascadedTreeControls()
		{
			//addDepthControl();
			if (Theme.ENABLE_DEBUG == true)
				addVisualToggle();
			//addFitToScreen();

			addFeedback();
			addMappings();
			addNotice();
			addUnmap();
			addHelp();
			addRestart();
			if (Theme.ENABLE_CONTINUE_BUTTON == true)
				addContinueButton();

			layout();
		}

		public function setSliderDepth(depth:uint):void
		{
			if (_depthSlider != null)
				_depthSlider.maximum = depth;
		}

		public function setSliderValue(value:uint):void
		{
			if (_depthSlider != null)
			{
				_depthSlider.value = value;
				_depthText.text = (value + 1).toString();
			}
		}
				
		private function addDepthControl():void
		{
            _depthTitle = new TextSprite("", Theme.FONT_MESSAGE);//_textFormat);
            _depthTitle.horizontalAnchor = TextSprite.CENTER;
            _depthTitle.text = "Current Depth";
            _depthTitle.textMode = TextSprite.DEVICE;	
            this.addChild( _depthTitle );
            			
			_depthSlider = new Slider();
            _depthSlider.addEventListener( SliderEvent.CHANGE, onSliderChange );
            _depthSlider.direction = SliderDirection.VERTICAL;
            _depthSlider.minimum = 0;
			_depthSlider.maximum = 2;            
            _depthSlider.value = _depthSlider.maximum;
            this.addChild( _depthSlider );

            _depthText = new TextSprite("", Theme.FONT_LABEL);//_textFormat);
            _depthText.horizontalAnchor = TextSprite.CENTER;
            _depthText.text = (_depthSlider.value + 1).toString();
            _depthText.textMode = TextSprite.DEVICE;
            this.addChild( _depthText );
           			
		}
		
        private function onSliderChange( sliderEvent:SliderEvent ):void
        {
        	_depthText.text = (sliderEvent.value + 1).toString();
			dispatchEvent( new ControlsEvent( ControlsEvent.CONTROLS_UPDATE, "slider", sliderEvent.value) );    	 
        }

		private function addVisualToggle():void
		{	   
			_visualToggle = new CheckBox();
			_visualToggle.label = "View Visual Nodes";
			_visualToggle.selected = true;
           	_visualToggle.addEventListener(MouseEvent.CLICK, onVisualToggle);
           	_visualToggle.setStyle("textFormat", Theme.FONT_LABEL);//_textFormat);
           	addChild(_visualToggle);
		}

        private function onVisualToggle( mouseEvent:MouseEvent ):void
        {
			dispatchEvent( new ControlsEvent( ControlsEvent.CONTROLS_UPDATE, "visual") ) ;	 
        }

		private function addFitToScreen():void
		{	   
			_fitToScreen = new Button();
			_fitToScreen.label = "Fit to screen";
			_fitToScreen.toggle = true;
           	_fitToScreen.addEventListener(MouseEvent.CLICK, onFitToScreen);
           	_fitToScreen.setStyle("textFormat", Theme.FONT_LABEL);//_textFormat);
           	addChild(_fitToScreen);         	
		}

        private function onFitToScreen( mouseEvent:MouseEvent ):void
        {
			dispatchEvent( new ControlsEvent( ControlsEvent.CONTROLS_UPDATE, "fit") );        			 
        }

		public function setIsTutorial(isTutorial:Boolean):void
		{
			_isTutorial = isTutorial;
			if (_isTutorial == true)
			{
				_helpButton.y = Theme.LAYOUT_HELP_Y + Theme.LAYOUT_TUTORIAL_OFFSET;
				_restartButton.visible = false;
				//_restartButton.y = Theme.LAYOUT_RESTART_Y + Theme.LAYOUT_TUTORIAL_OFFSET;
				_unmapButton.y = Theme.LAYOUT_UNMAP_Y + Theme.LAYOUT_TUTORIAL_OFFSET;
				_continueButton.y = Theme.LAYOUT_CONTINUE_Y + Theme.LAYOUT_TUTORIAL_OFFSET;
			}
			else
			{	
//				_helpButton.y = Theme.LAYOUT_HELP_Y;
//				_restartButton.y = Theme.LAYOUT_RESTART_Y;
			}				
		}

		
		/**
		 * Add unmap button for each tree layout
		 */		
		private function addUnmap():void
		{		
			_unmapButton = makeButton(Theme.ID_BUTTON_UNMAP);
			return;
			_unmapButton = new Button();
			_unmapButton.label = Theme.LABEL_NOMAPPING;
			_unmapButton.toggle = false;		
           	_unmapButton.addEventListener(MouseEvent.CLICK, onUnmapButton);
           	_unmapButton.setStyle("textFormat", Theme.FONT_BUTTON); 
           	_unmapButton.enabled = false;
           	_unmapButton.visible = false;
           	_unmapButton.useHandCursor = true;
           	addChild(_unmapButton);  			
		}
		
        private function onUnmapButton( mouseEvent:MouseEvent ):void
        {
			dispatchEvent( new ControlsEvent( ControlsEvent.CONTROLS_UPDATE, "unmap") );        			 
        }
        
        public function getButtonByID(id:Number):Button
        {
        	var button:Button = null;
        	if (id == Theme.ID_BUTTON_HELP)
        		button = _helpButton;
        	else if (id == Theme.ID_BUTTON_CONTINUE)
        		button = _continueButton;
        	else if (id == Theme.ID_BUTTON_RESTART)
        		button = _restartButton;
        	else if (id == Theme.ID_BUTTON_UNMAP)
        		button = _unmapButton;
        	return button;
        }
        public function enableButton(id:Number):void
        {
        	getButtonByID(id).enabled = true;
        }
        public function disableButton(id:Number):void
        {
        	getButtonByID(id).enabled = false;
        }		
        public function visibleButton(id:Number):void
        {
        	getButtonByID(id).visible = true;
        }		
        public function invisibleButton(id:Number):void
        {
        	getButtonByID(id).visible = false;
        }				

								
		private function addHelp():void
		{
			_helpButton = makeButton(Theme.ID_BUTTON_HELP);
			return;
			_helpButton = new Button();
			_helpButton.label = Theme.LABEL_HELP;
			_helpButton.toggle = false;		
           	_helpButton.addEventListener(MouseEvent.CLICK, onHelpButton);
           	_helpButton.setStyle("textFormat", Theme.FONT_BUTTON); 
           	_helpButton.enabled = false;
           	_helpButton.visible = false;
           	_helpButton.useHandCursor = true;
           	addChild(_helpButton);  			
					
		}     
		
        private function onHelpButton( mouseEvent:MouseEvent ):void
        {
			dispatchEvent( new ControlsEvent( ControlsEvent.CONTROLS_UPDATE, "help") );        			 
        }

		private function addRestart():void
		{
			_restartButton = makeButton(Theme.ID_BUTTON_RESTART);
			return;
			_restartButton = new Button();
			_restartButton.label = Theme.LABEL_RESTART;
			_restartButton.toggle = false;		
           	_restartButton.addEventListener(MouseEvent.CLICK, onRestartButton);
           	_restartButton.setStyle("textFormat", Theme.FONT_BUTTON); 
           	_restartButton.enabled = false;
           	_restartButton.visible = false;
           	_restartButton.useHandCursor = true;
           	addChild(_restartButton);  			
					
		}     
		
        private function onRestartButton( mouseEvent:MouseEvent ):void
        {
			dispatchEvent( new ControlsEvent( ControlsEvent.CONTROLS_UPDATE, "restart") );        			 
        }
   	        		   
        	        		           	        		   
		private function addContinueButton():void
		{	   
			_continueButton = makeButton(Theme.ID_BUTTON_CONTINUE);
			return;
			_continueButton = new Button();
			_continueButton.label = Theme.LABEL_CONT1;
			_continueButton.toggle = false;
           	_continueButton.addEventListener(MouseEvent.CLICK, onContinueButton);
           	_continueButton.setStyle("textFormat", Theme.FONT_BUTTON);//_textFormat);		
           	_continueButton.enabled = false;
           	_continueButton.visible = false;
           	_continueButton.useHandCursor = true;
           	addChild(_continueButton);  	           	
		}    
		
		private function makeButton(id:Number):Button
		{
			//var button:Button = getButtonByID(id);
			var button:Button = new Button();
			if (id == Theme.ID_BUTTON_CONTINUE)
			{
				button.label = Theme.LABEL_CONT1;
          		button.addEventListener(MouseEvent.CLICK, onContinueButton);				
			}
			else if (id == Theme.ID_BUTTON_RESTART)
			{
				button.label = Theme.LABEL_RESTART;
          		button.addEventListener(MouseEvent.CLICK, onRestartButton);				
			}
			else if (id == Theme.ID_BUTTON_HELP)
			{
				button.label = Theme.LABEL_HELP;
          		button.addEventListener(MouseEvent.CLICK, onHelpButton);				
			}
			else if (id == Theme.ID_BUTTON_UNMAP)
			{
				button.label = Theme.LABEL_NOMAPPING;
          		button.addEventListener(MouseEvent.CLICK, onUnmapButton);				
			}				
			button.toggle = false;
           	button.setStyle("textFormat", Theme.FONT_BUTTON);//_textFormat);		
           	button.enabled = false;
           	button.visible = false;
           	button.useHandCursor = true;
           	addChild(button);  				
			return button;
		}      
        private function onContinueButton( mouseEvent:MouseEvent ):void
        {
			//dispatchEvent( new ControlsEvent( ControlsEvent.CONTROLS_UPDATE, "continue") );        			 
			dispatchEvent( new ControlsEvent( ControlsEvent.CONTROLS_UPDATE, "next") );
        }	

                
		private function addFeedback():void
		{
            _feedback = new TextSprite("", Theme.FONT_MESSAGE);//_textFormat);
            _feedback.horizontalAnchor = TextSprite.LEFT;
            _feedback.text = Theme.MSG_LOADED;
            _feedback.textMode = TextSprite.DEVICE;
            this.addChild( _feedback );        
        }

        
        public function displayFeedback(message:String):void
        {
        	_feedback.text = message;
        }	
                        
		private function addNotice():void
		{
            _notice = new TextSprite("", Theme.FONT_MESSAGE);//_textFormat);
            _notice.horizontalAnchor = TextSprite.LEFT;
            _notice.text = Theme.MSG_STAGE1; 
            _notice.textMode = TextSprite.DEVICE;
            if (Theme.ENABLE_DEBUG == true)
            	this.addChild( _notice );        
        }
        
        public function displayStage(index:Number):void
        {
        	if (index == Theme.STAGE_HIERARCHICAL)
        	{
        		if (_continueButton)
        			_continueButton.label = Theme.LABEL_CONT2;
        		_notice.text = Theme.MSG_STAGE2; 
        	}
        	else if (index == Theme.STAGE_QUASI)
        	{
        		if (_continueButton)
        			_continueButton.label = Theme.LABEL_CONT3;
        		if (Theme.ENABLE_REL == true)
        			_notice.text = Theme.MSG_STAGE3;
        		else	
        		 	_notice.text = Theme.MSG_STAGE4;
        	}
        }	
        
		private function addMappings():void
		{
            _mappings = new TextSprite("", Theme.FONT_MESSAGE);//_textFormat);
            _mappings.horizontalAnchor = TextSprite.LEFT;
            _mappings.text = Theme.MSG_MAPPING_NONE;
            _mappings.textMode = TextSprite.DEVICE;
            if (Theme.ENABLE_DEBUG == true)
            	this.addChild( _mappings );        
        }   
        
        public function displayMappings(message:String):void
        {
        	_mappings.text = Theme.MSG_MAPPING + message;
        }	                 

		public function enableButtons():void
		{
			enableButton(Theme.ID_BUTTON_HELP);	
			enableButton(Theme.ID_BUTTON_RESTART);
			if (Theme.ENABLE_CONTINUE_BUTTON == true)
				enableButton(Theme.ID_BUTTON_CONTINUE);
			enableButton(Theme.ID_BUTTON_UNMAP);			
		}
		
		public function disableButtons():void
		{
			disableButton(Theme.ID_BUTTON_HELP);		
			disableButton(Theme.ID_BUTTON_RESTART);	
			if (Theme.ENABLE_CONTINUE_BUTTON == true)
				disableButton(Theme.ID_BUTTON_CONTINUE);	
			disableButton(Theme.ID_BUTTON_UNMAP);			
		}

		public function visibleButtons():void
		{
			visibleButton(Theme.ID_BUTTON_HELP);	
			visibleButton(Theme.ID_BUTTON_RESTART);
			if (Theme.ENABLE_CONTINUE_BUTTON == true)
				visibleButton(Theme.ID_BUTTON_CONTINUE);
			visibleButton(Theme.ID_BUTTON_UNMAP);				
		}
		
		public function invisibleButtons():void
		{
			invisibleButton(Theme.ID_BUTTON_HELP);	
			invisibleButton(Theme.ID_BUTTON_RESTART);
			if (Theme.ENABLE_CONTINUE_BUTTON == true)
				invisibleButton(Theme.ID_BUTTON_CONTINUE);
			invisibleButton(Theme.ID_BUTTON_UNMAP);				
		}		
						
		public function layout():void
		{

			var x:Number = 1200;
			var y:Number = 600;				

			if (_depthTitle)
			{
				_depthTitle.x = x-7;
				_depthTitle.y = y+5;
			}
			if (_depthSlider) 
			{
            	_depthSlider.x = x;
            	_depthSlider.y = y+30;
				//_depthSlider.setSize(500, 30);
				_depthSlider.tickInterval = 1;            	
			}					
			if (_depthText)
			{
				_depthText.x = x;
				_depthText.y = y+115;
			}
			if (_visualToggle)
			{
				_visualToggle.width = 150;
				_visualToggle.x = x-200;
				_visualToggle.y = y+135;
			}
			if (_fitToScreen)
			{
				_fitToScreen.x = x-60;
				_fitToScreen.y = y+135;
			}
			if (_continueButton)
			{
				_continueButton.x = Theme.LAYOUT_CONTINUE_X;
				_continueButton.y = Theme.LAYOUT_CONTINUE_Y;
				_continueButton.width = Theme.LAYOUT_CONTINUE_WIDTH;	
			}	
			if (_unmapButton)
			{
				if (Theme.ENABLE_CONTINUE_BUTTON == true)
					_unmapButton.x = Theme.LAYOUT_UNMAP_X + Theme.LAYOUT_CONTINUE_WIDTH + 30;
				else			
					_unmapButton.x = Theme.LAYOUT_UNMAP_X;
				_unmapButton.y = Theme.LAYOUT_UNMAP_Y;
				_unmapButton.width = Theme.LAYOUT_UNMAP_WIDTH;					
			}
			if (_restartButton)
			{
				if (Theme.ENABLE_CONTINUE_BUTTON == true)
					_restartButton.x = Theme.LAYOUT_RESTART_X + Theme.LAYOUT_CONTINUE_WIDTH + 10;
				else				
					_restartButton.x = Theme.LAYOUT_RESTART_X;
				_restartButton.y = Theme.LAYOUT_RESTART_Y;
				_restartButton.width = Theme.LAYOUT_RESTART_WIDTH;					
			}
			if (_helpButton)
			{
				if (Theme.ENABLE_CONTINUE_BUTTON == true)
					_helpButton.x = Theme.LAYOUT_HELP_X + Theme.LAYOUT_CONTINUE_WIDTH + 10;
				else
					_helpButton.x = Theme.LAYOUT_HELP_X;
				_helpButton.y = Theme.LAYOUT_HELP_Y;
				_helpButton.width = Theme.LAYOUT_HELP_WIDTH;					
			}						
			if (_notice)
			{
				_notice.x = Theme.LAYOUT_NOTICE_X; //250;
				_notice.y = Theme.LAYOUT_NOTICE_Y; //y+50;
			}	
			if (_feedback)
			{
				_feedback.x = Theme.LAYOUT_FEEDBACK_X; //250;
				_feedback.y = Theme.LAYOUT_FEEDBACK_Y; //y+80;
			}
			if (_mappings)
			{
				_mappings.x = Theme.LAYOUT_MAPPINGS_X; //250;
				_mappings.y = Theme.LAYOUT_MAPPINGS_Y; //y+110;
			}	
		}
		
	}
}
