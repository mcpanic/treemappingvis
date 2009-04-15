package cs448b.fp.utils
{
	import flash.text.TextFormat;		
	public class Theme
	{		
		// Tree visualization options: used in tree files
		public static var COLOR_ACTIVATED:uint = 0xff0000ff;
		public static var COLOR_SELECTED:uint = 0xffff0000;
		public static var LINE_WIDTH:uint = 15;
		public static var COLOR_FILL_MAPPED:Number = 0xffFFAAAAFF;
		public static var COLOR_FILL_UNMAPPED:Number = 0xffFFFFAAAA;
		
		// Tree layout options: used in tree layout files
		public static var CASCADE_OFFSET:uint = 10;
		public static var USE_DROPSHADOW:Boolean = false;
		public static var LAYOUT_CTREE_X:uint = 25;
		public static var LAYOUT_CTREE_Y:uint = 25;
		public static var LAYOUT_LTREE_X:uint = 600;
		public static var LAYOUT_LTREE_Y:uint = 25;
		
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
			FONT_LABEL = new TextFormat("Verdana,Tahoma,Arial",14,0,false);
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
