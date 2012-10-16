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
		private var ps : ParticlesSystem;

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
			ps=new ParticlesSystem(stage,null,loop);
			initCanvas();
			addChild(new FPS());
			ps.startRendering();
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

		private function loop() : void
		{
			canvasBmd.clear();
			l = ps.particles.length;

			while (l-- > 0)
			{
				var p=ps.particles[l];
				if (ps.particles[l].extra.isFire)
				{
					canvasBmd.fillRect(new Rectangle(p.position.x, p.position.y, 4, 4), p.extra.color);
				}
				else
				{
					canvasBmd.fillRect(new Rectangle(p.position.x, p.position.y, 3, 3), ps.particles[l].extra.color);
				}
			}

			blurBmd.draw(canvas, null, null, BlendMode.ADD);
			blurBmd.filter = blurFilter;
			blurBmd.colorOffset(-5, -5, -5, 0);
			postBmd.draw(blurBmp, matrix);
		}

		private function fire(e : MouseEvent) : void
		{
			var fireParticle : Particle = ps.createParticle(Particle);
			fireParticle.init(canvasBmd.width / 2, canvasBmd.height, 2.6);
			fireParticle.extra = {color:Math.random() * 0xffffff, isFire:true};
			fireParticle.velocity.reset(0, -(6.5 + Math.random() * 4));
			fireParticle.velocity.rotate(15 - Math.random() * 30);
			fireParticle.friction.reset(0, 0);
			fireParticle.addForce("g", gravity);
			fireParticle.addEventListener(ParticleEvent.DEAD, boom);
		}

		private function boom(e : Event) : void
		{
			
			Particle(e.target).removeEventListener(ParticleEvent.DEAD, boom);
			var fireNum : int = int(Math.random() * 100 + 200);
			while (fireNum-- > 0)
			{
				var fireParticle : Particle = ps.createParticle(Particle);
				fireParticle.init(e.target.position.x, e.target.position.y, 1.5);
				fireParticle.extra = {color:e.target.extra.color, isFire:false,size:0.5};
				fireParticle.velocity.reset(0, 8+Math.random()*8);
				fireParticle.velocity.rotate(Math.random() * 360);
				fireParticle.friction.reset(0.1, 0.1);
				fireParticle.addForce("g", gravity);
			}
			fireNum = NaN;
		}
		
	}
}
