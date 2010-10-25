/* click the stage to fire! */
package  tutorial
{
	import cn.flashhawk.spp.particles.*;
	import cn.flashhawk.spp.physics.Force;
	import cn.flashhawk.spp.util.FPS;

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
		private var ps:ParticlesSystem=new ParticlesSystem(Particle);

		public function SimpleFireWork()
		{
			setStage();
			initCanvas();
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
			//addChild(new FPS());
		}

		private function fire(e : MouseEvent) : void
		{
			var color : uint = 0xffffff * Math.random();
			var target : Sprite = createBall(color, 3);
			var fireParticle :Particle = ps.createParticle();
			fireParticle.init(mouseX, stage.stageHeight,stage.frameRate);
			fireParticle.target=target;
			fireParticle.extra = {color:color};
			fireParticle.v.reset(0, -(5 + Math.random() * 4));
			fireParticle.v.rotate(15 - Math.random() * 30);
			fireParticle.f.reset(0.001, 0.001);
			fireParticle.addEventListener('dead', boom);
			particleContainer.addChild(target);
		}

		private function boom(e : Event) : void
		{
			var particle:Particle=Particle(e.target);
			particle.removeEventListener('dead', boom);
			particleContainer.removeChild(particle.target);
			
			var fireNum : Number = 60 + int(100 * Math.random());
			
			for(var i : int = 0;i < fireNum;i++)
			{
				var target : Sprite = createBall(particle.extra.color, Math.random() * 4 + 2);
				target.blendMode = BlendMode.ADD;
				var fireParticle : Particle = ps.createParticle();
				
				fireParticle.init(particle.x, particle.y,stage.frameRate*1.5);
				fireParticle.target=target;
				fireParticle.v.reset(0, 5 * Math.random() + 1);
				fireParticle.v.rotate(Math.random() * 360);
				fireParticle.f.reset(0.02, 0.02);
				fireParticle.addForce("g", gravity);
				fireParticle.addEventListener("dead", destory);
				particleContainer.addChild(target);
			}
		}

		private function destory(e : Event) : void
		{
			var particle:Particle=Particle(e.target);
			particle.removeEventListener("dead", destory);
			particleContainer.removeChild(particle.target);
		}

		private function createBall(color : uint,r : Number = NaN) : Sprite
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
