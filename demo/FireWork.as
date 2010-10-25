package 
{
	import cn.flashhawk.spp.canvas.CanvasBMD;
	import cn.flashhawk.spp.events.ParticleEvent;
	import cn.flashhawk.spp.particles.Particle;
	import cn.flashhawk.spp.particles.ParticlesSystem;
	import cn.flashhawk.spp.physics.Force;
	import cn.flashhawk.spp.util.FPS;

	import flash.display.Bitmap;
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	/**
	 * @author flashhawk
	 */
	[SWF(backgroundColor="#000000", frameRate="30", width="800", height="600")]

	public class FireWork extends Sprite
	{
		private var gravity : Force = new Force(0, 0.1);
		private var canvasBmd : CanvasBMD;
		private var canvas : Bitmap;
		private var blurBmd : CanvasBMD;
		private var blurBmp : Bitmap;
		private var postBmd : CanvasBMD;
		private var postCanvas : Bitmap;
		private var matrix : Matrix = new Matrix();
		private var ps : ParticlesSystem = new ParticlesSystem(Particle);

		[Embed(source="assets/logo.png")]
		public var  LogoPic : Class;
		public var logo : Bitmap;

		private var l : int;
		private var blurFilter : BlurFilter = new BlurFilter(2, 2, 1);

		public function FireWork()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(e : Event) : void
		{
			matrix.scale(0.1, 0.1);
			setStage();
			initCanvas();
			addChild(new FPS());
			ps.startRendering();
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		private function setStage() : void
		{
			stage.quality = StageQuality.MEDIUM;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(MouseEvent.CLICK, fire);
			stage.addEventListener(Event.RESIZE, initCanvas);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
		}

		private function keyDownHandler(event : KeyboardEvent) : void
		{
			if (event.keyCode == 70)
				stage.displayState = StageDisplayState.FULL_SCREEN;
		}

		private function initCanvas(e : Event = null) : void
		{
			if (canvasBmd != null) canvasBmd.dispose();
			if (canvas != null) removeChild(canvas);
			canvasBmd = new CanvasBMD(stage.stageWidth * 0.5, stage.stageHeight * 0.5);
			canvas = new Bitmap(canvasBmd);
			canvas.width = stage.stageWidth;
			canvas.height = stage.stageHeight;
			addChildAt(canvas, 0);

			if (blurBmd != null) blurBmd.dispose();
			if (blurBmp != null) removeChild(blurBmp);
			blurBmd = new CanvasBMD(stage.stageWidth * 0.5, stage.stageHeight * 0.5);
			blurBmp = new Bitmap(blurBmd);
			blurBmp.width = stage.stageWidth;
			blurBmp.height = stage.stageHeight;
			addChildAt(blurBmp, 1);

			if (postBmd != null) postBmd.dispose();
			if (postCanvas != null) removeChild(postCanvas);
			postBmd = new CanvasBMD(stage.stageWidth * 0.05, stage.stageHeight * 0.05);
			postCanvas = new Bitmap(postBmd, "auto", true);
			postCanvas.width = stage.stageWidth;
			postCanvas.height = stage.stageHeight;
			postCanvas.blendMode = BlendMode.ADD;

			addChildAt(postCanvas, 2);
			
			if (logo == null)
			{
				logo = new LogoPic();
				logo.blendMode = BlendMode.OVERLAY;
				addChildAt(logo, 3);
			}
			logo.x = (stage.stageWidth - logo.width) / 2;
			logo.y = (stage.stageHeight - logo.height) / 2;
		}

		private function onEnterFrame(event : Event) : void
		{
			canvasBmd.clear();
			l = ps.particles.length;

			while (l-- > 0)
			{
				if (ps.particles[l].extra.isFire)
				{
					canvasBmd.fillRect(new Rectangle(ps.particles[l].x, ps.particles[l].y, 4, 4), ps.particles[l].extra.color);
				}
				else
				{
					canvasBmd.fillRect(new Rectangle(ps.particles[l].x, ps.particles[l].y, 3, 3), ps.particles[l].extra.color);
				}
			}

			blurBmd.draw(canvas, null, null, BlendMode.ADD);
			blurBmd.filter = blurFilter;
			blurBmd.colorOffset(-5, -5, -5, 0);
			postBmd.draw(blurBmp, matrix);
		}

		private function fire(e : MouseEvent) : void
		{
			var fireParticle : Particle = ps.createParticle();
			fireParticle.init(canvasBmd.width / 2, canvasBmd.height, 1.5 * stage.frameRate);
			fireParticle.extra = {color:Math.random() * 0xffffff, isFire:true};
			fireParticle.v.reset(0, -(5 + Math.random() * 3));
			fireParticle.v.rotate(15 - Math.random() * 30);
			fireParticle.f.reset(0.001, 0.001);
			fireParticle.addEventListener(ParticleEvent.DEAD, destory);
			fireParticle.addEventListener(ParticleEvent.DEAD, boom);
		}

		private function destory(e : Event) : void
		{
			var p : Particle = Particle(e.target);
			p.removeEventListener(ParticleEvent.DEAD, destory);
			p.removeEventListener(ParticleEvent.DEAD, boom);
		}

		private function boom(e : Event) : void
		{
			var fireNum : int = int(Math.random() * 200 + 100);
			while (fireNum-- > 0)
			{
				var fireParticle : Particle = ps.createParticle();
				fireParticle.init(e.target.position.x, e.target.position.y, 2 * stage.frameRate);
				fireParticle.extra = {color:e.target.extra.color, isFire:false};
				fireParticle.v.reset(0, 1 + Math.random() * 16);
				fireParticle.v.rotate(Math.random() * 360);
				fireParticle.f.reset(0.1, 0.1);
				fireParticle.addForce("g", gravity);
			}
			fireNum = NaN;
		}
	}
}
