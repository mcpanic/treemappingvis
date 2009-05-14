package cs448b.fp.utils
{
	import fl.controls.Button;	
	import flare.display.TextSprite;	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
		
	public class ResultManager extends Sprite
	{
		private var _confirmButton:Button;
		private var _inst:TextSprite;
		private var _message:TextSprite;
		
		public function ResultManager()
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
			addConfirmButton();		
			addInstruction();
			addMessage();
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

		/**
		 * Event handler for confirm button click
		 */	
        private function onConfirmButton( mouseEvent:MouseEvent ):void
        {
			dispatchEvent( new ControlsEvent( ControlsEvent.STATUS_UPDATE, "confirm") );        			 
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
            _message = new TextSprite("", Theme.FONT_MESSAGE);//_textFormat);
            _message.horizontalAnchor = TextSprite.LEFT;
            _message.text = "";
            _message.x = 50;
            _message.y = 70;
            addChild( _message );        
        }  
        
        public function showMessage(message:String):void
        {
        	_message.text = message;
        }                 	
	}
}