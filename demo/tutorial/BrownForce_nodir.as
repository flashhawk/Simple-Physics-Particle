package tutorial
{
	import cn.flashhawk.spp.particles.*;
	import cn.flashhawk.spp.physics.forces.Brownian;
	import cn.flashhawk.spp.util.FPS;

	import flash.display.Sprite;
	import flash.display.StageScaleMode;
	import flash.geom.Rectangle;

	/**
	 * @author flashhawk
	 */
	[SWF(backgroundColor="#000000", frameRate="30", width="550", height="400")]
	public class BrownForce_nodir extends Sprite 
	{
		private var ps:ParticlesSystem=new ParticlesSystem(BoundParticle);
		private var bound:Rectangle=new Rectangle(0,0,550,400);
		public function BrownForce_nodir()
		{
			stage.scaleMode=StageScaleMode.NO_SCALE;
			boom(275,200,200);
			ps.startRendering();
		}

		public function boom(startx : Number,starty : Number,count : int = 30) : void
		{
			for(var i : int = 0;i < count;i++)
			{
				var target : Sprite = createBall(0xFFFFFF*Math.random(),Math.random()*5+3);
				var particle : BoundParticle = BoundParticle(ps.createParticle());
				particle.init(startx, starty);
				particle.bounceIntensity=2;
				particle.particleBound=bound;
			   	var brownianForce : Brownian = new Brownian(2,0.5);
				particle.addForce("brownianForce", brownianForce);
				particle.target = target;
				addChild(target);
			}
			//addChild(new FPS());
		}
		private function createBall(color : uint,r : Number = NaN) : Sprite
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
