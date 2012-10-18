package cn.flashhawk.spp.particles
{
	import cn.flashhawk.spp.events.ParticleEvent;
	import cn.flashhawk.spp.geom.Vector2D;
	import cn.flashhawk.spp.physics.Force;
	import cn.flashhawk.spp.util.MathUtil;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * @author flashhawk
	 */
	public class Particle extends EventDispatcher
	{
		public var position : Vector2D = new Vector2D();
		public var point : Point = new Point();
		public var velocity : Vector2D = new Vector2D();
		public var acceleration : Vector2D = new Vector2D();
		public var friction : Vector2D = new Vector2D(0.1, 0.1) ;
		private var _life : Number;
		private var _forces : Object = {};
		private var _sumForce : Vector2D = new Vector2D();
		/*
		 * 碰撞矩形边界
		 */
		public var boundary : Rectangle = null;
		/*
		 * 碰到边界时候的反弹强度系数,默认是2
		 */
		public var bounceIntensity : Number = 2;
		/*
		 * 用来保存一些自定义的一些属性
		 */
		public 	var extra : Object = {};
		
		// TODO
		// private var _bounds:Rectangle;

		public function Particle()
		{
		}

		/**	 
		 * @param x 
		 * @param y 
		 * @param life 粒子的生命周期以秒为单位
		 * 		       
		 */
		public function init(x : Number, y : Number, life : Number = Infinity) : void
		{
			this.position.reset(x, y);
			this.point.x = x;
			this.point.y = y;
			this.velocity.reset(0, 0);
			this.acceleration.reset(0, 0);
			this.friction.reset(0.1, 0.1);
			this._life = life;
		}

		public function reset() : void
		{
			this._forces = {};
			this.extra = {};
			this._sumForce.reset();
		}

		public function destory() : void
		{
			position = null;
			velocity = null;
			acceleration = null;
			friction = null;
			_forces = null;
			extra = null;
			_life = NaN;
		}

		/**
		 * @private
		 */
		protected function move() : void
		{
			_sumForce.reset(0, 0);
			for (var i:String in _forces)
			{
				if (!_forces[i].isLive())
				{
					Force(_forces[i]).destory();
					delete _forces[i];
				}
				else
				{
					_sumForce.plus(_forces[i].value);
					acceleration.reset(_sumForce.x, _sumForce.y);
				}
				;
			}
			velocity.plus(acceleration);
			velocity.x *= (1 - friction.x);
			velocity.y *= (1 - friction.y);
			position.plus(velocity);
			point.x = position.x;
			point.y = position.y;
			if (boundary) bounce();
		}

		public function isLive() : Boolean
		{
			if ((_life -= 1 / ParticlesSystem.FPS) <= 0) return false;
			return true;
		}

		public function update() : void
		{
			if (isLive())
			{
				move();
				return;
			}
			dispatchEvent(new Event(ParticleEvent.DEAD));
		}

		private function bounce() : void
		{
			if (position.x < boundary.left || position.x > boundary.right)
			{
				position.x = position.x < boundary.left ? boundary.left : boundary.right;
				velocity.scaleX(-bounceIntensity);
				acceleration.scale(0);
			}
			if (position.y < boundary.top || position.y > boundary.bottom)
			{
				position.y = position.y < boundary.top ? boundary.top : boundary.bottom;
				velocity.scaleY(-bounceIntensity);
				acceleration.scale(0);
			}
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
		public function removeForce(id : String, destory : Boolean = false) : void
		{
			if (destory) Force(_forces[id]).destory();
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
		 * 返回当前生命值
		 */
		public function get life() : Number
		{
			return _life;
		}

		/**
		 * @return 返回粒子的运动方向,以度为单位
		 */
		public function get moveDirection() : Number
		{
			return MathUtil.atan2D(velocity.y, velocity.x);
		}

		/**
		 * @return 返回粒子的运动方向,以弧度度为单位
		 */
		public function get moveDirectionRad() : Number
		{
			return Math.atan2(velocity.y, velocity.x);
		}
	}
}