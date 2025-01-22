package gamelib2.math;

class MathEx
{
  /** A "close to zero" float epsilon value for use*/
  public static inline var FLT_EPSILON_ABCD : Float = 1.1920928955078125E-7;

  /** A value to multiply a degree value by, to convert it to radians. */
  // public static inline var DEG_TO_RAD : Float = Math.PI / 180.0;  
  public static inline function DEG_TO_RAD() : Float
  {
    return Math.PI / 180.0;
  }

  /** A value to multiply a radian value by, to convert it to degrees. */
  //public static inline var RAD_TO_DEG : Float  = 180.0 / Math.PI;
  public static inline function RAD_TO_DEG() : Float 
  {
    return 180.0 / Math.PI;
  }

  /** The value 2PI as a float. (360 degrees) */
  //public static inline var TWO_PI : Float  = 2.0 * Math.PI;
  public static inline function TWO_PI() : Float
  {
    return 2.0 * Math.PI;
  }

  /** The value PI/2 as a float. (90 degrees) */
  //public static inline var HALF_PI : Float  = 0.5 * Math.PI;
  public static inline function HALF_PI() : Float
  {
    return 0.5 * Math.PI;
  }

  /** The value PI/4 as a float. (45 degrees) */
  //public static inline var QUARTER_PI : Float = 0.25 * Math.PI;
  public static inline function QUARTER_PI() : Float 
  {
    return 0.25 * Math.PI;
  }

  public static function centerAngle(_x : Float, _y : Float) : Int
  {   
	  if ((_x == 0) && (_y == 0)) return 0;
	
	  if (_y == 0)
	  {
	    if (_x < 0) return 180;
	    else return 0;
	  }
	
	  if (_x == 0)
	  {
	    if (_y < 0) return 270;
	    else return 90;
	  }
	  
  	return Math.round((((Math.atan2(_y, _x) + Math.PI) * 180.0) / Math.PI) + 180) % 360;
  }
  
  // used to convert an angle to the ActionScript DisplayObject rotation
  public static function fixAngle(angle : Int) : Int
  {
    angle = (angle + 90) % 360;
    
    if (angle > 180)
    {
      angle = angle - 360;
    }
    
    if (angle < -180)
    {
      angle = angle + 360;
    }
      
    return angle;
  }  

  public static function randomSign() : Int
  {
    if (Std.random(2) == 0)
    {
      return -1;
    }

    return 1;
  }

  public static function clamp(val : Int, min : Int, max : Int) : Int
  {
    if (val < min)
    {
      val = min;
    }
    
    if (val > max)
    {
      val = max;
    }
    
    return val;
  }
  
  public static function fclamp(val : Float, min : Float, max : Float) : Float
  {
    if (val < min)
    {
      val = min;
    }
    
    if (val > max)
    {
      val = max;
    }
    
    return val;
  }

  public static function fclampAbove(v : Float, upperLimit : Float) : Float
  {
    if (v > upperLimit)
    {
      v = upperLimit;
    }

    return v;
  }

  public static function fsign(v : Float) : Float
  {
    if (v < 0)
    {
      return -1;
    }
    
    if (v > 0)
    {
      return 1;
    }
    
    return 0;
  }

  public static function interpolate(alpha : Float, x0 : Float, x1 : Float) : Float
  {
    return x0 + alpha * (x1 - x0);
  }

  public static function remapInterval(x : Float, in0 : Float, in1 : Float, out0 : Float, out1 : Float) : Float
  {
    if (in1 - in0 == 0)
    {
      return Math.POSITIVE_INFINITY;
    }

    // uninterpolate: what is x relative to the interval in0:in1?
    var relative = (x - in0) / (in1 - in0);

    // now interpolate between output interval based on relative x
    return interpolate (relative, out0, out1);
  }

  public static function remapIntervalClamp (x : Float, in0 : Float, in1 : Float, out0 : Float, out1 : Float) : Float
  {
    if (in1 - in0 == 0)
    {
      return Math.POSITIVE_INFINITY;
    }

    // uninterpolate: what is x relative to the interval in0:in1?
    var relative = (x - in0) / (in1 - in0);

    // now interpolate between output interval based on relative x
    return interpolate (fclamp(relative, 0, 1), out0, out1);
  }

  // example usage: blendIntoAccumulator (dt * 0.4f, currentFPS, smoothedFPS);
  public static function blendIntoAccumulator(smoothRate : Float, newValue : Float, smoothedAccumulator : Float) : Float
  {
    return interpolate (fclamp (smoothRate, 0, 1), smoothedAccumulator, newValue);
  }

  // specify the segment1 and segment2 to perform combinations of ray/segment collisions
  //public static function rayIntersection (segment1 : Bool, x1 : Float, y1 : Float, x2 : Float, y2 : Float, segment2 : Bool, x3 : Float, y3 : Float, x4 : Float, y4 : Float) : flash.geom.Point
  public static function rayIntersection (segment1 : Bool, ax : Float, ay : Float, bx : Float, by : Float, segment2 : Bool, cx : Float, cy : Float, dx : Float, dy : Float) : flash.geom.Point
  {
    var d : Float = (bx-ax) * (dy-cy)-(by-ay) * (dx-cx);

    if (d == 0) return null;

    var r : Float = ((ay-cy) * (dx-cx) - (ax-cx) * (dy-cy)) / d;
    var s : Float = ((ay-cy) * (bx-ax) - (ax-cx) * (by-ay)) / d;

    if (segment1)
    {
      if (r < 0 || r > 1) return null;
    }

    if (segment2)
    {
      if (s < 0 || s > 1) return null;
    }

    return new flash.geom.Point(ax + (bx - ax) * r, ay + (by - ay) * r);
        
    /*
    var xi : Float = ((x3-x4)*(x1*y2-y1*x2)-(x1-x2)*(x3*y4-y3*x4)) / d;
    var yi : Float = ((y3-y4)*(x1*y2-y1*x2)-(y1-y2)*(x3*y4-y3*x4)) / d;
    
    var p = new flash.geom.Point(xi, yi);

    if (segment1)
    {
      if ( xi < Math.min(x1, x2) || xi > Math.max(x1, x2) ) return null;
    }

    if (segment2)
    {
      if ( xi < Math.min(x3, x4) || xi > Math.max(x3, x4) ) return null;
    }

    //if ((xi < Math.min(x1, x2) || xi > Math.max(x1, x2)) && segment1) return null;
    //if ((xi < Math.min(x3, x4) || xi > Math.max(x3, x4)) && segment2) return null;

    //if ((yi < Math.min(y1, y2) || yi > Math.max(y1, y2)) && segment1) return null;
    //if ((yi < Math.min(y3, y4) || yi > Math.max(y3, y4)) && segment2) return null;

    return p;
    */
  }

  /**
  * Corrects errors caused by floating point math.
  */
  public static function correctFloatingPointError(number : Float, precision : Int = 5) : Float
  {
    //default returns (10000 * number) / 10000
    //should correct very small floating point errors

    var correction : Float = Math.pow(10, precision);
    return Math.round(correction * number) / correction;
  }

  public static function computeSqrDist(x1 : Float, y1 : Float, x2 : Float, y2 : Float)
  {
    var dx = x2-x1;
    var dy = y2-y1;

    return dx * dx + dy * dy;
  }

  public static function toScientific(num : Float, ?precision : Int = 20) : String
  {
    if (precision > 20)
    {
      precision = 20;
    }

    if (precision < 0)
    {
      precision = 0;
    }
    
    var sign : String = (num < 0) ? "-" : "";

    num = Math.abs(num);
    
    var e = Math.floor(Math.log(num) / Math.log(10));
    var mult = Math.pow(10, e);

    num = num / mult;

    if (num < 1) 
    {
        num = 1;
    }
    else if ((num < 10) && (num > 9.999999999)) {
        num = 10;
    }
    else if ((num < 100) && (num > 99.99999999)) {
        num = 100;
    }

    // for example: 3000 yields extraChar == 1
    // 3001 yields extraChar == 2
    // not very necessary :)
    var extraChar = (Std.string(num).length == 1) ? 1 : 2;

    var tmpCh = "";
    
    if (extraChar == 1 && precision > 0)
    {
      extraChar = 2;
      tmpCh = ".0";
    }

    var tmp = StringTools.rpad(Std.string(num) + tmpCh, "0", precision + extraChar);
    
    return sign + tmp.substr(0, precision + extraChar) + "e" + ((e >= 0) ? "+" : "") + e;
  }

  /**
   * Returns true if the number is a power of 2 (2,4,8,16...)
   * 
   * A good implementation found on the Java boards. note: a number is a power
   * of two if and only if it is the smallest number with that number of
   * significant bits. Therefore, if you subtract 1, you know that the new
   * number will have fewer bits, so ANDing the original number with anything
   * less than it will give 0.
   * 
   * @param number
   *            The number to test.
   * @return True if it is a power of two.
   */
  public static function isPowerOfTwo(number : Int) : Bool
  {
    return (number > 0) && (number & (number - 1)) == 0;
  }
    
  public static function nearestPowerOfTwo(number : Int) : Int
  {
    return Std.int(Math.pow(2, Math.ceil(Math.log(number) / Math.log(2))));
  }

  /**
   * Given 3 points in a 2d plane, this function computes if the points going from A-B-C
   * are moving counter clock wise.
   * @param p0 Point 0.
   * @param p1 Point 1.
   * @param p2 Point 2.
   * @return 1 If they are CCW, -1 if they are not CCW, 0 if p2 is between p0 and p1.
   */
  public static function counterClockwise(p0 : Vector2f, p1 : Vector2f, p2 : Vector2f) : Int
  {
    var dx1 : Float = p1.x-p0.x;
    var dy1 : Float = p1.y-p0.y;
    var dx2 : Float = p2.x-p0.x;
    var dy2 : Float = p2.y-p0.y;

    if (dx1*dy2>dy1*dx2) return 1;
    if (dx1*dy2<dy1*dx2) return -1;
    if ((dx1*dx2 < 0) || (dy1*dy2 <0)) return -1;
    if ((dx1*dx1+dy1*dy1) < (dx2*dx2+dy2*dy2)) return 1;

    return 0;
  }

  /**
   * Test if a point is inside a triangle.  1 if the point is on the ccw side,
   * -1 if the point is on the cw side, and 0 if it is on neither.
   * @param t0 First point of the triangle.
   * @param t1 Second point of the triangle.
   * @param t2 Third point of the triangle.
   * @param p The point to test.
   * @return Value 1 or -1 if inside triangle, 0 otherwise.
   */
  public static function pointInsideTriangle(t0 : Vector2f, t1 : Vector2f, t2 : Vector2f, p : Vector2f) : Bool
  {
    var val1=counterClockwise(t0,t1,p);
    if (val1==0) return true;
    var val2=counterClockwise(t1,t2,p);
    if (val2==0) return true;
    if (val2!=val1) return false;
    var val3=counterClockwise(t2,t0,p);
    if (val3==0) return true;
    if (val3!=val1) return false;

    return (val3 == 1);
  }


  /**
   * Returns the determinant of a 4x4 matrix.
   */ 
  public static function determinant(m00 : Float, m01 : Float, m02 : Float,
          m03 : Float, m10 : Float, m11 : Float, m12 : Float, m13 : Float,
          m20 : Float, m21 : Float, m22 : Float, m23 : Float, m30 : Float,
          m31 : Float, m32 : Float, m33 : Float) : Float
  {
    var det01 : Float = m20 * m31 - m21 * m30;
    var det02 : Float = m20 * m32 - m22 * m30;
    var det03 : Float = m20 * m33 - m23 * m30;
    var det12 : Float = m21 * m32 - m22 * m31;
    var det13 : Float = m21 * m33 - m23 * m31;
    var det23 : Float = m22 * m33 - m23 * m32;

    return ( m00 * (m11 * det23 - m12 * det13 + m13 * det12) - m01
             * (m10 * det23 - m12 * det03 + m13 * det02) + m02
             * (m10 * det13 - m11 * det03 + m13 * det01) - m03
             * (m10 * det12 - m11 * det02 + m12 * det01));
  }

  /**
   * Converts a point from Spherical coordinates to Cartesian (using positive
   * Y as up) and stores the results in the store var.
   */
  public static function  sphericalToCartesian(sphereCoords : Vector3f, store : Vector3f) : Vector3f
  {
    store.y = sphereCoords.x * Math.sin(sphereCoords.z);
    
    var a : Float = sphereCoords.x * Math.cos(sphereCoords.z);

    store.x = a * Math.cos(sphereCoords.y);
    store.z = a * Math.sin(sphereCoords.y);

    return store;
  }

  /**
   * Converts a point from Cartesian coordinates (using positive Y as up) to
   * Spherical and stores the results in the store var. (Radius, Azimuth,
   * Polar)
   */
  public static function cartesianToSpherical(cartCoords : Vector3f, store : Vector3f) : Vector3f
  {
    if (cartCoords.x == 0)
        cartCoords.x = 1.1920928955078125E-7/*FastMath.FLT_EPSILON*/;

    store.x = Math
            .sqrt((cartCoords.x * cartCoords.x)
                    + (cartCoords.y * cartCoords.y)
                    + (cartCoords.z * cartCoords.z));

    store.y = Math.atan(cartCoords.z / cartCoords.x);

    if (cartCoords.x < 0)
        store.y += Math.PI;

    store.z = Math.asin(cartCoords.y / store.x);

    return store;
  }

  /**
   * Converts a point from Spherical coordinates to Cartesian (using positive
   * Z as up) and stores the results in the store var.
   */
  public static function sphericalToCartesianZ(sphereCoords : Vector3f, store : Vector3f) : Vector3f
  {
    store.z = sphereCoords.x * Math.sin(sphereCoords.z);
    var a : Float = sphereCoords.x * Math.cos(sphereCoords.z);
    store.x = a * Math.cos(sphereCoords.y);
    store.y = a * Math.sin(sphereCoords.y);

    return store;
  }

  /**
   * Converts a point from Cartesian coordinates (using positive Z as up) to
   * Spherical and stores the results in the store var. (Radius, Azimuth,
   * Polar)
   */
  public static function cartesianZToSpherical(cartCoords : Vector3f, store : Vector3f) : Vector3f
  {
      if (cartCoords.x == 0)
          cartCoords.x = 1.1920928955078125E-7;//FastMath.FLT_EPSILON;

      store.x = Math.sqrt((cartCoords.x * cartCoords.x)
                      + (cartCoords.y * cartCoords.y)
                      + (cartCoords.z * cartCoords.z));

      store.z = Math.atan(cartCoords.z / cartCoords.x);

      if (cartCoords.x < 0)
          store.z += Math.PI;

      store.y = Math.asin(cartCoords.y / store.x);
      return store;
  }

	inline public static function compareAbsolute(x : Float, y : Float, eps : Float) : Bool
	{
		var d = x - y;
		return d > 0 ? d < eps : -d < eps;
	}

  public static function randomBool() : Bool
  {
    return (Std.random(2) == 1);
  }

  public static function randomInterval(a : Int, b : Int) : Int
  {
    return (a < b) ? (a + Std.random(b - a)) : (b + Std.random(a - b));
  }

  public static function randomFInterval(a : Float, b : Float) : Float
  {
    var delta = Math.abs(a - b) * Math.random();
    
    return (a < b) ? (a + delta) : (b + delta);
  }
}