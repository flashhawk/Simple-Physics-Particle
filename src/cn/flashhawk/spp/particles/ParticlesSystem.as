package cn.flashhawk.spp.particles 
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	import cn.flashhawk.spp.events.ParticleEvent;

	import flash.events.Event;

	/**
	 * @author flashhawk
	 */
	public class ParticlesSystem 
	{
		private var _particlePool:ParticlePool=new ParticlePool();
		private var _frameRate : int = 30;
		private var _particles : Array = [];
		private var timer : Timer;
		private var l:int;

		public function ParticlesSystem(frameRate:int=30) 
		{
			this._frameRate=frameRate;
			timer = new Timer(1000 / _frameRate);
			timer.addEventListener(TimerEvent.TIMER, render);
		}
		public function createParticle(x:Number,y:Number,life:Number=Infinity):Particle
		{
			var p:Particle=_particlePool.get();
			p.init(x, y,life);
			addParticle(p);
			return p;
		}
		private function render(event : TimerEvent) : void 
		{
			l=_particles.length;
			while(l-- >0) _particles[l].update();
		}

		public function startRendering() : void
		{
			timer.start();
		}

		public function stopRendering() : void
		{
			timer.stop();
		}

		public function addParticle(p : Particle) : void
		{
			_particles.push(p);
			p.addEventListener(ParticleEvent.DEAD, removeDeadParticle);
		}

		public function removeParticle(p : Particle) : void
		{
			var index : int = _particles.indexOf(p);
			if(index == -1)return;
			_particles.splice(index, 1);
			p.destory();
			p.removeEventListener(ParticleEvent.DEAD, removeDeadParticle);
			p = null;
			index=NaN;
		}

		private function removeDeadParticle(e : Event) : void
		{
			var p : Particle = Particle(e.target);
			var index : int = _particles.indexOf(p);
			if(index == -1)return;
			_particles.splice(index, 1);
			p.removeEventListener(ParticleEvent.DEAD, removeDeadParticle);
			_particlePool.recycle(p);
			index=NaN;
		}

		public function removeAllParticles() : void
		{
			for(var i : int = _particles.length;i > 0;i--)
			{
				var p : Particle = Particle(_particles[i - 1]);
				p.destory();
				p.removeEventListener(ParticleEvent.DEAD, removeDeadParticle);
				_particlePool.recycle(p);
			}
			_particles = [];
		}

		public function get particles() : Array
		{
			return _particles;
		}

		public function get frameRate() : int
		{
			return _frameRate;
		}

		public function set frameRate(frameRate : int) : void
		{
			_frameRate = frameRate;
			timer.delay=1000/_frameRate;
		}
		
		public function get particlePool() : ParticlePool
		{
			return _particlePool;
		}
	}
}
