package based 
{
	import cn.flashhawk.spp.ParticlesSystem;
	import cn.flashhawk.spp.PhysicsParticle;
	import cn.flashhawk.spp.physics.Force;
	import cn.flashhawk.spp.physics.forces.BrownForce;
	import cn.flashhawk.spp.util.FPS;

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	/**
	 * @author flashhawk
	 */
	 [SWF(backgroundColor="#000000", frameRate="30", width="800", height="600")]
	public class ColourfulLine extends Sprite 
	{
		public var particleSystem:ParticlesSystem;
		public var canvas:Sprite;
		public var gravity:Force=new Force(0,0.5);
		public function ColourfulLine()
		{
			particleSystem=new ParticlesSystem();
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void
		{
			canvas=new Sprite();
			canvas.graphics.lineStyle(1,0xffffff);
			
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
			canvas.graphics.lineStyle(4,0xffffff);
			var prevMid : Point = null;
			for(var i : int = 1;i < particleSystem.particles.length;i++)
			{
				trace(particleSystem.particles.length);
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
			
			//this.graphics.lineTo(pt2.x, pt2.y);
			
		}

		private function createFlow(event : MouseEvent) : void 
		{
			var brownForce:BrownForce=new BrownForce(2,2);
			var ball:Sprite=createBall(0xffffff,2);
			//addChild(ball);
			var p:PhysicsParticle=new PhysicsParticle(null, mouseX, mouseY,30,1);
			//p.addEventListener("dead", destroyBall);
			p.addForce("browForce", brownForce);
			//p.addForce("gravity", gravity);
			p.startRendering();
			particleSystem.addParticle(p);
		}
		private function destroyBall(e:Event):void
		{
			var p:PhysicsParticle=PhysicsParticle(e.target);
			var ball:Sprite=Sprite(p.target);
			this.removeChild(ball);
			p.removeEventListener("dead", destroyBall);
			
		}
		private function createBall(color : uint,r : Number) : Sprite
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
