package cs448b.fp.tree
{
	import cs448b.fp.utils.*;	
	import flare.util.Property;
	import flare.vis.data.NodeSprite;
	import flare.vis.operator.layout.*;
	
	import flash.filters.BitmapFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.DropShadowFilter;
	import flash.geom.Rectangle;
    	
	/**
	 * Layout that places node in a TreeMap layout that optimizes for low
	 * aspect ratios of visualized tree nodes. TreeMaps are a form of
	 * space-filling layout that represents nodes as boxes on the display, with
	 * children nodes represented as boxes placed within their parent's box.
	 * This layout determines the area of nodes in the tree map by looking up
	 * the <code>sizeField</code> property on leaf nodes. By default, this
	 * property is "size", such that the layout will look for size
	 * values in the <code>DataSprite.size</code> property.
	 * 
	 * <p>
	 * This particular algorithm is taken from Bruls, D.M., C. Huizing, and 
	 * J.J. van Wijk, "Squarified Treemaps" In <i>Data Visualization 2000, 
	 * Proceedings of the Joint Eurographics and IEEE TCVG Sumposium on 
	 * Visualization</i>, 2000, pp. 33-42. Available online at:
	 * <a href="http://www.win.tue.nl/~vanwijk/stm.pdf">
	 * http://www.win.tue.nl/~vanwijk/stm.pdf</a>.
	 * </p>
	 * <p>
	 * For more information on TreeMaps in general, see 
	 * <a href="http://www.cs.umd.edu/hcil/treemap-history/">
	 * http://www.cs.umd.edu/hcil/treemap-history/</a>.
	 * </p>
	 */
	public class CascadedTreeLayout extends Layout
	{
		private static const AREA:String = "treeMapArea";
		
		private var _kids:Array = new Array();
		private var _row:Array  = new Array();
		private var _r:Rectangle = new Rectangle();
		
		private var _size:Property = Property.$("size");
		
		private var _cascadeOffset:Number = Theme.CASCADE_OFFSET;
		
		private var _x:Number;
		private var _y:Number;
		/** The property from which to access size values for leaf nodes. */
		public function get sizeField():String { return _size.name; }
		public function set sizeField(s:String):void { _size = Property.$(s); }
		
		// --------------------------------------------------------------------
		
		/**
		 * Creates a new TreeMapLayout 
		 * @param sizeField the data property from which to access the size
		 *  value for leaf nodes. The default is the "size" property.
		 */
		public function CascadedTreeLayout(x:Number, y:Number, sizeField:String="size") {
			this.sizeField = sizeField;
			this._x = x;
			this._y = y;
		}
		
		/** @inheritDoc */
		protected override function layout():void
		{
			var root:NodeSprite = layoutRoot as NodeSprite;
			var b:Rectangle = layoutBounds;
			_r.x = b.x;
			_r.y = b.y;
			_r.width=b.width-1; 
	        _r.height=b.height-1;
	        
	        // process size values
	        computeAreas(root);
			//computeAreasOld(root);
	        
	        // layout root node
	        var o:Object = _t.$(root);
	        o.x = 0;//_r.x + _r.width/2;
	        o.y = 0;//_r.y + _r.height/2;

// mcpanic fixes
	        o.u = root.props["x"];//_r.x;
	        o.v = root.props["y"];//_r.y;
	        o.w = root.props["width"];//_r.width;
	        o.h = root.props["height"];//_r.height;
	
	        // layout the tree
	        //updateArea(root, _r);
	        doLayout(root, _r);
		}

	    /**
    	 * Drop shadow filter for the nodes
	     */
 		private function getBitmapFilter():BitmapFilter {
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
    	 * Compute the pixel areas of nodes based on their size values.
	     */
	    private function computeAreas(root:NodeSprite):void
	    {
	    	var leafCount:int = 0;

	        root.visitTreeDepthFirst(function(n:NodeSprite):void {
//	        	n.props[AREA] = 0;
	        	// mcpanic
	        	n.props[AREA] = n.props["width"] * n.props["height"];
	        	
	            // apply dropshadow filter for all nodes to give 3D-like look
	            if (Theme.USE_DROPSHADOW)
	            {
	            	var filter:BitmapFilter = getBitmapFilter();
	            	var myFilters:Array = new Array();
	            	myFilters.push(filter);
					n.filters = myFilters;
	            }
	        });

	        // apply offsets
	        root.visitTreeBreadthFirst(function(n:NodeSprite):void {
				n.props["image"].setSize(Number(n.props["width"]), Number(n.props["height"]));
				//n.props["image"].visible = false;
				n.props["image"].x = Number(n.props["x"]) + n.depth * _cascadeOffset;
				n.props["image"].y = Number(n.props["y"]) + n.depth * _cascadeOffset;	     
		   	
	        });
        
        
	        // scale sizes by display area factor
	        var b:Rectangle = layoutBounds;
	        var area:Number = (b.width-1)*(b.height-1);
	        var scale:Number = area / root.props[AREA];
	        root.visitTreeDepthFirst(function(n:NodeSprite):void {
	        	n.props[AREA] *= scale;
	        });
	    }

	    /**
	     * Compute the tree map layout.
	     */
	    private function doLayout(p:NodeSprite, r:Rectangle):void
	    {
	    	
	        // create sorted list of children's properties
	        for (var i:uint = 0; i < p.childDegree; ++i) {
	        	_kids.push(p.getChildNode(i).props);
	        }
	        _kids.sortOn(AREA, Array.NUMERIC);
	        // update array to point to sprites, not props
	        for (i = 0; i < _kids.length; ++i) {
	        	_kids[i] = _kids[i].self;
	        }
	        
	        // do squarified layout of siblings
	        var w:Number = Math.min(r.width, r.height);
	        squarify(_kids, _row, w, r); 
	        _kids.splice(0, _kids.length); // clear _kids
      
	        // recurse
	        for (i=0; i<p.childDegree; ++i) {
	        	var c:NodeSprite = p.getChildNode(i);
	        	if (c.childDegree > 0) {
	        		//updateArea(c, r);
	        		doLayout(c, r);
	        	}
	        }
	    }
/*	    
	    private function updateArea(n:NodeSprite, r:Rectangle):void
	    {
	    	var o:Object = _t.$(n);
			r.x = o.u;// + o.depth * 10;
			r.y = o.v;// + o.depth * 10;
			r.width = o.w;
			r.height = o.h;
			return;
	    }
*/	    
	    private function squarify(c:Array, row:Array, w:Number, r:Rectangle):void
	    {
	    	var worst:Number = Number.MAX_VALUE, nworst:Number;
	    	var len:int;
	        
	        while ((len=c.length) > 0) {
	            // add item to the row list, ignore if negative area
	            var item:NodeSprite = c[len-1];
				var a:Number = item.props[AREA];
	            if (a <= 0.0) {
	            	c.pop();
	                continue;
	            }
	            row.push(item);
	            
	            nworst = getWorst(row, w);
	            if (nworst <= worst) {
	            	c.pop();
	                worst = nworst;
	            } else {
	            	row.pop(); // remove the latest addition
	                r = layoutRow(row, w, r); // layout the current row
	                w = Math.min(r.width, r.height); // recompute w
	                row.splice(0, row.length); // clear the row
	                worst = Number.MAX_VALUE;
	            }
	        }
	        if (row.length > 0) {
	            r = layoutRow(row, w, r); // layout the current row
	            row.splice(0, row.length); // clear the row
	        }
	    }
	
	    private function getWorst(rlist:Array, w:Number):Number
	    {
	    	var rmax:Number = Number.MIN_VALUE;
	    	var rmin:Number = Number.MAX_VALUE;
	    	var s:Number = 0;

			for each (var n:NodeSprite in rlist) {
				var r:Number = n.props[AREA];
				rmin = Math.min(rmin, r);
				rmax = Math.max(rmax, r);
				s += r;
			}
	        s = s*s; w = w*w;
	        return Math.max(w*rmax/s, s/(w*rmin));
	    }

	    private function layoutRow(row:Array, ww:Number, r:Rectangle):Rectangle
	    {
	    	var s:Number = 0; // sum of row areas
	        for each (var n:NodeSprite in row) {
	        	s += n.props[AREA];
	        }
			
			var xx:Number = r.x, yy:Number = r.y, d:Number = 0;
			var hh:Number = ww==0 ? 0 : s/ww;
			var horiz:Boolean = (ww == r.width);
	        
	        // set node positions and dimensions
	        for each (n in row) {
	        	var p:NodeSprite = n.parentNode;
	        	var nw:Number = n.props[AREA]/hh;
	        	
	        	var o:Object = _t.$(n);
//					trace(n.name + " " + n.props["height"]);
//	        		o.u = n.props["image"].x;
//	        		o.v = n.props["image"].y;
//	        		o.w = n.props["image"].width;
//	        		o.h = n.props["height"].height;	       
	        		o.u = n.props["x"] + n.depth * _cascadeOffset;
	        		o.v = n.props["y"] + n.depth * _cascadeOffset;
	        		o.w = n.props["width"];
	        		o.h = n.props["height"];	  	

	        	o.x = 0;
	        	o.y = 0;
	        	d += nw;
	        }

	        return r;
	    }

	}
}