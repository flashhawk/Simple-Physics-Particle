package cn.flashhawk.spp.physics.forces 
{
	import cn.flashhawk.spp.physics.Force;

	/**
	 *  英文名称：Brownian motion,
	 *  定义：悬浮在流体中的微粒受到流体分子与粒子的碰撞而发生的不停息的随机运动.
	 *  本系中就是一个简单的随机运动.
	 * @author flashhawk
	 */
	public class SimpleBrownian extends Force 
	{
		public  var maxForce : Number;
		private var _timerID : uint;
		private var time : Number;

		/**
		 * 
		 * @param	maxForce   最大的加速度
		 * @param	life       生命周期
		 */
		public function SimpleBrownian(maxForce : Number = 0,life : Number = Infinity)
		{
			super(0, 0, life);
			this.maxForce = maxForce;
			
		}
		override protected  function update() : void
		{
			var xv : Number = (Math.random()*2-1)*maxForce;
			var yv : Number = (Math.random()*2-1)*maxForce;
			value.reset(xv, yv);
		}
		
	}
}