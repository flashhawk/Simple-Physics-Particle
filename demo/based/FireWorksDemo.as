package  based
{
	import cn.flashhawk.spp.PhysicsParticle;
	import cn.flashhawk.spp.geom.Vector2D;
	import cn.flashhawk.spp.physics.Force;
	import cn.flashhawk.spp.util.FPS;

	import com.greensock.TweenLite;

	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author flashhawk
	 */
	[SWF(backgroundColor="#000000", frameRate="30", width="800", height="600")]

	public class FireWorksDemo extends Sprite 
	{
		private var particleContainer : Sprite;
		private var g : Force = new Force(0, 0.1);

		public function FireWorksDemo()
		{
			setStage();
			initCanvas();
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
			addChild(new FPS());
		}

		private function fire(e : MouseEvent) : void
		{
			var color : uint = 0xffffff * Math.random();
			var target : Sprite = createBall(color, 3);
			var fireParticle : PhysicsParticle = new PhysicsParticle(target, mouseX, stage.stageHeight, 30, 2);
			fireParticle.extra = {color:color};
			fireParticle.v = new Vector2D(Math.random() * 8 - 4, -(Math.random() * 6 + 6));
			fireParticle.f = new Vector2D(0.001, 0.001);
			fireParticle.addEventListener('dead', boom);
			particleContainer.addChild(target);
			fireParticle.startRendering();
		}

		private function boom(e : Event) : void
		{
			var firetarget = e.target.target;
			var boomx : Number = firetarget.x;
			var boomy : Number = firetarget.y;
			var color : uint = e.target.extra.color;
			particleContainer.removeChild(firetarget);
			
			var fireNum : Number = 60 + int(100 * Math.random());
			
			for(var i : int = 0;i < fireNum;i++)
			{
				var target : Sprite = createBall(color, Math.random() * 4 + 2);
				target.blendMode = BlendMode.ADD;
				var fireParticle : PhysicsParticle = new PhysicsParticle(target, boomx, boomy, 30, 2);
				fireParticle.v = new Vector2D(0, 5 * Math.random() + 1);
				fireParticle.v.rotate(Math.random() * 360);
				fireParticle.f = new Vector2D(0.02, 0.02);
				fireParticle.addForce("g", g);
				fireParticle.addEventListener("dead", destorySelf);
				particleContainer.addChild(target);
				TweenLite.to(target, 1.5, {alpha:0, delay:0.5});
				fireParticle.startRendering();
			}
		}

		private function destorySelf(e : Event) : void
		{
			particleContainer.removeChild(e.target.target);
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
