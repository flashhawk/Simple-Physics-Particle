package cn.flashhawk.spp.physics.forces 
{
	import cn.flashhawk.spp.geom.Vector2D;
	import cn.flashhawk.spp.physics.Force;

	import flash.geom.Point;

	/**
	 * 吸引力
	 * @author FLASHHAWK
	 * 
	 */
	public class AttractionForce extends Force 
	{
		private   var _maxForce : Number;
		private   var _r : Number;
		/**
		 * @private
		 */
		protected var _particlePoint : Point;
		/**
		 * @private
		 */
		protected var _particleVector : Vector2D;
		private   var _attractionPoint : Point;
		/**
		 * @private
		 */
		protected var _attractionVector : Vector2D;

		/**
		 * 给定一个点,如果粒子小于给定的半径就会产生排斥力,如果大于这个半径就产生引力
		 * @param   attractionPoint 产生引力的点
		 * @param	maxForce 引力的最大值
		 * @param	r        产生斥力的最大半径
		 */
		public function AttractionForce(attractionPoint : Point,maxForce : Number,r : Number,life : Number = Infinity) 
		{
			super(0, 0, life);
			this._attractionPoint = attractionPoint;
			this._attractionVector = new Vector2D;
			this._particlePoint = new Point();
			this._particleVector = new Vector2D();
			this._maxForce = maxForce;
			this._r = r;
		}

		/**
		 * @private
		 */
		protected override function update() : void
		{
			this._particlePoint.x = this.target.position.x;
			this._particlePoint.y = this.target.position.y;
			var l : Number = Point.distance(_attractionPoint, _particlePoint);
			
			_particleVector.reset(this.target.position.x, this.target.position.y);
			_attractionVector.reset(_attractionPoint.x, _attractionPoint.y);
			if (l < _r)
			{
				value = _particleVector.minusNew(_attractionVector);
				value.scale(_maxForce / l);
			}
			else 
			{
				value = _attractionVector.minusNew(_particleVector);
				value.scale(_maxForce / l);
			}
		}

		/**
		 * 返回或设置半径
		 */
		public function get r() : Number
		{
			return _r;
		}

		/**
		 * @private
		 */
		public function set r(r : Number) : void
		{
			if(r <= 0) return;
			_r = r;
		}

		/**
		 * 返回或设置力的大小
		 */
		public function get maxForce() : Number
		{
			return _maxForce;
		}

		/**
		 * @private
		 */
		public function set maxForce(maxForce : Number) : void
		{
			_maxForce = maxForce;
		}

		/**
		 * 返回或设置引力点
		 */
		public function get attractionPoint() : Point
		{
			return _attractionPoint;
		}

		/**
		 * @private
		 */
		public function set attractionPoint(attractionPoint : Point) : void
		{
			_attractionPoint = attractionPoint;
		}
	}
}