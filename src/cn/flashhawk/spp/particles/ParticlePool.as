package cn.flashhawk.spp.particles 
{

	/**
	 * @author flashhawk
	 * 简单粒子池
	 */
	public class ParticlePool 
	{
		private var _array:Array=[];
		private var _particleType:Class;
		
		public function ParticlePool(particleType:Class) 
		{
			this._particleType = particleType;
		}
		public function get():Particle
		{
			if(_array.length==0)return new _particleType();
			return Particle( _array.pop());
			
		}
		public function recycle(p:Particle):void
		{
			_array.push(p);
		}
		
		public function get array() : Array
		{
			return _array;
		}
	}
}
