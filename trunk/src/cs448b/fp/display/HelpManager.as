package cs448b.fp.display
{
	import cs448b.fp.utils.ControlsEvent;
	import cs448b.fp.utils.Theme;
	
	import fl.controls.Button;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
//	import flash.display.DisplayObject;
//	import flash.display.DisplayObjectContainer;
//	import flash.events.Event;
		
	public class HelpManager extends Sprite
	{
		private var _closeButton:Button;
		private var _message:TextField;
		
		public function HelpManager()
		{
			this.graphics.beginFill(0x101010);
			this.graphics.lineStyle(3, 0xbbbbbb);
			this.graphics.drawRoundRect(0, 0, Theme.LAYOUT_POPUP_WIDTH, Theme.LAYOUT_POPUP_HEIGHT, 20);
			this.graphics.endFill();
		}

		/**
		 * 
		 */			
		public function init():void
		{
			addCloseButton();	
			addMessage();
		}

		/**
		 * Add a close button
		 */					
		private function addCloseButton():void
		{	   
			_closeButton = new Button();
			_closeButton.label = "Close";
			_closeButton.toggle = true;
			_closeButton.x = Theme.LAYOUT_POPUP_WIDTH / 2;
			_closeButton.y = Theme.LAYOUT_POPUP_HEIGHT - 40;
           	_closeButton.addEventListener(MouseEvent.CLICK, onCloseButton);
           	_closeButton.setStyle("textFormat", Theme.FONT_BUTTON);
           	_closeButton.useHandCursor = true;
           	addChild(_closeButton);         	
		}

		/**
		 * Event handler for close button click
		 */	
        private function onCloseButton( mouseEvent:MouseEvent ):void
        {
			dispatchEvent( new ControlsEvent( ControlsEvent.STATUS_UPDATE, "close") );        			 
        }	

 
		/**
		 * Add help message
		 */	        
		private function addMessage():void
		{
//            _message = new TextSprite("", Theme.FONT_MESSAGE);//_textFormat);
//            _message.horizontalAnchor = TextSprite.LEFT;
//            _message.text = Theme.MSG_HELP;
//            _message.x = 50;
//            _message.y = 30;
//            addChild( _message );    
            
            _message = new TextField();
            _message.x = 50;
            _message.y = 30;
//            _output.textColor = 0xffffff;
            _message.defaultTextFormat = Theme.FONT_MESSAGE;
            _message.width = Theme.LAYOUT_POPUP_WIDTH - 100;
            _message.height = Theme.LAYOUT_POPUP_HEIGHT - 100;
            _message.multiline = true;
            _message.wordWrap = true;
            _message.border = false;
            _message.text = Theme.MSG_HELP;
            addChild(_message);                
        }                   	
	}
}