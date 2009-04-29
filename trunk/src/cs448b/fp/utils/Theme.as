package cs448b.fp.utils 			
{
	import flash.text.TextFormat;
	public class Theme
	{	
		// Enable / Disable ancestor-descendent constraint
		public static var ENABLE_REL:Boolean = false;
		
		// Tree visualization options: used in tree files		
		public static var COLOR_ACTIVATED:uint = 0xff0000ff;
		public static var COLOR_SELECTED:uint = 0xffff0000; 		
		public static var LINE_WIDTH:uint = 15;
		public static var FIREBUG_CTREE:Boolean = false;	// node fillcolor true-original, false-firebug style
		public static var FIREBUG_LTREE:Boolean = true;		// node fillcolor true-original, false-firebug style
		public static var COLOR_FILL_MAPPED:Number = 0xffFFAAAAFF;
		public static var COLOR_FILL_UNMAPPED:Number = 0xffFFAAAAFF; //0xffFFFFAAAA;
		public static var ALPHA_MAPPED:Number = 0.3;
		public static var SHOW_MAPPPED:Boolean = true;		// hide content of the mapped nodes
		
		// Mapping status constants
		public static var STATUS_MAPPED:Number = 1;
		public static var STATUS_UNMAPPED:Number = 2;
		public static var STATUS_DEFAULT:Number = 0;
		
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
		public static var LAYOUT_UNMAP_X:Number = 200;		// unmap button x-coordinate
		public static var LAYOUT_UNMAP_Y:Number = -60;		// unmap button y-coordinate
		public static var LAYOUT_NODENAME_X:Number = 20;	// tree name label x-coordinate, relative to the canvas origin
		public static var LAYOUT_NODENAME_Y:Number = -25;	// tree name label y-coordinate, relative to the canvas origin		
		public static var LAYOUT_TREENAME_X:Number = 270;	// tree name label x-coordinate, relative to the canvas origin
		public static var LAYOUT_TREENAME_Y:Number = -25;	// tree name label y-coordinate, relative to the canvas origin
		public static var LAYOUT_NOTICE_X:Number = 0;		// notice x-coordinate
		public static var LAYOUT_NOTICE_Y:Number = 730;		// notice y-coordinate		
		public static var LAYOUT_FEEDBACK_X:Number = 450;		// notice x-coordinate
		public static var LAYOUT_FEEDBACK_Y:Number = 17;		// notice y-coordinate
		public static var LAYOUT_MAPPINGS_X:Number = 0;		// notice x-coordinate
		public static var LAYOUT_MAPPINGS_Y:Number = 750;		// notice y-coordinate
				
		// Messages: used in tree control files
		public static var MSG_STAGE1:String = "Stage: Initialization";
		public static var MSG_STAGE2:String = "Stage: Hierarchical Matching";
		public static var MSG_STAGE3:String = "Stage: Quasi-Hierarchical Matching";
		public static var MSG_MAPPING_NONE:String = "Mappings: None";
		public static var MSG_MAPPING:String = "Mappings: ";
		public static var MSG_LOADED:String = "Page loaded.";
		
		// Labels: for buttons and sections, used in tree control files
		public static var LABEL_CONT1:String = "Start";
		public static var LABEL_CONT2:String = "Continue";
		public static var LABEL_CONT3:String = "Finish";
		public static var LABEL_CONTENT:String = "Content";
		public static var LABEL_LAYOUT:String = "Layout";
		public static var LABEL_NOMAPPING:String = "Assign no mapping";
		
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
		
									
		public function Theme()
		{	
		}

	}
}
