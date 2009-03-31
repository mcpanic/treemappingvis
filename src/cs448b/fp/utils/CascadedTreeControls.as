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
	import flash.text.TextFormat;
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
		private var _notice:TextSprite;
		private var _feedback:TextSprite;
		private var _textFormat:TextFormat;
							
		public function CascadedTreeControls()
		{

//			_titleFormat = new TextFormat("Verdana,Tahoma,Arial",16,0,true);
//			_sectionFormat = new TextFormat("Verdana,Tahoma,Arial",12,0,true);
//			_legendFormat = new TextFormat("Verdana,Tahoma,Arial",11,0,true);
			_textFormat = new TextFormat("Verdana,Tahoma,Arial",12,0,false);
			_textFormat.color = "0xFFFFFF";

			//addDepthControl();
			//addVisualToggle();
			//addFitToScreen();
			addNotice();
			addFeedback();
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
            _depthTitle = new TextSprite("", _textFormat);
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

            _depthText = new TextSprite("", _textFormat);
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
           	_visualToggle.setStyle("textFormat", _textFormat);
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
           	_fitToScreen.setStyle("textFormat", _textFormat);
           	addChild(_fitToScreen);         	
		}

        private function onFitToScreen( mouseEvent:MouseEvent ):void
        {
			dispatchEvent( new ControlsEvent( ControlsEvent.CONTROLS_UPDATE, "fit") );        			 
        }
        
		private function addContinueButton():void
		{	   
			_continueButton = new Button();
			_continueButton.label = "Continue";
			_continueButton.toggle = true;
           	_continueButton.addEventListener(MouseEvent.CLICK, onContinueButton);
           	_continueButton.setStyle("textFormat", _textFormat);
           	addChild(_continueButton);  
		}    

        private function onContinueButton( mouseEvent:MouseEvent ):void
        {
			dispatchEvent( new ControlsEvent( ControlsEvent.CONTROLS_UPDATE, "continue") );        			 
        }	

		private function addFeedback():void
		{
            _feedback = new TextSprite("", _textFormat);
            _feedback.horizontalAnchor = TextSprite.CENTER;
            _feedback.text = "Page loaded.";
            this.addChild( _feedback );        
        }

        public function displayFeedback(message:String):void
        {
        	_feedback.text = message;
        }	
                        
		private function addNotice():void
		{
            _notice = new TextSprite("", _textFormat);
            _notice.horizontalAnchor = TextSprite.CENTER;
            _notice.text = "Stage: Initialization";
//            _notice.text = "Stage: Hierarchical Matching";
            this.addChild( _notice );        
        }
        
        public function displayStage(index:Number):void
        {
        	if (index == 1)
        		_notice.text = "Stage: Hierarchical Matching";
        	else if (index == 2)
        	{
        		_continueButton.label = "Finish";
        		_notice.text = "Stage: Quasi-Hierarchical Matching";
        	}
        }	    
//                        		
//        /**
//         * Adds a load event listener 
//         */
//        public function addLoadEventListener(callback:Function):void
//        {
//        	cb = callback;
//        }

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
				_notice.x = 350;
				_notice.y = y+50;
			}	
			if (_feedback)
			{
				_feedback.x = 350;
				_feedback.y = y+80;
			}
		}
		
	}
}
