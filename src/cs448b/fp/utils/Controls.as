package cs448b.fp.utils
{
// Data related	
	import fl.controls.CheckBox;
	import fl.controls.Slider;
	import fl.controls.SliderDirection;
	import fl.events.SliderEvent;
	import flash.events.MouseEvent;
	import flare.display.TextSprite;
	
	import flash.display.Sprite;
	import flash.text.TextFormat;
	import flash.utils.*;
					        			
	public class Controls extends Sprite
	{		
		private var _controlListener:ControlListener;		
		private var _depthSlider:Slider;
		private var _depthText:TextSprite;
		private var _visualToggle:CheckBox;
		private var cb:Function = null;
		private var _textFormat:TextFormat;
							
		public function Controls()
		{

//			_titleFormat = new TextFormat("Verdana,Tahoma,Arial",16,0,true);
//			_sectionFormat = new TextFormat("Verdana,Tahoma,Arial",12,0,true);
//			_legendFormat = new TextFormat("Verdana,Tahoma,Arial",11,0,true);
			_textFormat = new TextFormat("Verdana,Tahoma,Arial",10,0,false);

			addDepthControl();
			addVisualToggle();
			layout();
		}

		private function addDepthControl():void
		{
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
//            
//            _speedText2 = new TextSprite("", _textFormat);
//            _speedText2.horizontalAnchor = TextSprite.CENTER;
//            _speedText2.text = "Slow";
//            this.addChild( _speedText2 );	            			
		}
		
        private function onSliderChange( sliderEvent:SliderEvent ):void
        {
        	_depthText.text = (sliderEvent.value + 1).toString();
        	if (cb != null)
        		cb(sliderEvent);	 
        }

		private function addVisualToggle():void
		{	   
			_visualToggle = new CheckBox();
			_visualToggle.label = "View Visual Nodes";
			_visualToggle.selected = true;
           	_visualToggle.addEventListener(MouseEvent.CLICK, onVisualToggle);
           	addChild(_visualToggle);
		}

        private function onVisualToggle( mouseEvent:MouseEvent ):void
        {
        	//_visualToggle.selected = !_visualToggle.selected
        	if (cb != null)
        		cb(mouseEvent);	 
        }
        		
        /**
         * Adds a load event listener 
         */
        public function addLoadEventListener(callback:Function):void
        {
        	cb = callback;
        }

		public function layout():void
		{

			var x:Number = 1200;
			var y:Number = 500;				

			if (_depthSlider) 
			{
            	_depthSlider.x = x;
            	_depthSlider.y = y;
				//_depthSlider.setSize(500, 30);
				_depthSlider.tickInterval = 1;            	
			}					
			if (_depthText)
			{
				_depthText.x = x;
				_depthText.y = y+100;
			}
			if (_visualToggle)
			{
				_visualToggle.x = x-70;
				_visualToggle.y = y+130;
			}
		}
  		
  		public function addControlListener(cl:ControlListener):void
  		{
  			_controlListener = cl;
  		}
  			
		private function fireDepthChanged(pa:Array):void
		{
//			for(var o:Object in _controlListener)
//			{
//				var cl:ControlListener = _controlListener[o] as ControlListener;
//				cl.playerNo(pa);
//			}
		}
		
	}
}
