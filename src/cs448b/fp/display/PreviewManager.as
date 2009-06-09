package cs448b.fp.display
{
	import cs448b.fp.utils.ControlsEvent;
	import cs448b.fp.utils.NodeActions;
	import cs448b.fp.utils.Theme;
	
	import fl.controls.Button;
	
	import flare.vis.Visualization;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	public class PreviewManager extends Sprite
	{
//		private var _tree:CascadedTree;
//		private var _iscontentTree:Boolean;
		private var _isTutorial:Boolean;
		private var _x:Number;
		private var _y:Number;
		private var _nextButton:Button;
		private var _output:TextField;
		private var _curStep:Number;
		private var _numStep:Number;
		private var _previewPanel:Sprite;
		private var _currentVis:Visualization;
		
		/**
		 * Preview: show full-screen view of two pages, 
		 * to give users an overview of the content & semantics of the pages
		 */		
		public function PreviewManager()
		{
			super();
			this.graphics.beginFill(0x101010);
			this.graphics.lineStyle(3, 0xbbbbbb);
			//this.graphics.drawRoundRect(Theme.LAYOUT_PREVIEW_X, Theme.LAYOUT_PREVIEW_Y, Theme.LAYOUT_PREVIEW_WIDTH, Theme.LAYOUT_PREVIEW_HEIGHT, 20);
			this.graphics.drawRoundRect(0, 0, Theme.LAYOUT_PREVIEW_WIDTH, Theme.LAYOUT_PREVIEW_HEIGHT, 20);
			this.graphics.endFill();
					
						
			_numStep = 3;
			_currentVis = null;		
			// initialize the step (1: init, 2: content page, 3: layout page)
			_curStep = 1;

//			_iscontentTree = bContentTree;
//			_isTutorial = bTutorial;					
		}
		
		public function init(bTutorial:Boolean):void
		{	
			_isTutorial = bTutorial;		
//			_previewPanel = new Sprite();
//			_previewPanel.graphics.beginFill(0xbbbbbb);
//			// panel starts from the content tree origin			
//			_x = Number(Theme.LAYOUT_CTREE_X);
//			_y = Number(Theme.LAYOUT_CTREE_Y);
////			_previewPanel.graphics.drawRect(25, 190, 1024, 668);			
//			// smaller pane for tutorial session
//		    if (_isTutorial == true)
//		    	_previewPanel.graphics.drawRect(_x, _y, Theme.LAYOUT_FULL_PREVIEW_WIDTH+30, Theme.LAYOUT_FULL_PREVIEW_HEIGHT/2+30);
//		    else
//				_previewPanel.graphics.drawRect(_x, _y, Theme.LAYOUT_FULL_PREVIEW_WIDTH+30, Theme.LAYOUT_FULL_PREVIEW_HEIGHT+30);
//			_previewPanel.mouseEnabled = false;
//			addChild(_previewPanel);			
//			_previewPanel.scrollRect = new Rectangle(_x, _y, Theme.LAYOUT_FULL_PREVIEW_WIDTH+40, Theme.LAYOUT_FULL_PREVIEW_HEIGHT+40);
//		
			
			// add controls		
			addNextButton();
			addMessage();	
			
//			NodeActions.lock = false;
			// hide all necessary controls
			dispatchEvent( new ControlsEvent( ControlsEvent.STATUS_UPDATE, "preview_invisible_button") );
			// request the content page
			showContentPage();	
			
		}

		/**
		 * Display the given visualization on the panel
		 */			
		public function displayPage(vis:Visualization):void
		{		
			// if anything is already there, remove it for the new page to display properly
			if (_currentVis != null)
				_previewPanel.removeChild(_currentVis);	
			
			// invalid input
			if (vis == null)
				return;
				
			// update the current vis	
			_currentVis = vis;
			vis.x = Theme.LAYOUT_PREVIEW_X;
			vis.y = 190;
			// adjust the vis scale to the preview mode
//			vis.scaleX = _tree.getScale(Theme.LAYOUT_FULL_PREVIEW_WIDTH, Theme.LAYOUT_FULL_PREVIEW_HEIGHT);	
//			vis.scaleY = _tree.getScale(Theme.LAYOUT_FULL_PREVIEW_WIDTH, Theme.LAYOUT_FULL_PREVIEW_HEIGHT);			
			_previewPanel.addChild(vis);						
		}
			
		/**
		 * Add a next button
		 */					
		private function addNextButton():void
		{	   
			_nextButton = new Button();
			_nextButton.label = Theme.LABEL_PREVIEW_NEXT;
			_nextButton.toggle = false;
			_nextButton.x = Theme.LAYOUT_PREVIEW_WIDTH - Theme.LAYOUT_TUTORIAL_BUTTON_WIDTH - 10;
			_nextButton.y = Theme.LAYOUT_PREVIEW_Y + Theme.LAYOUT_PREVIEW_HEIGHT/2 - 20;
			_nextButton.width = Theme.LAYOUT_TUTORIAL_BUTTON_WIDTH;
           	_nextButton.addEventListener(MouseEvent.CLICK, onNextButton);
           	_nextButton.setStyle("textFormat", Theme.FONT_BUTTON);
           	_nextButton.useHandCursor = true;
           	addChild(_nextButton);         	
		}

        
		/**
		 * Event handler for close button click
		 */	
        private function onNextButton( mouseEvent:MouseEvent ):void
        {	
        	_curStep++;		      
        	// in the final stage of preview, issue a completion event
        	if (_curStep == _numStep)
        		onComplete();		
        	// on first next button click, show the layout page
        	else    
        		showLayoutPage();
        }	

		/**
		 * Cleanup when the preview is complete
		 */	        
        private function onComplete():void
        {     
        	dispatchEvent( new ControlsEvent( ControlsEvent.STATUS_UPDATE, "preview_complete") );
        }

		/**
		 * Show the content page
		 */	         
        public function showContentPage():void
        {
			dispatchEvent( new ControlsEvent( ControlsEvent.STATUS_UPDATE, "preview_show_content") );
			showMessage(Theme.MSG_PREVIEW1);        	
        }

		/**
		 * Show the layout page
		 */	         
        private function showLayoutPage():void
        {
			dispatchEvent( new ControlsEvent( ControlsEvent.STATUS_UPDATE, "preview_show_layout") );
			showMessage(Theme.MSG_PREVIEW2);        	
        }
         
		/**
		 * Add help message
		 */	        
		private function addMessage():void
		{           
            _output = new TextField();
            _output.x = Theme.LAYOUT_PREVIEW_MSG_X;
            _output.y = Theme.LAYOUT_PREVIEW_MSG_Y;
            _output.textColor = 0xffffff;
            _output.defaultTextFormat = Theme.FONT_TUTORIAL;
            _output.width = Theme.LAYOUT_PREVIEW_WIDTH - 130;
//            _output.height = 130;
            _output.multiline = false;
            _output.wordWrap = true;
            _output.border = false;
            _output.text = Theme.MSG_PREVIEW1;
            addChild(_output);                    
        }          

        
		/**
		 * Show the message
		 */        
        public function showMessage(message:String):void
        {
        	//_message.text = message + "\n";
        	_output.text = message;
        }  
        		
	}
}