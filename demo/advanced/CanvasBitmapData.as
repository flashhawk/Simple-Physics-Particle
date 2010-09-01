package advanced
{
	import flash.display.BitmapData;
	import flash.filters.BlurFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Point;

	public class CanvasBitmapData extends BitmapData
	{	
		private var bgColor:uint;
		
		public function CanvasBitmapData(width : Number, height : Number ,transparent:Boolean=false,color:uint=0x000000) : void
		{
			this.bgColor=color;
			super(width, height, transparent, color);
		}

		public function blur( amountX : uint, amountY : uint, quality : uint ) : void
		{
			applyFilter(this, this.rect, new Point(), new BlurFilter(amountX, amountY, quality));
			
		}
		public function colorMod( red : int, green : int, blue : int, alpha : int ) : void
		{
			colorTransform(rect, new ColorTransform(1, 1, 1, 1, red, green, blue, alpha));
		}

		public function clear() : void
		{
			
			fillRect(rect, bgColor);
		}
	}
}