package based
{
	import flash.display.BlendMode;
	import cn.flashhawk.spp.PhysicsParticle;
	import cn.flashhawk.spp.geom.Vector2D;
	import cn.flashhawk.spp.physics.forces.BrownForce;

	import com.greensock.TweenLite;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * @author flashhawk
	 */
	[SWF(backgroundColor="#000000", frameRate="30", width="800", height="600")]
	public class BrownForceDemo extends Sprite 
	{
		private var brownForce : BrownForce = new BrownForce(1, 5);
		public function BrownForceDemo()
		{
			
			stage.addEventListener(MouseEvent.CLICK, function(e : Event):void
			{
				boom(mouseX, mouseY,50+Math.random()*100);
			});
		}

		public function boom(startx : Number,starty : Number,count : int = 30,color : uint = 0) : void
		{
			if(color == 0)
			color = 0xffffff * Math.random();
			for(var i : int = 0;i < count;i++)
			{
				var target : Sprite = createBall(color, Math.random() * 3);
				target.blendMode=BlendMode.ADD;
				var fireParticle : PhysicsParticle = new PhysicsParticle(target, startx, starty, 30, 2);
				fireParticle.v = new Vector2D(0, Math.random()*5);
				fireParticle.v.rotate(Math.random() * 360);
				fireParticle.f = new Vector2D(0.05, 0.05);
				fireParticle.addEventListener("dead", destorySelf);
				fireParticle.addForce("brow", brownForce);
				this.addChild(target);
				TweenLite.to(target, 1, {alpha:0, delay:1});
				fireParticle.startRendering();
			}
		}

		private function destorySelf(e : Event) : void
		{
			this.removeChild(e.target.target);
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
