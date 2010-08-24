package  based
{
	import cn.flashhawk.spp.BoundParticle;
	import cn.flashhawk.spp.physics.forces.BrownForce;
	import cn.flashhawk.spp.physics.forces.RepulsionForce;
	import cn.flashhawk.spp.util.FPS;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * @author flashhawk
	 */
	[SWF(backgroundColor="#000000", frameRate="30", width="800", height="600")]

	public class MouseRepulsionDemo extends Sprite 
	{
		public var sttractionPoint : Point = new Point();

		public function MouseRepulsionDemo()
		{
			var brownForce : BrownForce = new BrownForce(3, 5);
			for(var i : int = 0;i < 500;i++)
			{
				var repulsionForce : RepulsionForce = new RepulsionForce(sttractionPoint, 8, 100);
				var ball : Sprite = createBall();
				addChild(ball);
				var p : BoundParticle = new BoundParticle(ball, 400, 300, new Rectangle(0, 0, 800, 600));
				p.addForce("repulsionForce", repulsionForce);
				p.addForce("brownForce", brownForce);
				p.startRendering();
			}
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			var fps : FPS = new FPS();
			addChild(fps);
		}

		private function onEnterFrame(event : Event) : void 
		{
			sttractionPoint.x = mouseX;
			sttractionPoint.y = mouseY;
		}

		private function createBall() : Sprite
		{
			var s : Sprite = new Sprite();
			s.graphics.beginFill(Math.random() * 0xffffff);
			s.graphics.drawCircle(0, 0, Math.random() * 6 + 1);
			s.graphics.endFill();
			return s;
		}
	}
}
