package cn.flashhawk.spp.physics
{
	import cn.flashhawk.spp.geom.Vector2D;
	import cn.flashhawk.spp.PhysicsParticle;

	/**
	 * 力场的基类,由次类可以扩展好多力,例如 布朗力
	 * @see cn.flashhawk.simpleParticle.physics.forces.BrownForce  BrownForce
	 */
	public class  Force
	{
		private   var _value : Vector2D;
		public    var life : Number;
		public    var target : PhysicsParticle;

		/**
		 * @param x X轴方向的力
		 * @param y Y轴方向的力
		 * @param life 力的生命周期,以秒为单位
		 */
		public function Force(x : Number,y : Number,life : Number = Infinity)
		{
			this._value = new Vector2D(x, y);
			this.life = life*1000;
		}

		public function get value() : Vector2D
		{
			return _value;
		}

		public function set value(v : Vector2D) : void
		{
			_value.reset(v.x, v.y);
		}

		public function live() : Boolean
		{
			if ((life-=target.interval)<= 0)
			{
				destory();
				return false;
			}
			else 
			{
				update();
				return true;
			}
		}
		
		/**
		 * @private
		 */
		protected function update() : void
		{
			
		}

		/**
		 * @private
		 */
		protected function destory() : void
		{
			
		}
	}
}