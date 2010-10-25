package cn.flashhawk.spp.util
{

	/**
	 * ...
	 * @author FLASHHAWK
	 */
	public class MathUtil 
	{

		public static function toDegree(radian : Number) : Number
		{
			return (radian / Math.PI) * 180.0;
		}

		public static function toRadian(degree : Number) : Number
		{
			return (degree / 180) * Math.PI;
		}

		
		/**
		 * 
		 * @param	angle 度数
		 * @return  返回angle度数的正弦；
		 */

		public static function sinD(angle : Number) : Number
		{
			return Math.sin(toRadian(angle));
		}

		/**
		 * 
		 * @param	ratio 正弦值
		 * @return   反回正弦值为ratio的角的度数,以度为单位；
		 */
		public static function asinD(ratio : Number) : Number
		{
			return toDegree(Math.asin(ratio));
		}

		/**
		 * @param	angle 度数
		 * @return  返回angle度数的余弦；
		 */
		public static function cosD(angle : Number) : Number
		{
			return Math.cos(toRadian(angle));
		}

		/**
		 * @param	ratio 余弦值
		 * @return   反回余弦值为ratio的角的度数,以度为单位；
		 */
		public static function acosD(ratio : Number) : Number
		{
			return toDegree(Math.acos(ratio));
		}
		
		/**
		 * @param	angle 度数
		 * @return  返回angle度数的正切；
		 */
		public static function tanD(angle : Number) : Number
		{
			return Math.tan(toRadian(angle));
		}
		/** 
		 * @param	ratio 正切值
		 * @return   反回正切值为ratio的角的度数,以度为单位；
		 */
		public static function atanD(ratio : Number) : Number
		{
			return  toDegree(Math.atan(ratio));
		}

		/**
		 * 
		 * @param	y 该点的 y 坐标。
		 * @param	x 该点的 x 坐标。
		 * @return   y/x 的角度,以度为单位;
		 */
		public static function atan2D(y : Number, x : Number) : Number
		{
			return toDegree(Math.atan2(y, x));
		}
		
		public static function random(n : int) : int
		{
			var randomNum : int;
			if (n <= 0)
			{
				randomNum = 0;
			}
			else 
			{
				randomNum = Math.round(Math.random() * (n - 1));
			}
			return randomNum;
		}
	}
}