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
	public class Attraction extends Force 
	{
		public    var maxForce : Number;
		public    var r : Number;
		public    var attractionPoint : Point;
		protected var _particlePoint : Point;
		protected var _particleVector : Vector2D;
		protected var _attractionVector : Vector2D;

		/**
		 * 给定一个点,如果粒子小于给定的半径就会产生排斥力,如果大于这个半径就产生引力
		 * @param   attractionPoint 产生引力的点
		 * @param	maxForce 引力的最大值
		 * @param	r        产生斥力的最大半径
		 */
		public function Attraction(attractionPoint : Point,maxValue : Number,r : Number,life : Number = Infinity) 
		{
			super(0, 0, life);
			this.attractionPoint = attractionPoint;
			this._attractionVector = new Vector2D;
			this._particlePoint = new Point();
			this._particleVector = new Vector2D();
			this.maxForce = maxValue;
			this.r = r;
		}

		/**
		 * @private
		 */
		protected override function update() : void
		{
			this._particlePoint.x = this.target.position.x;
			this._particlePoint.y = this.target.position.y;
			var l : Number = Point.distance(attractionPoint, _particlePoint);
			
			_particleVector.reset(this.target.position.x, this.target.position.y);
			_attractionVector.reset(attractionPoint.x, attractionPoint.y);
			if (l < r)
			{
				value = _particleVector.minusNew(_attractionVector);
				value.scale(maxForce / l);
			}
			else 
			{
				value = _attractionVector.minusNew(_particleVector);
				value.scale(maxForce / l);
			}
		}
	}
}