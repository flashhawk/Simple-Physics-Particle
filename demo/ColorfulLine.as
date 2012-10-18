package
{
	import cn.flashhawk.spp.canvas.CanvasBMD;
	import cn.flashhawk.spp.particles.*;
	import cn.flashhawk.spp.physics.forces.Brownian;
	import cn.flashhawk.spp.util.FPS;

	import flash.display.Bitmap;
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.geom.Point;

	/**
	 * @author flashhawk
	 */
	[SWF(backgroundColor="#000000", frameRate="30", width="800", height="600")]
	public class ColorfulLine extends Sprite
	{
		public var particleSystem : ParticlesSystem;
		public var lineCanvas : Sprite;
		private var blurBmd : CanvasBMD;
		private var blurBmp : Bitmap;
		private var canvaseScale : Number = 0.5;
		private var r : Number = 255;
		private var g : Number = 127;
		private var b : Number = 0;
		private var ri : Number = 0.02;
		private var gi : Number = 0.015;
		private var bi : Number = 0.025;
		[Embed(source="assets/logo.png")]
		public var  LogoPic : Class;
		public var logo : Bitmap;
		private var blurFilter : BlurFilter = new BlurFilter(2, 2, 1);

		public function ColorfulLine()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(e : Event) : void
		{
			setStage();
			lineCanvas = new Sprite();
			initBitmapCanvas();
			ParticlesSystem.STAGE=stage;
			particleSystem = new ParticlesSystem(loop);
			particleSystem.startRendering();
			//addChild(new FPS());
		}

		private function setStage() : void
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(MouseEvent.MOUSE_MOVE, createFlow);
			stage.addEventListener(Event.RESIZE, initBitmapCanvas);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
		}

		private function keyDownHandler(event : KeyboardEvent) : void
		{
			if (event.keyCode == 70)
				stage.displayState = StageDisplayState.FULL_SCREEN;
		}

		private function initBitmapCanvas(e : Event = null) : void
		{
			if (blurBmd != null) blurBmd.dispose();
			if (blurBmp != null) removeChild(blurBmp);
			blurBmd = new CanvasBMD(stage.stageWidth * canvaseScale, stage.stageHeight * canvaseScale);
			blurBmp = new Bitmap(blurBmd);
			blurBmp.width = stage.stageWidth;
			blurBmp.height = stage.stageHeight;
			addChildAt(blurBmp, 0);

			if (logo == null)
			{
				logo = new LogoPic();
				logo.blendMode = BlendMode.OVERLAY;
				addChildAt(logo, 1);
			}
			logo.x = (stage.stageWidth - logo.width) / 2;
			logo.y = (stage.stageHeight - logo.height) / 2;
		}

		private function loop() : void
		{
			var color : uint = (Math.sin(r += ri) * 128 + 127) << 16 | (Math.sin(g += gi) * 128 + 127) << 8 | (Math.sin(b += bi) * 128 + 127) ;
			lineCanvas.graphics.clear();
			lineCanvas.graphics.lineStyle(1.5, color);
			var prevMid : Point = null;

			var i : int = particleSystem.particles.length;
			while (i-- > 1)
			{
				var pt1 : Object = {};
				var pt2 : Object = {};
				pt1.x = particleSystem.particles[i].position.x;
				pt1.y = particleSystem.particles[i].position.y;
				pt2.x = particleSystem.particles[i - 1].position.x;
				pt2.y = particleSystem.particles[i - 1].position.y;
				var midPoint : Point = new Point((pt1.x + pt2.x) / 2, (pt1.y + pt2.y) / 2);
				if (prevMid)
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
				trace(i);
			}
			blurBmd.draw(lineCanvas, null, null, BlendMode.ADD);
			blurBmd.filter = blurFilter;
			blurBmd.colorOffset(-5, -5, -5, 0);
		}

		private function createFlow(e : Event) : void
		{
			var brownianForce : Brownian = new Brownian(0.4,0.1);
			var p : Particle = particleSystem.createParticle(Particle);
			p.init(mouseX * canvaseScale, mouseY * canvaseScale, 0.8);
			p.addForce("brownianForce", brownianForce);
		}
	}
}
