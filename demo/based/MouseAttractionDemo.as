package  based
{
	import cn.flashhawk.spp.PhysicsParticle;
	import cn.flashhawk.spp.physics.forces.AttractionForce;
	import cn.flashhawk.spp.physics.forces.BrownForce;

	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;

	/**
	 * @author flashhawk
	 */
	[SWF(backgroundColor="#000000", frameRate="30", width="800", height="600")]

	public class MouseAttractionDemo extends Sprite 
	{
		public var sttractionPoint : Point = new Point();

		public function MouseAttractionDemo()
		{
			var brownForce : BrownForce = new BrownForce(2, 2);
			for(var i : int = 0;i < 400;i++)
			{
				var attractionForce : AttractionForce = new AttractionForce(sttractionPoint, 3, 100);
				var ball : Sprite = createBall();
				ball.blendMode = BlendMode.ADD;
				addChild(ball);
				var p : PhysicsParticle = new PhysicsParticle(ball, Math.random() * 800, Math.random() * 400);
				p.addForce("attractionForce", attractionForce);
				p.addForce("brownForce", brownForce);
				p.startRendering();
			}
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		private function onEnterFrame(event : Event) : void 
		{
			sttractionPoint.x = mouseX;
			sttractionPoint.y = mouseY;
		}

		private function createBall() : Sprite
		{
			var s : Sprite = new Sprite();
			s.cacheAsBitmap = true;
			s.graphics.beginFill(0xffffff * Math.random());
			s.graphics.drawCircle(0, 0, 4);
			s.graphics.endFill();
			return s;
		}
	}
}
