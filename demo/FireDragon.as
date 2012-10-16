package  
{
	import flash.display.BitmapData;
	import cn.flashhawk.spp.canvas.CanvasBMD;
	import cn.flashhawk.spp.particles.*;
	import cn.flashhawk.spp.physics.forces.Attraction;
	import cn.flashhawk.spp.physics.forces.Brownian;

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

	/**
	 * @author flashhawk
	 */
	[SWF(backgroundColor="#000000", frameRate="30", width="800", height="600")]

	public class FireDragon extends Sprite 
	{

		private var r : Number = 255; 
		private var g : Number = 127; 
		private var b : Number = 0; 

		private var ri : Number = 0.02;
		private var gi : Number = 0.015; 
		private var bi : Number = 0.025; 

		private var canvasBmd : CanvasBMD;
		private var canvas : Bitmap;

		private var blurBmd:CanvasBMD;
		private var blurBmp : Bitmap;

		private var postBmd : BitmapData;
		private var postCanvas : Bitmap;
		private var matrix : Matrix;
		private var ps : ParticlesSystem;
		public var sttractionPoint : Point = new Point();

		[Embed(source="assets/logo.png")]
		public var  LogoPic : Class;
		public var logo : Bitmap;
		private var blurFilter : BlurFilter = new BlurFilter(2, 2, 1);
		private var l : int;

		public function FireDragon()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void
		{
			setStage();
			initCanvas();
			
			ps=new ParticlesSystem(stage,null,loop);
			boom();
			ps.startRendering();
			stage.addEventListener(Event.RESIZE, initCanvas);
		}
		private function setStage() : void
		{
			stage.quality = StageQuality.MEDIUM;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
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
		
			matrix = new Matrix();
			matrix.scale(0.1, 0.1);
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
			canvasBmd.lock();
			canvasBmd.clear();
			var color : uint = (Math.sin(r += ri) * 128 + 127) << 16 | (Math.sin(g += gi) * 128 + 127) << 8 | (Math.sin(b += bi) * 128 + 127) ;
			l = ps.particles.length;
			while (l-- > 0)
			{
				canvasBmd.fillRect(new Rectangle(ps.particles[l].position.x, ps.particles[l].position.y, 3, 3), color);
			}
			blurBmd.draw(canvas, null, null, BlendMode.ADD);
			blurBmd.filter = blurFilter;
			blurBmd.colorOffset(-5, -5, -5, 0);
			postBmd.draw(blurBmp, matrix);
			
			sttractionPoint.x = mouseX * 0.5;
			sttractionPoint.y = mouseY * 0.5;
			canvasBmd.unlock();
		}

		private function boom() : void
		{
			for(var i : int = 300;i > 0;i--)
			{
				var fireParticle : Particle = ps.createParticle(Particle);
				fireParticle.init(canvasBmd.width / 2, canvasBmd.height / 2);
				var brownForce : Brownian = new Brownian(1.5,0.01);
				fireParticle.addForce("brownForce", brownForce);
				var attractionForce : Attraction = new Attraction(sttractionPoint, 4, 2);
				fireParticle.addForce("attractionForce", attractionForce);
				
			}
		}
	}
}
