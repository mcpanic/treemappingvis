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
		private var _notice:TextSprite;
		private var _feedback:TextSprite;
		private var _mappings:TextSprite;
//		private var _textFormat:TextFormat;
		private var _isPreview:Boolean;
									
		public function CascadedTreeControls()
		{

//			_titleFormat = new TextFormat("Verdana,Tahoma,Arial",16,0,true);
//			_sectionFormat = new TextFormat("Verdana,Tahoma,Arial",12,0,true);
//			_legendFormat = new TextFormat("Verdana,Tahoma,Arial",11,0,true);
//			_textFormat = new TextFormat("Verdana,Tahoma,Arial",12,0,false);
//			_textFormat.color = "0xFFFFFF";

			//addDepthControl();
			//addVisualToggle();
			//addFitToScreen();

			addFeedback();
			addMappings();
			addNotice();
			addHelp();
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

		public function setIsPreview(isPreview:Boolean):void
		{
			_isPreview = isPreview;
			if (_isPreview == true)
				_helpButton.y = Theme.LAYOUT_HELP_Y + Theme.LAYOUT_TUTORIAL_OFFSET;
			else
				_helpButton.y = Theme.LAYOUT_HELP_Y;			
		}
		
		private function addHelp():void
		{
			_helpButton = new Button();
			_helpButton.label = Theme.LABEL_HELP;
			_helpButton.toggle = true;
			_helpButton.x = Theme.LAYOUT_HELP_X;
			if (_isPreview == true)
				_helpButton.y = Theme.LAYOUT_HELP_Y + Theme.LAYOUT_TUTORIAL_OFFSET;
			else
				_helpButton.y = Theme.LAYOUT_HELP_Y;
			_helpButton.width = Theme.LAYOUT_HELP_WIDTH;			
           	_helpButton.addEventListener(MouseEvent.CLICK, onHelpButton);
           	_helpButton.setStyle("textFormat", Theme.FONT_BUTTON); 
           	_helpButton.enabled = false;
           	_helpButton.useHandCursor = true;
           	addChild(_helpButton);  			
					
		}     
		
        private function onHelpButton( mouseEvent:MouseEvent ):void
        {
			dispatchEvent( new ControlsEvent( ControlsEvent.CONTROLS_UPDATE, "help") );        			 
        }
        
        public function showHelpButton():void
        {
        	_helpButton.enabled = true;
        }
     
        public function hideHelpButton():void
        {
        	_helpButton.enabled = false;
        }
        	        		   
		private function addContinueButton():void
		{	   
			_continueButton = new Button();
			_continueButton.label = Theme.LABEL_CONT1;
			_continueButton.toggle = true;
           	_continueButton.addEventListener(MouseEvent.CLICK, onContinueButton);
           	_continueButton.setStyle("textFormat", Theme.FONT_BUTTON);//_textFormat);
           	addChild(_continueButton);  
		}    

		private function addFeedback():void
		{
            _feedback = new TextSprite("", Theme.FONT_MESSAGE);//_textFormat);
            _feedback.horizontalAnchor = TextSprite.LEFT;
            _feedback.text = Theme.MSG_LOADED;
            this.addChild( _feedback );        
        }
        
        private function onContinueButton( mouseEvent:MouseEvent ):void
        {
			dispatchEvent( new ControlsEvent( ControlsEvent.CONTROLS_UPDATE, "continue") );        			 
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
//            _notice.text = "Stage: Hierarchical Matching";
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
            if (Theme.ENABLE_DEBUG == true)
            	this.addChild( _mappings );        
        }   
        
        public function displayMappings(message:String):void
        {
        	_mappings.text = Theme.MSG_MAPPING + message;
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
				_continueButton.x = 100;
				_continueButton.y = y+50;
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
