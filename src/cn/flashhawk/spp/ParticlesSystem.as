package cn.flashhawk.spp 
{
	import cn.flashhawk.spp.events.ParticleEvent;
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
			var l:int = _particles.length;
			while(l-- >0)
			{
				PhysicsParticle(_particles[l]).startRendering();
			}
		}

		public function stopAll() : void
		{
			var l:int = _particles.length;
			while(l-- >0)
			{
				PhysicsParticle(_particles[l]).stopRendering();
			}
		}

		public function addParticle(p : PhysicsParticle) : void
		{
			_particles.push(p);
			p.addEventListener(ParticleEvent.DEAD, removeDeadParticle);
		}

		public function removeParticle(p : PhysicsParticle) : void
		{
			var index : int = _particles.indexOf(p);
			if(index == -1)return;
			_particles.splice(index, 1);
			p.destory();
			p.removeEventListener(ParticleEvent.DEAD, removeDeadParticle);
			p = null;
		}
		private function removeDeadParticle(e:Event):void
		{
			var p : PhysicsParticle = PhysicsParticle(e.target);
			var index : int = _particles.indexOf(p);
			if(index == -1)return;
			_particles.splice(index, 1);
			p.removeEventListener(ParticleEvent.DEAD, removeDeadParticle);
			p = null;
		}
		public function removeAllParticles() : void
		{
			for(var i : int = _particles.length;i > 0;i--)
			{
				var p:PhysicsParticle=PhysicsParticle(_particles[i - 1]);
				p.destory();
				p.removeEventListener(ParticleEvent.DEAD, removeDeadParticle);
				p=null;
				_particles[i - 1]=null;
			}
			_particles=[];
		}
		public function get particles() : Array
		{
			return _particles;
		}
	}
}
