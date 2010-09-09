package advanced
{
	import flash.display.StageDisplayState;

	import cn.flashhawk.spp.ParticlesSystem;
	import cn.flashhawk.spp.PhysicsParticle;
	import cn.flashhawk.spp.geom.Vector2D;

	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	/**
	 * @author flashhawk
	 */
	[SWF(backgroundColor="#000000", frameRate="30", width="1000", height="700")]

	public class Tree extends Sprite 
	{

		private var ps : ParticlesSystem = new ParticlesSystem();
		private var level : int = 11;
		private var branchCount : int = 2;
		private var branchWidth : Number = 30;

		private var canvasBmd : CanvasBitmapData;
		private var canvas : Bitmap;

		private var r : Number = 255; 
		private var g : Number = 127; 
		private var b : Number = 0; 

		private var ri : Number = 0.02;
		private var gi : Number = 0.015; 
		private var bi : Number = 0.025;

		private var isCanClick : Boolean = false;

		public function Tree()
		{
			
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(e : Event) : void
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.doubleClickEnabled = true;
			stage.addEventListener(MouseEvent.DOUBLE_CLICK, function(e : MouseEvent):void
			{
				if(stage.displayState != StageDisplayState.FULL_SCREEN)
				{
					stage.displayState = StageDisplayState.FULL_SCREEN;
				}
				else
				{
					stage.displayState = StageDisplayState.NORMAL;
				}
			});
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(MouseEvent.CLICK, function(e : MouseEvent):void
			{
				if(isCanClick) run();
			});
			stage.addEventListener(Event.RESIZE, initCanvas);
			initCanvas();
		}

		private function initCanvas(e : Event = null) : void
		{
			if(canvasBmd != null)canvasBmd.dispose();
			if(canvas != null)removeChild(canvas);
			canvasBmd = new CanvasBitmapData(stage.stageWidth, stage.stageHeight);
			canvas = new Bitmap(canvasBmd);
			canvas.width = stage.stageWidth;
			canvas.height = stage.stageHeight;
			addChild(canvas);
			ps.removeAllParticles();
			run();
		}

		private function onEnterFrame(event : Event) : void 
		{
			//canvasBmd.colorMod(-1, -1, -1,0);
			var color : uint = (Math.sin(r += ri) * 128 + 127) << 16 | (Math.sin(g += gi) * 128 + 127) << 8 | (Math.sin(b += bi) * 128 + 127) ;
			var l : int = ps.particles.length;
			while(l-- > 0)
			{
				var rectWdith : Number = branchWidth / ps.particles[l].extra.level;
				if(ps.particles[l].extra.level == 1)rectWdith = 20;
				canvasBmd.fillRect(new Rectangle(ps.particles[l].x - rectWdith / 2, ps.particles[l].y, rectWdith, 1), color);
			}
		}

		private function run() : void
		{
			isCanClick = false;
			canvasBmd.clear();
			var p : PhysicsParticle = new PhysicsParticle(null, stage.stageWidth / 2, stage.stageHeight, 30, 1);
			p.addEventListener("dead", deadHandler);
			p.extra = {level:1};
			p.v = new Vector2D(0, -4);
			p.f = new Vector2D(0, 0);
			p.startRendering();
			ps.addParticle(p);
		}

		public function createParticle(x : Number,y : Number,v : Vector2D,parentLevel : int) : void
		{
			var theLevel : int = (parentLevel + 1);
			var p : PhysicsParticle = new PhysicsParticle(null, x, y, 30, 0.5);
			p.extra = {level:theLevel};
			if(p.extra.level < level)
			p.addEventListener("dead", deadHandler);
			else isCanClick = true;
			p.v = v.rotateNew(30 - Math.random() * 60);
			p.f = new Vector2D(0, 0);
			p.startRendering();
			ps.addParticle(p);
		}

		private function deadHandler(e : Event) : void
		{
			var particle : PhysicsParticle = PhysicsParticle(e.target);
			for(var i : int = 0;i < branchCount;i++)
			{
				createParticle(particle.x, particle.y, particle.v, particle.extra.level);
			}
		}
	}
}
