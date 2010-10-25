package cn.flashhawk.spp.physics
{
	import cn.flashhawk.spp.particles.Particle;
	import cn.flashhawk.spp.geom.Vector2D;


	/**
	 * 力场的基类,由次类可以扩展好多力,例如 布朗力
	 * @see cn.flashhawk.simpleParticle.physics.forces.BrownForce  BrownForce
	 */
	public class  Force
	{
		private   var _value : Vector2D;
		private   var _life : Number;
		private   var _target : Particle;
		protected var isHasTarget:Boolean=true;

		/**
		 * @param x X轴方向的力
		 * @param y Y轴方向的力
		 * @param life 生命周期 以帧为单位
		 */
		public function Force(x : Number,y : Number,life : Number = Infinity)
		{
			this._value = new Vector2D(x, y);
			this._life = life;
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
			if (_life-- <= 0)
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

		public function destory() : void
		{
		}
		
		public function get life() : Number
		{
			return _life;
		}
		
		public function get target() : Particle
		{
			return _target;
		}
		
		public function set target(target : Particle) : void
		{
			if(isHasTarget)_target = target;
		}
	}
}