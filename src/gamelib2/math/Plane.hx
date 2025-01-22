package gamelib2.math;

import gamelib2.math.MathTypes;

/**
 * A plane in 3D space.
 * <p>
 * The plane is defined by a vector, <i>N</i> which is normal to the plane; and
 * a constant, <i>C</i>, representing the distance of the plane from the
 * origin. The plane can be represented by the equation <i>C = Nâp</i> where
 * <i>p</p> is a point on the plane.
 *
 * @author ported to Haxe
 */
class Plane
{
  /** Vector normal to the plane. */
  public var normal : Vector3f;

  /** Constant of the plane. See formula in class definition. */
  public var constant : Float;

  /**
   * Constructor instantiates a new <code>Plane</code> object. The normal
   * and constant values are set at creation.
   * 
   * @param normal
   *            the normal of the plane.
   * @param constant
   *            the constant of the plane.
   */
  public function new(?normal : Vector3f = null, ?constant : Float = 0) 
  {
    if (normal == null) 
    {
      trace("Plane initialized witha a null normal, created default normal.");
      normal = new Vector3f();
    }

    this.normal = normal;
    this.constant = constant;
  }

  /**
   * <code>pseudoDistance</code> calculates the distance from this plane to
   * a provided point. If the point is on the negative side of the plane the
   * distance returned is negative, otherwise it is positive. If the point is
   * on the plane, it is zero.
   * 
   * @param point
   *            the point to check.
   * @return the signed distance from the plane to a point.
   */
  public function pseudoDistance(point : Vector3f) : Float
  {
    return normal.dot(point) - constant;
  }

  /**
   * Determine on which side of this plane the point {@code p} lies.
   * 
   * @param p the point to check.
   * @return the side at which the point lies.
   */
  public function whichSide(p : Vector3f) : Side
  {
    var dis = pseudoDistance(p);
    if (dis < 0) { return Side.NEGATIVE; }
    if (dis > 0) { return Side.POSITIVE; }
    return Side.NONE;
  }

  /**
   * Initialize this plane using the three points of the given triangle.
   * 
   * @param t
   *            the triangle
   */
  public function setPlaneByTriangle(t : Triangle) : Void
  {
    setPlanePoints(t.get(0), t.get(1), t.get(2));
  }

  /**
   * Initialize the Plane using the given 3 points as coplanar.
   * 
   * @param v1
   *            the first point
   * @param v2
   *            the second point
   * @param v3
   *            the third point
   */
  public function setPlanePoints(v1 : Vector3f, v2 : Vector3f, v3 : Vector3f) : Void
  {
    normal.setFromVector(v2).subtractVectorLocal(v1);
    normal.crossLocal(v3.x - v1.x, v3.y - v1.y, v3.z - v1.z)
            .normalizeLocal();
    constant = normal.dot(v1);
  }

  /**
   * <code>toString</code> returns a string that represents the string
   * representation of this plane. 
   * 
   * @return the string representation of this plane.
   */
  public function toString() : String
  {
      return "Plane[" + normal.toString() + " - " + constant + "]";
  }

  public function clone() : Plane
  {
    var p = new Plane(this.normal.clone(), constant);
    return p;
  }
}