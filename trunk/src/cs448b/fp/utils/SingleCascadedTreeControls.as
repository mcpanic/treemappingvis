package cs448b.fp.utils
{
	import fl.controls.Button;
	
	import flare.display.TextSprite;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;

						
	public class SingleCascadedTreeControls extends Sprite
	{
		private var _loader1:Loader;		
		private var _loader2:Loader;	
		private var _zoomInButton:Button;
		private var _zoomOutButton:Button;
		//private var _zoomResetButton:Button;
		private var _title:TextSprite;
		private var _isContentTree:Boolean;
				
		public function SingleCascadedTreeControls(isContentTree:Boolean)
		{
			super();
			_isContentTree = isContentTree;
			_loader1 = new Loader();
			_loader2 = new Loader();			
			//addLabel();
			addZoomInButton();
			addZoomOutButton();
			
		}


		/**
		 * Add tree name labels
		 */				
		private function addLabel():void
		{
            _title = new TextSprite("", Theme.FONT_LABEL); 
            _title.horizontalAnchor = TextSprite.CENTER;
            if (_isContentTree == true)
            	_title.text = Theme.LABEL_CONTENT;
            else
            	_title.text = Theme.LABEL_LAYOUT;
            _title.textMode = TextSprite.DEVICE;	
            _title.x = Theme.LAYOUT_TREENAME_X;
            _title.y = Theme.LAYOUT_TREENAME_Y;
            addChild( _title );			
		}

		/**
		 * Enable button controls
		 */		
		public function enableZoomButtons():void
		{
			_zoomInButton.enabled = true;
			_zoomOutButton.enabled = true;
			//_zoomResetButton.enabled = true;
		}

		/**
		 * Disable button controls
		 */		
		public function disableZoomButtons():void
		{
			_zoomInButton.enabled = false;
			_zoomOutButton.enabled = false;
			//_zoomResetButton.enabled = false;			
		}

		/**
		 * MAke visible button controls
		 */		
		public function visibleZoomButtons():void
		{
			_zoomInButton.visible = true;
			_zoomOutButton.visible = true;
			//_zoomResetButton.visible = true;			
		}

		/**
		 * Make invisible button controls
		 */		
		public function invisibleZoomButtons():void
		{
			_zoomInButton.visible = false;
			_zoomOutButton.visible = false;
			//_zoomResetButton.visible = false;			
		}
								
		/**
		 * Add zoom-in button for each tree layout
		 */		
		private function addZoomInButton():void
		{	
			_loader1.contentLoaderInfo.addEventListener(Event.COMPLETE, completeZoomInLoad);
			_loader1.load(new URLRequest("../data/Gnome-zoom-in.png"));
           	_loader1.scaleX = 0.5;
           	_loader1.scaleY = 0.5;

			_zoomInButton = new Button();
			_zoomInButton.label = "";Theme.LABEL_ZOOM_IN;
			_zoomInButton.toggle = false;
			_zoomInButton.x = Theme.LAYOUT_ZOOM_X;
			_zoomInButton.y = Theme.LAYOUT_ZOOM_Y;
			_zoomInButton.setSize(Theme.LAYOUT_ZOOM_WIDTH, Theme.LAYOUT_ZOOM_WIDTH)			
           	_zoomInButton.addEventListener(MouseEvent.CLICK, onZoomInButton);
           	//_zoomInButton.setStyle("textFormat", Theme.FONT_BUTTON); 
           	_zoomInButton.enabled = false;
           	_zoomInButton.useHandCursor = true;
           	addChild(_zoomInButton);  			
		}

		/**
		 * Add zoom-in button for each tree layout
		 */		
		private function completeZoomInLoad(evt:Event):void 
		{
		    _zoomInButton.setStyle("icon", _loader1);
		    _zoomInButton.validateNow();
		}

		/**
		 * Add zoom-out button for each tree layout
		 */		
		private function addZoomOutButton():void
		{		
			_loader2.contentLoaderInfo.addEventListener(Event.COMPLETE, completeZoomOutLoad);
			_loader2.load(new URLRequest("../data/Gnome-zoom-out.png"));				
           	_loader2.scaleX = 0.5;
           	_loader2.scaleY = 0.5;			
			_zoomOutButton = new Button();			
			_zoomOutButton.label = "";//Theme.LABEL_ZOOM_OUT;
			_zoomOutButton.toggle = false;
			_zoomOutButton.x = Theme.LAYOUT_ZOOM_X + Theme.LAYOUT_ZOOM_WIDTH + 20;// + Theme.LAYOUT_ZOOM_RESET_WIDTH + 10;
			_zoomOutButton.y = Theme.LAYOUT_ZOOM_Y;
			_zoomOutButton.setSize(Theme.LAYOUT_ZOOM_WIDTH, Theme.LAYOUT_ZOOM_WIDTH)						
           	_zoomOutButton.addEventListener(MouseEvent.CLICK, onZoomOutButton);
           	//_zoomOutButton.setStyle("textFormat", Theme.FONT_BUTTON); 
           	_zoomOutButton.enabled = false;
           	_zoomOutButton.useHandCursor = true;
           	addChild(_zoomOutButton);  			
		}

		private function completeZoomOutLoad(evt:Event):void {
		    _zoomOutButton.setStyle("icon", _loader2);
		    _zoomOutButton.validateNow();
		}
		
		/**
		 * Add zoom-reset button for each tree layout
		 */		
//		private function addZoomResetButton():void
//		{		
//			_zoomResetButton = new Button();
//			_zoomResetButton.label = Theme.LABEL_ZOOM_RESET;
//			_zoomResetButton.toggle = true;
//			_zoomResetButton.x = Theme.LAYOUT_ZOOM_X + Theme.LAYOUT_ZOOM_WIDTH + 10;
//			_zoomResetButton.y = Theme.LAYOUT_ZOOM_Y;
//			_zoomResetButton.width = Theme.LAYOUT_ZOOM_RESET_WIDTH;			
//           	_zoomResetButton.addEventListener(MouseEvent.CLICK, onZoomResetButton);
//           	_zoomResetButton.setStyle("textFormat", Theme.FONT_BUTTON); 
//           	_zoomResetButton.enabled = false;
//           	_zoomResetButton.useHandCursor = true;
//           	addChild(_zoomResetButton);  			
//		}	

		/**
		 * Zoom in
		 */
		private function onZoomInButton(event:MouseEvent):void
		{
			dispatchEvent( new ControlsEvent( ControlsEvent.CONTROLS_UPDATE, "zoom_in") ); 	
		}

		/**
		 * Zoom out
		 */
		private function onZoomOutButton(event:MouseEvent):void
		{
			dispatchEvent( new ControlsEvent( ControlsEvent.CONTROLS_UPDATE, "zoom_out") ); 		
		}
		
		/**
		 * Zoom reset
		 */
		private function onZoomResetButton(event:MouseEvent):void
		{
			dispatchEvent( new ControlsEvent( ControlsEvent.CONTROLS_UPDATE, "zoom_reset") ); 		
		}	
	}
}