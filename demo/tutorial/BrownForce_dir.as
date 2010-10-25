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
	public class BrownForce_dir extends Sprite 
	{
		private var ps:ParticlesSystem=new ParticlesSystem(BoundParticle);
		private var bound:Rectangle=new Rectangle(0,0,550,400);
		public function BrownForce_dir()
		{
			stage.scaleMode=StageScaleMode.NO_SCALE;
			boom(275,200,300);
			ps.startRendering();
		}

		public function boom(startx : Number,starty : Number,count : int = 30) : void
		{
			for(var i : int = 0;i < count;i++)
			{
				var target : Sprite = createArrow(0xFFFFFF*Math.random());
				var fireParticle : BoundParticle = BoundParticle(ps.createParticle());
				fireParticle.init(startx, starty);
				fireParticle.isRenderTargetDir=true;
				fireParticle.bounceIntensity=3;
				fireParticle.particleBound=bound;
			    var brownianForce : Brownian = new Brownian(1,1);
				fireParticle.addForce("brownianForce", brownianForce);
				fireParticle.target = target;
				addChild(target);
			}
			//addChild(new FPS());
		}
		private function createArrow(color:uint):Sprite
		{
			var s : Sprite = new Sprite();
			//s.cacheAsBitmap = true;
			s.graphics.beginFill(color);
			s.graphics.drawPath(Vector.< int >([1,2,2,2,2,2,2,2]), Vector.< Number >([-9,-7,-3,-7,-3,-11,9,-4,-3,3,-3,-1,-9,-1,-9,-7]));
			s.graphics.endFill();
			return s;
		}
	}
}