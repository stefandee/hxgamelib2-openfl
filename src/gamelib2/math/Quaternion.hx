package gamelib2.math;

/**
 * <code>Quaternion</code> defines a single example of a more general class of
 * hypercomplex numbers. Quaternions extends a rotation in three dimensions to a
 * rotation in four dimensions. This avoids "gimbal lock" and allows for smooth
 * continuous rotation.
 * 
 * <code>Quaternion</code> is defined by four floating point numbers: {x y z
 * w}.
 * 
 * @author Mark Powell
 * @author Joshua Slack
 */
class Quaternion 
{
  public var x : Float;
  public var y : Float;
  public var z : Float;
  public var w : Float;

  /**
   * Constructor instantiates a new <code>Quaternion</code> object
   * initializing the value to the Identity Quaternion, {0,0,0,1}.
   * The class JavaDoc defines the sequence of those elements.
   */
  public function new(?x : Float = 0, ?y : Float = 0, ?z : Float = 0, ?w : Float = 0) 
  {
    this.x = x;
    this.y = y;
    this.z = z;
    this.w = w;
  }

  /**
   * sets the data in a <code>Quaternion</code> object from the given list
   * of parameters.
   *
   * @param x
   *            the x value of the quaternion.
   * @param y
   *            the y value of the quaternion.
   * @param z
   *            the z value of the quaternion.
   * @param w
   *            the w value of the quaternion.
   */
  public function set(x : Float, y : Float, z : Float, w : Float) : Void
  {
    this.x = x;
    this.y = y;
    this.z = z;
    this.w = w;
  }

  /**
   * Sets the data in this <code>Quaternion</code> object to be equal to the
   * passed <code>Quaternion</code> object. The values are copied producing
   * a new object.
   *
   * @param q
   *            The Quaternion to copy values from.
   * @return this for chaining
   */
  public function setQuaternion(q : Quaternion) : Quaternion
  {
    this.x = q.x;
    this.y = q.y;
    this.z = q.z;
    this.w = q.w;
    return this;
  }

  /**
   * To be deprecated, as this method name is not consistent with the
   * other jME math method names.
   * If we want a method name to be explicit that it is changing data
   * internally, we use the word "local"; but the case here is a very close
   * parallel to Vector3f.zero(), where everybody understands that the
   * operation is local.
   *
   * @see #identity()
   */
  public function loadIdentity() : Void
  {
    identity();
  }

  /**
   * Sets the value of this Quaternion to the Identity Quaternion,
   * {0, 0, 0, 1}.
   * Same as calling set(0,0,0,1).
   * The class JavaDoc defines the sequence of those elements.
   */
  public function identity() : Void
  {
    x = y = z = 0;
    w = 1;
  }
  
  /**
   * @return true if this Quaternion is the Identity Quaternion, {0,0,0,1}
   */
  public function isIdentity() : Bool
  {
    return (x == 0 && y == 0 && z == 0 && w == 1);
  }
  
  /**
   * <code>fromAngles</code> builds a quaternion from the Euler rotation
   * angles (y,r,p).
   *
   * @param angles
   *            the Euler angles of rotation (in radians).
   */
  public function fromAngles(angles : Array<Float>) : Void
  {
    if (angles.length != 3)
    {
      throw "Angles array must have three elements";
    }

    fromAnglesYRP(angles[0], angles[1], angles[2]);
  }

/**
 * <code>fromAngles</code> builds a Quaternion from the Euler rotation
 * angles (y,r,p). Note that we are applying in order: roll, pitch, yaw but
 * we've ordered them in x, y, and z for convenience.
 * See: http://www.euclideanspace.com/maths/geometry/rotations/conversions/eulerToQuaternion/index.htm
 * 
 * @param yaw
 *            the Euler yaw of rotation (in radians). (aka Bank, often rot
 *            around x)
 * @param roll
 *            the Euler roll of rotation (in radians). (aka Heading, often
 *            rot around y)
 * @param pitch
 *            the Euler pitch of rotation (in radians). (aka Attitude, often
 *            rot around z)
 */
  public function fromAnglesYRP(yaw : Float, roll : Float, pitch : Float) : Quaternion
  {
    var angle = pitch * 0.5;
    var sinPitch = Math.sin(angle);
    var cosPitch = Math.cos(angle);
    angle = roll * 0.5;
    var sinRoll = Math.sin(angle);
    var cosRoll = Math.cos(angle);
    angle = yaw * 0.5;
    var sinYaw = Math.sin(angle);
    var cosYaw = Math.cos(angle);

    // variables used to reduce multiplication calls.
    var cosRollXcosPitch = cosRoll * cosPitch;
    var sinRollXsinPitch = sinRoll * sinPitch;
    var cosRollXsinPitch = cosRoll * sinPitch;
    var sinRollXcosPitch = sinRoll * cosPitch;
    
    w = (cosRollXcosPitch * cosYaw - sinRollXsinPitch * sinYaw);
    x = (cosRollXcosPitch * sinYaw + sinRollXsinPitch * cosYaw);
    y = (sinRollXcosPitch * cosYaw + cosRollXsinPitch * sinYaw);
    z = (cosRollXsinPitch * cosYaw - sinRollXcosPitch * sinYaw);
    
    normalize();
    return this;
  }
  
  /**
 * <code>toAngles</code> returns this quaternion converted to Euler
 * rotation angles (yaw,roll,pitch).<br/>
 * See http://www.euclideanspace.com/maths/geometry/rotations/conversions/quaternionToEuler/index.htm
 * 
 * @param angles
 *            the float[] in which the angles should be stored, or null if
 *            you want a new float[] to be created
 * @return the float[] in which the angles are stored.
 */
public function toAngles(angles : Array<Float>) : Array<Float>
{
  if (angles == null)
  {
    angles = new Array<Float>();
  }
  else if (angles.length != 3)
  {
    throw ("Angles array must have three elements");
  }

  var sqw = w * w;
  var sqx = x * x;
  var sqy = y * y;
  var sqz = z * z;
  var unit = sqx + sqy + sqz + sqw; // if normalized is one, otherwise
                    // is correction factor
  var test = x * y + z * w;
  if (test > 0.499 * unit) 
  { 
    // singularity at north pole
    angles[1] = 2 * Math.atan2(x, w);
    angles[2] = MathEx.HALF_PI();
    angles[0] = 0;
  } 
  else if (test < -0.499 * unit) 
  { 
    // singularity at south pole
    angles[1] = -2 * Math.atan2(x, w);
    angles[2] = -MathEx.HALF_PI();
    angles[0] = 0;
  } 
  else 
  {
    angles[1] = Math.atan2(2 * y * w - 2 * x * z, sqx - sqy - sqz + sqw); // roll or heading 
    angles[2] = Math.asin(2 * test / unit); // pitch or attitude
    angles[0] = Math.atan2(2 * x * w - 2 * y * z, -sqx + sqy - sqz + sqw); // yaw or bank
  }

  return angles;
}

  /**
 * 
 * <code>fromRotationMatrix</code> generates a quaternion from a supplied
 * matrix. This matrix is assumed to be a rotational matrix.
 * 
 * @param matrix
 *            the matrix that defines the rotation.
 */
  public function fromRotationMatrix(matrix : Matrix3f) : Quaternion
  {
    return fromRotationMatrix2(matrix.m00, matrix.m01, matrix.m02, matrix.m10,
            matrix.m11, matrix.m12, matrix.m20, matrix.m21, matrix.m22);
  }
  
  public function fromRotationMatrix2(m00 : Float, m01 : Float, m02 : Float,
          m10 : Float, m11 : Float, m12 : Float,
          m20 : Float, m21 : Float, m22 : Float) : Quaternion
  {
    // Use the Graphics Gems code, from 
    // ftp://ftp.cis.upenn.edu/pub/graphics/shoemake/quatut.ps.Z
    // *NOT* the "Matrix and Quaternions FAQ", which has errors!
    
    // the trace is the sum of the diagonal elements; see
    // http://mathworld.wolfram.com/MatrixTrace.html
    var t = m00 + m11 + m22;

    // we protect the division by s by ensuring that s>=1
    if (t >= 0) 
    { 
      // |w| >= .5
      var s = Math.sqrt(t+1); // |s|>=1 ...
      w = 0.5 * s;
      s = 0.5 / s;                 // so this division isn't bad
      x = (m21 - m12) * s;
      y = (m02 - m20) * s;
      z = (m10 - m01) * s;
    } 
    else if ((m00 > m11) && (m00 > m22)) 
    {
      var s = Math.sqrt(1.0 + m00 - m11 - m22); // |s|>=1
      x = s * 0.5; // |x| >= .5
      s = 0.5 / s;
      y = (m10 + m01) * s;
      z = (m02 + m20) * s;
      w = (m21 - m12) * s;
    } 
    else if (m11 > m22) 
    {
      var s = Math.sqrt(1.0 + m11 - m00 - m22); // |s|>=1
      y = s * 0.5; // |y| >= .5
      s = 0.5 / s;
      x = (m10 + m01) * s;
      z = (m21 + m12) * s;
      w = (m02 - m20) * s;
    } 
    else 
    {
      var s = Math.sqrt(1.0 + m22 - m00 - m11); // |s|>=1
      z = s * 0.5; // |z| >= .5
      s = 0.5 / s;
      x = (m02 + m20) * s;
      y = (m21 + m12) * s;
      w = (m10 - m01) * s;
    }
    
    return this;
  }

  /**
   * <code>toRotationMatrix</code> converts this quaternion to a rotational
   * matrix. Note: the result is created from a normalized version of this quat.
   * 
   * @return the rotation matrix representation of this quaternion.
   */
  public function toRotationMatrix3() : Matrix3f
  {
    var matrix = new Matrix3f();
    return toRotationMatrix3Store(matrix);
  }

  /**
   * <code>toRotationMatrix</code> converts this quaternion to a rotational
   * matrix. The result is stored in result.
   * 
   * @param result
   *            The Matrix3f to store the result in.
   * @return the rotation matrix representation of this quaternion.
   */
  public function toRotationMatrix3Store(result : Matrix3f) : Matrix3f
  {
    var norm = norm();
    // we explicitly test norm against one here, saving a division
    // at the cost of a test and branch.  Is it worth it?
    var s = (norm==1.0) ? 2.0 : (norm > 0.0) ? 2.0/norm : 0;
    
    // compute xs/ys/zs first to save 6 multiplications, since xs/ys/zs
    // will be used 2-4 times each.
    var xs      = x * s;
    var ys      = y * s;
    var zs      = z * s;
    var xx      = x * xs;
    var xy      = x * ys;
    var xz      = x * zs;
    var xw      = w * xs;
    var yy      = y * ys;
    var yz      = y * zs;
    var yw      = w * ys;
    var zz      = z * zs;
    var zw      = w * zs;

    // using s=2/norm (instead of 1/norm) saves 9 multiplications by 2 here
    result.m00  = 1 - ( yy + zz );
    result.m01  =     ( xy - zw );
    result.m02  =     ( xz + yw );
    result.m10  =     ( xy + zw );
    result.m11  = 1 - ( xx + zz );
    result.m12  =     ( yz - xw );
    result.m20  =     ( xz - yw );
    result.m21  =     ( yz + xw );
    result.m22  = 1 - ( xx + yy );

    return result;
  }

  /**
   * <code>toRotationMatrix</code> converts this quaternion to a rotational
   * matrix. The result is stored in result. 4th row and 4th column values are
   * untouched. Note: the result is created from a normalized version of this quat.
   * 
   * @param result
   *            The Matrix4f to store the result in.
   * @return the rotation matrix representation of this quaternion.
   */
  public function toRotationMatrix4Store(result : Matrix4f) : Matrix4f
  {
    var norm = norm();
    // we explicitly test norm against one here, saving a division
    // at the cost of a test and branch.  Is it worth it?
    var s = (norm==1.0) ? 2.0 : (norm > 0.0) ? 2.0/norm : 0;
    
    // compute xs/ys/zs first to save 6 multiplications, since xs/ys/zs
    // will be used 2-4 times each.
    var xs      = x * s;
    var ys      = y * s;
    var zs      = z * s;
    var xx      = x * xs;
    var xy      = x * ys;
    var xz      = x * zs;
    var xw      = w * xs;
    var yy      = y * ys;
    var yz      = y * zs;
    var yw      = w * ys;
    var zz      = z * zs;
    var zw      = w * zs;

    // using s=2/norm (instead of 1/norm) saves 9 multiplications by 2 here
    result.m00  = 1 - ( yy + zz );
    result.m01  =     ( xy - zw );
    result.m02  =     ( xz + yw );
    result.m10  =     ( xy + zw );
    result.m11  = 1 - ( xx + zz );
    result.m12  =     ( yz - xw );
    result.m20  =     ( xz - yw );
    result.m21  =     ( yz + xw );
    result.m22  = 1 - ( xx + yy );

    return result;
  }

  /**
   * <code>getRotationColumn</code> returns one of three columns specified
   * by the parameter. This column is returned as a <code>Vector3f</code>
   * object.
   *
   * @param i
   *            the column to retrieve. Must be between 0 and 2.
   * @return the column specified by the index.
   */
  public function getRotationColumn(i : Int) : Vector3f
  {
    return getRotationColumnStore(i, null);
  }

  /**
   * <code>getRotationColumn</code> returns one of three columns specified
   * by the parameter. This column is returned as a <code>Vector3f</code>
   * object.  The value is retrieved as if this quaternion was first normalized.
   *
   * @param i
   *            the column to retrieve. Must be between 0 and 2.
   * @param store
   *            the vector object to store the result in. if null, a new one
   *            is created.
   * @return the column specified by the index.
   */
  public function getRotationColumnStore(i : Int, store : Vector3f) : Vector3f
  {
    if (store == null)
    {
      store = new Vector3f();
    }

    var norm = norm();
    if (norm != 1.0) 
    {
      norm = 1.0 / Math.sqrt(norm);
    }
    
    var xx      = x * x * norm;
    var xy      = x * y * norm;
    var xz      = x * z * norm;
    var xw      = x * w * norm;
    var yy      = y * y * norm;
    var yz      = y * z * norm;
    var yw      = y * w * norm;
    var zz      = z * z * norm;
    var zw      = z * w * norm;
    
    switch (i) 
    {
      case 0:
      {
        store.x  = 1 - 2 * ( yy + zz );
        store.y  =     2 * ( xy + zw );
        store.z  =     2 * ( xz - yw );
      }
      case 1:
      {
        store.x  =     2 * ( xy - zw );
        store.y  = 1 - 2 * ( xx + zz );
        store.z  =     2 * ( yz + xw );
      }
      case 2:
      {
        store.x  =     2 * ( xz + yw );
        store.y  =     2 * ( yz - xw );
        store.z  = 1 - 2 * ( xx + yy );
      }
      default:
      {
        trace("Invalid column index. " + i);
        throw ("Invalid column index. " + i);
      }
    }

    return store;
  }

  /**
   * <code>fromAngleAxis</code> sets this quaternion to the values specified
   * by an angle and an axis of rotation. This method creates an object, so
   * use fromAngleNormalAxis if your axis is already normalized.
   *
   * @param angle
   *            the angle to rotate (in radians).
   * @param axis
   *            the axis of rotation.
   * @return this quaternion
   */
  public function fromAngleAxis(angle : Float, axis : Vector3f) : Quaternion
  {
    var normAxis : Vector3f = axis.normalize();
    fromAngleNormalAxis(angle, normAxis);
    return this;
  }

  /**
   * <code>fromAngleNormalAxis</code> sets this quaternion to the values
   * specified by an angle and a normalized axis of rotation.
   *
   * @param angle
   *            the angle to rotate (in radians).
   * @param axis
   *            the axis of rotation (already normalized).
   */
  public function fromAngleNormalAxis(angle : Float, axis : Vector3f) : Quaternion
  {
    if (axis.x == 0 && axis.y == 0 && axis.z == 0) 
    {
      loadIdentity();
    } 
    else 
    {
      var halfAngle = 0.5 * angle;
      var sin = Math.sin(halfAngle);
      w = Math.cos(halfAngle);
      x = sin * axis.x;
      y = sin * axis.y;
      z = sin * axis.z;
    }

    return this;
  }

  /**
   * <code>toAngleAxis</code> sets a given angle and axis to that
   * represented by the current quaternion. The values are stored as
   * following: The axis is provided as a parameter and built by the method,
   * the angle is returned as a float.
   *
   * @param axisStore
   *            the object we'll store the computed axis in.
   * @return the angle of rotation in radians.
   */
  public function toAngleAxis(axisStore : Vector3f) : Float
  {
    var sqrLength = x * x + y * y + z * z;
    var angle;

    if (sqrLength == 0.0) 
    {
      angle = 0.0;

      if (axisStore != null) 
      {
        axisStore.x = 1.0;
        axisStore.y = 0.0;
        axisStore.z = 0.0;
      }
    } 
    else 
    {
      angle = (2.0 * Math.acos(w));
      
      if (axisStore != null) 
      {
        var invLength = (1.0 / Math.sqrt(sqrLength));
        axisStore.x = x * invLength;
        axisStore.y = y * invLength;
        axisStore.z = z * invLength;
      }
    }

    return angle;
  }

  /**
   * <code>slerp</code> sets this quaternion's value as an interpolation
   * between two other quaternions.
   *
   * @param q1
   *            the first quaternion.
   * @param q2
   *            the second quaternion.
   * @param t
   *            the amount to interpolate between the two quaternions.
   */
  public function slerp(q1 : Quaternion, q2 : Quaternion, t : Float) : Quaternion
  {
    // Create a local quaternion to store the interpolated quaternion
    if (q1.x == q2.x && q1.y == q2.y && q1.z == q2.z && q1.w == q2.w) 
    {
      this.setQuaternion(q1);
      return this;
    }

    var result = (q1.x * q2.x) + (q1.y * q2.y) + (q1.z * q2.z) + (q1.w * q2.w);

    if (result < 0.0) 
    {
      // Negate the second quaternion and the result of the dot product
      q2.x = -q2.x;
      q2.y = -q2.y;
      q2.z = -q2.z;
      q2.w = -q2.w;
      result = -result;
    }

    // Set the first and second scale for the interpolation
    var scale0 = 1 - t;
    var scale1 = t;

    // Check if the angle between the 2 quaternions was big enough to
    // warrant such calculations
    if ((1 - result) > 0.1) 
    {
      // Get the angle between the 2 quaternions,
      // and then store the sin() of that angle
      var theta = Math.acos(result);
      var invSinTheta = 1 / Math.sin(theta);

      // Calculate the scale for q1 and q2, according to the angle and
      // it's sine value
      scale0 = Math.sin((1 - t) * theta) * invSinTheta;
      scale1 = Math.sin((t * theta)) * invSinTheta;
    }

    // Calculate the x, y, z and w values for the quaternion by using a
    // special
    // form of linear interpolation for quaternions.
    this.x = (scale0 * q1.x) + (scale1 * q2.x);
    this.y = (scale0 * q1.y) + (scale1 * q2.y);
    this.z = (scale0 * q1.z) + (scale1 * q2.z);
    this.w = (scale0 * q1.w) + (scale1 * q2.w);

    // Return the interpolated quaternion
    return this;
  }

  /**
   * Sets the values of this quaternion to the slerp from itself to q2 by
   * changeAmnt
   *
   * @param q2
   *            Final interpolation value
   * @param changeAmnt
   *            The amount diffrence
   */
  public function slerpLocal(q2 : Quaternion, changeAmnt : Float) : Void
  {
    if (this.x == q2.x && this.y == q2.y && this.z == q2.z && this.w == q2.w) 
    {
      return;
    }

    var result = (this.x * q2.x) + (this.y * q2.y) + (this.z * q2.z) + (this.w * q2.w);

    if (result < 0.0) 
    {
      // Negate the second quaternion and the result of the dot product
      q2.x = -q2.x;
      q2.y = -q2.y;
      q2.z = -q2.z;
      q2.w = -q2.w;
      result = -result;
    }

    // Set the first and second scale for the interpolation
    var scale0 = 1 - changeAmnt;
    var scale1 = changeAmnt;

    // Check if the angle between the 2 quaternions was big enough to
    // warrant such calculations
    if ((1 - result) > 0.1) 
    {
      // Get the angle between the 2 quaternions, and then store the sin()
      // of that angle
      var theta = Math.acos(result);
      var invSinTheta = 1 / Math.sin(theta);

      // Calculate the scale for q1 and q2, according to the angle and
      // it's sine value
      scale0 = Math.sin((1 - changeAmnt) * theta) * invSinTheta;
      scale1 = Math.sin((changeAmnt * theta)) * invSinTheta;
    }

    // Calculate the x, y, z and w values for the quaternion by using a
    // special
    // form of linear interpolation for quaternions.
    this.x = (scale0 * this.x) + (scale1 * q2.x);
    this.y = (scale0 * this.y) + (scale1 * q2.y);
    this.z = (scale0 * this.z) + (scale1 * q2.z);
    this.w = (scale0 * this.w) + (scale1 * q2.w);
  }

  /**
   * <code>add</code> adds the values of this quaternion to those of the
   * parameter quaternion. The result is returned as a new quaternion.
   *
   * @param q
   *            the quaternion to add to this.
   * @return the new quaternion.
   */
  public function add(q : Quaternion) : Quaternion
  {
    return new Quaternion(x + q.x, y + q.y, z + q.z, w + q.w);
  }

  /**
   * <code>add</code> adds the values of this quaternion to those of the
   * parameter quaternion. The result is stored in this Quaternion.
   *
   * @param q
   *            the quaternion to add to this.
   * @return This Quaternion after addition.
   */
  public function addLocal(q : Quaternion) : Quaternion
  {
    this.x += q.x;
    this.y += q.y;
    this.z += q.z;
    this.w += q.w;
    return this;
  }

  /**
   * <code>subtract</code> subtracts the values of the parameter quaternion
   * from those of this quaternion. The result is returned as a new
   * quaternion.
   *
   * @param q
   *            the quaternion to subtract from this.
   * @return the new quaternion.
   */
  public function subtract(q : Quaternion) : Quaternion
  {
    return new Quaternion(x - q.x, y - q.y, z - q.z, w - q.w);
  }

  /**
   * <code>subtract</code> subtracts the values of the parameter quaternion
   * from those of this quaternion. The result is stored in this Quaternion.
   *
   * @param q
   *            the quaternion to subtract from this.
   * @return This Quaternion after subtraction.
   */
  public function subtractLocal(q : Quaternion) : Quaternion
  {
    this.x -= q.x;
    this.y -= q.y;
    this.z -= q.z;
    this.w -= q.w;
    return this;
  }

  /**
   * <code>mult</code> multiplies this quaternion by a parameter quaternion.
   * The result is returned as a new quaternion. It should be noted that
   * quaternion multiplication is not cummulative so q * p != p * q.
   *
   * @param q
   *            the quaternion to multiply this quaternion by.
   * @return the new quaternion.
   */
  public function mult(q : Quaternion) : Quaternion
  {
    return multStore(q, null);
  }

  /**
   * <code>mult</code> multiplies this quaternion by a parameter quaternion
   * (q).
   * 'this' is not modified.
   * It should be noted that quaternion multiplication is not cummulative so
   * q * p != p * q.
   *
   * It IS safe for q and res to be the same object.
   *
   * @param q the quaternion to multiply this quaternion by.
   * @param res the quaternion to store the result in (may be null).
   *            If non-null, the input values of 'res' will be ignored and
   *            replaced.
   * @return If specified res is null, then a new Quaternion;
   *         otherwise returns the populated 'res'.
   */
  public function multStore(q : Quaternion, res : Quaternion) : Quaternion
  {
    if (res == null)
    {
      res = new Quaternion();
    }

    var qw = q.w; 
    var qx = q.x;
    var qy = q.y;
    var qz = q.z;

    res.x = x * qw + y * qz - z * qy + w * qx;
    res.y = -x * qz + y * qw + z * qx + w * qy;
    res.z = x * qy - y * qx + z * qw + w * qz;
    res.w = -x * qx - y * qy - z * qz + w * qw;
    return res;
  }

  /**
   * <code>apply</code> multiplies this quaternion by a parameter matrix
   * internally.
   *
   * @param matrix
   *            the matrix to apply to this quaternion.
   */
  public function apply(matrix : Matrix3f) : Void
  {
    var oldX = x; 
    var oldY = y; 
    var oldZ = z;
    var oldW = w;

    fromRotationMatrix(matrix);

    var tempX = x; 
    var tempY = y; 
    var tempZ = z; 
    var tempW = w;

    x = oldX * tempW + oldY * tempZ - oldZ * tempY + oldW * tempX;
    y = -oldX * tempZ + oldY * tempW + oldZ * tempX + oldW * tempY;
    z = oldX * tempY - oldY * tempX + oldZ * tempW + oldW * tempZ;
    w = -oldX * tempX - oldY * tempY - oldZ * tempZ + oldW * tempW;
  }

  /**
   *
   * <code>fromAxes</code> creates a <code>Quaternion</code> that
   * represents the coordinate system defined by three axes. These axes are
   * assumed to be orthogonal and no error checking is applied. Thus, the user
   * must insure that the three axes being provided indeed represents a proper
   * right handed coordinate system.
   *
   * @param axis
   *            the array containing the three vectors representing the
   *            coordinate system.
   */
  public function fromAxesArray(axis : Array<Vector3f>) : Quaternion
  {
    if (axis.length != 3)
    {
      throw ("Axis array must have three elements");
    }

    return fromAxes(axis[0], axis[1], axis[2]);
  }

  /**
   *
   * <code>fromAxes</code> creates a <code>Quaternion</code> that
   * represents the coordinate system defined by three axes. These axes are
   * assumed to be orthogonal and no error checking is applied. Thus, the user
   * must insure that the three axes being provided indeed represents a proper
   * right handed coordinate system.
   *
   * @param xAxis vector representing the x-axis of the coordinate system.
   * @param yAxis vector representing the y-axis of the coordinate system.
   * @param zAxis vector representing the z-axis of the coordinate system.
   */
  public function fromAxes(xAxis : Vector3f, yAxis : Vector3f, zAxis : Vector3f) : Quaternion
  {
    return fromRotationMatrix2(xAxis.x, yAxis.x, zAxis.x, xAxis.y, yAxis.y, zAxis.y, xAxis.z, yAxis.z, zAxis.z);
  }

  /**
   *
   * <code>toAxes</code> takes in an array of three vectors. Each vector
   * corresponds to an axis of the coordinate system defined by the quaternion
   * rotation.
   *
   * @param axis
   *            the array of vectors to be filled.
   */
  public function toAxes(axis : Array<Vector3f>) : Void
  {
    var tempMat : Matrix3f = toRotationMatrix3();
    axis[0] = tempMat.getColumnStore(0, axis[0]);
    axis[1] = tempMat.getColumnStore(1, axis[1]);
    axis[2] = tempMat.getColumnStore(2, axis[2]);
  }

  /**
   * <code>mult</code> multiplies this quaternion by a parameter vector. The
   * result is returned as a new vector.
   * 'this' is not modified.
   *
   * @param v
   *            the vector to multiply this quaternion by.
   * @return the new vector.
   */
  public function multVector3(v : Vector3f) : Vector3f
  {
    return multVector3Store(v, null);
  }

  /**
   * <code>mult</code> multiplies this quaternion by a parameter vector. The
   * result is stored in the supplied vector
   * This method is very poorly named, since the specified vector is
   * modified and, contrary to the other *Local methods in this and other jME
   * classes, <b>'this' remains unchanged</b>.
   *
   * Made a static method.
   *
   * @param v the vector which this Quaternion multiplies.
   * @return v
   */
  public function multVector3Local(v : Vector3f) : Vector3f
  {
    var tempX = w * w * v.x + 2 * y * w * v.z - 2 * z * w * v.y + x * x * v.x
            + 2 * y * x * v.y + 2 * z * x * v.z - z * z * v.x - y * y * v.x;
    var tempY = 2 * x * y * v.x + y * y * v.y + 2 * z * y * v.z + 2 * w * z
            * v.x - z * z * v.y + w * w * v.y - 2 * x * w * v.z - x * x
            * v.y;
    v.z = 2 * x * z * v.x + 2 * y * z * v.y + z * z * v.z - 2 * w * y * v.x
            - y * y * v.z + 2 * w * x * v.y - x * x * v.z + w * w * v.z;
    v.x = tempX;
    v.y = tempY;
    return v;
  }

  /**
   * Multiplies this Quaternion by the supplied quaternion. The result is
   * stored in this Quaternion, which is also returned for chaining. Similar
   * to this *= q.
   *
   * @param q
   *            The Quaternion to multiply this one by.
   * @return This Quaternion, after multiplication.
   */
  public function multQuatLocal(q : Quaternion) : Quaternion
  {
    var x1 = x * q.w + y * q.z - z * q.y + w * q.x;
    var y1 = -x * q.z + y * q.w + z * q.x + w * q.y;
    var z1 = x * q.y - y * q.x + z * q.w + w * q.z;
    w = -x * q.x - y * q.y - z * q.z + w * q.w;
    x = x1;
    y = y1;
    z = z1;
    return this;
  }

  /**
   * Multiplies this Quaternion by the supplied quaternion. The result is
   * stored in this Quaternion, which is also returned for chaining. Similar
   * to this *= q.
   *
   * @param qx -
   *            quat x value
   * @param qy -
   *            quat y value
   * @param qz -
   *            quat z value
   * @param qw -
   *            quat w value
   *
   * @return This Quaternion, after multiplication.
   */
  public function multQuatLocal2(qx : Float, qy : Float, qz : Float, qw : Float) : Quaternion
  {
    var x1 = x * qw + y * qz - z * qy + w * qx;
    var y1 = -x * qz + y * qw + z * qx + w * qy;
    var z1 = x * qy - y * qx + z * qw + w * qz;
    w = -x * qx - y * qy - z * qz + w * qw;
    x = x1;
    y = y1;
    z = z1;
    return this;
  }

  /**
   * <code>mult</code> multiplies this quaternion by a parameter vector. The
   * result is returned as a new vector.
   * 'this' is not modified.
   * 
   * @param v
   *            the vector to multiply this quaternion by.
   * @param store
   *            the vector to store the result in. It IS safe for v and store
   *            to be the same object.
   * @return the result vector.
   */
  public function multVector3Store(v : Vector3f, store : Vector3f) : Vector3f
  {
    if (store == null)
    {
      store = new Vector3f();
    }

    if (v.x == 0 && v.y == 0 && v.z == 0) 
    {
      store.set(0, 0, 0);
    } 
    else 
    {
      var vx = v.x; 
      var vy = v.y; 
      var vz = v.z;

      store.x = w * w * vx + 2 * y * w * vz - 2 * z * w * vy + x * x
              * vx + 2 * y * x * vy + 2 * z * x * vz - z * z * vx - y
              * y * vx;
      store.y = 2 * x * y * vx + y * y * vy + 2 * z * y * vz + 2 * w
              * z * vx - z * z * vy + w * w * vy - 2 * x * w * vz - x
              * x * vy;
      store.z = 2 * x * z * vx + 2 * y * z * vy + z * z * vz - 2 * w
              * y * vx - y * y * vz + 2 * w * x * vy - x * x * vz + w
              * w * vz;
    }

    return store;
  }

  /**
   * <code>mult</code> multiplies this quaternion by a parameter scalar. The
   * result is returned as a new quaternion.
   *
   * @param scalar
   *            the quaternion to multiply this quaternion by.
   * @return the new quaternion.
   */
  public function multScalar(scalar : Float) : Quaternion
  {
    return new Quaternion(scalar * x, scalar * y, scalar * z, scalar * w);
  }

  /**
   * <code>mult</code> multiplies this quaternion by a parameter scalar. The
   * result is stored locally.
   *
   * @param scalar
   *            the quaternion to multiply this quaternion by.
   * @return this.
   */
  public function multScalarLocal(scalar : Float) : Quaternion
  {
    w *= scalar;
    x *= scalar;
    y *= scalar;
    z *= scalar;
    return this;
  }

  /**
   * <code>dot</code> calculates and returns the dot product of this
   * quaternion with that of the parameter quaternion.
   *
   * @param q
   *            the quaternion to calculate the dot product of.
   * @return the dot product of this and the parameter quaternion.
   */
  public function dot(q : Quaternion) : Float
  {
    return w * q.w + x * q.x + y * q.y + z * q.z;
  }

  /**
   * <code>norm</code> returns the norm of this quaternion. This is the dot
   * product of this quaternion with itself.
   *
   * @return the norm of the quaternion.
   */
  public function norm() : Float
  {
    return w * w + x * x + y * y + z * z;
  }

  /**
   * <code>normalize</code> normalizes the current <code>Quaternion</code>
   */
  public function normalize() : Void
  {
    var n = 1.0 / Math.sqrt(norm());
    x *= n;
    y *= n;
    z *= n;
    w *= n;
  }

  /**
   * <code>inverse</code> returns the inverse of this quaternion as a new
   * quaternion. If this quaternion does not have an inverse (if its normal is
   * 0 or less), then null is returned.
   *
   * @return the inverse of this quaternion or null if the inverse does not
   *         exist.
   */
  public function inverse() : Quaternion
  {
    var norm = norm();

    if (norm > 0.0) 
    {
      var invNorm = 1.0 / norm;
      return new Quaternion(-x * invNorm, -y * invNorm, -z * invNorm, w * invNorm);
    } 

    // return an invalid result to flag the error
    return null;        
  }

  /**
   * <code>inverse</code> calculates the inverse of this quaternion and
   * returns this quaternion after it is calculated. If this quaternion does
   * not have an inverse (if it's norma is 0 or less), nothing happens
   *
   * @return the inverse of this quaternion
   */
  public function inverseLocal() : Quaternion
  {
    var norm = norm();

    if (norm > 0.0) 
    {
      var invNorm = 1.0 / norm;
      x *= -invNorm;
      y *= -invNorm;
      z *= -invNorm;
      w *= invNorm;
    }

    return this;
  }

  /**
   * <code>negate</code> inverts the values of the quaternion.
   *
   */
  public function negate() : Void
  {
    x *= -1;
    y *= -1;
    z *= -1;
    w *= -1;
  }

  /**
   *
   * <code>toString</code> creates the string representation of this
   * <code>Quaternion</code>. The values of the quaternion are displace
   * (x, y, z, w), in the following manner:
   * <code>[x=1" y=2 z=3 w=1]</code>
   * <p>
   * If you want to display a class name, then use
   * Quaternion.class.getName() or getClass().getName().
   * </p>
   *
   * @return the string representation of this object.
   * @see java.lang.Object#toString()
   */
  public function toString() : String
  {
    return "Quaternion[x=" + x + " y=" + y + " z=" + z + " w=" + w + "]";
  }

  /**
   * <code>equals</code> determines if two quaternions are logically equal,
   * that is, if the values of (x, y, z, w) are the same for both quaternions.
   *
   * @param o
   *            the object to compare for equality
   * @return true if they are equal, false otherwise.
   */
  public function equals(q : Quaternion) : Bool
  {
    return (x == q.x) && (y == q.y) && (z == q.z) && (w == q.w);
  }

  /**
   * 
   * <code>hashCode</code> returns the hash code value as an integer and is
   * supported for the benefit of hashing based collection classes such as
   * Hashtable, HashMap, HashSet etc.
   * 
   * @return the hashcode for this instance of Quaternion.
   * @see java.lang.Object#hashCode()
   */
   /*
  public int hashCode() {
      int hash = 37;
      hash = 37 * hash + Float.floatToIntBits(x);
      hash = 37 * hash + Float.floatToIntBits(y);
      hash = 37 * hash + Float.floatToIntBits(z);
      hash = 37 * hash + Float.floatToIntBits(w);
      return hash;

  }
  */

  private static var tmpYaxis : Vector3f = new Vector3f();
  private static var tmpZaxis : Vector3f = new Vector3f();
  private static var tmpXaxis : Vector3f = new Vector3f();

  /**
   * <code>lookAt</code> is a convienence method for auto-setting the
   * quaternion based on a direction and an up vector. It computes
   * the rotation to transform the z-axis to point into 'direction'
   * and the y-axis to 'up'.
   *
   * @param direction
   *            where to look at in terms of local coordinates
   * @param up
   *            a vector indicating the local up direction.
   *            (typically {0, 1, 0} in jME.)
   */
  public function lookAt(direction : Vector3f, up : Vector3f ) : Void
  {
    tmpZaxis.setFromVector( direction ).normalizeLocal();
    tmpXaxis.setFromVector( up ).crossVectorLocal( direction ).normalizeLocal();
    tmpYaxis.setFromVector( direction ).crossVectorLocal( tmpXaxis ).normalizeLocal();
    fromAxes( tmpXaxis, tmpYaxis, tmpZaxis );
  }

  /**
   * @return A new quaternion that describes a rotation that would point you
   *         in the exact opposite direction of this Quaternion.
   */
  public function opposite() : Quaternion
  {
    return oppositeStore(null);
  }

  /**
   * FIXME: This seems to have singularity type issues with angle == 0, possibly others such as PI.
   * @param store
   *            A Quaternion to store our result in. If null, a new one is
   *            created.
   * @return The store quaternion (or a new Quaterion, if store is null) that
   *         describes a rotation that would point you in the exact opposite
   *         direction of this Quaternion.
   */
  public function oppositeStore(store : Quaternion) : Quaternion
  {
    if (store == null)
    {
      store = new Quaternion();
    }
    
    var axis : Vector3f = new Vector3f();
    var angle : Float = toAngleAxis(axis);

    store.fromAngleAxis(Math.PI + angle, axis);
    return store;
  }

  /**
   * @return This Quaternion, altered to describe a rotation that would point
   *         you in the exact opposite direction of where it is pointing
   *         currently.
   */
  public function oppositeLocal() : Quaternion
  {
    return oppositeStore(this);
  }

  public function clone() : Quaternion
  {
    return new Quaternion(x, y, z, w);
  }
}

