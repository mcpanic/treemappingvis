package cs448b.fp.data
{
	import flash.geom.Point;
	
	public class Mapping
	{
		private var map:Array = new Array();
		
		public function Mapping()
		{
			// createMap();
		}

		public function printMapping():void
		{
			for(var o:Object in map)
			{
				var p:Point = map[o] as Point;

				trace("(" + p.x + "--" + p.y + ") ");
			}			
		}
		
		public function createMap(num1:Number, num2:Number):void
		{
			addMapping(num1, num2);
		}		
		
		public function addMapping(num1:Number, num2:Number):void
		{
			map.push(new Point(num1, num2));
		}
		
		public function removeMapping(isContentTree:Boolean, nodeId:Number):void
		{
			if(isContentTree) // content tree
			{
				for(var o:Object in map)
				{
					var p:Point = map[o] as Point;

					if(p.x == nodeId)
					{
						map.splice(map.indexOf(p), 1);
					}
				}
			}
			else
			{ // layout trees
				for(o in map)
				{
					p = map[o] as Point;
					
					if(p.y == nodeId) 
					{
						map.splice(map.indexOf(p), 1);
					}
				}
			}
		}
		
//		public function jjanMap():void
//		{
//			map.push(new Point(1, 117));
//			map.push(new Point(16, 121));
//			map.push(new Point(112, 225));
//			map.push(new Point(115, 227));
//			map.push(new Point(41, 144));
//			map.push(new Point(52, 158));
//			map.push(new Point(56, 162));
//			map.push(new Point(32, 137));
//			map.push(new Point(96, 212));
//			map.push(new Point(23, 130));
//			map.push(new Point(105, 220));
//			map.push(new Point(107, 222));
//			map.push(new Point(48, 153));
//			map.push(new Point(99, 215));
//			map.push(new Point(102, 217));
//		}
	
		/**
		 * Returns the mapped index.
		 * 
		 * @param idx - the index to find mapped index.
		 * @param treeId - the ID of the tree mapped
		 */	
		public function getMappedIndex(idx:Number, treeId:Number):Number
		{
			if(treeId == 0) // send to content tree
			{
				for(var oo:Object in map)
				{
					var pp:Point = map[oo] as Point;
					
					if(pp.y == idx) return pp.x;
				}
			}
			else
			{ // send to all trees
				// for each mapping
				for(var o:Object in map)
				{
					var p:Point = map[o] as Point;
					
					if(p.x == idx) return p.y;
				}
					
			}
			
			return -1;
		}
	}
}