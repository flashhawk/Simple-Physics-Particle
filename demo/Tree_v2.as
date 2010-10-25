package 
{
	import cn.flashhawk.spp.canvas.CanvasBMD;
	import cn.flashhawk.spp.geom.Vector2D;
	import cn.flashhawk.spp.particles.*;

	import com.bit101.components.HSlider;
	import com.bit101.components.Label;
	import com.bit101.components.Panel;
	import com.bit101.components.PushButton;
	import com.bit101.components.Style;

	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	/**
	 * @author flashhawk
	 */
	[SWF(backgroundColor="#000000", frameRate="30", width="1000", height="700")]

	public class Tree_v2 extends Sprite 
	{

		private var ps : ParticlesSystem = new ParticlesSystem(Particle);
		private var level : int =11;
		private var branchCount : int = 2;
		private var branchWidth : Number = 30;
		private var treeRotaion:Number=90;
		private var countScale:int=1;

		private var canvasBmd :CanvasBMD;
		private var canvas : Bitmap;

		private var r : Number = 255; 
		private var g : Number = 127; 
		private var b : Number = 0; 

		private var ri : Number = 0.02;
		private var gi : Number = 0.015; 
		private var bi : Number = 0.025;

		private var isCanClick : Boolean = false;
		
		private var l:int;
		public var sttractionPoint : Point = new Point();
		
		private var panel:Panel;
		private var hslider1:HSlider;
		private var hslider2:HSlider;
		private var label1:Label;
		private var label2:Label;

		public function Tree_v2()
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
				//initCanvas();
			});
			stage.addEventListener(Event.RESIZE, initCanvas);
			initControlUI();
			initCanvas();
			ps.startRendering();
			
		}
		private function fullscreen(e:MouseEvent):void
		{
			if(stage.displayState != StageDisplayState.FULL_SCREEN)
				{
					stage.displayState = StageDisplayState.FULL_SCREEN;
					e.target.label="WINDOW";
				}
				else
				{
					stage.displayState = StageDisplayState.NORMAL;
					e.target.label="FULLSCREEN";
				}
		}
		private function initControlUI():void
		{
			Style.BACKGROUND = 0x666666;
			Style.PANEL = 0x000000;
			Style.BUTTON_FACE = 0x333333;
			panel=new Panel(this,5,5);
			panel.setSize(200, 140);
			hslider1 = new HSlider(panel, 60, 20,uichanged);
			hslider1.width=120;
			hslider1.height=20;
			hslider1.maximum = 180;
            hslider1.value = 90;
			label1=new Label(panel,10,20);
			label1.text="Rotation";
			
			hslider2 = new HSlider(panel, 60, 50,uichanged);
			hslider2.width=120;
			hslider2.height=20;
			hslider2.maximum = 10;
			hslider2.minimum=1;
            hslider2.value = 1;
			label2=new Label(panel,10,50);
			label2.text="Count";
			
			var myPushButton:PushButton = new PushButton(panel, 60, 80, "REBUILD",initCanvas);
			myPushButton.width=120;
			myPushButton.height=20;
			var myPushButton2:PushButton = new PushButton(panel, 60, 110, "FULLSCREEN",fullscreen);
			myPushButton2.width=120;
			myPushButton2.height=20;
			addChild(panel);
		}
		private function uichanged(e:Event):void
		{
			if(e.target==hslider1)treeRotaion=hslider1.value;
			if(e.target==hslider2)countScale=hslider2.value;
		}
		private function initCanvas(e : Event = null) : void
		{
			removeAll();
			if(canvasBmd != null)canvasBmd.dispose();
			if(canvas != null)removeChild(canvas);
			canvasBmd = new CanvasBMD(stage.stageWidth, stage.stageHeight,false,0x000000);
			canvas = new Bitmap(canvasBmd);
			canvas.width = stage.stageWidth;
			canvas.height = stage.stageHeight;
			addChildAt(canvas, 0);
			if (panel!=null)
			{
				panel.x=stage.stageWidth-panel.width;
				panel.y=5;
			}
			run();
		}

		private function onEnterFrame(event : Event) : void 
		{
			var color : uint = (Math.sin(r += ri) * 128 + 127) << 16 | (Math.sin(g += gi) * 128 + 127) << 8 | (Math.sin(b += bi) * 128 + 127) ;
			l = ps.particles.length;
			canvasBmd.lock();
			while(l-- > 0)
			{
				var rectWdith : Number = branchWidth / ps.particles[l].extra.level;
				if(ps.particles[l].extra.level == 1)rectWdith = 20;
				//canvasBmd.fillRect(new Rectangle(ps.particles[l].x - rectWdith / 2, ps.particles[l].y, rectWdith, 1), color);
					for(var i:int=0;i<countScale;i++)
					{
					canvasBmd.setPixel(ps.particles[l].x - rectWdith / 2+(Math.random()*rectWdith-rectWdith*2), ps.particles[l].y+((Math.random()*rectWdith-rectWdith*2)), color);
					}
				
				
			}
			canvasBmd.unlock();
			sttractionPoint.x = mouseX;
			sttractionPoint.y = mouseY;
		}

		private function run() : void
		{
			isCanClick = false;
			canvasBmd.clear();
			var p :Particle = ps.createParticle();
			p.init(stage.stageWidth / 2, stage.stageHeight, 1*30);
			p.addEventListener("dead", deadHandler);
			p.extra.level=1;
			p.v = new Vector2D(0, -4);
			p.f = new Vector2D(0, 0);
		
			
		}

		public function createParticle(x : Number,y : Number,v : Vector2D,parentLevel : int) : void
		{
			var p : Particle = ps.createParticle();
			p.init(x, y, 0.5*30);
			p.extra.level=parentLevel + 1;
			if(p.extra.level < level)
			p.addEventListener("dead", deadHandler);
			p.v =v.clone();
			p.v.rotate((0.5-Math.random())*treeRotaion);
			p.f = new Vector2D(0, 0);
			trace(ps.particles.length);
		
		}
		private function removeAll():void
		{
			var n:int=ps.particles.length;
			while(n-- > 0)
			{				
				ps.particles[n].removeEventListener("dead", deadHandler);
			}
			ps.removeAllParticles();
		}
		private function deadHandler(e : Event) : void
		{
			var particle : Particle = Particle(e.target);
			particle.removeEventListener("dead", deadHandler);
			var j : int = branchCount;
			while(j-- >0)
			{
				//trace(particle.v,particle.extra.level);
				createParticle(particle.x, particle.y, particle.v,particle.extra.level);
			}
		}
		private function createBall(color : uint,r : Number = NaN) : Sprite
		{
			var s : Sprite = new Sprite();
			s.cacheAsBitmap = true;
			s.graphics.beginFill(color);
			s.graphics.drawCircle(0, 0, r);
			s.graphics.endFill();
			return s;
		}
	}
}
