package cn.flashhawk.spp.physics.forces 
{
	import cn.flashhawk.spp.physics.Force;

	/**
	 * 重力
	 * @author flashhawk
	 */
	public class Gravity extends Force 
	{
		public function Gravity(value:Number)
		{
			isHasTarget=false;
			super(0, value, Infinity);
		}
	}
}
