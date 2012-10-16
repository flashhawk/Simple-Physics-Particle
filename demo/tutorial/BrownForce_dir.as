package tutorial
{
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
	public class BrownForce_dir extends Sprite
	{
		private var ps : ParticlesSystem;
		private var bound : Rectangle = new Rectangle(0, 0, 550, 400);

		public function BrownForce_dir()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			Spp.FPS = 60;
			ps = new ParticlesSystem(this.stage, null, renderAfter);
			boom(275, 200, 300);
			ps.startRendering();
		}

		public function boom(startx : Number, starty : Number, count : int = 30) : void
		{
			for (var i : int = 0;i < count;i++)
			{
				var target : Sprite = createArrow(0xFFFFFF * Math.random());
				var fireParticle : Particle = ps.createParticle(Particle);
				fireParticle.init(startx, starty);

				fireParticle.bounceIntensity = 3;
				fireParticle.boundary = bound;
				fireParticle.extra.target=target;
				var brownianForce : Brownian = new Brownian(0.6, Math.random()*2+1);
				fireParticle.addForce("brownianForce", brownianForce);
				addChild(target);
			}
			// addChild(new FPS());
		}

		public function renderAfter() : void
		{
			var l : int = ps.particles.length;
			while (l-- > 0)
			{
				ps.particles[l].extra.target.x = ps.particles[l].position.x;
				ps.particles[l].extra.target.y = ps.particles[l].position.y;
				ps.particles[l].extra.target.rotation = ps.particles[l].moveDirection;
			}
		}

		private function createArrow(color : uint) : Sprite
		{
			var s : Sprite = new Sprite();
			// s.cacheAsBitmap = true;
			s.graphics.beginFill(color);
			s.graphics.drawPath(Vector.< int >([1, 2, 2, 2, 2, 2, 2, 2]), Vector.< Number >([-9, -7, -3, -7, -3, -11, 9, -4, -3, 3, -3, -1, -9, -1, -9, -7]));
			s.graphics.endFill();
			return s;
		}
	}
}