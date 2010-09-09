package  advanced
{
	import cn.flashhawk.spp.ParticlesSystem;
	import cn.flashhawk.spp.PhysicsParticle;
	import cn.flashhawk.spp.physics.forces.AttractionForce;
	import cn.flashhawk.spp.physics.forces.BrownForce;

	import flash.display.Bitmap;
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * @author flashhawk
	 */
	[SWF(backgroundColor="#ffffff", frameRate="30", width="800", height="600")]

	public class BlackDragon extends Sprite 
	{

		private var r : Number = 255; 
		private var g : Number = 127; 
		private var b : Number = 0; 

		private var ri : Number = 0.02;
		private var gi : Number = 0.015; 
		private var bi : Number = 0.025; 

		private var canvasBmd : CanvasBitmapData;
		private var canvas : Bitmap;

		private var blurBmd : CanvasBitmapData;
		private var blurBmp : Bitmap;

		private var postBmd : CanvasBitmapData;
		private var postCanvas : Bitmap;
		private var particles : Array = [];

		private var matrix : Matrix;
		private var particleSystem : ParticlesSystem = new ParticlesSystem();
		public var sttractionPoint : Point = new Point();
		private var logo:Logo;

		public function BlackDragon()
		{
			setStage();
			initCanvas();
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			boom();
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
			canvasBmd = new CanvasBitmapData(stage.stageWidth * 0.5, stage.stageHeight * 0.5,false,0xffffff);
			canvas = new Bitmap(canvasBmd);
			canvas.width = stage.stageWidth;
			canvas.height = stage.stageHeight;
			addChildAt(canvas, 0);

			if(blurBmd != null)blurBmd.dispose();
			if(blurBmp != null)removeChild(blurBmp);
			blurBmd = new CanvasBitmapData(stage.stageWidth * 0.5, stage.stageHeight * 0.5,false,0xffffff);
			blurBmp = new Bitmap(blurBmd);
			blurBmp.width = stage.stageWidth;
			blurBmp.height = stage.stageHeight;
			//addChildAt(blurBmp, 0);
			
			
			matrix = new Matrix();
			matrix.scale(0.1, 0.1);
			
			particles = particleSystem.particles;
			
			if(logo==null)
			{
				logo=new Logo();
				logo.blendMode=BlendMode.OVERLAY;
				addChildAt(logo, 1);
			}
			logo.x=stage.stageWidth/2;
			logo.y=stage.stageHeight/2;
		}

		private function onEnterFrame(event : Event) : void 
		{
			//canvasBmd.clear();
			particles = particleSystem.particles;
			
			var color : uint = (Math.sin(r += ri) * 128 + 127) << 16 | (Math.sin(g += gi) * 128 + 127) << 8 | (Math.sin(b += bi) * 128 + 127) ;
			for(var i : int = particles.length;i > 0;i--)
			{
				canvasBmd.fillRect(new Rectangle(particles[i - 1].x, particles[i - 1].y, 5+Math.random()*5, 5+Math.random()*5), 0x000000);
			}
			
			canvasBmd.blur(2, 2, 1);
			canvasBmd.colorMod(+5, +5, +5, 0);
			//postBmd.draw(blurBmp, matrix);
			
			sttractionPoint.x = mouseX * 0.5;
			sttractionPoint.y = mouseY * 0.5;
		}

		private function boom() : void
		{
	
			for(var i : int = 250;i > 0;i--)
			{

				var fireParticle : PhysicsParticle = new PhysicsParticle(null, canvasBmd.width / 2, canvasBmd.height / 2);
				var brownForce : BrownForce = new BrownForce(1, 1);
				fireParticle.addForce("brownForce", brownForce);
				var attractionForce : AttractionForce = new AttractionForce(sttractionPoint, 4, 0);
				fireParticle.addForce("attractionForce", attractionForce);
				particleSystem.addParticle(fireParticle);
				fireParticle.startRendering();
			}
		}
	}
}
