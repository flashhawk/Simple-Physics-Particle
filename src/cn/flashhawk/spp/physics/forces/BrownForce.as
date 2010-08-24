package cn.flashhawk.spp.physics.forces 
{
	import cn.flashhawk.spp.physics.Force;

	import flash.utils.clearInterval;
	import flash.utils.setInterval;

	/**
	 * 布朗力,就上随机运动的力
	 * @author flashhawk
	 */
	public class BrownForce extends Force 
	{
		private var _maxForce : Number;
		private var _timerID : uint;
		private var time : Number;

		/**
		 * 
		 * @param	maxForce   最大的加速度
		 * @param	frequency  加速度变化频率系数
		 * @param	life       生命周期
		 */
		public function BrownForce(maxForce : Number = 0,frequency : Number = 2,life : Number = Infinity)
		{
			super(0, 0, life);
			time = Math.random() * (1000 / frequency) + (1000 / frequency);
			this._maxForce = maxForce;
			run();
		}

		private function run() : void
		{
			update();
			_timerID = setInterval(update, time);
		}

		override protected function update() : void
		{
			var xv : Number = Math.random() * _maxForce * 2 - _maxForce;
			var yv : Number = Math.random() * _maxForce * 2 - _maxForce;
			value.reset(xv, yv);
		}

		override protected function destory() : void
		{
			clearInterval(_timerID);
		}
	}
}