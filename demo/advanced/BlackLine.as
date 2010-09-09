package advanced 
{
	import cn.flashhawk.spp.ParticlesSystem;
	import cn.flashhawk.spp.PhysicsParticle;
	import cn.flashhawk.spp.physics.forces.BrownForce;

	import flash.display.Bitmap;
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	/**
	 * @author flashhawk
	 */
	[SWF(backgroundColor="#ffffff", frameRate="30", width="800", height="600")]

	public class BlackLine extends Sprite 
	{
		public var particleSystem : ParticlesSystem;
		public var lineCanvas : Sprite;
		private var blurBmd : CanvasBitmapData;
		private var blurBmp : Bitmap;
		private var logo : Logo;

		public function BlackLine()
		{
			particleSystem = new ParticlesSystem();
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(e : Event) : void
		{
			lineCanvas = new Sprite();
			lineCanvas.graphics.lineStyle(1, 0xffffff);
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, createFlow);
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(Event.RESIZE, initBitmapCanvas);
			initBitmapCanvas();
		}

		private function initBitmapCanvas(e : Event = null) : void
		{
			if(blurBmd != null)blurBmd.dispose();
			if(blurBmp != null)removeChild(blurBmp);
			blurBmd = new CanvasBitmapData(stage.stageWidth * 0.5, stage.stageHeight * 0.5, false, 0xffffff);
			
			blurBmp = new Bitmap(blurBmd);
			blurBmp.width = stage.stageWidth;
			blurBmp.height = stage.stageHeight;
			addChildAt(blurBmp, 0);
			
			
			if(logo == null)
			{
				logo = new Logo();
				logo.blendMode = BlendMode.OVERLAY;
				addChildAt(logo, 1);
			}
			logo.x = stage.stageWidth / 2;
			logo.y = stage.stageHeight / 2;
		}

		private function onEnterFrame(event : Event) : void 
		{
			lineCanvas.graphics.clear();
			lineCanvas.graphics.lineStyle(0, 0x333333);
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
					
					lineCanvas.graphics.moveTo(prevMid.x, prevMid.y);
					lineCanvas.graphics.curveTo(pt1.x, pt1.y, midPoint.x, midPoint.y);
				}
				else
				{
					lineCanvas.graphics.moveTo(pt1.x, pt1.y);
					lineCanvas.graphics.lineTo(midPoint.x, midPoint.y);
				}
				prevMid = midPoint;
			}
			
			blurBmd.draw(lineCanvas);
			blurBmd.blur(2, 2, 1);
			blurBmd.colorMod(+8, +8, +8, 0);
		}

		private function createFlow(event : MouseEvent) : void 
		{
			var brownForce : BrownForce = new BrownForce(1, 0.1);
			var p : PhysicsParticle = new PhysicsParticle(null, mouseX * 0.5, mouseY * 0.5, 30, 1);
			p.addForce("browForce", brownForce);
			p.startRendering();
			particleSystem.addParticle(p);
		}
	}
}
