package  
{
	import cn.flashhawk.spp.particles.Particle;
	import cn.flashhawk.spp.particles.ParticlesSystem;
	import cn.flashhawk.spp.physics.Force;
	import cn.flashhawk.spp.physics.forces.SimpleBrownian;

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	/**
	 * @author flashhawk
	 */
	[SWF(backgroundColor="#000000", frameRate="30", width="800", height="600")]

	public class Line extends Sprite 
	{
		public var particleSystem : ParticlesSystem;
		public var canvas : Sprite;
		public var gravity : Force = new Force(0, 0.5);

		public function Line()
		{
			particleSystem = new ParticlesSystem(Particle);
			particleSystem.startRendering();
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(e : Event) : void
		{
			canvas = new Sprite();
			canvas.graphics.lineStyle(1, 0xffffff);
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, createFlow);
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			this.addChild(canvas);
			//addChild(new FPS());
		}

		private function onEnterFrame(event : Event) : void 
		{
			canvas.graphics.clear();
			canvas.graphics.lineStyle(4, 0xffffff);
			var prevMid : Point = null;
			for(var i : int = 1;i < particleSystem.particles.length;i++)
			{
				var pt1 : Object = {};
				var pt2 : Object = {};
				pt1.x = particleSystem.particles[i - 1].x;
				pt1.y = particleSystem.particles[i - 1].y;
				pt2.x = particleSystem.particles[i].x;
				pt2.y = particleSystem.particles[i].y;
				var midPoint : Point = new Point((pt1.x + pt2.x) / 2, (pt1.y + pt2.y) / 2);
				if(prevMid)
				{
					
					canvas.graphics.moveTo(prevMid.x, prevMid.y);
					canvas.graphics.curveTo(pt1.x, pt1.y, midPoint.x, midPoint.y);
				}
				else
				{
					canvas.graphics.moveTo(pt1.x, pt1.y);
					canvas.graphics.lineTo(midPoint.x, midPoint.y);
				}
				prevMid = midPoint;
			}
		}

		private function createFlow(event : MouseEvent) : void 
		{
			var brownianForce :SimpleBrownian = new SimpleBrownian(2);
			var p:Particle = particleSystem.createParticle();
			p.init(mouseX, mouseY, 0.5*stage.frameRate);
			p.addForce("brownianForce", brownianForce);
		}
	}
}
