/* click the stage to fire! */
package tutorial
{
	import cn.flashhawk.spp.Spp;
	import cn.flashhawk.spp.particles.*;
	import cn.flashhawk.spp.physics.Force;

	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author flashhawk
	 */
	[SWF(backgroundColor="#000000", frameRate="30", width="550", height="400")]
	public class SimpleFireWork extends Sprite
	{
		private var particleContainer : Sprite;
		private var gravity : Force = new Force(0, 0.1);
		private var ps : ParticlesSystem;

		public function SimpleFireWork()
		{
			setStage();
			initCanvas();
			Spp.FPS = 60;
			ps = new ParticlesSystem(this.stage, null, renderAfter);
			ps.startRendering();
		}

		private function setStage() : void
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(MouseEvent.CLICK, fire);
		}

		private function initCanvas() : void
		{
			particleContainer = new Sprite();
			particleContainer.blendMode = BlendMode.ADD;
			particleContainer.cacheAsBitmap = true;
			addChild(particleContainer);
			// addChild(new FPS());
		}

		private function fire(e : MouseEvent) : void
		{
			var color : uint = 0xffffff * Math.random();
			var target : Sprite = createBall(color, 3);
			var fireParticle : Particle = ps.createParticle(Particle);
			fireParticle.init(mouseX, stage.stageHeight, 1);

			fireParticle.extra = {color:color, target:target};
			fireParticle.velocity.reset(0, -(5 + Math.random() * 4));
			fireParticle.velocity.rotate(15 - Math.random() * 30);
			fireParticle.friction.reset(0, 0);
			fireParticle.addForce("gravity", gravity)
			fireParticle.addEventListener('dead', boom);
			particleContainer.addChild(target);
		}

		private function boom(e : Event) : void
		{
			var particle : Particle = Particle(e.target);
			particle.removeEventListener('dead', boom);
			particleContainer.removeChild(particle.extra.target);
			var fireNum : Number = 100 + int(100 * Math.random());
			for (var i : int = 0;i < fireNum;i++)
			{
				var target : Sprite = createBall(particle.extra.color, Math.random() * 4 + 2);
				target.blendMode = BlendMode.ADD;
				var fireParticle : Particle = ps.createParticle(Particle);

				fireParticle.init(particle.position.x, particle.position.y, 1.5);
				fireParticle.extra.target = target;
				fireParticle.velocity.reset(0, 3* Math.random() + 1);
				fireParticle.velocity.rotate(Math.random() * 360);
				fireParticle.friction.reset(0, 0);
				fireParticle.addForce("g", gravity);
				fireParticle.addEventListener("dead", destory);
				particleContainer.addChild(target);
			}
		}

		public function renderAfter() : void
		{
			var l : int = ps.particles.length;
			while (l-- > 0)
			{
				ps.particles[l].extra.target.x = ps.particles[l].position.x;
				ps.particles[l].extra.target.y = ps.particles[l].position.y;
			}
		}

		private function destory(e : Event) : void
		{
			var particle : Particle = Particle(e.target);
			particle.removeEventListener("dead", destory);
			particleContainer.removeChild(particle.extra.target);
		}

		private function createBall(color : uint, r : Number = NaN) : Sprite
		{
			var s : Sprite = new Sprite();
			s.graphics.beginFill(color);
			s.graphics.drawCircle(0, 0, r);
			s.graphics.endFill();
			s.cacheAsBitmap = true;
			return s;
		}
	}
}
