package cn.flashhawk.spp.particles
{

	/**
	 * @author flashhawk
	 * 简单粒子池
	 */
	public class ParticlePool
	{
		private var _array : Array = [];

		public function ParticlePool()
		{
		}

		public function get(particleType : Class) : Particle
		{
			var p : Particle;
			for ( var i:String in _array)
			{
				if (_array[i].constructor == particleType)
				{
					p = _array[i];
					_array.splice(int(i), 1);
					return p;
				}
			}
			return new particleType();
		}

		public function recycle(p : Particle) : void
		{
			_array.push(p);
		}

		public function get array() : Array
		{
			return _array;
		}
	}
}
