/**
 * AUTHOR flashhawk
 * VERSION: 1.0
 * DATE: 2010-08-17
 * Simple-physics-particle is a particle system for actionscript3.0
 * For actionscript3.0  player9~10.
 * Code less easy to use, based on mechanics.
 * Make your own custom forces.
 * Open source!
 * BLOG http://www.flashquake.cn 
 **/
package cn.flashhawk.spp
{
	import cn.flashhawk.spp.geom.Vector2D;
	import cn.flashhawk.spp.physics.Force;

	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class  PhysicsParticle extends EventDispatcher
	{

		private var timer : Timer;
		private var _position : Vector2D;
		private var _v : Vector2D;
		private var _a : Vector2D;
		private var _f : Vector2D;
		private var _forces : Object;
		private var _target : DisplayObject;
		private var _interval : Number;
		private var life : Number;
		/**
		 * 是否让target 的rotation 属性和粒子运动方向一致。
		 */
		public  var isDir : Boolean;

		/**
		 * 附加属性对象
		 */
		public 	var extra : Object;

		/**
		 * @param target 被渲染的显示对象
		 * @param x 初始化显示对象x;
		 * @param y 初始化显示对象y;
		 * @param life 生命周期 以秒为单位
		 */
		public function PhysicsParticle(target : DisplayObject,x : Number,y : Number,framerate : Number = 30,life : Number = Infinity)
		{
			this._target = target;
			this._position = new Vector2D(x, y);
			this._v = new Vector2D(0, 0);
			this._a = new Vector2D(0, 0);
			//摩擦系数默认为0.1
			this._f = new Vector2D(0.1, 0.1);
			this._forces = {};
			this.life = life * 1000;
			if(target != null)
			{
				target.x = x;
				target.y = y;
			}
			
			this.extra = {};
			_interval = 1000 / framerate;
			timer = new Timer(_interval);
			timer.addEventListener(TimerEvent.TIMER, update);
		}

		/**
		 * @private
		 */
		protected function move() : void 
		{
			var force : Vector2D = new Vector2D();
			for (var i:String in _forces) 
			{
				if (!_forces[i].live()) 
				{
					delete _forces[i];
					dispatchEvent(new Event(i + "Dead"));
				} 
				else 
				{
					force.plus(_forces[i].value);
					a.reset(force.x, force.y);
				}
				;
			}	
			v.plus(a);
			v.x *= (1 - f.x);
			v.y *= (1 - f.y);
			position.plus(v);
			if(target != null)
			renderTarget();
		}

		/**
		 * @return 返回时候还有生命
		 */
		public function live() : Boolean
		{
			if ((life -= _interval) <= 0)
			{
				return false;
			}
			else 
			{
				return true;
			}
		}

		/**
		 * 销毁粒子渲染,包括target上的所有事件等.
		 */
		public function destory() : void
		{
			dispatchEvent(new Event("dead"));
			this._position = null;
			this._v = null;
			this._a = null;
			this._f = null;
			timer.stop();
			timer.removeEventListener(TimerEvent.TIMER, update);
			timer = null;
			this._target = null;
			
			for (var i:String in _forces) 
			{
				if (!_forces[i].live()) 
				{
					delete _forces[i];
				} 
			}
			this._forces = null;
		}

		/**
		 * @private
		 */
		protected function renderTarget() : void 
		{
			this._target.x = _position.x;
			this._target.y = _position.y;
			if(isDir)
			{
				this._target.rotation = Math.atan2(_v.y, _v.x) * (180 / Math.PI);
			}
		}

		/**
		 * 开始渲染
		 */
		public function startRendering() : void
		{
			if(life <= 0) return;
			timer.start();
		}

		/**
		 * 停止渲染
		 */
		public function stopRendering() : void
		{
			timer.stop();
		}

		private function update(e : Event) : void 
		{	
			if(live())
			{
				move();
			}
			else
			{
				destory();
			}
		}

		/**
		 * 给粒子新增加一个力场
		 */
		public function addForce(id_str : String,force : Force) : void
		{
			
			_forces[id_str] = force;
			force.target = this;
		}

		/**
		 * 
		 * @param id_str 力场的id
		 */
		public function removeForce(id_str : String) : void
		{
			delete _forces[id_str];
		}

		/**
		 * 销毁所有的力场
		 */
		public function removeAllForces() : void
		{
			for (var i:String in _forces) 
			{
				delete _forces[i];
			}	
		}

		/**
		 * 返回或设置粒子的向量坐标
		 */
		public function get position() : Vector2D
		{
			return _position;
		}

		public function set position(pos : Vector2D) : void
		{
			_position.reset(pos.x, pos.y);
		}

		/**
		 * 返回或设置粒子的速度
		 */
		public function get v() : Vector2D
		{
			return _v;
		}

		public function set v(v : Vector2D) : void
		{
			_v .reset(v.x, v.y);
		}

		/**
		 * 返回或设置粒子的摩擦系数 0~1
		 */
		public function get f() : Vector2D
		{
			return _f;
		}

		public function set f(f : Vector2D) : void
		{
			_f.reset(f.x, f.y);
		}

		/**
		 * 返回或设置粒子加速度
		 */
		public function get a() : Vector2D
		{
			return _a;
		}

		/**
		 * 返回或设置粒子渲染的目标
		 */
		public function get target() : DisplayObject
		{
			return _target;
		}

		public function set target(target : DisplayObject) : void
		{
			if(target != null)
			{
				this._target = target;
			}
		}

		public function get interval() : Number
		{
			return _interval;
		}

		public function get x() : Number
		{
			return _position.x;
		}

		public function set x(x : Number) : void
		{
			_position.x = x;
		}

		public function get y() : Number
		{
			return _position.y;
		}

		public function set y(y : Number) : void
		{
			_position.x = y;
		}
	}
}