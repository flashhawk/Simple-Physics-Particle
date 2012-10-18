package cn.flashhawk.spp.particles
{
	import flash.display.Stage;
	import cn.flashhawk.spp.Spp;
	import cn.flashhawk.spp.events.ParticleEvent;

	import flash.events.Event;
	import flash.events.EventDispatcher;

	/**
	 * @author flashhawk
	 */
	public class ParticlesSystem extends EventDispatcher
	{
		private var _particlePool : ParticlePool;
		private var _particles : Array = [];
		private var l : int;
		private var _renderBefore:Function;
		private var _renderAfter:Function;
	
		public static var STAGE:Stage;
		

		public function ParticlesSystem(renderAfter:Function=null,renderBefore:Function=null)
		{
			Spp.showInfo();
			_particlePool = new ParticlePool();
			this._renderBefore=renderBefore;
			this._renderAfter=renderAfter;
		}

		public function createParticle(particleType : Class) : Particle
		{
			var p : Particle = _particlePool.get(particleType);
			p.addEventListener(ParticleEvent.DEAD, removeDeadParticle, false, -1);
			_particles.push(p);
			return p;
		}

		private function singleRender(event : Event) : void
		{
			if(_renderBefore!=null)_renderBefore();
			l = _particles.length;
			while (l-- > 0) _particles[l].update();
			if(_renderAfter!=null)_renderAfter();
		}

		public function startRendering() : void
		{
			
			STAGE.addEventListener(Event.ENTER_FRAME, singleRender);
		}

		public function stopRendering() : void
		{
			
			STAGE.removeEventListener(Event.ENTER_FRAME, singleRender);
		}

		public function removeParticle(p : Particle) : void
		{
			var index : int = _particles.indexOf(p);
			if (index == -1) return;
			_particles.splice(index, 1);
			p.removeEventListener(ParticleEvent.DEAD, removeDeadParticle);
			p.reset();
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

		public  static function get FPS() : int
		{
			return STAGE.frameRate;
		}

		public  static function set FPS(f : int) : void
		{
			STAGE.frameRate=f;
		}

	}
}
