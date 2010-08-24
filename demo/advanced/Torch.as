package  advanced
{
	import cn.flashhawk.spp.ParticlesSystem;
	import cn.flashhawk.spp.PhysicsParticle;
	import cn.flashhawk.spp.geom.Vector2D;
	import cn.flashhawk.spp.physics.Force;
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

	import flash.utils.setInterval;

	/**
	 * @author flashhawk
	 */
	[SWF(backgroundColor="#000000", frameRate="30", width="800", height="600")]

	public class Torch extends Sprite 
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
		public var sttractionPoint:Point=new Point();
		private var logo:Logo;

		
		public function Torch()
		{
			setStage();
			initCanvas();
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(Event.RESIZE, initCanvas);
			var id2:Number=setInterval(boom, 20);
			var id2:Number=setInterval(boom, 10);
			//addChild(new FPS());
			
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
			postCanvas = new Bitmap(postBmd,"auto",true);
			postCanvas.width = stage.stageWidth;
			postCanvas.height = stage.stageHeight;
			postCanvas.blendMode = BlendMode.ADD;
		
			
			addChildAt(postCanvas, 2);
			
			matrix = new Matrix();
			matrix.scale(0.1, 0.1);
			
			particles=particleSystem.particles;
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
			particles = particleSystem.particles;
			
			//var color:uint=(Math.sin(r += ri) * 128 + 127) << 16  |  (Math.sin(g += gi) * 128 + 127) << 8  |  (Math.sin(b += bi) * 128 + 127) ;
			var color:uint=16415262;
			
			for(var i : int = particles.length;i > 0;i--)
			{
				canvasBmd.fillRect(new Rectangle(particles[i - 1].x, particles[i - 1].y, Math.random()*9, Math.random()*9), color);
			}
			blurBmd.draw(canvas, null, null, BlendMode.ADD);
			blurBmd.blur(4, 4, 1);
			blurBmd.colorMod(-30, -30, -30, 0);
			postBmd.draw(blurBmp, matrix);
			
			
		}
		private function boom(e:Event=null) : void
		{
			    var randomDis:Number=Math.random()*15-8;
				var fireParticle :PhysicsParticle = new PhysicsParticle(null, mouseX * 0.5 + randomDis, mouseY*0.5-10,30,1);
				fireParticle.f=new Vector2D(0.2,0.2);
				var brownForce : BrownForce = new BrownForce(2,1);
				 
				var upForce:Force=new Force(0, -1.2);
				fireParticle.addForce("brownForce", brownForce);
				fireParticle.addForce("upForce", upForce);
				particleSystem.addParticle(fireParticle);
				fireParticle.startRendering();
			}
		}
	
}
