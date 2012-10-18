package tutorial
{
	import cn.flashhawk.spp.util.FPS;
	import cn.flashhawk.spp.Spp;
	import cn.flashhawk.spp.particles.*;
	import cn.flashhawk.spp.physics.forces.Brownian;

	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.geom.Rectangle;

	/**
	 * @author flashhawk
	 */
	[SWF(backgroundColor="#000000", frameRate="30", width="550", height="400")]
	public class BrownForce_nodir extends Sprite
	{
		private var ps : ParticlesSystem;
		private var bound : Rectangle = new Rectangle(0, 0, 550, 400);

		public function BrownForce_nodir()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			ParticlesSystem.STAGE=stage;
			ParticlesSystem.FPS = 60;
			ps = new ParticlesSystem(loop);
			boom(275, 200, 200);
			ps.startRendering();
			addChild(new FPS());
		}

		public function boom(startx : Number, starty : Number, count : int = 30) : void
		{
			for (var i : int = 0;i < count;i++)
			{
				var target : Sprite = createBall(0xFFFFFF * Math.random(), Math.random() * 5 + 3);
				var particle : Particle = ps.createParticle(Particle);
				particle.init(startx, starty);
				particle.bounceIntensity = 3;
				particle.boundary = bound;
				particle.extra.target = target;
				var brownianForce : Brownian = new Brownian(0.5, Math.random() * 3);
				particle.addForce("brownianForce", brownianForce);
				addChild(target);
			}
		}

		public function loop() : void
		{
			var l : int = ps.particles.length;
			while (l-- > 0)
			{
				ps.particles[l].extra.target.x = ps.particles[l].position.x;
				ps.particles[l].extra.target.y = ps.particles[l].position.y;
			}
		}

		private function createBall(color : uint, r : Number = NaN) : Sprite
		{
			var s : Sprite = new Sprite();
			s.cacheAsBitmap = true;
			s.graphics.beginFill(color);
			s.graphics.drawCircle(0, 0, r);
			s.graphics.endFill();
			return s;
		}
	}
}
