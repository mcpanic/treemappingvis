package cs448b.fp.utils
{
	import fl.controls.Button;
	
	import flare.display.TextSprite;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
//	import flash.display.DisplayObject;
//	import flash.display.DisplayObjectContainer;
//	import flash.events.Event;
		
	public class HelpManager extends Sprite
	{
//		private var _mergeButton:Button;
//		private var _replaceButton:Button;
		private var _closeButton:Button;
		private var _message:TextSprite;
		
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
            _message = new TextSprite("", Theme.FONT_MESSAGE);//_textFormat);
            _message.horizontalAnchor = TextSprite.LEFT;
            _message.text = Theme.MSG_HELP;
            _message.x = 50;
            _message.y = 30;
            addChild( _message );        
        }                   	
	}
}