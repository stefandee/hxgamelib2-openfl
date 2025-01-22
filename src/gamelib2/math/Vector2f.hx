package gamelib2.math;

/**
 * <code>Vector2f</code> defines a Vector for a two float value vector.
 * 
 * @author Ported from jMonkeyEngine
 */
class Vector2f
{
	public static var UNIT_X : Vector2f = { new Vector2f(1, 0); }
	public static var UNIT_Y : Vector2f = { new Vector2f(0, 1); }
	public static var UNIT_NEG_X : Vector2f = { new Vector2f(-1, 0); }
	public static var UNIT_NEG_Y : Vector2f = { new Vector2f(0, -1); }

  /**
   * the x value of the vector.
   */
  public var x : Float;

  /**
   * the y value of the vector.
   */
  public var y : Float;

  /**
   * Creates a Vector2f with the given initial x and y values.
   * 
   * @param x
   *            The x value of this Vector2f.
   * @param y
   *            The y value of this Vector2f.
   */
  public function new(?x : Float = 0, ?y : Float = 0) 
  {
    this.x = x;
    this.y = y;
  }

  /**
   * set the x and y values of the vector
   * 
   * @param x
   *            the x value of the vector.
   * @param y
   *            the y value of the vector.
   * @return this vector
   */
  public function setComp(x : Float, y : Float) : Vector2f
  {
    this.x = x;
    this.y = y;
    return this;
  }

  /**
   * set the x and y values of the vector from another vector
   * 
   * @param vec
   *            the vector to copy from
   * @return this vector
   */
  public function set(vec : Vector2f) : Vector2f
  {
    this.x = vec.x;
    this.y = vec.y;
    return this;
  }

  /**
   * <code>addLocal</code> adds a provided vector to this vector internally,
   * and returns a handle to this vector for easy chaining of calls. If the
   * provided vector is null, null is returned.
   * 
   * @param vec
   *            the vector to add to this vector.
   * @return this
   */
  public function addLocal(vec : Vector2f) : Vector2f
  {
    if (null == vec) 
    {
      trace("Warning: Provided vector is null, null returned.");
      return null;
    }

    x += vec.x;
    y += vec.y;

    return this;
  }

  /**
   * <code>addLocal</code> adds the provided values to this vector
   * internally, and returns a handle to this vector for easy chaining of
   * calls.
   * 
   * @param addX
   *            value to add to x
   * @param addY
   *            value to add to y
   * @return this
   */
  public function addCompLocal(addX : Float, addY : Float) : Vector2f
  {
    x += addX;
    y += addY;
    return this;
  }

  /**
   * <code>add</code> adds this vector by <code>vec</code> and stores the
   * result in <code>result</code>.
   * 
   * @param vec
   *            The vector to add.
   * @param result
   *            The vector to store the result in.
   * @return The result vector, after adding.
   */
  public function add(vec : Vector2f, ?result : Vector2f = null) : Vector2f
  {
    if (null == vec) 
    {
      trace("Warning: Provided vector is null, null returned.");
      return null;
    }

    if (result == null)
    {
      result = new Vector2f();
    }

    result.x = x + vec.x;
    result.y = y + vec.y;

    return result;
  }

  /**
   * <code>dot</code> calculates the dot product of this vector with a
   * provided vector. If the provided vector is null, 0 is returned.
   * 
   * @param vec
   *            the vector to dot with this vector.
   * @return the resultant dot product of this vector and a given vector.
   */
  public function dot(vec : Vector2f) : Float
  {
    if (null == vec) 
    {
      trace("Warning: Provided vector is null, 0 returned.");
      return 0;
    }

    return x * vec.x + y * vec.y;
  }

  /**
   * <code>cross</code> calculates the cross product of this vector with a
   * parameter vector v.
   * 
   * @param v
   *            the vector to take the cross product of with this.
   * @return the cross product vector.
   */
  public function cross(v : Vector2f) : Vector3f
  {
    return new Vector3f(0, 0, determinant(v));
  }

  public function determinant(v : Vector2f) : Float
  {
    return (x * v.y) - (y * v.x);
  }
  
  /**
   * Sets this vector to the interpolation by changeAmnt from this to the
   * finalVec this=(1-changeAmnt)*this + changeAmnt * finalVec
   * 
   * @param finalVec
   *            The final vector to interpolate towards
   * @param changeAmnt
   *            An amount between 0.0 - 1.0 representing a percentage change
   *            from this towards finalVec
   */
  public function interpolate(finalVec : Vector2f, changeAmnt : Float) : Void
  {
    this.x = (1 - changeAmnt) * this.x + changeAmnt * finalVec.x;
    this.y = (1 - changeAmnt) * this.y + changeAmnt * finalVec.y;
  }

  /**
   * Sets this vector to the interpolation by changeAmnt from beginVec to
   * finalVec this=(1-changeAmnt)*beginVec + changeAmnt * finalVec
   * 
   * @param beginVec
   *            The begining vector (delta=0)
   * @param finalVec
   *            The final vector to interpolate towards (delta=1)
   * @param changeAmnt
   *            An amount between 0.0 - 1.0 representing a precentage change
   *            from beginVec towards finalVec
   */
  public function interpolateVectors(beginVec : Vector2f, finalVec : Vector2f, changeAmnt : Float) : Void
  {
      this.x = (1 - changeAmnt) * beginVec.x + changeAmnt * finalVec.x;
      this.y = (1 - changeAmnt) * beginVec.y + changeAmnt * finalVec.y;
  }

  /**
   * Check a vector... if it is null or its floats are NaN or infinite, return
   * false. Else return true.
   * 
   * @param vector
   *            the vector to check
   * @return true or false as stated above.
   */
  public static function isValidVector(vector : Vector2f) : Bool
  {
    if (vector == null) return false;
    if (Math.isNaN(vector.x) ||
        Math.isNaN(vector.y)) return false;
    if (!Math.isFinite(vector.x) ||
        !Math.isFinite(vector.y)) return false;
    return true;
  }

  /**
   * <code>length</code> calculates the magnitude of this vector.
   * 
   * @return the length or magnitude of the vector.
   */
  public function length() : Float
  {
    return Math.sqrt(lengthSquared());
  }

  /**
   * <code>lengthSquared</code> calculates the squared value of the
   * magnitude of the vector.
   * 
   * @return the magnitude squared of the vector.
   */
  public function lengthSquared() : Float
  {
    return x * x + y * y;
  }

  /**
   * <code>distanceSquared</code> calculates the distance squared between
   * this vector and vector v.
   *
   * @param v the second vector to determine the distance squared.
   * @return the distance squared between the two vectors.
   */
  public function distanceSqr(v : Vector2f) : Float 
  {
    var dx : Float = x - v.x;
    var dy : Float = y - v.y;
    return (dx * dx + dy * dy);
  }

  /**
   * <code>distanceSquared</code> calculates the distance squared between
   * this vector and vector v.
   *
   * @param v the second vector to determine the distance squared.
   * @return the distance squared between the two vectors.
   */
  public function distanceCompSquared(otherX : Float, otherY : Float) : Float
  {
    var dx = x - otherX;
    var dy = y - otherY;
    return (dx * dx + dy * dy);
  }

  /**
   * <code>distance</code> calculates the distance between this vector and
   * vector v.
   *
   * @param v the second vector to determine the distance.
   * @return the distance between the two vectors.
   */
  public function distance(v : Vector2f) : Float
  {
    return Math.sqrt(distanceSqr(v));
  }

  /**
   * <code>mult</code> multiplies this vector by a scalar. The resultant
   * vector is returned.
   * 
   * @param scalar
   *            the value to multiply this vector by.
   * @return the new vector.
   */
   /*
  public function multScalar(scalar : Float) : Vector2f
  {
    return new Vector2f(x * scalar, y * scalar);
  }
  */

  /**
   * <code>multLocal</code> multiplies this vector by a scalar internally,
   * and returns a handle to this vector for easy chaining of calls.
   * 
   * @param scalar
   *            the value to multiply this vector by.
   * @return this
   */
  public function multScalarLocal(scalar : Float) : Vector2f
  {
    x *= scalar;
    y *= scalar;
    return this;
  }

  /**
   * <code>multLocal</code> multiplies a provided vector to this vector
   * internally, and returns a handle to this vector for easy chaining of
   * calls. If the provided vector is null, null is returned.
   * 
   * @param vec
   *            the vector to mult to this vector.
   * @return this
   */
  public function multLocal(vec : Vector2f) : Vector2f
  {
    if (null == vec) 
    {
        trace("Warning: Provided vector is null, null returned.");
        return null;
    }
    x *= vec.x;
    y *= vec.y;
    return this;
  }

  /**
   * Multiplies this Vector2f's x and y by the scalar and stores the result in
   * product. The result is returned for chaining. Similar to
   * product=this*scalar;
   * 
   * @param scalar
   *            The scalar to multiply by.
   * @param product
   *            The vector2f to store the result in.
   * @return product, after multiplication.
   */
  public function multScalar(scalar : Float, ?product : Vector2f = null) : Vector2f
  {
    if (null == product) 
    {
      product = new Vector2f();
    }

    product.x = x * scalar;
    product.y = y * scalar;

    return product;
  }

  public function mult(vec : Vector2f, ?product : Vector2f = null) : Vector2f
  {
    if (null == product) 
    {
      product = new Vector2f();
    }

    product.x = x * vec.x;
    product.y = y * vec.y;

    return product;
  }

  /**
   * <code>divide</code> divides the values of this vector by a scalar and
   * returns the result. The values of this vector remain untouched.
   * 
   * @param scalar
   *            the value to divide this vectors attributes by.
   * @return the result <code>Vector</code>.
   */
  public function divideScalar(scalar : Float) : Vector2f
  {
    return new Vector2f(x / scalar, y / scalar);
  }

  /**
   * <code>divideLocal</code> divides this vector by a scalar internally,
   * and returns a handle to this vector for easy chaining of calls. Dividing
   * by zero will result in an exception.
   * 
   * @param scalar
   *            the value to divides this vector by.
   * @return this
   */
  public function divideScalarLocal(scalar : Float) : Vector2f
  {
    x /= scalar;
    y /= scalar;
    return this;
  }

  public function divideLocal(vec : Vector2f) : Vector2f
  {
    x /= vec.x;
    y /= vec.y;
    return this;
  }

  /**
   * <code>negate</code> returns the negative of this vector. All values are
   * negated and set to a new vector.
   * 
   * @return the negated vector.
   */
  public function negate() : Vector2f 
  {
    return new Vector2f(-x, -y);
  }

  /**
   * <code>negateLocal</code> negates the internal values of this vector.
   * 
   * @return this.
   */
  public function negateLocal() : Vector2f
  {
    x = -x;
    y = -y;
    return this;
  }

  /**
   * <code>subtract</code> subtracts the values of a given vector from those
   * of this vector storing the result in the given vector object. If the
   * provided vector is null, an exception is thrown.
   * 
   * @param vec
   *            the vector to subtract from this vector.
   * @param store
   *            the vector to store the result in. It is safe for this to be
   *            the same as vec. If null, a new vector is created.
   * @return the result vector.
   */
  public function subtract(vec : Vector2f, ?store : Vector2f = null) : Vector2f
  {
    if (store == null)
    {
      store = new Vector2f();
    }

    store.x = x - vec.x;
    store.y = y - vec.y;
    return store;
  }

  /**
   * <code>subtract</code> subtracts the given x,y values from those of this
   * vector creating a new vector object.
   * 
   * @param valX
   *            value to subtract from x
   * @param valY
   *            value to subtract from y
   * @return this
   */
  public function subtractComp(valX : Float, valY : Float) : Vector2f
  {
    return new Vector2f(x - valX, y - valY);
  }

  /**
   * <code>subtractLocal</code> subtracts a provided vector to this vector
   * internally, and returns a handle to this vector for easy chaining of
   * calls. If the provided vector is null, null is returned.
   * 
   * @param vec
   *            the vector to subtract
   * @return this
   */
  public function subtractLocal(vec : Vector2f) : Vector2f
  {
    if (null == vec) 
    {
      trace("Warning: Provided vector is null, null returned.");
      return null;
    }
    x -= vec.x;
    y -= vec.y;
    return this;
  }

  /**
   * <code>subtractLocal</code> subtracts the provided values from this
   * vector internally, and returns a handle to this vector for easy chaining
   * of calls.
   * 
   * @param valX
   *            value to subtract from x
   * @param valY
   *            value to subtract from y
   * @return this
   */
  public function subtractCompLocal(valX : Float, valY : Float) : Vector2f
  {
    x -= valX;
    y -= valY;
    return this;
  }

  /**
   * <code>normalize</code> returns the unit vector of this vector.
   * 
   * @return unit vector of this vector.
   */
  public function normalize() : Vector2f
  {
    var length = length();

    if (length != 0) 
    {
      return divideScalar(length);
    }

    return divideScalar(1);
  }

  /**
   * <code>normalizeLocal</code> makes this vector into a unit vector of
   * itself.
   * 
   * @return this.
   */
  public function normalizeLocal() : Vector2f
  {
    var length = length();

    if (length != 0) 
    {
      return divideScalarLocal(length);
    }

    return divideScalarLocal(1);
  }

  /**
   * <code>smallestAngleBetween</code> returns (in radians) the minimum
   * angle between two vectors. It is assumed that both this vector and the
   * given vector are unit vectors (iow, normalized).
   * 
   * @param otherVector
   *            a unit vector to find the angle against
   * @return the angle in radians.
   */
  public function smallestAngleBetween(otherVector : Vector2f) : Float
  {
    var dotProduct = dot(otherVector);
    var angle = Math.acos(dotProduct);
    return angle;
  }

  /**
   * <code>angleBetween</code> returns (in radians) the angle required to
   * rotate a ray represented by this vector to lie colinear to a ray
   * described by the given vector. It is assumed that both this vector and
   * the given vector are unit vectors (iow, normalized).
   * 
   * @param otherVector
   *            the "destination" unit vector
   * @return the angle in radians.
   */
  public function angleBetween(otherVector : Vector2f) : Float
  {
    var angle = Math.atan2(otherVector.y, otherVector.x) - Math.atan2(y, x);
    return angle;
  }
  
  /*
  public float getX() {
      return x;
  }

  public void setX(float x) {
      this.x = x;
  }

  public float getY() {
      return y;
  }

  public void setY(float y) {
      this.y = y;
  }
  */

  /**
   * <code>getAngle</code> returns (in radians) the angle represented by
   * this Vector2f as expressed by a conversion from rectangular coordinates (<code>x</code>,&nbsp;<code>y</code>)
   * to polar coordinates (r,&nbsp;<i>theta</i>).
   * 
   * @return the angle in radians. [-pi, pi)
   */
  public function getAngle() : Float
  {
    //return -Math.atan2(y, x);
    return Math.atan2(y, x);
  }

  /**
   * <code>zero</code> resets this vector's data to zero internally.
   */
  public function zero() : Void
  {
    x = 0;
    y = 0;
  }

  /**
   * <code>hashCode</code> returns a unique code for this vector object
   * based on it's values. If two vectors are logically equivalent, they will
   * return the same hash code value.
   * 
   * @return the hash code value of this vector.
   */
  /*
  public int hashCode() {
      int hash = 37;
      hash += 37 * hash + Float.floatToIntBits(x);
      hash += 37 * hash + Float.floatToIntBits(y);
      return hash;
  }
  */

  public function clone() : Vector2f
  {
    return new Vector2f(x, y);
  }

  /**
   * Saves this Vector2f into the given float[] object.
   * 
   * @param floats
   *            The float[] to take this Vector2f. If null, a new float[2] is
   *            created.
   * @return The array, with X, Y float values in that order
   */
  public function toArray(floats : Array<Float>) : Array<Float>
  {
    if (floats == null) 
    {
      floats = new Array();
    }

    floats.push(x);
    floats.push(y);

    return floats;
  }

  /**
   * are these two vectors the same? they are is they both have the same x and
   * y values.
   * 
   * @param o
   *            the object to compare for equality
   * @return true if they are equal
   */
  public function equals(vec : Vector2f)  : Bool
  {
    return (vec.x == x) && (vec.y == y);
  }

  /**
   * <code>toString</code> returns the string representation of this vector.
   * The format is: <code>(xx.x..., yy.y...)</code>
   * <p>
   * If you want to display a class name, then use
   * Vector2f.class.getName() or getClass().getName().
   * </p>
   *
   * @return the string representation of this vector.
   */
  public function toString() : String
  {
    return "(" + x + ", " + y + ')';
  }

  public function rotateAroundOrigin(angle : Float, cw : Bool) : Void
  {
    if (cw)
    {
      angle = -angle;
    }

    var newX : Float = Math.cos(angle) * x - Math.sin(angle) * y;
    var newY : Float = Math.sin(angle) * x + Math.cos(angle) * y;
    x = newX;
    y = newY;
  }

  public function transformLocal(m : Matrix3f) : Void
  {
    var sx = this.x;
    var sy = this.y;
    
    this.x = m.m00 * sx + m.m01 * sy + m.m02;
    this.y = m.m10 * sx + m.m11 * sy + m.m12;
  }

  public function transform(m : Matrix3f) : Vector2f
  {
    var sx = this.x;
    var sy = this.y;

    return new Vector2f(m.m00 * sx + m.m01 * sy + m.m02, m.m10 * sx + m.m11 * sy + m.m12);
  }
}
