package 
{
	import cn.flashhawk.spp.canvas.CanvasBMD;
	import cn.flashhawk.spp.particles.*;
	import cn.flashhawk.spp.physics.forces.Attraction;
	import cn.flashhawk.spp.physics.forces.Repulsion;
	import cn.flashhawk.spp.physics.forces.SimpleBrownian;
	import cn.flashhawk.spp.util.FPS;

	import flash.display.Bitmap;
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * @author flashhawk
	 */
	[SWF(backgroundColor="#000000", frameRate="30", width="1000", height="800")]

	public class Sand extends Sprite
	{
		public var sttractionPoint : Point;
		private var ps : ParticlesSystem;
		private var bound : Rectangle;
		private var canvase : Bitmap;
		private var bmd : CanvasBMD;
		private var isBrown : Boolean = false;
		private var scale : Number = 0.5;
		public function Sand()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(e : Event) : void
		{
			stageSetup();
			ps = new ParticlesSystem(BoundParticle);
			sttractionPoint = new Point();
			boom(10000);
			resizeHandler(null);
			ps.startRendering();
			this.addEventListener(Event.ENTER_FRAME, loop);
			addChild(new FPS());
		}

		private function stageSetup() : void
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.quality = StageQuality.LOW;
			stage.doubleClickEnabled = true;
			
			stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseHandler);
			stage.addEventListener(MouseEvent.DOUBLE_CLICK, mouseHandler);
			stage.addEventListener(Event.RESIZE, resizeHandler);
		}

		private function resizeHandler(e : Event) : void
		{
			if (bmd != null) bmd.dispose();
			if (canvase != null) removeChild(canvase);
			bmd = new CanvasBMD(stage.stageWidth * scale, stage.stageHeight * scale, false, 0);
			canvase = new Bitmap(bmd);
			canvase.blendMode=BlendMode.ADD;
			canvase.width = stage.stageWidth;
			canvase.height = stage.stageHeight;
			addChild(canvase);

			var i : int;
			i = ps.particles.length;
			bound = new Rectangle(0, 0, stage.stageWidth * scale, stage.stageHeight * scale);
			while (i-- > 0)
			{
				ps.particles[i].particleBound = bound;
			}
		}

		private function mouseHandler(event : MouseEvent) : void
		{
			var i : int;
			if (event.type == MouseEvent.MOUSE_DOWN)
			{
				i = ps.particles.length;
				while (i-- > 0)
				{
					ps.particles[i].removeForce("repulsionForce");
					var attractionForce : Attraction = new Attraction(sttractionPoint, 3, 0);
					ps.particles[i].addForce("attractionForce", attractionForce);
				}
			}
			else if (event.type == MouseEvent.MOUSE_UP)
			{
				i = ps.particles.length;
				while (i-- > 0)
				{
					ps.particles[i].removeForce("attractionForce");
					var repulsionForce : Repulsion = new Repulsion(sttractionPoint, 8, 100);
					ps.particles[i].addForce("repulsionForce", repulsionForce);
				}
			}
			else if (event.type == MouseEvent.DOUBLE_CLICK)
			{
				i = ps.particles.length;
				if (isBrown)
				{
					while (i-- > 0)
					{
						ps.particles[i].removeForce("brownian", true);
					}
					isBrown = false;
				}
				else
				{
					while (i-- > 0)
					{
						var brownForce:SimpleBrownian = new SimpleBrownian(1);
						ps.particles[i].addForce("brownian", brownForce);
					}
					isBrown = true;
				}
			}
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
			sttractionPoint.x = mouseX * scale;
			sttractionPoint.y = mouseY * scale;
			bmd.unlock();
			
			//bmd.filter = blurFilter;
			//bmd.colorOffset(-10, -10, -10, 0);
		}

		public function boom(count : int = 30) : void
		{
			bound = new Rectangle(0, 0, stage.stageWidth * scale, stage.stageHeight * scale);
			for (var i : int = 0;i < count;i++)
			{
				var fireParticle : BoundParticle = BoundParticle(ps.createParticle());
				fireParticle.bounceIntensity = 2;
				fireParticle.particleBound = bound;
				var repulsionForce : Repulsion = new Repulsion(sttractionPoint, 8, 100);
				fireParticle.addForce("repulsionForce", repulsionForce);
				fireParticle.init(stage.stageWidth * Math.random()*scale, stage.stageHeight * Math.random()*scale);
				
			}
		}
	}
}
