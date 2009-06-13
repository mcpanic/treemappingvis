package cs448b.fp.ui
{
	import cs448b.fp.data.SessionManager;
	
	import fl.containers.ScrollPane;
	import fl.events.ScrollEvent;
	
	import flare.vis.Visualization;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	public class ScrollPanel extends Sprite
	{
        //private var sampleImagePath:String = "test.jpg";
        private var sp:ScrollPane;
        private var previewPositioner:Sprite;
        private var previewWindowSize:Number = 100;
        private var box:Sprite;
        private var _vis:Visualization;
        private var _canvasWidth:Number;
        private var _canvasHeight:Number;
        
        public function ScrollPanel(vis:Visualization, canvasWidth:Number, canvasHeight:Number)
		{
			super();
			_vis = vis;
			_canvasWidth = canvasWidth;
			_canvasHeight = canvasHeight;
			//stage.frameRate = 31; // for smoother scrolling
            createScrollPanel();
		}

		/**
		 * Create a scroll panel and add a visualization to display inside
		 */	
        private function createScrollPanel():void 
        {
            sp = new ScrollPane();
            sp.move(10,10);
            
            sp.setSize(_canvasWidth, _canvasHeight);
            //sp.source = sampleImagePath;
            sp.source = _vis;
            sp.source.x = 15;
            sp.source.y = 15;

            var bgColor:Sprite = new Sprite();
            bgColor.graphics.beginFill(0x101010);
//			bgColor.graphics.lineStyle(3, 0xbbbbbb);
			bgColor.graphics.drawRect(0, 0, Theme.LAYOUT_PREVIEW_WIDTH, Theme.LAYOUT_PREVIEW_HEIGHT);
			bgColor.graphics.endFill();
			sp.setStyle("upSkin", bgColor);

            sp.scrollDrag = false;
            //trace(sp.scrollDrag);
            sp.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
            addChild(sp);            
        }

		/**
		 * Create a small preview window
		 */	        
        private function createPreviewWindow():void 
        {
            var previewWindow:Sprite = new Sprite();
            previewWindow.x = Theme.LAYOUT_SCROLL_PREVIEW_X;
            previewWindow.y = Theme.LAYOUT_SCROLL_PREVIEW_Y;
            previewWindow.graphics.lineStyle(1,0,1);
            previewWindow.graphics.drawRect(0,0, Theme.LAYOUT_SCROLL_PREVIEW_WIDTH, Theme.LAYOUT_SCROLL_PREVIEW_HEIGHT);
            addChild(previewWindow);
            
            if(sp.content.width > Theme.LAYOUT_SCROLL_PREVIEW_WIDTH && sp.content.height > Theme.LAYOUT_SCROLL_PREVIEW_HEIGHT) {
                var bitmapData:BitmapData;
                try {
                    bitmapData = new BitmapData(sp.content.width,sp.content.height);
                    bitmapData.draw(sp.content);
                    var bitmap:Bitmap = new Bitmap(bitmapData);
                    bitmap.width = previewWindowSize;
                    bitmap.height = previewWindowSize;
                    bitmap.alpha = 0.25
                    previewWindow.addChild(bitmap);            
                }
                catch (e:Error) {
                    trace(e.toString());
                }

                previewPositioner = new Sprite();
                previewPositioner.graphics.beginFill(0xFFFFFF,0.5);
                previewPositioner.graphics.lineStyle(1,0,0.5);
                previewPositioner.graphics.drawRect(0,0,getHorizontalAspect() * previewWindowSize, getVerticalAspect() * previewWindowSize);
                previewPositioner.addEventListener(MouseEvent.MOUSE_DOWN, dragPreviewPositioner);
                previewPositioner.addEventListener(MouseEvent.MOUSE_UP, dropPreviewPositioner);
                previewWindow.addChild(previewPositioner);
            }
        }
        
        private function dragPreviewPositioner(e:MouseEvent):void 
        {
            var bounds:Rectangle = new Rectangle(0,0,previewWindowSize - Math.floor(previewPositioner.width) + 1,previewWindowSize - Math.floor(previewPositioner.height) + 1);
            previewPositioner.startDrag(false, bounds);
            previewPositioner.addEventListener(MouseEvent.MOUSE_MOVE, repositionScrollPane);
        }
        
        private function dropPreviewPositioner(e:MouseEvent):void 
        {
            previewPositioner.stopDrag();
            previewPositioner.removeEventListener(MouseEvent.MOUSE_MOVE, repositionScrollPane);
        }
        
        private function repositionScrollPane(e:MouseEvent):void 
        {
            sp.horizontalScrollPosition = (previewPositioner.x / previewWindowSize) * sp.content.width;
            sp.verticalScrollPosition = (previewPositioner.y / previewWindowSize) * sp.content.height;
        }
        
        private function repositionPreview(e:ScrollEvent):void 
        {
            previewPositioner.x = (sp.horizontalScrollPosition * previewWindowSize) / sp.content.width;
            previewPositioner.y = (sp.verticalScrollPosition * previewWindowSize) / sp.content.height;
        }
        
        private function getHorizontalAspect():Number 
        {
            return sp.width / sp.content.width;
        }
        
        private function getVerticalAspect():Number 
        {
            return sp.height / sp.content.height;
        }

        private function onMouseDown(e:MouseEvent):void 
        {
            //trace("mouse down");
        }
        
		/**
		 * Update the scrollbar based on the current width and height.
		 * Called whenever zoom button is pressed.
		 */	        
        public function update():void 
        {
        	sp.update();
        }
        		
	}
}