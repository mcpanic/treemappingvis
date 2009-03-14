package cs448b.fp.utils
{
	import cs448b.fp.utils.ControlsEvent;
	
// Data related	
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
					        			
	public class SimpleTreeControls extends Sprite
	{		
		//private var _controlListener:ControlListener;		
		private var _depthSlider:Slider;
		private var _depthText:TextSprite;
		private var _depthTitle:TextSprite;
//		private var _visualToggle:CheckBox;
		private var _fitToScreen:Button;
		private var _textFormat:TextFormat;
							
		public function SimpleTreeControls()
		{

//			_titleFormat = new TextFormat("Verdana,Tahoma,Arial",16,0,true);
//			_sectionFormat = new TextFormat("Verdana,Tahoma,Arial",12,0,true);
//			_legendFormat = new TextFormat("Verdana,Tahoma,Arial",11,0,true);
			_textFormat = new TextFormat("Verdana,Tahoma,Arial",10,0,false);
			_textFormat.color = "0xFFFFFF";

			addDepthControl();
//			addVisualToggle();
			addFitToScreen();
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
//
//		private function addVisualToggle():void
//		{	   
//			_visualToggle = new CheckBox();
//			_visualToggle.label = "View Visual Nodes";
//			_visualToggle.selected = true;
//           	_visualToggle.addEventListener(MouseEvent.CLICK, onVisualToggle);
//           	_visualToggle.setStyle("textFormat", _textFormat);
//           	addChild(_visualToggle);
//		}

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
//			if (_visualToggle)
//			{
//				_visualToggle.width = 150;
//				_visualToggle.x = x-200;
//				_visualToggle.y = y+135;
//			}
			if (_fitToScreen)
			{
				_fitToScreen.x = x-60;
				_fitToScreen.y = y+135;
			}
		}
		
	}
}
