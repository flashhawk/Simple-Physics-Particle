package
{
	import cn.flashhawk.spp.canvas.CanvasBMD;
	import cn.flashhawk.spp.particles.*;
	import cn.flashhawk.spp.physics.forces.Attraction;
	import cn.flashhawk.spp.physics.forces.Brownian;
	import cn.flashhawk.spp.physics.forces.Repulsion;
	import cn.flashhawk.spp.util.FPS;

	import flash.display.Bitmap;
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;

	/**
	 * @author flashhawk
	 */
	[SWF(backgroundColor="#000000", frameRate="30", width="1000", height="800")]
	public class CrazeArrow extends Sprite
	{
		public var sttractionPoint : Point;
		private var ps : ParticlesSystem;
		private var boundary : Rectangle;
		private var canvase : Bitmap;
		private var bmd : CanvasBMD;
		private var scale : Number = 0.6;
		[Embed(source="assets/arrow.png")]
		public var  arrowPic : Class;
		public var arrowBmd : CanvasBMD;
		public var arrowBmp : Bitmap;
		public var bmpContainer : Sprite = new Sprite();
		public var mat : Matrix = new Matrix();
		public var bmdArray : Array = [];
		private var r : Number = 255;
		private var g : Number = 127;
		private var b : Number = 0;
		private var ri : Number = 0.02;
		private var gi : Number = 0.015;
		private var bi : Number = 0.025;
		private var pause : Boolean;

		public function CrazeArrow()
		{
			this.addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(e : Event) : void
		{
			stageSetup();
			boundary=new Rectangle(0,0,stage.stageWidth*scale,stage.stageHeight*scale);
			ParticlesSystem.STAGE=stage;
			ps = new ParticlesSystem(loop);
			sttractionPoint = new Point();
			initBmdArray();
			boom(2500);
			resizeHandler(null);
			ps.startRendering();
			//addChild(new FPS());
			initTitleText();
		}

		private function initTitleText() : void
		{
			var titleTxt : TextField = new TextField();
			titleTxt.text = "Key 'p:'pause, Move your mouse and click the stage.";
			titleTxt.textColor = 0xe1e1e1;
			titleTxt.autoSize = "left";
			titleTxt.selectable = false;
			titleTxt.x = 5;
			titleTxt.y = 20;
			addChild(titleTxt);
		}

		private function stageSetup() : void
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.quality = StageQuality.LOW;
			stage.doubleClickEnabled = true;

			stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseHandler);
			stage.addEventListener(MouseEvent.DOUBLE_CLICK, mouseHandler);
			stage.addEventListener(Event.RESIZE, resizeHandler);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
		}

		private function keyDownHandler(event : KeyboardEvent) : void
		{
			if (event.keyCode == 80)
			{
				if (pause)
				{
					ps.startRendering();
					pause = false;
				}
				else
				{
					ps.stopRendering();
					pause = true;
				}
			}
		}

		private function initBmdArray() : void
		{
			arrowBmp = new arrowPic();
			arrowBmd = new CanvasBMD(arrowBmp.width, arrowBmp.height, true, 0);
			for (var i : int = 0;i < 361;i++)
			{
				mat = new Matrix();
				mat.translate(-arrowBmp.width / 2, -arrowBmp.height / 2);
				mat.rotate(i * (Math.PI / 180));
				mat.translate(arrowBmp.width / 2, arrowBmp.height / 2);
				var bmd : CanvasBMD = new CanvasBMD(arrowBmp.width, arrowBmp.height, true, 0);
				bmd.draw(arrowBmp.bitmapData, mat);
				bmdArray.push(bmd);
			}
		}

		private function resizeHandler(e : Event) : void
		{
			if (bmd != null) bmd.dispose();
			if (canvase != null) removeChild(canvase);
			bmd = new CanvasBMD(stage.stageWidth * scale, stage.stageHeight * scale, false, 0);
			canvase = new Bitmap(bmd);
			canvase.blendMode = BlendMode.ADD;
			canvase.width = stage.stageWidth;
			canvase.height = stage.stageHeight;
			addChild(canvase);
			boundary.width=stage.stageWidth*scale;
			boundary.height=stage.stageHeight*scale;
			
		}

		private function mouseHandler(event : MouseEvent) : void
		{
			var i : int;
			if (event.type == MouseEvent.MOUSE_DOWN)
			{
				i = ps.particles.length;
				while (i-- > 0)
				{
					ps.particles[i].removeForce("repulsionForce");
					var attractionForce : Attraction = new Attraction(sttractionPoint, 1.5, 80);
					ps.particles[i].addForce("attractionForce", attractionForce);
				}
			}
			else if (event.type == MouseEvent.MOUSE_UP)
			{
				i = ps.particles.length;
				while (i-- > 0)
				{
					ps.particles[i].removeForce("attractionForce");
					var repulsionForce : Repulsion = new Repulsion(sttractionPoint, 8, 100);
					ps.particles[i].addForce("repulsionForce", repulsionForce);
				}
			}
		}

		private function loop() : void
		{
			var i : int = ps.particles.length;
			bmd.lock();
			while (i-- > 0)
			{
				var angle : Number = ps.particles[i].moveDirection;
				if (angle < 0)
				{
					angle = 360 + angle;
				}
				bmd.copyPixels(bmdArray[int(angle % 360)], arrowBmd.rect, new Point(ps.particles[i].position.x, ps.particles[i].position.y));
			}
			bmd.colorOffset(-(Math.sin(r += ri) * 128 + 127) - 15, -(Math.sin(g += gi) * 128 + 127) - 15, -(Math.sin(b += bi) * 128 + 127) - 15, 0);
			sttractionPoint.x = mouseX * scale;
			sttractionPoint.y = mouseY * scale;

			bmd.unlock();
		}

		public function boom(count : int = 30) : void
		{
			for (var i : int = 0;i < count;i++)
			{
				var fireParticle : Particle = ps.createParticle(Particle);
				fireParticle.bounceIntensity = 2;
				fireParticle.boundary = boundary;
				var repulsionForce : Repulsion = new Repulsion(sttractionPoint, 8, 100);
				fireParticle.addForce("repulsionForce", repulsionForce);
				var brownForce : Brownian = new Brownian(0.5, Math.random()*2);
				fireParticle.addForce("brown", brownForce);
				fireParticle.init(stage.stageWidth * scale / 2, stage.stageHeight * scale / 2);
			}
		}
	}
}
