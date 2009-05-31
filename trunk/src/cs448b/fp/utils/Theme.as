package cs448b.fp.utils 			
{
	import flash.filters.BitmapFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.text.TextFormat;
	public class Theme
	{	
		public static var ENABLE_DEBUG:Boolean = false;
		public static var ENABLE_MANUAL_PREVIEW:Number = 2;	//0: normal, 1: force preview, 2: force actual
		
		// How many sessions are we having for each task?
		public static var NUM_SESSIONS:Number = 5;
		
		// Enable / Disable ancestor-descendent constraint
		public static var ENABLE_REL:Boolean = false;
		// Enable / Disable serial node presentation (one content node at a time)
		public static var ENABLE_SERIAL:Boolean = true;	
		// Enable / Disable continue button - determined by ENABLE_REL
		public static var ENABLE_CONTINUE_BUTTON:Boolean = ENABLE_REL;
		// Enable /Disable blinking effect for mapping actions
		public static var ENABLE_BLINKING:Boolean = true;
		
		// Tree traversal order
		public static var ORDER_PREORDER:Number = 1;
		public static var ORDER_BFS:Number = 2;
		public static var ORDER_DFS:Number = 3;
		
		// Animation duration
		public static var DURATION_PREVIEW:Number = 0.3;
		public static var DURATION_BLINKING:Number = 0.5;
		
		// Tree visualization options: used in tree files		
		public static var COLOR_ACTIVATED:uint = 0xff0000ff;
		public static var COLOR_SELECTED:uint = 0xffff0000; 	
		public static var COLOR_CONNECTED:uint = 0xff0000ff;//0xffbbbbbb;	
		public static var LINE_WIDTH:uint = 15;
		public static var FIREBUG_CTREE:Boolean = false;	// node fillcolor true-original, false-firebug style
		public static var FIREBUG_LTREE:Boolean = true;		// node fillcolor true-original, false-firebug style
		public static var COLOR_FILL_MAPPED:Number = 0x00000000; //0xffFFAAAAFF;
		public static var COLOR_FILL_UNMAPPED:Number = 0x00000000; //0xffFFFFAAAA;
		public static var ALPHA_MAPPED:Number = 0.8;		// alpha value for mapped nodes
		public static var SHOW_MAPPPED:Boolean = true;		// hide content of the mapped nodes
		public static var CONNECTED_ALPHA:Number = 0.5;		// alpha value for the connected layout nodes on mouseover
		public static var CONNECTED_LINE_WIDTH:Number = 1;	// dividend for the connected layout nodes on mouseover
		public static var ALPHA_POPUP:Number = 0.5; 		// alpha value for the trees while popup menu is open
		
		public static var MAX_ZOOM:Number = 4; 		// alpha value for the trees while popup menu is open
		public static var MIN_ZOOM:Number = 0.25; 		// alpha value for the trees while popup menu is open
		
		// Mapping status constants
		public static var STATUS_DEFAULT:Number = 0;
		public static var STATUS_MAPPED:Number = 1;
		public static var STATUS_UNMAPPED:Number = 2;
				
		// Mapping stage constants
		public static var STAGE_INITIAL:Number = 0;
		public static var STAGE_HIERARCHICAL:Number = 1;
		public static var STAGE_QUASI:Number = 2;
		
		// Tree layout options: used in tree layout files
		public static var CASCADE_OFFSET:uint = 0;
		public static var USE_DROPSHADOW:Boolean = false;
		
		public static var LAYOUT_CANVAS_WIDTH:uint = 550;	// single tree canvas width
		public static var LAYOUT_CANVAS_HEIGHT:uint = 700;	// single tree canvas height
		public static var LAYOUT_CTREE_X:uint = 25;			// content tree x-coordinate
		public static var LAYOUT_CTREE_Y:uint = 75;			// content tree y-coordinate
		public static var LAYOUT_LTREE_X:uint = 600;		// layout tree x-coordinate
		public static var LAYOUT_LTREE_Y:uint = 75;			// layout tree y-coordinate
		
		public static var LAYOUT_UNMAP_X:Number = 770;//200;	// unmap button x-coordinate
		public static var LAYOUT_UNMAP_Y:Number = -60;		// unmap button y-coordinate
		public static var LAYOUT_UNMAP_WIDTH:Number = 150;	// unmap button width		
		public static var LAYOUT_HELP_X:Number = 950;		// help button x-coordinate
		public static var LAYOUT_HELP_Y:Number = 15;		// help button y-coordinate
		public static var LAYOUT_HELP_WIDTH:Number = 50;	// help button width
		public static var LAYOUT_FEEDBACK_X:Number = 25;//450;	// notice x-coordinate
		public static var LAYOUT_FEEDBACK_Y:Number = 17;		// notice y-coordinate
				
		public static var LAYOUT_NODENAME_X:Number = 20;	// tree name label x-coordinate, relative to the canvas origin
		public static var LAYOUT_NODENAME_Y:Number = -25;	// tree name label y-coordinate, relative to the canvas origin		
		public static var LAYOUT_TREENAME_X:Number = 270;	// tree name label x-coordinate, relative to the canvas origin
		public static var LAYOUT_TREENAME_Y:Number = -30;	// tree name label y-coordinate, relative to the canvas origin
		public static var LAYOUT_ZOOM_X:Number = 350;		// zoom button x-coordinate
		public static var LAYOUT_ZOOM_Y:Number = -30;		// zoom button y-coordinate
		public static var LAYOUT_ZOOM_WIDTH:Number = 30;	// zoom button width	
		public static var LAYOUT_ZOOM_RESET_WIDTH:Number = 50;	// zoom reset button width	
		public static var LAYOUT_NOTICE_X:Number = 0;		// notice x-coordinate
		public static var LAYOUT_NOTICE_Y:Number = 730;		// notice y-coordinate		

		public static var LAYOUT_MAPPINGS_X:Number = 0;			// notice x-coordinate
		public static var LAYOUT_MAPPINGS_Y:Number = 750;		// notice y-coordinate
		
		public static var LAYOUT_POPUP_X:Number = 300;		// popup x-coordinate
		public static var LAYOUT_POPUP_Y:Number = 120;		// popup y-coordinate
		public static var LAYOUT_POPUP_WIDTH:Number = 600;		// popup width
		public static var LAYOUT_POPUP_HEIGHT:Number = 270;		// popup height
		public static var LAYOUT_POPUP_INNER_X:Number = 50;		// popup content x-coordinate
		public static var LAYOUT_POPUP_INNER_Y:Number = 30;		// popup content y-coordinate
		public static var LAYOUT_POPUP_DIAGRAM_SIZE:Number = 30;	// popup diagram's square size
		public static var LAYOUT_POPUP_DIAGRAM_INACTIVE_COLOR:Number = 0x888888;	// popup diagram's inactive node color
		public static var LAYOUT_POPUP_DIAGRAM_ACTIVE_COLOR:Number = 0xffffff;	// popup diagram's active node color
		public static var LAYOUT_POPUP_DIAGRAM_LINE_COLOR:Number = 0xFFD700;	// popup diagram's line color
		public static var LAYOUT_POPUP_DIAGRAM_LINE_ALPHA:Number = 0.2;			// popup diagram's line alpha for inactive links 
		
		public static var LAYOUT_TUTORIAL_X:Number = 20;		// popup x-coordinate
		public static var LAYOUT_TUTORIAL_Y:Number = 10;		// popup y-coordinate
		public static var LAYOUT_TUTORIAL_WIDTH:Number = 740;		// popup width
		public static var LAYOUT_TUTORIAL_HEIGHT:Number = 100;		// popup height
		public static var LAYOUT_TUTORIAL_OFFSET:Number = 70;		// pixel offset 
						
		// Messages: used in tree control files
		public static var MSG_STAGE1:String = "Stage: Initialization";
		public static var MSG_STAGE2:String = "Stage: Hierarchical Matching";
		public static var MSG_STAGE3:String = "Stage: Quasi-Hierarchical Matching";
		public static var MSG_STAGE4:String = "Stage: Task Complete";
		public static var MSG_MAPPING_NONE:String = "Mappings: None";
		public static var MSG_MAPPING:String = "Mappings: ";
		public static var MSG_MAPPING_INST:String = "Select a segment on the Layout page that you think corresponds to the highlighted segment.";
		public static var MSG_LOADED:String = "Page loaded.";
		public static var MSG_POPUP:String = "This segment already has a mapping. What do you want to do?";
		public static var MSG_RESULT:String = "Your mapping task is successfully finished!";
		public static var MSG_HELP:String = "Mouse click: add a mapping\n\n" + 
				"Mouse over\n" + 
				"  * unmapped: view current (red) and visually related (purple) segments \n" + 
				"  * mapped:   view mapped segment(s) on the other page. \n\n" + 
				"Mouse wheel (Place the cursor on either page) \n" + 
				"  * scroll up: zoom in \n" + 
				"  * scroll down: zoom out";

		// Tutorial messages: used in tutorial session
		public static var MSG_TUT1:String = "Welcome! \nThis tutorial will guide you through the mapping interface.";
		public static var MSG_TUT2:String = "When the task starts, it first shows an animated preview of \npage segments you will find mappings for.";
		public static var MSG_TUT3:String = "For each highlighted segment on the left (content) page, \nyour task is to find a segment on the right (layout) page \nthat you think corresponds to the highlighted segment.";		
		public static var MSG_TUT4:String = "You can explore the layout page by moving the mouse cursor around. \nWhen your cursor is placed on top of a segment, it is highlighted in red. \nVisually related segments are also highlighted in purple.";	
		public static var MSG_TUT5:String = "Note that there are larger segments containing multiple small segments. \nKeep in mind they can be mapped as well.";			
		public static var MSG_TUT6:String = "When you find an appropriate segment, click that node as it is highlighted in red.";	
		public static var MSG_TUT7:String = "If you think there are no corresponding segments on the right (layout) page \nfor the current left (content) segment, click 'Assign no mapping' button.";		
		public static var MSG_TUT8:String = "If you think more than one segments map to a segment on the right (layout) page, \nyou can 'merge' mappings by clicking on the mapped node again. \nWhen a popup menu opens, choose 'Merge'."; 
		public static var MSG_TUT9:String = "Select 'Replace' if you want to remove existing mappings and \napply the new mapping. \nSelect 'Cancel' if you do not want to change anything.";	
		public static var MSG_TUT10:String = "Once you have defined a mapping, \nmouse over the mapped segment to see the mapped node on the other page. \nBlue border means a valid mapping, red means no mapping assigned.";
		public static var MSG_TUT11:String = "The mapping process automatically continues until all segments are mapped. \nWhen the task is complete, a popup window opens. \nClick 'Confirm' to submit your results.";
		public static var MSG_TUT12:String = "That's it! You can practice with the example set, \nor start the actual HIT by accepting it if you are ready. \nYou can always click the 'help' button to see the interactions.";	

		// Labels: for buttons and sections, used in tree control files
		public static var LABEL_CONT1:String = "Start";
		public static var LABEL_CONT2:String = "Continue";
		public static var LABEL_CONT3:String = "Finish";
		public static var LABEL_CONTENT:String = "Content";
		public static var LABEL_LAYOUT:String = "Layout";
		public static var LABEL_NOMAPPING:String = "Assign no mapping";
		public static var LABEL_HELP:String = "Help";
		public static var LABEL_ZOOM_IN:String = "+";
		public static var LABEL_ZOOM_OUT:String = "-";
		public static var LABEL_ZOOM_RESET:String = "Reset";
		
		// Text formats: font styles for controls
		public static var FONT_LABEL:TextFormat;
			FONT_LABEL = new TextFormat("Verdana,Tahoma,Arial",16,0,false);
			FONT_LABEL.color = "0xFFFFFF"; 
			
		public static var FONT_BUTTON:TextFormat;
			FONT_BUTTON = new TextFormat("Verdana,Tahoma,Arial",12,0,false);
			FONT_BUTTON.color = "0xFFFFFF"; 

		public static var FONT_MESSAGE:TextFormat;
			FONT_MESSAGE = new TextFormat("Verdana,Tahoma,Arial",12,0,false);
			FONT_MESSAGE.color = "0xFFFFFF"; 

		public static var FONT_TUTORIAL:TextFormat;
			FONT_TUTORIAL = new TextFormat("Verdana,Tahoma,Arial",12,0,false);
			FONT_TUTORIAL.color = "0xFFFFFF"; 		
		
		public static var FONT_TUTORIAL_STEP:TextFormat;
			FONT_TUTORIAL_STEP = new TextFormat("Verdana,Tahoma,Arial",14,0,false);
			FONT_TUTORIAL_STEP.color = "0xFFFFFF"; 		
										
		public function Theme()
		{	
		}
		
		
	    /**
    	 * Drop shadow filter for the nodes
	     */
 		public static function getDropShadowFilter():BitmapFilter 
 		{
            var color:Number = 0x000000;
            var angle:Number = 45;
            var alpha:Number = 0.8;
            var blurX:Number = 8;
            var blurY:Number = 8;
            var distance:Number = 15;
            var strength:Number = 0.65;
            var inner:Boolean = false;
            var knockout:Boolean = false;
            var quality:Number = BitmapFilterQuality.HIGH;
            return new DropShadowFilter(distance,
                                        angle,
                                        color,
                                        alpha,
                                        blurX,
                                        blurY,
                                        strength,
                                        quality,
                                        inner,
                                        knockout);
        }
        
	    /**
    	 * Drop shadow filter for the nodes
	     */
 		public static function getGlowFilter(a:Number, bx:Number, by:Number):BitmapFilter 
 		{
            var color:Number = 0xff0000;
            var alpha:Number = a;
            var blurX:Number = bx;
            var blurY:Number = by;
            var strength:Number = 3;
            var quality:Number = BitmapFilterQuality.HIGH;
            var inner:Boolean = false;
            var knockout:Boolean = false;
            
            return new GlowFilter(color, alpha, blurX, blurY, strength, quality, inner, knockout); 
            
        }        
	}
}
