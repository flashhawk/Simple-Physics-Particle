package tutorial
{
	import cn.flashhawk.spp.canvas.CanvasBMD;
	import cn.flashhawk.spp.particles.*;
	import cn.flashhawk.spp.physics.forces.Repulsion;
	import cn.flashhawk.spp.util.FPS;

	import flash.display.Bitmap;
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * @author flashhawk
	 */
	[SWF(backgroundColor="#000000", frameRate="30", width="550", height="400")]

	public class SimpleSand extends Sprite
	{
		public var sttractionPoint : Point;
		private var ps : ParticlesSystem;
		private var bound : Rectangle;
		private var canvase : Bitmap;
		private var bmd : CanvasBMD;
		
		public function SimpleSand()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(e : Event) : void
		{
			stageSetup();
			ps = new ParticlesSystem(BoundParticle);
			sttractionPoint = new Point();
			initCanvas();
			boom(8000);
			ps.startRendering();
			this.addEventListener(Event.ENTER_FRAME, loop);
			//addChild(new FPS());
		}

		private function stageSetup() : void
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.quality = StageQuality.LOW;
		}

		private function initCanvas() : void
		{
			bmd = new CanvasBMD(stage.stageWidth, stage.stageHeight, false, 0);
			canvase = new Bitmap(bmd);
			canvase.blendMode = BlendMode.ADD;
			canvase.width = stage.stageWidth;
			canvase.height = stage.stageHeight;
			addChild(canvase);
		}
		private function loop(e : Event) : void
		{
			var i : int = ps.particles.length;
			bmd.lock();
			bmd.clear();
			while (i-- > 0)
			{
				bmd.setPixel(ps.particles[i].x, ps.particles[i].y, 0xffffff);
			}
			sttractionPoint.x = mouseX;
			sttractionPoint.y = mouseY;
			bmd.unlock();
		}

		public function boom(count : int = 30) : void
		{
			bound = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
			for (var i : int = 0;i < count;i++)
			{
				var particle : BoundParticle = BoundParticle(ps.createParticle());
				particle.init(stage.stageWidth * Math.random(), stage.stageHeight * Math.random());
				particle.bounceIntensity = 1;
				var repulsionForce : Repulsion = new Repulsion(sttractionPoint, 4, 60);
				particle.addForce("repulsionForce", repulsionForce);
				particle.particleBound = bound;
				
			}
		}
	}
}
