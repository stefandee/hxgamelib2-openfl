package gamelib2.math;

/**
 * <code>Ray</code> defines a line segment which has an origin and a direction.
 * That is, a point and an infinite ray is cast from this point. The ray is
 * defined by the following equation: R(t) = origin + t*direction for t >= 0.
 * 
 * @author ported to Haxe
 */
class Ray
{
  /** The ray's begining point. */
  public var origin : Vector3f;
  /** The direction of the ray. */
  public var direction : Vector3f;
  
  private static var tempVa : Vector3f = new Vector3f();
  private static var tempVb : Vector3f = new Vector3f();
  private static var tempVc : Vector3f = new Vector3f();
  private static var tempVd : Vector3f =new Vector3f();

  /**
   * Constructor instantiates a new <code>Ray</code> object. As default, the
   * origin is (0,0,0) and the direction is (0,0,0).
   *
   */
  public function new() 
  {
    origin = new Vector3f();
    direction = new Vector3f();
  }

  /**
   * <code>intersect</code> determines if the Ray intersects a triangle.
   * @param t the Triangle to test against.
   * @return true if the ray collides.
   */
  public function intersectTriangle(t : Triangle) : Bool
  {
    return intersect(t.get(0), t.get(1), t.get(2));
  }

  /**
   * <code>intersect</code> determines if the Ray intersects a triangle
   * defined by the specified points.
   *
   * @param v0
   *            first point of the triangle.
   * @param v1
   *            second point of the triangle.
   * @param v2
   *            third point of the triangle.
   * @return true if the ray collides.
   */
  public function intersect(v0 : Vector3f, v1 : Vector3f, v2 : Vector3f) : Bool
  {
    return intersectWhere(v0, v1, v2, null);
  }

  /**
   * <code>intersectWhere</code> determines if the Ray intersects a triangle. It then
   * stores the point of intersection in the given loc vector
   * @param t the Triangle to test against.
   * @param loc
   *            storage vector to save the collision point in (if the ray
   *            collides)
   * @return true if the ray collides.
   */
  public function intersectTriangleWhere(t : Triangle, loc : Vector3f) : Bool
  {
    return intersectWhere(t.get(0), t.get(1), t.get(2), loc);
  }

  /**
   * <code>intersectWhere</code> determines if the Ray intersects a triangle
   * defined by the specified points and if so it stores the point of
   * intersection in the given loc vector.
   *
   * @param v0
   *            first point of the triangle.
   * @param v1
   *            second point of the triangle.
   * @param v2
   *            third point of the triangle.
   * @param loc
   *            storage vector to save the collision point in (if the ray
   *            collides)  if null, only boolean is calculated.
   * @return true if the ray collides.
   */
  public function intersectWhere(v0 : Vector3f, v1 : Vector3f, v2 : Vector3f, loc : Vector3f) : Bool
  {
    return intersects(v0, v1, v2, loc, false, false );
  }

  /**
   * <code>intersectWherePlanar</code> determines if the Ray intersects a
   * triangle and if so it stores the point of
   * intersection in the given loc vector as t, u, v where t is the distance
   * from the origin to the point of intersection and u,v is the intersection
   * point in terms of the triangle plane.
   *
   * @param t the Triangle to test against.
   * @param loc
   *            storage vector to save the collision point in (if the ray
   *            collides) as t, u, v
   * @return true if the ray collides.
   */
  public function intersectTriangleWherePlanar(t : Triangle, loc : Vector3f) : Bool
  {
    return intersectWherePlanar(t.get(0), t.get(1), t.get(2), loc);
  }

  /**
   * <code>intersectWherePlanar</code> determines if the Ray intersects a
   * triangle defined by the specified points and if so it stores the point of
   * intersection in the given loc vector as t, u, v where t is the distance
   * from the origin to the point of intersection and u,v is the intersection
   * point in terms of the triangle plane.
   *
   * @param v0
   *            first point of the triangle.
   * @param v1
   *            second point of the triangle.
   * @param v2
   *            third point of the triangle.
   * @param loc
   *            storage vector to save the collision point in (if the ray
   *            collides) as t, u, v
   * @return true if the ray collides.
   */
  public function intersectWherePlanar(v0 : Vector3f, v1 : Vector3f, v2 : Vector3f, loc : Vector3f) : Bool
  {
    return intersects(v0, v1, v2, loc, true, false );
  }

  /**
   * <code>intersects</code> does the actual intersection work.
   *
   * @param v0
   *            first point of the triangle.
   * @param v1
   *            second point of the triangle.
   * @param v2
   *            third point of the triangle.
   * @param store
   *            storage vector - if null, no intersection is calc'd
   * @param doPlanar
   *            true if we are calcing planar results.
   * @param quad
   * @return true if ray intersects triangle
   */
  private function intersects( v0 : Vector3f, v1 : Vector3f, v2 : Vector3f,
                               store : Vector3f, doPlanar : Bool, quad : Bool ) : Bool
  {
    var diff  : Vector3f = origin.subtractVector(v0, tempVa);
    var edge1 : Vector3f = v1.subtractVector(v0, tempVb);
    var edge2 : Vector3f = v2.subtractVector(v0, tempVc);
    var norm  : Vector3f = edge1.crossVector(edge2, tempVd);

    var dirDotNorm : Float = direction.dot(norm);
    var sign : Float;

    if (dirDotNorm > MathEx.FLT_EPSILON_ABCD) 
    {
      sign = 1.0;
    } 
    else if (dirDotNorm < -MathEx.FLT_EPSILON_ABCD) 
    {
      sign = -1.0;
      dirDotNorm = -dirDotNorm;
    } 
    else 
    {
      // ray and triangle/quad are parallel
      return false;
    }

    var dirDotDiffxEdge2 : Float = sign * direction.dot(diff.crossVector(edge2, edge2));

    if (dirDotDiffxEdge2 >= 0.0) 
    {
      var dirDotEdge1xDiff : Float = sign * direction.dot(edge1.crossVectorLocal(diff));

      if (dirDotEdge1xDiff >= 0.0) 
      {
        if ( !quad ? dirDotDiffxEdge2 + dirDotEdge1xDiff <= dirDotNorm : dirDotEdge1xDiff <= dirDotNorm ) 
        {
          var diffDotNorm : Float = -sign * diff.dot(norm);
          
          if (diffDotNorm >= 0.0) 
          {
            // ray intersects triangle
            // if storage vector is null, just return true,
            if (store == null)
            {
              return true;
            }

            // else fill in.
            var inv = 1.0 / dirDotNorm;
            var t = diffDotNorm * inv;

            if (!doPlanar) 
            {
              store.setFromVector(origin).addLocal(direction.x * t,
                      direction.y * t, direction.z * t);
            } 
            else 
            {
              // these weights can be used to determine
              // interpolated values, such as texture coord.
              // eg. texcoord s,t at intersection point:
              // s = w0*s0 + w1*s1 + w2*s2;
              // t = w0*t0 + w1*t1 + w2*t2;
              var w1 = dirDotDiffxEdge2 * inv;
              var w2 = dirDotEdge1xDiff * inv;
              //float w0 = 1.0f - w1 - w2;
              store.set(t, w1, w2);
            }

            return true;
          }
        }
      }
    }

    return false;
  }
  
  /**
   * <code>intersectWherePlanar</code> determines if the Ray intersects a
   * quad defined by the specified points and if so it stores the point of
   * intersection in the given loc vector as t, u, v where t is the distance
   * from the origin to the point of intersection and u,v is the intersection
   * point in terms of the quad plane.
   * One edge of the quad is [v0,v1], another one [v0,v2]. The behaviour thus is like
   * {@link #intersectWherePlanar(Vector3f, Vector3f, Vector3f, Vector3f)} except for
   * the extended area, which is equivalent to the union of the triangles [v0,v1,v2]
   * and [-v0+v1+v2,v1,v2].
   *
   * @param v0
   *            top left point of the quad.
   * @param v1
   *            top right point of the quad.
   * @param v2
   *            bottom left point of the quad.
   * @param loc
   *            storage vector to save the collision point in (if the ray
   *            collides) as t, u, v
   * @return true if the ray collides with the quad.
   */
  public function intersectWherePlanarQuad( v0 : Vector3f, v1 : Vector3f, v2 : Vector3f,
                                            loc : Vector3f) : Bool
  {
    return intersects( v0, v1, v2, loc, true, true );
  }
  
  /**
   * 
   * @param p
   * @param loc
   * @return true if the ray collides with the given Plane
   */
  public function intersectsWherePlane(p : Plane, loc : Vector3f) : Bool
  {
    var denominator : Float = p.normal.dot(direction);

    if (denominator > -MathEx.FLT_EPSILON_ABCD && denominator < MathEx.FLT_EPSILON_ABCD)
    {
      return false; // coplanar
    }

    var numerator = -(p.normal.dot(origin) - p.constant);
    var ratio = numerator / denominator;

    if (ratio < MathEx.FLT_EPSILON_ABCD)
    {
      return false; // intersects behind origin
    }

    loc.setFromVector(direction).multScalarLocal(ratio).addVectorLocal(origin);

    return true;
  }
  
  public function distanceSquared(point : Vector3f) : Float
  {
    point.subtractVector(origin, tempVa);
    
    var rayParam = direction.dot(tempVa);
    
    if (rayParam > 0) 
    {
      origin.addVector(direction.multScalar(rayParam, tempVb), tempVb);
    } 
    else 
    {
      tempVb.setFromVector(origin);
      rayParam = 0.0;
    }

    tempVb.subtractVector(point, tempVa);
    return tempVa.lengthSquared();
  }

  /**
   * Copies information from a source ray into this ray.
   * 
   * @param source
   *            the ray to copy information from
   */
  public function set(source : Ray) : Void
  {
    origin.setFromVector(source.origin);
    direction.setFromVector(source.direction);
  }

  public function clone() : Ray
  {
    var r : Ray = new Ray();
    r.direction = direction.clone();
    r.origin = direction.clone();
    return r;
  }
}

