package cn.flashhawk.spp.util
{

	/**
	 * ...
	 * @author FLASHHAWK
	 */
	public class MathUtil
	{

		/**
		 * 
		 * @param	angle 度数
		 * @return  返回angle度数的正弦；
		 */
	
		public static function sinD(angle:Number):Number
		{
			return Math.sin(angle * (Math.PI / 180));
		}
		/**
		 * 
		 * @param	angle 度数
		 * @return  返回angle度数的余弦；
		 */
		public static function cosD(angle:Number):Number
		{
			return Math.cos(angle * (Math.PI / 180));
		}
		/**
		 * 
		 * @param	angle 度数
		 * @return  返回angle度数的正切；
		 */
		public static function tanD(angle:Number):Number
		{
			return Math.tan(angle * (Math.PI / 180));
		}
		
		/**
		 * 
		 * @param	ratio 正弦值
		 * @return   反回正弦值为ratio的角的度数；
		 */
		public static function asinD(ratio:Number):Number
		{
			return Math.asin(ratio) * (180 / Math.PI);
		}
		
		/**
		 * 
		 * @param	ratio 余弦值
		 * @return   反回余弦值为ratio的角的度数；
		 */
		public static function acosD(ratio:Number):Number
		{
			return Math.acos(ratio) * (180 / Math.PI);
		}
		
		/**
		 * 
		 * @param	ratio 正切值
		 * @return   反回正切值为ratio的角的度数；
		 */
		public static function atanD(ratio:Number):Number
		{
			return Math.atan(ratio) * (180 / Math.PI);
		}
		
		/**
		 * 
		 * @param	y 该点的 y 坐标。
		 * @param	x 该点的 x 坐标。
		 * @return   y/x 的角度
		 */
		public static function atan2D(y:Number, x:Number):Number
		{
			return Math.atan2(y,x)*(180 / Math.PI);
		}
		
		public static function random(n:int):int
		{
			var randomNum:int;
			if (n <= 0)
			{
				randomNum = 0;
			}else 
			{
				randomNum = Math.round(Math.random() * (n-1));
			}
			return randomNum;
		}
	}
	
}