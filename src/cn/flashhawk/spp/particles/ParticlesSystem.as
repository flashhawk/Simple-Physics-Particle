package cn.flashhawk.spp.particles
{
	import cn.flashhawk.spp.Spp;
	import cn.flashhawk.spp.events.ParticleEvent;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;

	/**
	 * @author flashhawk
	 */
	public class ParticlesSystem extends EventDispatcher
	{
		private var _particlePool : ParticlePool;
		private var _frameRate : int = 30;
		private var _particles : Array = [];
		private var l : int;
		private var _particleType : Class;
		private var _enterFrameObj : Sprite;

		public function ParticlesSystem(particleType : Class)
		{
			Spp.showInfo();
			_enterFrameObj = new Sprite();
			this._particleType = particleType;
			_particlePool = new ParticlePool(_particleType);
		}

		public function createParticle() : Particle
		{
			var p : Particle = _particlePool.get();
			p.addEventListener(ParticleEvent.DEAD, removeDeadParticle, false, -1);
			_particles.push(p);
			return p;
		}

		private function render(event : Event) : void
		{
			l = _particles.length;
			while (l-- > 0) _particles[l].update();
		}

		public function startRendering() : void
		{
			
			_enterFrameObj.addEventListener(Event.ENTER_FRAME, render);
		}

		public function stopRendering() : void
		{
			
			_enterFrameObj.removeEventListener(Event.ENTER_FRAME, render);
		}

		public function removeParticle(p : Particle) : void
		{
			var index : int = _particles.indexOf(p);
			if (index == -1) return;
			_particles.splice(index, 1);
			p.reset();
			p.removeEventListener(ParticleEvent.DEAD, removeDeadParticle);
			_particlePool.recycle(p);
			index = NaN;
		}

		public function destoryParticle(p : Particle) : void
		{
			var index : int = _particles.indexOf(p);
			if (index == -1) return;
			_particles.splice(index, 1);
			p.destory();
			p.removeEventListener(ParticleEvent.DEAD, removeDeadParticle);
			index = NaN;
			p = null;
		}

		private function removeDeadParticle(e : Event) : void
		{
			var p : Particle = Particle(e.target);
			var index : int = _particles.indexOf(p);
			if (index == -1) return;
			_particles.splice(index, 1);
			p.removeEventListener(ParticleEvent.DEAD, removeDeadParticle);
			p.reset();
			_particlePool.recycle(p);
			index = NaN;
		}

		public function removeAllParticles() : void
		{
			var i : int = _particles.length;
			var p : Particle;
			while (i-- > 0)
			{
				p = Particle(_particles[i]);
				p.reset();
				p.removeEventListener(ParticleEvent.DEAD, removeDeadParticle);
				_particlePool.recycle(p);
			}
			_particles = [];
		}

		public function destoryAllParticles() : void
		{
			var i : int = _particles.length;
			var p : Particle;
			while (i-- > 0)
			{
				p = Particle(_particles[i]);
				p.destory();
				p.removeEventListener(ParticleEvent.DEAD, removeDeadParticle);
			}
			i = _particlePool.array.length;
			while (i-- > 0)
			{
				p = Particle(_particlePool.array[i]);
				p.destory();
				p.removeEventListener(ParticleEvent.DEAD, removeDeadParticle);
			}
			_particles = [];
		}

		public function get particles() : Array
		{
			return _particles;
		}
		public function get particlePool() : ParticlePool
		{
			return _particlePool;
		}
	}
}
