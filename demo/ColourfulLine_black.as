package 
{
	import cn.flashhawk.spp.canvas.CanvasBMD;
	import cn.flashhawk.spp.particles.*;
	import cn.flashhawk.spp.physics.forces.SimpleBrownian;
	import cn.flashhawk.spp.util.FPS;

	import flash.display.Bitmap;
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
	[SWF(backgroundColor="#ffffff", frameRate="30", width="800", height="600")]
	public class ColourfulLine_black extends Sprite
	{
		public var particleSystem : ParticlesSystem=new ParticlesSystem(Particle);
		public var lineCanvas : Sprite;
		private var blurBmd:CanvasBMD;
		private var blurBmp : Bitmap;
		private var canvaseScale:Number=0.5;
		private var blurFilter:BlurFilter=new BlurFilter(2,2,1);
		
	
		public function ColourfulLine_black()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(e : Event) : void
		{
			setStage();
			lineCanvas = new Sprite();
			initBitmapCanvas();
			particleSystem.startRendering();
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			addChild(new FPS());
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
			blurBmd = new CanvasBMD(stage.stageWidth * canvaseScale, stage.stageHeight * canvaseScale,false,0xffffff);
			blurBmp = new Bitmap(blurBmd);
			blurBmp.width = stage.stageWidth;
			blurBmp.height = stage.stageHeight;
			addChildAt(blurBmp, 0);

			
		}

		private function onEnterFrame(event : Event) : void
		{
			lineCanvas.graphics.clear();
			lineCanvas.graphics.lineStyle(2, 0x888888);
			var prevMid : Point = null;
			for (var i : int = 1;i < particleSystem.particles.length;i++)
			{
				var pt1 : Object = {};
				var pt2 : Object = {};
				pt1.x = particleSystem.particles[i - 1].x;
				pt1.y = particleSystem.particles[i - 1].y;
				pt2.x = particleSystem.particles[i].x;
				pt2.y = particleSystem.particles[i].y;
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
			}
			blurBmd.draw(lineCanvas);
			blurBmd.filter = blurFilter;
			blurBmd.colorOffset(+5, +5, +5, 0);
		}

		private function createFlow(e:Event) : void
		{
			var brownianForce :SimpleBrownian = new SimpleBrownian(1);
			var p : Particle = particleSystem.createParticle();
			p.init(mouseX * canvaseScale, mouseY * canvaseScale, 1 * stage.frameRate);
			p.addForce("brownianForce", brownianForce);
		}
	}
}
