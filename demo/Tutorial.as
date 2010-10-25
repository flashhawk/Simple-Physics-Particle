package
{
	import flash.display.Bitmap;
	import cn.flashhawk.spp.canvas.CanvasBMD;
	import flash.events.Event;
	import cn.flashhawk.spp.physics.forces.Brownian;
	import cn.flashhawk.spp.particles.Particle;
	import cn.flashhawk.spp.particles.ParticlesSystem;

	import flash.display.Sprite;

	/**
	 * @author flashhawk
	 */
	[SWF(backgroundColor="#FFFFFF", frameRate="31", width="640", height="480")]
	public class Tutorial extends Sprite
	{
		private var ps : ParticlesSystem;
		private var canvasBmd:CanvasBMD;
		private var canvas:Bitmap;
		private var color:uint;

		public function Tutorial()
		{
		}

		private function init() : void
		{
			/*参数为粒子的类型,例如Particle, BoundParticle,或者你自定义的粒子类 */
			/* What type of particle parameters, such as Particle, BoundParticle, or your custom partilce class.*/
			ps = new ParticlesSystem(Particle);

			for (var i : int = 0;i < 100;i++)
			{
				var p : Particle = ps.createParticle();
				/*
				 *粒子初始化速度v和加速度a都为 new Vector2D(0,0),摩擦系数为 new Vector2D(0.1,0.1);
				 *你可以直接修改这些默认值.
				 */
				/*Initialize particle velocity v and acceleration a are all new Vector2D (0,0), 
				 *the friction coefficient of new Vector2D (0.1,0.1); 
				 *you can modify the default values
				 */
				p.v.reset(x, y);
				p.a.reset(x, y);
				p.f.reset(x, y);
				/* x, y, is the particle coordinates, life for the particle's life cycle,the default value is infinite.The frame as a unit.*/
				p.init(stage.stageWidth * 0.5, stage.stageHeight * 0.5, stage.frameRate * 2);
				
				var brownForce:Brownian=new Brownian(2);
				p.addForce("brownforce", brownForce);
				
			}
			ps.startRendering();
		}
		private function loop(e:Event):void
		{
			/*
			 * 为了效率更高和能创造出更绚烂的效果我们一般使用Bitmap.也可以渲染DisplayObject;
			 * In order to create a more efficient and able to effect a more gorgeous we generally use Bitmap. 
			 * Also render DisplayObject
			 */
		   canvasBmd.lock();
			var l:int=ps.particles.length;
			while (l-- > 0)
			{
				/*
				 * Or canvasBmd.fillRect(rect, color);
				 * Or canvasBmd.copyPixels(sourceBitmapData, sourceRect, destPoint);
				 * Or canvasBmd.setPixels(rect, inputByteArray).
				 */
				canvasBmd.setPixel(ps.particles[l].x, ps.particles[l].y, color);
			}
			canvasBmd.unlock();
			 
		}
	}
}
