package  
{
	
	import cn.flashhawk.spp.canvas.CanvasBMD;
	import cn.flashhawk.spp.particles.*;
	import cn.flashhawk.spp.physics.Force;
	import cn.flashhawk.spp.physics.forces.SimpleBrownian;
	import cn.flashhawk.spp.util.FPS;

	import flash.display.Bitmap;
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.setInterval;

	/**
	 * @author flashhawk
	 */
	[SWF(backgroundColor="#000000", frameRate="30", width="800", height="600")]

	public class Torch extends Sprite 
	{
		private var canvasBmd : CanvasBMD;
		private var canvas : Bitmap;

		private var blurBmd : CanvasBMD;
		private var blurBmp : Bitmap;

		private var postBmd : CanvasBMD;
		private var postCanvas : Bitmap;
		private var particles : Array = [];

		private var matrix : Matrix;
		private var particleSystem : ParticlesSystem;
		public var sttractionPoint : Point = new Point();

		[Embed(source="assets/logo.png")]
		public var  LogoPic : Class;
		public var logo : Bitmap;
		private var fireColor : uint = 0xff6600;
		private var blurFilter : BlurFilter = new BlurFilter(2, 2, 1);

		//private var brownForce:TorchBrownian = new TorchBrownian(2);
		public function Torch()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		private function init(e:Event):void
		{
			setStage();
			ParticlesSystem.STAGE=stage;
			particleSystem=new ParticlesSystem(loop);
			initCanvas();
			var id : Number = setInterval(boom, 0);
			particleSystem.startRendering();
			addChild(new FPS());
		}
		private function setStage() : void
		{
			stage.quality = StageQuality.MEDIUM;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addEventListener(Event.RESIZE, initCanvas);
		}

		private function initCanvas(e : Event = null) : void
		{
			if(canvasBmd != null)canvasBmd.dispose();
			if(canvas != null)removeChild(canvas);
			canvasBmd = new CanvasBMD(stage.stageWidth * 0.5, stage.stageHeight * 0.5);
			canvas = new Bitmap(canvasBmd);
			canvas.width = stage.stageWidth;
			canvas.height = stage.stageHeight;
			addChildAt(canvas, 0);

			if(blurBmd != null)blurBmd.dispose();
			if(blurBmp != null)removeChild(blurBmp);
			blurBmd = new CanvasBMD(stage.stageWidth * 0.5, stage.stageHeight * 0.5);
			blurBmp = new Bitmap(blurBmd);
			blurBmp.width = stage.stageWidth;
			blurBmp.height = stage.stageHeight;
			addChildAt(blurBmp, 1);
			
			if(postBmd != null)postBmd.dispose();
			if(postCanvas != null)removeChild(postCanvas);
			postBmd = new CanvasBMD(stage.stageWidth * 0.05, stage.stageHeight * 0.05);
			postCanvas = new Bitmap(postBmd, "auto", true);
			postCanvas.width = stage.stageWidth;
			postCanvas.height = stage.stageHeight;
			postCanvas.blendMode = BlendMode.ADD;
		
			
			addChildAt(postCanvas, 2);
			
			matrix = new Matrix();
			matrix.scale(0.1, 0.1);
			
			particles = particleSystem.particles;
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
			particles = particleSystem.particles;
			var l : int = particles.length;
			while(l-- > 0)
			{
				canvasBmd.fillRect(new Rectangle(particles[l].position.x, particles[l].position.y, Math.random() * 5 + 3, Math.random() * 5 + 3), fireColor);
			}
			blurBmd.draw(canvas, null, null, BlendMode.ADD);
			blurBmd.filter = blurFilter;
			blurBmd.colorOffset(-30, -30, -30, 0);
			postBmd.draw(blurBmp, matrix);	
		}

		private function boom() : void
		{
			var x_d : Number = (0.5 - Math.random()) * 15;
			var y_d : Number = -Math.random() * 5 - 10;
			var fireParticle : Particle = particleSystem.createParticle(Particle);
			fireParticle.init(mouseX * 0.5 + x_d, mouseY * 0.5 + y_d, 1);
			fireParticle.friction.reset(0.2, 0.2);
			
			var upForce : Force = new Force(0, -1);
			 var brownForce:SimpleBrownian = new SimpleBrownian(1.5);
			fireParticle.addForce("brownForce", brownForce);
			fireParticle.addForce("upForce", upForce);
		}
	}
}
