package cn.flashhawk.spp.particles
{
	import cn.flashhawk.spp.util.MathUtil;
	import cn.flashhawk.spp.events.ParticleEvent;
	import cn.flashhawk.spp.geom.Vector2D;
	import cn.flashhawk.spp.physics.Force;

	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;

	/**
	 * @author flashhawk
	 */
	public class Particle extends EventDispatcher
	{
		private var _position : Vector2D = new Vector2D();
		private var _v : Vector2D = new Vector2D();
		private var _a : Vector2D = new Vector2D();
		private var _f : Vector2D = new Vector2D(0.1, 0.1) ;
		private var _life : Number;
		private var _forces : Object = {};
		private var _target : DisplayObject;
		private var sumForce : Vector2D = new Vector2D();
		/**
		 * 是否渲染 target的rotation属性.
		 */
		public  var isRenderTargetDir : Boolean;
		/**
		 * 用来保存一些自定义的一些属性
		 */
		public 	var extra : Object = {};

		/**
		 * @param target 被渲染的显示对象			 
		 * @param x 
		 * @param y 
		 * @param life 粒子的生命周期以桢为单位
		 * 		       
		 */
		public function Particle()
		{
		}

		public function init(x : Number, y : Number, life : Number = Infinity) : void
		{
			this._position.reset(x, y);
			this._life = life;
			this._v.reset(0, 0);
			this._a.reset(0, 0);
			this._f.reset(0.1, 0.1);
		}

		public function reset() : void
		{
			this._forces = {};
			this.extra = {};
			_target = null;
		}

		public function destory() : void
		{
			_position = null;
			_v = null;
			_a = null;
			_f = null;
			_forces = null;
			extra = null;
			_life = NaN;
			_target = null;
		}

		/**
		 * @private
		 */
		protected function move() : void
		{
			sumForce.reset(0, 0);
			for (var i:String in _forces)
			{
				if (!_forces[i].live())
				{
					Force(_forces[i]).destory();
					delete _forces[i];
					dispatchEvent(new Event(i + ParticleEvent.DEAD));
				}
				else
				{
					sumForce.plus(_forces[i].value);
					a.reset(sumForce.x, sumForce.y);
				};
			}
			v.plus(a);
			v.x *= (1 - f.x);
			v.y *= (1 - f.y);
			position.plus(v);
			if (target == null) return;
			renderTarget();
		}

		public function live() : Boolean
		{
			if (_life-- <= 0) return false;
			return true;
		}

		/**
		 * @private
		 */
		protected function renderTarget() : void
		{
			this._target.x = _position.x;
			this._target.y = _position.y;
			if (!isRenderTargetDir) return;
			this._target.rotation = dir;
		}

		public function update() : void
		{
			if (live())
			{
				move();
				return;
			}
			dispatchEvent(new Event(ParticleEvent.DEAD));
		}

		/**
		 * 施加一个力
		 * @param id 力的ID
		 * @param force 力
		 */
		public function addForce(id : String, force : Force) : void
		{
			_forces[id] = force;
			force.target = this;
		}

		/**
		 * @param id 力的ID
		 * @param destory 移除此力的同时是否要销毁此力
		 */
		public function removeForce(id : String,destory : Boolean = false) : void
		{
			if(destory)Force(_forces[id]).destory();
			delete _forces[id];
		}

		/**
		 * 移除所有施加于这个粒子身上的力
		 */
		public function removeAllForces() : void
		{
			for (var i:String in _forces)
				delete _forces[i];
		}

		/**
		 * 返回粒子位置向量
		 */
		public function get position() : Vector2D
		{
			return _position;
		}

		/**
		 * @private
		 */
		public function set position(pos : Vector2D) : void
		{
			_position.reset(pos.x, pos.y);
		}

		/**
		 * 返回粒子或设置当前速度,
		 */
		public function get v() : Vector2D
		{
			return _v;
		}

		/**
		 * @private
		 */
		public function set v(v : Vector2D) : void
		{
			_v .reset(v.x, v.y);
		}

		/**
		 * 返回粒子或设置摩擦系数 范围0-1。
		 */
		public function get f() : Vector2D
		{
			return _f;
		}

		/**
		 * @private
		 */
		public function set f(f : Vector2D) : void
		{
			_f.reset(f.x, f.y);
		}

		/**
		 * 返回当前粒子当前加速度
		 */
		public function get a() : Vector2D
		{
			return _a;
		}

		/**
		 * @private
		 */
		public function set a(a : Vector2D) : void
		{
			_a.reset(a.x, a.y);
		}

		/**
		 * 返回或设置当前渲染的显示对象
		 */
		public function get target() : DisplayObject
		{
			return _target;
		}

		/**
		 * @private
		 */
		public function set target(target : DisplayObject) : void
		{
			if (target != null)
			{
				this._target = target;
				target.x = x;
				target.y = y;
			}
		}

		public function get x() : Number
		{
			return _position.x;
		}

		/**
		 * @private
		 */
		public function set x(x : Number) : void
		{
			_position.x = x;
		}

		public function get y() : Number
		{
			return _position.y;
		}

		/**
		 * @private
		 */
		public function set y(y : Number) : void
		{
			_position.x = y;
		}

		/**
		 * 返回当前生命值
		 */
		public function get life() : Number
		{
			return _life;
		}

		/**
		 * @return 返回粒子的运动方向,以度为单位
		 */
		public function get dir() : Number
		{
			return MathUtil.atan2D(_v.y, _v.x);
		}

		/**
		 * @return 返回粒子的运动方向,以弧度度为单位
		 */
		public function get dir_rad() : Number
		{
			return Math.atan2(_v.y, _v.x);
		}
	}
}