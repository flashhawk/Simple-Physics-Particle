package cn.flashhawk.spp.physics.forces 
{
	import cn.flashhawk.spp.geom.Vector2D;
	import cn.flashhawk.spp.physics.Force;

	import flash.geom.Point;	

	/**
	 * 排斥力
	 * @author FLASHHAWK
	 */
	public class RepulsionForce extends Force 
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
		private   var _repulsionPoint : Point;
		/**
		 * @private
		 */
		protected var _repulsionkVector : Vector2D;

		/**
		 * 给定一个点,如果粒子小于给定的半径就会产生排斥力,半径越小,斥力越大.
		 * @param repulsionPoint 产生斥力的点
		 * @param	maxForce 斥力的最大值
		 * @param	r        产生斥力的最大半径
		 */
		public function RepulsionForce(repulsionPoint : Point,maxForce : Number,r : Number,life : Number = Infinity) 
		{
			super(0, 0, life);
			this._repulsionPoint = repulsionPoint;
			this._repulsionkVector = new Vector2D;
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
			var l : Number = Point.distance(_repulsionPoint, _particlePoint);
			
			_particleVector.reset(this.target.position.x, this.target.position.y);
			_repulsionkVector.reset(_repulsionPoint.x, _repulsionPoint.y);
			if (l < _r)
			{
				value = _particleVector.minusNew(_repulsionkVector);
				value.scale(_maxForce / l);
			}
			else 
			{
				value.reset(0, 0);
			}
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
			_r = r;
		}

		/**
		 * 返回或设置引力点
		 */
		public function get repulsionPoint() : Point
		{
			return _repulsionPoint;
		}

		/**
		 * @private
		 */
		public function set repulsionPoint(repulsionPoint : Point) : void
		{
			_repulsionPoint = repulsionPoint;
		}
	}
}