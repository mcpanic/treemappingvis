package cs448b.fp.display
{
	import cs448b.fp.tree.CascadedTree;
	import cs448b.fp.utils.ControlsEvent;
	import cs448b.fp.utils.NodeActions;
	import cs448b.fp.utils.Theme;
	
	import flash.display.Sprite;

	public class DisplayManager extends Sprite
	{
		private var _popupManager:PopupManager;
		private var _resultManager:ResultManager;
		private var _helpManager:HelpManager;
		private var _contentTree:CascadedTree = null;
		private var _layoutTree:CascadedTree = null;
						
		public function DisplayManager()
		{
			super();
			_popupManager = new PopupManager();	
			_resultManager = new ResultManager();
			_helpManager = new HelpManager();			
		}

		/**
		 * Initialize all types of screen popups
		 */	
		public function init():void
		{
			// Initialize popup manager
			_popupManager.init();
			_popupManager.x = Theme.LAYOUT_POPUP_X;
			_popupManager.y = Theme.LAYOUT_POPUP_Y;
			_popupManager.width = Theme.LAYOUT_POPUP_WIDTH;
			_popupManager.addEventListener(ControlsEvent.STATUS_UPDATE, onPopupStatusEvent);
			//_popupManager.height = Theme.LAYOUT_POPUP_HEIGHT;
			//addChild(_popupManager);
			
			// Initialize result popup manager
			_resultManager.init();
			_resultManager.x = Theme.LAYOUT_POPUP_X;
			_resultManager.y = Theme.LAYOUT_POPUP_Y;
			_resultManager.width = Theme.LAYOUT_POPUP_WIDTH;
			_resultManager.addEventListener(ControlsEvent.STATUS_UPDATE, onResultStatusEvent);

			// Initialize popup manager
			_helpManager.init();
			_helpManager.x = Theme.LAYOUT_POPUP_X;
			_helpManager.y = Theme.LAYOUT_POPUP_Y;
			_helpManager.width = Theme.LAYOUT_POPUP_WIDTH;
			_helpManager.addEventListener(ControlsEvent.STATUS_UPDATE, onHelpStatusEvent);				
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
		 * Set the assignment ID (called from MappingManager)
		 * Wrapper for ResultManager
		 */			
		public function setAssignmentId(id:String):void
		{
			_resultManager.setAssignmentId(id);
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
				_resultManager.showMessage("Result successfully submitted.");
				//hideResults();			
			}
			else if (event.name == "close")
			{
				hideResults();	
				dispatchEvent( new ControlsEvent( ControlsEvent.STATUS_UPDATE, "finish") ); 		
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
		 * Before hiding the popup
		 */					
		private function beforeHidePopup():void
		{
			_contentTree.alpha = 1;
			_layoutTree.alpha = 1;			
			
			// Enable the unmap button
			_contentTree.enableUnmapButton();
			// Enable the help button
			dispatchEvent( new ControlsEvent( ControlsEvent.STATUS_UPDATE, "showhelp", 0) );  				
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
			
			// Disable the unmap button
			_contentTree.disableUnmapButton();
			// Disable the help button
			dispatchEvent( new ControlsEvent( ControlsEvent.STATUS_UPDATE, "hidehelp", 0) );  							
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
		}
								
								
		/**
		 * Merge a mapping based on the current user selection: Add another
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