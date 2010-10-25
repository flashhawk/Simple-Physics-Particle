package cn.flashhawk.spp.physics.forces 
{
	import cn.flashhawk.spp.geom.Vector2D;
	import cn.flashhawk.spp.physics.Force;

	import flash.geom.Point;	

	/**
	 * 排斥力
	 * @author FLASHHAWK
	 */
	public class Repulsion extends Force 
	{
		public    var maxForce : Number;
		public    var r : Number;
		public    var repulsionPoint : Point;
		protected var _particlePoint : Point;
		protected var _particleVector : Vector2D;

		protected var _repulsionkVector : Vector2D;

		/**
		 * 给定一个点,如果粒子小于给定的半径就会产生排斥力,半径越小,斥力越大.
		 * @param repulsionPoint 产生斥力的点
		 * @param	maxForce 斥力的最大值
		 * @param	r        产生斥力的最大半径
		 */
		public function Repulsion(repulsionPoint : Point,maxValue : Number,r : Number,life : Number = Infinity) 
		{
			super(0, 0, life);
			this.repulsionPoint = repulsionPoint;
			this._repulsionkVector = new Vector2D;
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
			var l : Number = Point.distance(repulsionPoint, _particlePoint);
			
			_particleVector.reset(this.target.position.x, this.target.position.y);
			_repulsionkVector.reset(repulsionPoint.x, repulsionPoint.y);
			if (l < r)
			{
				value = _particleVector.minusNew(_repulsionkVector);
				value.scale(maxForce / l);
			}
			else 
			{
				value.reset(0, 0);
			}
		}
	}
}