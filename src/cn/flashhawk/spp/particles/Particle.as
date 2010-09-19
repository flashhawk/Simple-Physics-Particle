package cn.flashhawk.spp.particles
{
	import cn.flashhawk.spp.events.ParticleEvent;
	import cn.flashhawk.spp.geom.Vector2D;
	import cn.flashhawk.spp.physics.Force;

	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;

	public class  Particle extends EventDispatcher
	{
		private var _position : Vector2D = new Vector2D();
		private var _v : Vector2D = new Vector2D();
		private var _a : Vector2D = new Vector2D();
		private var _f : Vector2D = new Vector2D(0.1, 0.1);
		private var _forces : Object = {};
		private var _target : DisplayObject;
		private var _life : Number;
		/**
		 * 是否让target 的rotation 属性和粒子运动方向一致。
		 */
		public  var isRotation : Boolean;

		/**
		 * 附加属性对象
		 */
		public 	var extra : Object = {};

		/**
		 * @param target 被渲染的显示对象
		 * @param x 初始化显示对象x;
		 * @param y 初始化显示对象y;
		 * @param life 生命周期 以帧为单位
		 */
		public function Particle()
		{
		}

		public function init(x : Number,y : Number,life : Number = Infinity) : void
		{
			this._position.reset(x, y);
			this._life = life;
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
					dispatchEvent(new Event(i + ParticleEvent.DEAD));
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
			if(target == null) return;
			renderTarget();
		}

		/**
		 * @return 返回时候还有生命
		 */
		public function live() : Boolean
		{
			if (_life-- <= 0)return false;
			return true;
		}

		/**
		 * 销毁粒子渲染,包括target上的所有事件等.
		 */
		public function destory() : void
		{
			this._v.reset(0, 0);
			this._a.reset(0, 0);
			this._f.reset(0.1, 0.1);
			this._target = null;
			
			for (var i:String in _forces) 
			{
				delete _forces[i]; 
			}
		}

		/**
		 * @private
		 */
		protected function renderTarget() : void 
		{
			this._target.x = _position.x;
			this._target.y = _position.y;
			if(!isRotation)return;
			this._target.rotation = Math.atan2(_v.y, _v.x) * (180 / Math.PI);
		}

		public function update() : void 
		{	
			if(live())
			{
				move();
				return;
			}
			dispatchEvent(new Event(ParticleEvent.DEAD));
			destory();
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
			delete _forces[i];
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
				target.x = x;
				target.y = y;
			}
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

		public function get life() : Number
		{
			return _life;
		}
	}
}