package cs448b.fp.display
{
	import cs448b.fp.data.SessionManager;
	import cs448b.fp.tree.CascadedTree;
	import cs448b.fp.event.ControlsEvent;
	import cs448b.fp.event.DisplayEvent;
	import cs448b.fp.ui.NodeActions;
	import cs448b.fp.ui.Theme;
	
	import flare.vis.Visualization;
	
	import flash.display.Sprite;

	public class DisplayManager extends Sprite
	{
		private var _popupManager:PopupManager;
		private var _resultManager:ResultManager;
		private var _helpManager:HelpManager;
		private var _tutorialManager:TutorialManager;
		private var _previewManager:PreviewManager;
		private var _contentTree:CascadedTree = null;
		private var _layoutTree:CascadedTree = null;
						
		public function DisplayManager()
		{
			super();
			if (Theme.ENABLE_MERGE == true)
				_popupManager = new PopupManager();	
			_resultManager = new ResultManager();
			_helpManager = new HelpManager();	
			_tutorialManager = new TutorialManager();
			if (Theme.ENABLE_FULL_PREVIEW == true && SessionManager.isPreview == true && SessionManager.isTutorial() == false)		
				_previewManager = new PreviewManager();
		}

		/**
		 * Initialize all types of screen popups
		 */	
		public function init():void
		{
			if (Theme.ENABLE_MERGE == true)
			{
				// Initialize popup manager

				_popupManager.x = Theme.LAYOUT_POPUP_X;
				_popupManager.y = Theme.LAYOUT_POPUP_Y;
				_popupManager.width = Theme.LAYOUT_POPUP_WIDTH;
				_popupManager.addEventListener(ControlsEvent.STATUS_UPDATE, onPopupStatusEvent);
				_popupManager.init();
			}
			
			// Initialize result popup manager

			_resultManager.x = Theme.LAYOUT_POPUP_X;
			_resultManager.y = Theme.LAYOUT_POPUP_Y;
			_resultManager.width = Theme.LAYOUT_POPUP_WIDTH;
			_resultManager.addEventListener(ControlsEvent.STATUS_UPDATE, onResultStatusEvent);
			_resultManager.init();
			
			// Initialize popup manager

			_helpManager.x = Theme.LAYOUT_POPUP_X;
			_helpManager.y = Theme.LAYOUT_POPUP_Y;
			_helpManager.width = Theme.LAYOUT_POPUP_WIDTH;
			_helpManager.addEventListener(ControlsEvent.STATUS_UPDATE, onHelpStatusEvent);	
			_helpManager.init();
						
			// Initialize tutorial manager

			_tutorialManager.x = Theme.LAYOUT_TUTORIAL_X;
			_tutorialManager.y = Theme.LAYOUT_TUTORIAL_Y;
			_tutorialManager.width = Theme.LAYOUT_TUTORIAL_WIDTH;
			//_tutorialManager.height = Theme.LAYOUT_TUTORIAL_HEIGHT;
			_tutorialManager.addEventListener(ControlsEvent.STATUS_UPDATE, onTutorialStatusEvent);		
			_tutorialManager.init();
						
			// Initialize preview manager
			if (Theme.ENABLE_FULL_PREVIEW == true && SessionManager.isPreview == true && SessionManager.isTutorial() == false)
			{
				_previewManager.x = Theme.LAYOUT_PREVIEW_X;//Theme.LAYOUT_CTREE_X;//
				_previewManager.y = Theme.LAYOUT_PREVIEW_Y;;//Theme.LAYOUT_CTREE_Y;
				//_previewManager.width = 1300;//Theme.LAYOUT_TUTORIAL_WIDTH;		
				_previewManager.addEventListener(ControlsEvent.STATUS_UPDATE, onPreviewStatusEvent);	
				_previewManager.init();								
				addChild(_previewManager);
			}					
		}

		/**
		 * Set the content tree (called from MappingManager)
		 */	
		public function setContentTree(t:CascadedTree):void
		{
			_contentTree = t;
		}

		/**
		 * Set the layout tree (called from MappingManager)
		 */			
		public function setLayoutTree(t:CascadedTree):void
		{
			_layoutTree = t;
		}

		/**
		 * Set the session manager (called from MappingManager)
		 * Wrapper for ResultManager
		 */			
		public function setSessionManager(sessionManager:SessionManager):void
		{
			_resultManager.setSessionManager(sessionManager);
		}		
		
		/**
		 * Popup status change event.
		 * Triggered by popupManager, when button is pressed.
		 */	
		private function onPopupStatusEvent( event:ControlsEvent ):void
		{
			if (event.name == "merge")
			{	
				mergeMapping();			
			}
			else if (event.name == "replace")
			{	
				replaceMapping();			
			}
			else if (event.name == "cancel")
			{	
				cancelMapping();			
			}
		}

		/**
		 * Result confirm button event.
		 * Triggered by resultManager, when button is pressed.
		 */	
		private function onResultStatusEvent( event:ControlsEvent ):void
		{			
			if (event.name == "confirm")
			{
				//_resultManager.showMessage("Result successfully submitted.");
				hideResults();
				dispatchEvent( new ControlsEvent( ControlsEvent.STATUS_UPDATE, "finish") ); 			
			}
			else if (event.name == "close")
			{
				hideResults();	
				dispatchEvent( new ControlsEvent( ControlsEvent.STATUS_UPDATE, "finish") ); 		
			}	
			else if (event.name == "tutorial_submit")
			{
				hideResults();	
				_tutorialManager.showNext();		
			}						
		}


		/**
		 * Help button event.
		 * Triggered by helpManager, when button is pressed.
		 */	
		private function onHelpStatusEvent( event:ControlsEvent ):void
		{			
			if (event.name == "close")
			{
				hideHelp();			
			}			
		}

		/**
		 * Tutorial button event.
		 * Triggered by tutorialManager, when button is pressed.
		 */	
		private function onTutorialStatusEvent( event:ControlsEvent ):void
		{	
			if (event.name == "prev")
			{
				_tutorialManager.showPrev();			
			}					
			else if (event.name == "next")
			{
				_tutorialManager.showNext();			
			}			
			else if (event.name == "close")
			{
				hideTutorial();			
			}	
			else if (event.name == "restart")
			{
				dispatchEvent( new ControlsEvent( ControlsEvent.STATUS_UPDATE, "restart") ); 	
			}				
			else if (event.name == "tutorial_preview")
			{
				dispatchEvent( new DisplayEvent( DisplayEvent.DISPLAY_UPDATE, "tutorial_preview") ); 		
			}	
//			else if (event.name == "tutorial_highlight")
//			{
//				dispatchEvent( new DisplayEvent( DisplayEvent.DISPLAY_UPDATE, "tutorial_highlight") ); 		
//			}	
			else if (event.name == "tutorial_click")
			{
				dispatchEvent( new ControlsEvent( ControlsEvent.STATUS_UPDATE, "enable_button", 0) ); 
				dispatchEvent( new DisplayEvent( DisplayEvent.DISPLAY_UPDATE, "tutorial_click") ); 	
				dispatchEvent( new ControlsEvent( ControlsEvent.STATUS_UPDATE, "hide_unmap", 0) ); 	
			}	
			else if (event.name == "tutorial_unmap")
			{
				dispatchEvent( new ControlsEvent( ControlsEvent.STATUS_UPDATE, "show_unmap", 0) ); 
				dispatchEvent( new DisplayEvent( DisplayEvent.DISPLAY_UPDATE, "tutorial_unmap") ); 
				dispatchEvent( new ControlsEvent( ControlsEvent.STATUS_UPDATE, "hide_map", 0) ); 		
			}		
			else if (event.name == "tutorial_result")
			{
				dispatchEvent( new ControlsEvent( ControlsEvent.STATUS_UPDATE, "show_map", 0) ); 			
			}																
		}


		/**
		 * Preview button events.
		 * Triggered by previewManager, when button is pressed.
		 */	
		private function onPreviewStatusEvent( event:ControlsEvent ):void
		{			
			if (event.name == "preview_complete")	
			{
				removeChild(_previewManager);
				dispatchEvent( new DisplayEvent( DisplayEvent.DISPLAY_UPDATE, "preview_complete") ); 
			}	
			else if (event.name == "preview_invisible_button")	
			{
				dispatchEvent( new DisplayEvent( DisplayEvent.DISPLAY_UPDATE, "preview_invisible_button") ); 	
			}					
			else if (event.name == "preview_show_content")	
			{
				dispatchEvent( new DisplayEvent( DisplayEvent.DISPLAY_UPDATE, "preview_show_content") ); 	
			}
			else if (event.name == "preview_show_layout")	
			{
				dispatchEvent( new DisplayEvent( DisplayEvent.DISPLAY_UPDATE, "preview_show_layout") ); 	
			}		
		}

//		/**
//		 * Send page display data to the previewManager
//		 */			
//		public function displayPage(vis:Visualization):void
//		{
//			if (_previewManager != null)
//				_previewManager.displayPage(vis);
//		}
				
		/**
		 * Before hiding the popup
		 */					
		private function beforeHidePopup():void
		{
			_contentTree.alpha = 1;
			_layoutTree.alpha = 1;			

			// Enable all buttons
			dispatchEvent( new ControlsEvent( ControlsEvent.STATUS_UPDATE, "enable_button", 0) );  				
			// Disable the lock so that interactionis enabled again
			NodeActions.lock = false;			
		}

		/**
		 * Before showing the popup
		 */					
		private function beforeShowPopup():void
		{
			_contentTree.alpha = Theme.ALPHA_POPUP;
			_layoutTree.alpha = Theme.ALPHA_POPUP; 		
			
			// Disable all buttons
			dispatchEvent( new ControlsEvent( ControlsEvent.STATUS_UPDATE, "disable_button", 0) );  							
			// Enable the lock so that interaction is disabled during popup
			NodeActions.lock = true;					
		}	
			
		/**
		 * Hide the popup
		 */					
		private function hidePopup():void
		{				
			beforeHidePopup();
			removeChild(_popupManager);
		}
		
		/**
		 * Show the popup
		 */					
		public function showPopup():void
		{
			beforeShowPopup();
			addChild(_popupManager);
		}

		/**
		 * Hide the result popup
		 */					
		private function hideResults():void
		{
			beforeHidePopup();
			removeChild(_resultManager);
		}
		
		/**
		 * Show the result upon mapping completion
		 */					
		public function showResults(message:String):void
		{
			beforeShowPopup();
			_resultManager.addResults(message);
			addChild(_resultManager);
		}			
		
		/**
		 * Hide the popup
		 */					
		private function hideHelp():void
		{
			beforeHidePopup();
			removeChild(_helpManager);
		}
		
		/**
		 * Show the popup
		 */					
		public function showHelp():void
		{
			beforeShowPopup();
			addChild(_helpManager);
						trace(this.numChildren + "/" + this.getChildIndex(_helpManager));
		}


		/**
		 * Hide the popup
		 */					
		private function hideTutorial():void
		{
			//beforeHidePopup();
			removeChild(_tutorialManager);
			//dispatchEvent( new DisplayEvent( DisplayEvent.DISPLAY_UPDATE, "start") ); 
		}
		
		/**
		 * Show the popup
		 */					
		public function showTutorial():void
		{			
			NodeActions.lock = true;	
			addChild(_tutorialManager);
		}								
				
		/**
		 * Show the next step in tutorial
		 */					
		public function showTutorialNextStep():void
		{			
			_tutorialManager.showNext();
		}								

		/**
		 * Get the current tutorial step
		 */	
		public function get currentTutorialStep():Number
		{			
			return _tutorialManager.curStep;
		}
						
		/**
		 * Merge a mapping based on the current user selection: with popup / add another
		 */					
		public function mergeMapping():void
		{
			hidePopup();			
			//addMapping();
			dispatchEvent( new DisplayEvent( DisplayEvent.DISPLAY_UPDATE, "add") );  	
			//blinkNode();
			dispatchEvent( new DisplayEvent( DisplayEvent.DISPLAY_UPDATE, "blink") ); 
		}

		/**
		 * Merge a mapping based on the current user selection: without popup / add another
		 */					
		public function mergeMappingWithoutPopup():void
		{			
			//addMapping();
			dispatchEvent( new DisplayEvent( DisplayEvent.DISPLAY_UPDATE, "add") );  	
			//blinkNode();
			dispatchEvent( new DisplayEvent( DisplayEvent.DISPLAY_UPDATE, "blink") ); 
		}
				
		/**
		 * Replace a mapping based on the current user selection: Remove and Add
		 */					
		public function replaceMapping():void
		{
			hidePopup();			
			//removeMapping(_selectedLayoutID);				
			dispatchEvent( new DisplayEvent( DisplayEvent.DISPLAY_UPDATE, "remove") );
			//addMapping();
			dispatchEvent( new DisplayEvent( DisplayEvent.DISPLAY_UPDATE, "add") );
			//blinkNode();
			dispatchEvent( new DisplayEvent( DisplayEvent.DISPLAY_UPDATE, "blink") );
		}
		
		/**
		 * Cancel: leave as it is
		 */					
		public function cancelMapping():void
		{
			hidePopup();
			// shouldn't progress to the next node!
		//	blinkNode();	
		}
								
	}
}