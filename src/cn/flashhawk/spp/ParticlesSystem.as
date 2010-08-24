package cn.flashhawk.spp 
{
	import flash.events.Event;

	/**
	 * @author flashhawk
	 */
	public class ParticlesSystem 
	{
		private var _particles : Array = [];

		public function ParticlesSystem() 
		{
		}

		public function startAll() : void
		{
			for(var i : int = _particles.length;i > 0;i--)
			{
				PhysicsParticle(_particles[i - 1]).startRendering();
			}
		}

		public function stopAll() : void
		{
			for(var i : int = _particles.length;i > 0;i--)
			{
				PhysicsParticle(_particles[i - 1]).stopRendering();
			}
		}

		public function addParticle(p : PhysicsParticle) : void
		{
			_particles.push(p);
			p.addEventListener("dead", destroyParticle);
		}

		public function removeParticle(p : PhysicsParticle) : void
		{
			var index : int = _particles.indexOf(p);
			if(index == -1)return;
			_particles.splice(index, 1);
			p.removeEventListener("death", destroyParticle);
			p = null;
		}

		public function removeAllParticles() : void
		{
			for(var i : int = _particles.length;i > 0;i--)
			{
				removeParticle(_particles[i - 1]);
			}
		}

		private function destroyParticle(e : Event) : void
		{
			var p : PhysicsParticle = PhysicsParticle(e.target);
			removeParticle(p);
		}

		public function get particles() : Array
		{
			return _particles;
		}
	}
}
