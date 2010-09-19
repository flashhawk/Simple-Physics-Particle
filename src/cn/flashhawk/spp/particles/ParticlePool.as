package cn.flashhawk.spp.particles 
{

	/**
	 * @author flashhawk
	 */
	public class ParticlePool 
	{
		private var _array:Array=[];
		
		public function ParticlePool() 
		{
			
		}
		public function get():Particle
		{
			if(_array.length==0)return new Particle();
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
