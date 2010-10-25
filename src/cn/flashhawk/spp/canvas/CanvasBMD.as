package cn.flashhawk.spp.canvas
{
	import flash.display.BitmapData;
	import flash.filters.BitmapFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;

	/**
	 * @author flashhawk
	 */
	public class CanvasBMD extends BitmapData
	{	
		private var bgColor : uint;

		
		public function CanvasBMD(width : Number, height : Number ,transparent : Boolean = false,color : uint = 0x000000) : void
		{
			this.bgColor = color;
			super(width, height, transparent, color);
		}

		public function set filter(filter : BitmapFilter) : void
		{
			applyFilter(this, rect, new Point(), filter);
		}

		public function colorOffset(redOffset : int, greenOffset : int, blueOffset : int, alphaOffset : int ) : void
		{
			colorTransform(rect, new ColorTransform(1, 1, 1, 1, redOffset, greenOffset, blueOffset, alphaOffset));
		}

		public function colorMultiply(redMultiplier : Number, greenMultiplier : Number, blueMultiplier : Number,alphaMultiplier : Number) : void
		{
		
			colorTransform(rect, new ColorTransform(redMultiplier, greenMultiplier, blueMultiplier, alphaMultiplier, 0, 0, 0, 0));
		}

		public function colorMod(redMultiplier : Number = 1.0, greenMultiplier : Number = 1.0, blueMultiplier : Number = 1.0, alphaMultiplier : Number = 1.0, redOffset : Number = 0, greenOffset : Number = 0, blueOffset : Number = 0, alphaOffset : Number = 0) : void
		{
			colorTransform(rect, new ColorTransform(redMultiplier, greenMultiplier, blueMultiplier, alphaMultiplier, redOffset, greenOffset, blueOffset, alphaOffset));
		}

		public function clear() : void
		{
			fillRect(rect, bgColor);
		}
	}
}