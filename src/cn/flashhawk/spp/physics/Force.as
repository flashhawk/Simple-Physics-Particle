package cn.flashhawk.spp.physics
{
	import cn.flashhawk.spp.events.ParticleEvent;
	import cn.flashhawk.spp.geom.Vector2D;
	import cn.flashhawk.spp.particles.Particle;
	import cn.flashhawk.spp.particles.ParticlesSystem;

	import flash.events.Event;
	import flash.events.EventDispatcher;

	/**
	 * 力场的基类,由次类可以扩展好多力,例如 布朗力
	 * @see cn.flashhawk.simpleParticle.physics.forces.BrownForce  BrownForce
	 */
	public class Force extends EventDispatcher
	{
		public   var value : Vector2D;
		private   var _life : Number;
		public   var target : Particle;
		
		/**
		 * @param x X轴方向的力
		 * @param y Y轴方向的力
		 * @param life 生命周期 以帧为单位
		 */
		public function Force(x : Number, y : Number, life : Number = Infinity)
		{
			this.value = new Vector2D(x, y);
			this._life = life;
		}
		public function isLive() : Boolean
		{
			if ((_life -= 1 / ParticlesSystem.FPS) <= 0)
			{
				dispatchEvent(new Event(ParticleEvent.DEAD));
				destory();
				return false;
			}
			update();
			return true;
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
	}
}