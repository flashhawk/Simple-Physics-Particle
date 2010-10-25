package cn.flashhawk.spp.physics.forces 
{
	import cn.flashhawk.spp.physics.Force;

	import flash.utils.clearInterval;
	import flash.utils.setInterval;

	/**
	 *  英文名称：Brownian motion,
	 *  定义：悬浮在流体中的微粒受到流体分子与粒子的碰撞而发生的不停息的随机运动.
	 *  本系中就是一个简单的随机运动.
	 * @author flashhawk
	 */
	public class Brownian extends Force 
	{
		public  var maxForce : Number;
		private var _timerID : uint;
		private var time : Number;
	

		/**
		 * 
		 * @param	maxForce   最大的加速度
		 * @param	cycle      加速度变化周期,以秒为单位;
		 * @param	life       生命周期
		 */
		public function Brownian(maxForce : Number = 0,cycle : Number = 1,life : Number = Infinity)
		{
			super((Math.random()*2-1)*maxForce,(Math.random()*2-1)*maxForce, life);
			time = cycle*1000;
			this.maxForce = maxForce;
			run();
		}

		private function run() : void
		{
			updateBrown();
			_timerID = setInterval(updateBrown, time);
		}

		private  function updateBrown() : void
		{
			var xv : Number = (Math.random()*2-1)*maxForce;
			var yv : Number = (Math.random()*2-1)*maxForce;
			value.reset(xv, yv);
		}
		override public function destory() : void
		{
			clearInterval(_timerID);
		}
	}
}