package cs448b.fp.utils 			
{
	import flash.filters.BitmapFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.text.TextFormat;
	public class Theme
	{	
		public static var ENABLE_DEBUG:Boolean = true;
		public static var ENABLE_MANUAL_PREVIEW:Number = 2;	//0: normal, 1: force preview, 2: force actual
				
		// How many sessions are we having for each task?
		public static var NUM_SESSIONS:Number = 5;
		// How many pairs are in the database
		public static var NUM_PAIRS:Number = 15;
		// How many steps are in the tutorial session
		public static var NUM_TUTORIAL_STEPS:Number = 6;
				
		// Node offset options for better parent selection. 0: nothing, 1: cascaded offset, 2: expanded parent
		public static var ENABLE_CASCADE_OFFSET:uint = 2;
		public static var CASCADE_OFFSET:uint = 16;
		
		// Load or not image segments. If true, only root image is loaded. If false, all segments are loaded, causing more overhead.
		public static var ENABLE_IMAGE_SEGMENT:Boolean = false;
		// Enable /Disable merge operation (1 to N mapping possible)
		public static var ENABLE_MERGE:Boolean = true;		
		// Enable /Disable merge popup (1 to N mapping possible)
		public static var ENABLE_MERGE_POPUP:Boolean = false;		
		// Enable / Disable ancestor-descendent constraint
		public static var ENABLE_REL:Boolean = false;
		// Enable / Disable serial node presentation (one content node at a time)
		public static var ENABLE_SERIAL:Boolean = true;	
		// Enable / Disable continue button - determined by ENABLE_REL
		public static var ENABLE_CONTINUE_BUTTON:Boolean = true;	// ENABLE_REL
		// Enable /Disable blinking effect for mapping actions
		public static var ENABLE_BLINKING:Boolean = true;
		
		
		// Tree traversal order
		public static var ORDER_PREORDER:Number = 1;
		public static var ORDER_BFS:Number = 2;
		public static var ORDER_DFS:Number = 3;
		public static var ORDER_PREORDER_RANDOM:Number = 4;
		
		// Animation duration
		public static var DURATION_PREVIEW:Number = 0.3;
		public static var DURATION_BLINKING:Number = 0.5;
		
		// Tree visualization options: used in tree files		
		public static var COLOR_ACTIVATED:uint = 0xff0000ff;
		public static var COLOR_SELECTED:uint = 0xffff0000; 	
		public static var COLOR_CONNECTED:uint = 0xff0000ff;//0xffbbbbbb;	
		public static var COLOR_MAPPED:uint = 0xff93B02A;//458764;//87BF76;//96A84A;
		public static var COLOR_UNMAPPED:uint = 0xffff0000;
		public static var LINE_WIDTH:uint = 12;
		public static var FIREBUG_CTREE:Boolean = false;	// node fillcolor true-original, false-firebug style
		public static var FIREBUG_LTREE:Boolean = true;		// node fillcolor true-original, false-firebug style
		public static var COLOR_FILL_MAPPED:Number = 0x00000000; //0xffFFAAAAFF;
		public static var COLOR_FILL_UNMAPPED:Number = 0x00000000; //0xffFFFFAAAA;
		public static var ALPHA_MAPPED:Number = 1; //0.8;		// alpha value for mapped nodes
		public static var SHOW_MAPPPED:Boolean = true;		// hide content of the mapped nodes
		public static var CONNECTED_ALPHA:Number = 0.5;		// alpha value for the connected layout nodes on mouseover
		public static var CONNECTED_LINE_WIDTH:Number = 1.5;	// dividend for the connected layout nodes on mouseover
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
		public static var USE_DROPSHADOW:Boolean = false;
		
		public static var LAYOUT_CANVAS_WIDTH:uint = 550;	// single tree canvas width
		public static var LAYOUT_CANVAS_HEIGHT:uint = 600;	// single tree canvas height
		public static var LAYOUT_CTREE_X:uint = 25;			// content tree x-coordinate
		public static var LAYOUT_CTREE_Y:uint = 90;			// content tree y-coordinate
		public static var LAYOUT_LTREE_X:uint = 620;		// layout tree x-coordinate
		public static var LAYOUT_LTREE_Y:uint = 90;			// layout tree y-coordinate
		
		public static var LAYOUT_UNMAP_X:Number = 650;//200;	// unmap button x-coordinate
		public static var LAYOUT_UNMAP_Y:Number = 15; //-75;		// unmap button y-coordinate
		public static var LAYOUT_UNMAP_WIDTH:Number = 150;	// unmap button width		
		public static var LAYOUT_HELP_X:Number = 860;		// help button x-coordinate
		public static var LAYOUT_HELP_Y:Number = 15;		// help button y-coordinate
		public static var LAYOUT_HELP_WIDTH:Number = 50;	// help button width
		public static var LAYOUT_RESTART_X:Number = 915;		// restart button x-coordinate
		public static var LAYOUT_RESTART_Y:Number = 15;		// restart button y-coordinate
		public static var LAYOUT_RESTART_WIDTH:Number = 70;	// restart button width			
		public static var LAYOUT_CONTINUE_X:Number = 650;		// continue button x-coordinate
		public static var LAYOUT_CONTINUE_Y:Number = 15;		// continue button y-coordinate
		public static var LAYOUT_CONTINUE_WIDTH:Number = 150;	// continue button width				
		public static var LAYOUT_FEEDBACK_X:Number = 25;//450;	// notice x-coordinate
		public static var LAYOUT_FEEDBACK_Y:Number = 10;		// notice y-coordinate
				
		public static var LAYOUT_NODENAME_X:Number = 20;	// tree name label x-coordinate, relative to the canvas origin
		public static var LAYOUT_NODENAME_Y:Number = -25;	// tree name label y-coordinate, relative to the canvas origin		
		public static var LAYOUT_TREENAME_X:Number = 270+20;	// tree name label x-coordinate, relative to the canvas origin
		public static var LAYOUT_TREENAME_Y:Number = -35;	// tree name label y-coordinate, relative to the canvas origin
		public static var LAYOUT_ZOOM_X:Number = 50;		// zoom button x-coordinate
		public static var LAYOUT_ZOOM_Y:Number = -40;		// zoom button y-coordinate
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
		public static var LAYOUT_TUTORIAL_WIDTH:Number = 620;		// popup width
		public static var LAYOUT_TUTORIAL_HEIGHT:Number = 95;//120;		// popup height
		public static var LAYOUT_TUTORIAL_OFFSET:Number = 65;//90;		// pixel offset 
		public static var LAYOUT_TUTORIAL_BUTTON_WIDTH:Number = 80;	// button width
		public static var LAYOUT_TUTORIAL_STEP_X:Number = 15;	// step display x-coordinate
		public static var LAYOUT_TUTORIAL_STEP_Y:Number = 10;	// step display y-coordinate
		public static var LAYOUT_TUTORIAL_MSG_X:Number = 15;//25	// message display x-coordinate
		public static var LAYOUT_TUTORIAL_MSG_Y:Number = 15;//35	// message display x-coordinate
		
		// Messages: used in tree control files
		public static var MSG_STAGE1:String = "Stage: Initialization";
		public static var MSG_STAGE2:String = "Stage: Hierarchical Matching";
		public static var MSG_STAGE3:String = "Stage: Quasi-Hierarchical Matching";
		public static var MSG_STAGE4:String = "Stage: Task Complete";
		public static var MSG_MAPPING_NONE:String = "Mappings: None";
		public static var MSG_MAPPING:String = "Mappings: ";
		public static var MSG_MAPPING_INST:String = "For the highlighted segment on the left-hand page, \nfind the best corresponding segment on the right-hand page.";
		public static var MSG_LOADED:String = "Loading...";
		public static var MSG_POPUP:String = "This segment already has a mapping. What do you want to do?";
		public static var MSG_RESULT:String = "Your mapping task is successfully finished!";	
		public static var MSG_RESULT_SENDING:String = "Sending results to Mechanical Turk server.\n"
		public static var MSG_RESULT_TUTORIAL:String = "Practice task 1 of 1 complete. Click 'Continue' to finish the tutorial."
		public static var MSG_RESULT_CONTINUE:String = "Click on the 'Continue' button to start the next task."
		public static var MSG_RESULT_FINISH:String = "Click on the 'Continue' button to submit the result and finish this HIT."
		
		public static var MSG_HELP:String = "Mouse click: select a segment\n" + 
				"Mouse over\n" + 
				"  * not yet mapped: view current(red) and visually related(purple) segments \n" + 
				"  * mapped already: blue - there is a mapped segment on the other page. \n" + 
				"                                 red  - you assigned 'no mapping' for this segment.\n" + 
				"Zoom control \n" + 
				"  * (+): zoom in button \n" + 
				"  * (-): zoom out button \n" + 
				//"  * Reset: back to default scale \n\n" + 
				"Panning: Control Key + Mouse Drag \n";

		public static var MSG_TUT1:String = "\nYour goal in this task is to match regions between two web pages.\n" + 
				"This tutorial will give you an overview of the task."; 
		//<click 'Start'>
		
		public static var MSG_TUT2:String = "\nWhen the task starts, you are first shown an animated preview \n" + 
				"of the page segments you will have to match (left-hand page)."; 
		// <automatically advance after preview is over>
		
		public static var MSG_TUT3:String = "For each highlighted segment on the left-hand page, " + 
				"your goal is to find the best corresponding segment on the right-hand page. \n" + 
				"Currently, the header of the left-hand page is highlighted. " + 
				"For practice, click on the header of the right-hand page and then click \"Match\" to match the two headers. ";
		// <when task is successfully completed, automatically advance>
		
		public static var MSG_TUT4:String = "Good job! \n" + 
				"Sometimes, there will not be a good match for a highlighted segment. \n" + 
				"Currently, the image of the dog is highlighted. " + 
				"Click \"No match\" to indicate that there isn't a corresponding region on the right-hand page."; 
		// <when task is successfully completed, automatically advance>
		
		public static var MSG_TUT5:String = "Great job! \n" + 
				"Now complete the task by mapping the three remaining menu segments on the left-hand page " + 
				"to their corresponding regions on the right-hand page. \n" + 
				"Careful: a region on the right-hand side can only be matched once; " + 
				"afterwards, it is disabled and cannot be used in subsequent matchings!";  
		// <when task is successfully completed, automatically advance>
		
		public static var MSG_TUT6:String = "\nWell done! " + 
				"You are now ready to start the actual HIT. \n" + 
				"Be sure to check out 'Help' to learn a few additional interaction tips. \n" + 
				"Click 'Restart' to see this tutorial again.";

		// Labels: for buttons and sections, used in tree control files
		public static var LABEL_CONT1:String = "Match"; //"Start";
		public static var LABEL_CONT2:String = "Match";
		public static var LABEL_CONT3:String = "Match";
		public static var LABEL_CONTENT:String = "Content";
		public static var LABEL_LAYOUT:String = "Layout";
		public static var LABEL_NOMAPPING:String = "No match";
		public static var LABEL_HELP:String = "Help";
		public static var LABEL_RESTART:String = "Restart";
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
            var distance:Number = 10;
            var strength:Number = 0.8;//0.65;
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
            var strength:Number = 2;
            var quality:Number = BitmapFilterQuality.HIGH;
            var inner:Boolean = false;
            var knockout:Boolean = false;
            
            return new GlowFilter(color, alpha, blurX, blurY, strength, quality, inner, knockout); 
            
        }        
	}
}
