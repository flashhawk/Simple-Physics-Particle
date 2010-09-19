package  advanced
{
	import cn.flashhawk.spp.events.ParticleEvent;
	import cn.flashhawk.spp.geom.Vector2D;
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
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	/**
	 * @author flashhawk
	 */
	[SWF(backgroundColor="#000000", frameRate="30", width="800", height="600")]

	public class FireWork extends Sprite 
	{
		private var gravity : Force = new Force(0, 0.1);
		private var canvasBmd : CanvasBitmapData;
		private var canvas : Bitmap;

		private var blurBmd : CanvasBitmapData;
		private var blurBmp : Bitmap;

		private var postBmd : CanvasBitmapData;
		private var postCanvas : Bitmap;
		private var particles : Array = [];

		private var matrix : Matrix;
		private var particleSystem : ParticlesSystem = new ParticlesSystem();

		private var logo : Logo;

		private var l : int;
		private var frameRate : int = 30;
		private var v_array = [10,13,16];

		public function FireWork()
		{
			setStage();
			initCanvas();
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(Event.RESIZE, initCanvas);
			addChild(new FPS());
			particleSystem.startRendering();
		}

		private function setStage() : void
		{
			stage.quality = StageQuality.MEDIUM;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(MouseEvent.CLICK, fire);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
		}

		private function keyDownHandler(event : KeyboardEvent) : void 
		{
			if(event.keyCode == 70)
			stage.displayState = StageDisplayState.FULL_SCREEN;
		}

		private function initCanvas(e : Event = null) : void
		{
			if(canvasBmd != null)canvasBmd.dispose();
			if(canvas != null)removeChild(canvas);
			canvasBmd = new CanvasBitmapData(stage.stageWidth * 0.5, stage.stageHeight * 0.5);
			canvas = new Bitmap(canvasBmd);
			canvas.width = stage.stageWidth;
			canvas.height = stage.stageHeight;
			addChildAt(canvas, 0);

			if(blurBmd != null)blurBmd.dispose();
			if(blurBmp != null)removeChild(blurBmp);
			blurBmd = new CanvasBitmapData(stage.stageWidth * 0.5, stage.stageHeight * 0.5);
			blurBmp = new Bitmap(blurBmd);
			blurBmp.width = stage.stageWidth;
			blurBmp.height = stage.stageHeight;
			addChildAt(blurBmp, 1);
			
			if(postBmd != null)postBmd.dispose();
			if(postCanvas != null)removeChild(postCanvas);
			postBmd = new CanvasBitmapData(stage.stageWidth * 0.05, stage.stageHeight * 0.05);
			postCanvas = new Bitmap(postBmd, "auto", true);
			postCanvas.width = stage.stageWidth;
			postCanvas.height = stage.stageHeight;
			postCanvas.blendMode = BlendMode.ADD;
			
			addChildAt(postCanvas, 2);
			
			matrix = new Matrix();
			matrix.scale(0.1, 0.1);
			if(logo == null)
			{
				logo = new Logo();
				logo.blendMode = BlendMode.OVERLAY;
				addChildAt(logo, 3);
			}
			logo.x = stage.stageWidth / 2;
			logo.y = stage.stageHeight / 2;
		}

		private function onEnterFrame(event : Event) : void 
		{
			canvasBmd.clear();
			particles = particleSystem.particles;
			l = particles.length;
			
			
			while(l-- > 0)
			{
				if(particles[l].extra.isFire)
				{
					canvasBmd.fillRect(new Rectangle(particles[l].x, particles[l].y, 4, 4), particles[l].extra.color);
				}
				else
				{
					canvasBmd.fillRect(new Rectangle(particles[l].x, particles[l].y, 3, 3), particles[l].extra.color);
				}
			}
		
			blurBmd.draw(canvas, null, null, BlendMode.ADD);
			blurBmd.blur(2, 2, 1);
			blurBmd.colorMod(-5, -5, -5, 0);
			postBmd.draw(blurBmp, matrix);
		}

		private function fire(e : MouseEvent) : void
		{
			
			var fireParticle : Particle = particleSystem.createParticle(canvasBmd.width / 2, canvasBmd.height, 1.5 * frameRate);
			fireParticle.extra = {color:Math.random() * 0xffffff, isFire:true};
			fireParticle.v = new Vector2D(Math.random() * 4 - 2, -(5 + Math.random() * 3));
			fireParticle.f = new Vector2D(0.001, 0.001);
			fireParticle.addEventListener(ParticleEvent.DEAD, destory);
			fireParticle.addEventListener(ParticleEvent.DEAD, boom);
			trace(particleSystem.particlePool.array.length);
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
			while(fireNum-- > 0)
			{
				var fireParticle : Particle = particleSystem.createParticle(e.target.position.x, e.target.position.y, 2 * frameRate);
				fireParticle.extra = {color:e.target.extra.color, isFire:false};
				fireParticle.v = new Vector2D(0, 1 + Math.random() * 16);
				fireParticle.v.rotate(Math.random() * 360);
				fireParticle.f = new Vector2D(0.1, 0.1);
				fireParticle.addForce("g", gravity);
			}
			fireNum = NaN;
		}
	}
}
