package cs448b.fp.utils
{
	import fl.controls.Button;
	
	import flare.display.TextSprite;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
//	import flash.display.DisplayObject;
//	import flash.display.DisplayObjectContainer;
//	import flash.events.Event;
		
	public class PopupManager extends Sprite
	{
		private var _mergeButton:Button;
		private var _replaceButton:Button;
		private var _cancelButton:Button;
		private var _message:TextSprite;
		
		public function PopupManager()
		{
			this.graphics.beginFill(0x101010);
			this.graphics.drawRoundRect(0, 0, Theme.LAYOUT_POPUP_WIDTH, Theme.LAYOUT_POPUP_HEIGHT, 20);
			this.graphics.endFill();
		}

		/**
		 * 
		 */			
		public function init():void
		{
			addMergeButton();
			addReplaceButton();
			addCancelButton();
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
		 * Add a merge button
		 */					
		private function addMergeButton():void
		{	   
			_mergeButton = new Button();
			_mergeButton.label = "Merge";
			_mergeButton.toggle = true;
			_mergeButton.x = Theme.LAYOUT_POPUP_INNER_X;
			_mergeButton.y = Theme.LAYOUT_POPUP_INNER_Y + 40;
           	_mergeButton.addEventListener(MouseEvent.CLICK, onMergeButton);
           	_mergeButton.setStyle("textFormat", Theme.FONT_BUTTON);
           	_mergeButton.useHandCursor = true;
           	addChild(_mergeButton);         	
		}

		/**
		 * Event handler for merge button click
		 */	
        private function onMergeButton( mouseEvent:MouseEvent ):void
        {
			dispatchEvent( new ControlsEvent( ControlsEvent.STATUS_UPDATE, "merge") );        			 
        }	

		/**
		 * Add a replace button
		 */					
		private function addReplaceButton():void
		{	   
			_replaceButton = new Button();
			_replaceButton.label = "Replace";
			_replaceButton.toggle = true;
			_replaceButton.x = Theme.LAYOUT_POPUP_INNER_X + 200;
			_replaceButton.y = Theme.LAYOUT_POPUP_INNER_Y + 40;
           	_replaceButton.addEventListener(MouseEvent.CLICK, onReplaceButton);
           	_replaceButton.setStyle("textFormat", Theme.FONT_BUTTON);
           	_replaceButton.useHandCursor = true;
           	addChild(_replaceButton);         	
		}

		/**
		 * Event handler for replace button click
		 */	
        private function onReplaceButton( mouseEvent:MouseEvent ):void
        {
			dispatchEvent( new ControlsEvent( ControlsEvent.STATUS_UPDATE, "replace") );        			 
        }
        
		/**
		 * Add a cancel button
		 */					
		private function addCancelButton():void
		{	   
			_cancelButton = new Button();
			_cancelButton.label = "Cancel";
			_cancelButton.toggle = true;
			_cancelButton.x = Theme.LAYOUT_POPUP_INNER_X + 400;
			_cancelButton.y = Theme.LAYOUT_POPUP_INNER_Y + 40;
           	_cancelButton.addEventListener(MouseEvent.CLICK, onCancelButton);
           	_cancelButton.setStyle("textFormat", Theme.FONT_BUTTON);
           	_cancelButton.useHandCursor = true;
           	addChild(_cancelButton);         	
		}

		/**
		 * Event handler for cancel button click
		 */	
        private function onCancelButton( mouseEvent:MouseEvent ):void
        {
			dispatchEvent( new ControlsEvent( ControlsEvent.STATUS_UPDATE, "cancel") );        			 
        }     

		/**
		 * Event handler for cancel button click
		 */	        
		private function addMessage():void
		{
            _message = new TextSprite("", Theme.FONT_MESSAGE);//_textFormat);
            _message.horizontalAnchor = TextSprite.LEFT;
            _message.text = Theme.MSG_POPUP;
            _message.x = 50;
            _message.y = 30;
            addChild( _message );        
        }                   	
	}
}