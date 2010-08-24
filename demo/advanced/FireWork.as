package  advanced
{
	import cn.flashhawk.spp.ParticlesSystem;
	import cn.flashhawk.spp.PhysicsParticle;
	import cn.flashhawk.spp.geom.Vector2D;
	import cn.flashhawk.spp.physics.Force;
	import cn.flashhawk.spp.util.FPS;

	import flash.display.Bitmap;
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
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
		private var particleSystem:ParticlesSystem=new ParticlesSystem();
		
		private var logo:Logo;
	
		public function FireWork()
		{
			setStage();
			initCanvas();
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(Event.RESIZE, initCanvas);
			addChild(new FPS());
		}

		private function setStage() : void
		{
			stage.quality = StageQuality.MEDIUM;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(MouseEvent.CLICK, fire);
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
			if(logo==null)
			{
				logo=new Logo();
				logo.blendMode=BlendMode.OVERLAY;
				addChildAt(logo, 3);
			}
			logo.x=stage.stageWidth/2;
			logo.y=stage.stageHeight/2;
		}

		private function onEnterFrame(event : Event) : void 
		{
			canvasBmd.clear();
			particles=particleSystem.particles;
			for(var i : int =particles.length;i > 0;i--)
			{
				if(particles[i - 1].extra.isFire)
				{
					canvasBmd.fillRect(new Rectangle(particles[i - 1].x, particles[i - 1].y, 4, 4), particles[i - 1].extra.color);
				}
				else
				{
					canvasBmd.fillRect(new Rectangle(particles[i - 1].x, particles[i - 1].y, 3, 3), particles[i - 1].extra.color);
				}
			}
			blurBmd.draw(canvas, null, null, BlendMode.ADD);
			blurBmd.blur(2, 2, 1);
			blurBmd.colorMod(-5, -5, -5, 0);
			postBmd.draw(blurBmp, matrix);
			
		}

		private function fire(e : MouseEvent) : void
		{
			var fireParticle :PhysicsParticle= new PhysicsParticle(null, canvasBmd.width / 2, canvasBmd.height, 30, 1.5);
			fireParticle.extra = {color:Math.random() * 0xffffff, isFire:true};
			particleSystem.addParticle(fireParticle);
			fireParticle.v = new Vector2D(Math.random() * 4 - 2, -(5+Math.random()*3));
			fireParticle.f = new Vector2D(0.001, 0.001);
			fireParticle.addEventListener('dead', destory);
			fireParticle.addEventListener('dead', boom);
			fireParticle.startRendering();
		}

		private function destory(e : Event) : void 
		{
			var p : PhysicsParticle = PhysicsParticle(e.target);
			p.removeEventListener("dead", destory);
			p.removeEventListener("dead", boom);
			p = null;
		}

		private function boom(e : Event) : void
		{
			var fireNum : int = int(Math.random() * 200 + 100);
			for(var i : int = fireNum;i > 0;i--)
			{
				var fireParticle : PhysicsParticle = new PhysicsParticle(null, e.target.position.x, e.target.position.y, 30, 2);
				fireParticle.extra = {color:e.target.extra.color, isFire:false};
				
				fireParticle.v = new Vector2D(0, 1 + Math.random() * 16);
				fireParticle.v.rotate(Math.random() * 360);
				fireParticle.f = new Vector2D(0.1, 0.1);
				fireParticle.addForce("g", gravity);
				particleSystem.addParticle(fireParticle);
				fireParticle.addEventListener("dead", destory);
				fireParticle.startRendering();
			}
			fireNum = NaN;
		}
	}
}
