package cs448b.fp.display
{
	import cs448b.fp.event.ControlsEvent;
	import cs448b.fp.ui.Theme;
	
	import fl.controls.Button;
	
	import flare.display.TextSprite;
	
	import flash.display.Shape;
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
			this.graphics.lineStyle(3, 0xbbbbbb);
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
			addMergeDiagram();
			addReplaceDiagram();
			addCancelDiagram();			
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
		 * Add a merge diagram
		 */					
		private function addMergeDiagram():void
		{	
			var diagram:Shape = new Shape();
			var baseX:Number = Theme.LAYOUT_POPUP_INNER_X;
			var baseY:Number = Theme.LAYOUT_POPUP_INNER_Y+100;
			
			diagram.graphics.beginFill(Theme.LAYOUT_POPUP_DIAGRAM_INACTIVE_COLOR);
			diagram.graphics.drawRect(baseX, baseY, Theme.LAYOUT_POPUP_DIAGRAM_SIZE, Theme.LAYOUT_POPUP_DIAGRAM_SIZE);		
			diagram.graphics.drawRect(baseX+80, baseY+30, Theme.LAYOUT_POPUP_DIAGRAM_SIZE, Theme.LAYOUT_POPUP_DIAGRAM_SIZE);
           	diagram.graphics.endFill();
           	// current content node
           	diagram.graphics.beginFill(Theme.LAYOUT_POPUP_DIAGRAM_ACTIVE_COLOR);
           	diagram.graphics.drawRect(baseX, baseY+60, Theme.LAYOUT_POPUP_DIAGRAM_SIZE, Theme.LAYOUT_POPUP_DIAGRAM_SIZE);
           	diagram.graphics.endFill();
           	// lines
           	diagram.graphics.lineStyle(5, Theme.LAYOUT_POPUP_DIAGRAM_LINE_COLOR, 1, false);
            diagram.graphics.moveTo(baseX+80, baseY+30+Theme.LAYOUT_POPUP_DIAGRAM_SIZE/2);
            diagram.graphics.lineTo(baseX+Theme.LAYOUT_POPUP_DIAGRAM_SIZE, baseY+Theme.LAYOUT_POPUP_DIAGRAM_SIZE/2);
            diagram.graphics.moveTo(baseX+80, baseY+30+Theme.LAYOUT_POPUP_DIAGRAM_SIZE/2);
            diagram.graphics.lineTo(baseX+Theme.LAYOUT_POPUP_DIAGRAM_SIZE, baseY+60+Theme.LAYOUT_POPUP_DIAGRAM_SIZE/2);    
            addChild(diagram);     	
		}
	

		/**
		 * Add a replace diagram
		 */					
		private function addReplaceDiagram():void
		{	
			var diagram:Shape = new Shape();
			var baseX:Number = Theme.LAYOUT_POPUP_INNER_X+200;
			var baseY:Number = Theme.LAYOUT_POPUP_INNER_Y+100;
			
			diagram.graphics.beginFill(Theme.LAYOUT_POPUP_DIAGRAM_INACTIVE_COLOR);
			diagram.graphics.drawRect(baseX, baseY, Theme.LAYOUT_POPUP_DIAGRAM_SIZE, Theme.LAYOUT_POPUP_DIAGRAM_SIZE);		
			diagram.graphics.drawRect(baseX+80, baseY+30, Theme.LAYOUT_POPUP_DIAGRAM_SIZE, Theme.LAYOUT_POPUP_DIAGRAM_SIZE);
           	diagram.graphics.endFill();
           	// current content node
           	diagram.graphics.beginFill(Theme.LAYOUT_POPUP_DIAGRAM_ACTIVE_COLOR);
           	diagram.graphics.drawRect(baseX, baseY+60, Theme.LAYOUT_POPUP_DIAGRAM_SIZE, Theme.LAYOUT_POPUP_DIAGRAM_SIZE);
           	diagram.graphics.endFill();
           	// lines
           	diagram.graphics.lineStyle(5, Theme.LAYOUT_POPUP_DIAGRAM_LINE_COLOR, Theme.LAYOUT_POPUP_DIAGRAM_LINE_ALPHA, false);
            diagram.graphics.moveTo(baseX+80, baseY+30+Theme.LAYOUT_POPUP_DIAGRAM_SIZE/2);
            diagram.graphics.lineTo(baseX+Theme.LAYOUT_POPUP_DIAGRAM_SIZE, baseY+Theme.LAYOUT_POPUP_DIAGRAM_SIZE/2);
            diagram.graphics.lineStyle(5, Theme.LAYOUT_POPUP_DIAGRAM_LINE_COLOR, 1, false);
            diagram.graphics.moveTo(baseX+80, baseY+30+Theme.LAYOUT_POPUP_DIAGRAM_SIZE/2);
            diagram.graphics.lineTo(baseX+Theme.LAYOUT_POPUP_DIAGRAM_SIZE, baseY+60+Theme.LAYOUT_POPUP_DIAGRAM_SIZE/2);  
            addChild(diagram);       	
		}
	
		/**
		 * Add a cancel diagram
		 */					
		private function addCancelDiagram():void
		{	
			var diagram:Shape = new Shape();
			var baseX:Number = Theme.LAYOUT_POPUP_INNER_X+400;
			var baseY:Number = Theme.LAYOUT_POPUP_INNER_Y+100;
			
			diagram.graphics.beginFill(Theme.LAYOUT_POPUP_DIAGRAM_INACTIVE_COLOR);
			diagram.graphics.drawRect(baseX, baseY, Theme.LAYOUT_POPUP_DIAGRAM_SIZE, Theme.LAYOUT_POPUP_DIAGRAM_SIZE);		
			diagram.graphics.drawRect(baseX+80, baseY+30, Theme.LAYOUT_POPUP_DIAGRAM_SIZE, Theme.LAYOUT_POPUP_DIAGRAM_SIZE);
           	diagram.graphics.endFill();
           	// current content node
           	diagram.graphics.beginFill(Theme.LAYOUT_POPUP_DIAGRAM_ACTIVE_COLOR);
           	diagram.graphics.drawRect(baseX, baseY+60, Theme.LAYOUT_POPUP_DIAGRAM_SIZE, Theme.LAYOUT_POPUP_DIAGRAM_SIZE);
           	diagram.graphics.endFill();
           	// lines
           	diagram.graphics.lineStyle(5, Theme.LAYOUT_POPUP_DIAGRAM_LINE_COLOR, 1, false);
            diagram.graphics.moveTo(baseX+80, baseY+30+Theme.LAYOUT_POPUP_DIAGRAM_SIZE/2);
            diagram.graphics.lineTo(baseX+Theme.LAYOUT_POPUP_DIAGRAM_SIZE, baseY+Theme.LAYOUT_POPUP_DIAGRAM_SIZE/2);
            diagram.graphics.lineStyle(5, Theme.LAYOUT_POPUP_DIAGRAM_LINE_COLOR, Theme.LAYOUT_POPUP_DIAGRAM_LINE_ALPHA, false);
            diagram.graphics.moveTo(baseX+80, baseY+30+Theme.LAYOUT_POPUP_DIAGRAM_SIZE/2);
            diagram.graphics.lineTo(baseX+Theme.LAYOUT_POPUP_DIAGRAM_SIZE, baseY+60+Theme.LAYOUT_POPUP_DIAGRAM_SIZE/2);         
            addChild(diagram);	
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
            _message.textMode = TextSprite.DEVICE;
            addChild( _message );        
        }                   	
	}
}