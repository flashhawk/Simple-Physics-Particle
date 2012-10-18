package cn.flashhawk.spp.geom
{
	/**
	 * 2D向量类
	 * @author FLASHHAWK
	 */
	import cn.flashhawk.spp.util.MathUtil;

	public class Vector2D
	{
		public var x : Number;
		public var y : Number;

		public function Vector2D(x : Number = 0, y : Number = 0)
		{
			init(x, y);
		}

		private function init(x : Number, y : Number) : void
		{
			this.x = x;
			this.y = y;
		}

		public function toString() : String
		{
			var temp : String = "Vector2D:";
			temp += "[" + x + "," + y + "]\n";
			return temp;
		}

		public function reset(x : Number=0, y : Number=0) : void
		{
			init(x, y);
		}

		public function clone() : Vector2D
		{
			return new Vector2D(this.x, this.y);
		}

		/**
		 * 
		 * @param	v  向量
		 * @return  适时候和V向量相等
		 */
		public function equals(v : Vector2D) : Boolean
		{
			return (this.x == v.x && this.y == v.y);
		}

		/**
		 * 向量相加,原向量改变; 
		 * @param	v 向量 
		 */
		public function plus(v : Vector2D) : void
		{
			this.x += v.x;
			this.y += v.y;
		}

		/**
		 * 向量向量相加，返回新向量，原向量不变 
		 * @param	v 向量
		 * @return   反回新向量
		 */
		public function plusNew(v : Vector2D) : Vector2D
		{
			return new Vector2D(this.x + v.x, this.y + v.y);
		}

		/**
		 * 向量相减,原向量改变; 
		 * @param	v 向量
		 */
		public function minus(v : Vector2D) : void
		{
			this.x -= v.x;
			this.y -= v.x;
		}

		/**
		 * 向量向量相减，返回新向量，原向量不变 
		 * @param	v  向量
		 * @return   返回新向量
		 */
		public function minusNew(v : Vector2D) : Vector2D
		{
			return new Vector2D(this.x - v.x, this.y - v.y);
		}

		/**
		 * 向量求反
		 */
		public function negate() : void
		{
			this.x *= -1;
			this.y *= -1;
		}

		public function negateX() : void
		{
			this.x *= -1;
		}

		public function negateY() : void
		{
			this.y *= -1;
		}

		/**
		 * 返回一个反向量,愿向量不变
		 * @return  一个反向量
		 */
		public function negateNew() : Vector2D
		{
			return new Vector2D(-this.x, -this.y);
		}

		/**
		 * 向量的放缩
		 * @param	ratio  放缩率
		 */
		public function scale(ratio : Number) : void
		{
			this.x *= ratio;
			this.y *= ratio;
		}

		public function scaleX(ratio : Number) : void
		{
			this.x *= ratio;
		}

		public function scaleY(ratio : Number) : void
		{
			this.y *= ratio;
		}

		public function scaleNew(ratio : Number) : Vector2D
		{
			return new Vector2D(this.x * ratio, this.y * ratio);
		}

		/**
		 * @return  向量的长度
		 */
		public function getLength() : Number
		{
			return Math.sqrt(this.x * this.x + this.y * this.y);
		}

		/**
		 * 设置向量的长度
		 * @param	l  长度
		 */
		public function setLength(l : Number) : void
		{
			var ratio : Number = l / this.getLength();
			this.scale(ratio);
		}

		/**
		 * 向量的角度
		 * @return  向量的角度
		 */
		public function getAngle() : Number
		{
			return MathUtil.atan2D(this.y, this.x);
		}

		/**
		 * 设置向量的角度
		 * @param	angle  角度
		 */
		public function setAngle(angle : Number) : void
		{
			var l : Number = this.getLength();
			this.x = l * MathUtil.cosD(angle);
			this.y = l * MathUtil.sinD(angle);
		}

		/**
		 * 向量的旋转
		 * @param	angle 旋转的角度度为单位,逆时针为正.
		 */
		public function rotate(angle : Number) : void
		{
			var sina : Number = MathUtil.sinD(angle);
			var cosa : Number = MathUtil.cosD(angle);
			var tempx : Number = this.x;
			var tempy : Number = this.y;
			this.x = tempx * cosa - tempy * sina;
			this.y = tempx * sina + tempy * cosa;
		}

		public function rotateNew(angle : Number) : Vector2D
		{
			var v : Vector2D = this.clone();
			v.rotate(angle);
			return v;
		}

		/**
		 * 向量的点积
		 * @param	v 向量
		 * @return   和向量v的点积
		 */
		public function dot(v : Vector2D) : Number
		{
			return this.x * v.x + this.y * v.y;
		}

		/**
		 * 返回在向量v上的投影向量
		 * @param	v 向量
		 * @return  返回在向量v上的投影向量
		 */
		public function projection(v : Vector2D) : Vector2D
		{
			var btweenAngle : Number = this.angleBetween(v);
			var k : Number = (this.getLength() * MathUtil.cosD(btweenAngle)) / v.getLength();
			return v.scaleNew(k);
		}

		/**
		 * 返回一个标准化向量
		 * @return
		 */
		public function normalized() : Vector2D
		{
			return new Vector2D(this.x / this.getLength(), this.y / this.getLength());
		}

		/**
		 * 
		 * @return 向量的法线，就是垂线
		 */
		public function getNormal() : Vector2D
		{
			return new Vector2D(-this.y, this.x);
		}

		/**
		 * 垂直判断
		 * @param	v
		 */
		public function isPerpTo(v : Vector2D) : Boolean
		{
			return (this.dot(v) == 0);
		}

		/**
		 * 
		 * @param	v
		 * @return  返回和向量v的夹角，度为单位
		 */
		public function angleBetween(v : Vector2D) : Number
		{
			var dp : Number = this.dot(v);
			var cosAngle : Number = dp / (this.getLength() * v.getLength());
			return MathUtil.acosD(cosAngle);
		}
	}
}