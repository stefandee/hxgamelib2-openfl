package gamelib2.bounding;

import gamelib2.math.Vector2f;
import gamelib2.math.Vector3f;
import gamelib2.math.Matrix3f;
//import gamelib2.math.Quaternion;
import gamelib2.math.Ray;
import gamelib2.math.Plane;
import gamelib2.math.MathTypes;
import gamelib2.intersection.IntersectionRecord;

enum BoundingAreaType 
{
  Disk;
  AABB;
  OBB;
}

/**
 * <code>BoundingVolume</code> defines an interface for dealing with
 * containment of a collection of points.
 * 
 * @author Mark Powell
 * @version $Id: BoundingVolume.java 4131 2009-03-19 20:15:28Z blaine.dev $
 */
class BoundingArea
{	
	public var checkPlane : Int;
  public var type       : Null<BoundingAreaType>;
  public var center     : Vector2f;
	
	private static var _compVect1 : Vector2f = new Vector2f();
	private static var _compVect2 : Vector2f = new Vector2f();
	private static var _compVect3 : Vector2f = new Vector2f();

	private static var _compVect3f : Vector3f = new Vector3f();

  private static var _compMat : Matrix3f = new Matrix3f();

	private function new(?center : Vector2f = null) 
  {
    checkPlane = 0;

    if (center == null)
    {
      this.center = new Vector2f();
    }
    else
    {
      this.center.set(center);
    }

    type = null;
  }

	/**
	 * 
	 * <code>transform</code> alters the location of the bounding volume by a
	 * rotation, translation and a scalar.
	 * 
	 * @param rotate
	 *            the rotation to affect the bound.
	 * @param translate
	 *            the translation to affect the bound.
	 * @param scale
	 *            the scale to resize the bound.
	 * @param store
	 *            sphere to store result in
	 * @return the new bounding volume.
	 */
	public function transform(rotate : Matrix3f, translate : Vector2f, scale : Vector2f, ?store : BoundingArea = null) : BoundingArea
  {
    return null;
  }

	/**
	 * 
	 * <code>whichSide</code> returns the side on which the bounding volume
	 * lies on a plane. Possible values are POSITIVE_SIDE, NEGATIVE_SIDE, and
	 * NO_SIDE.
	 * 
	 * @param plane
	 *            the plane to check against this bounding volume.
	 * @return the side on which this bounding volume lies.
	 */
	public function whichSide(ray : Ray) : Null<Side>
  {
    return null;
  }

	/**
	 * 
	 * <code>computeFromPoints</code> generates a bounding volume that
	 * encompasses a collection of points.
	 * 
	 * @param points
	 *            the points to contain.
	 */
	public function computeFromPoints(points : Array<Vector2f>) : Void
  {
  }

	/**
	 * <code>merge</code> combines two bounding volumes into a single bounding
	 * volume that contains both this bounding volume and the parameter volume.
	 * 
	 * @param volume
	 *            the volume to combine.
	 * @return the new merged bounding volume.
	 */
	public function merge(volume : BoundingArea) : BoundingArea
  {
    return null;
  }

	/**
	 * <code>mergeLocal</code> combines two bounding volumes into a single
	 * bounding volume that contains both this bounding volume and the parameter
	 * volume. The result is stored locally.
	 * 
	 * @param volume
	 *            the volume to combine.
	 * @return this
	 */
	public function mergeLocal(volume : BoundingArea) : BoundingArea
  {
    return null;
  }

	/**
	 * <code>clone</code> creates a new BoundingVolume object containing the
	 * same data as this one.
	 * 
	 * @param store
	 *            where to store the cloned information. if null or wrong class,
	 *            a new store is created.
	 * @return the new BoundingVolume
	 */
	public function clone(?store : BoundingArea = null) : BoundingArea
  {
    return null;
  }

	
  /**
   * Find the distance from the center of this Bounding Volume to the given
   * point.
   * 
   * @param point
   *            The point to get the distance to
   * @return distance
   */
  public function distanceTo(point : Vector2f) : Float
  {
    return center.distance(point);
  }

  /**
   * Find the squared distance from the center of this Bounding Volume to the
   * given point.
   * 
   * @param point
   *            The point to get the distance to
   * @return distance
   */
  public function distanceToSqr(point : Vector2f) : Float
  {
    return center.distanceSqr(point);
  }

  /**
   * Find the distance from the nearest edge of this Bounding Volume to the given
   * point.
   * 
   * @param point
   *            The point to get the distance to
   * @return distance
   */
  public function distanceToEdge(point : Vector2f) : Float
  {
    return 0;
  }
    
	/**
	 * determines if this bounding volume and a second given volume are
	 * intersecting. Intersecting being: one volume contains another, one volume
	 * overlaps another or one volume touches another.
	 * 
	 * @param bv
	 *            the second volume to test against.
	 * @return true if this volume intersects the given volume.
	 */
	public function intersects(bv : BoundingArea) : Bool
  {
    return false;
  }

	/**
	 * determines if a ray intersects this bounding volume.
	 * 
	 * @param ray
	 *            the ray to test.
	 * @return true if this volume is intersected by a given ray.
	 */
	public function intersectsRay(ray : Ray) : Bool
  {
    return false;
  }

  /**
   * determines if a ray intersects this bounding volume and if so, where.
   * 
   * @param ray
   *            the ray to test.
   * @return an IntersectionRecord containing information about any
   *         intersections made by the given Ray with this bounding
   */
  public function intersectsRayWhere(ray : Ray) : IntersectionRecord
  {
    return null;
  }

	/**
	 * determines if this bounding volume and a given bounding sphere are
	 * intersecting.
	 * 
	 * @param bs
	 *            the bounding sphere to test against.
	 * @return true if this volume intersects the given bounding sphere.
	 */
	//public abstract boolean intersectsSphere(BoundingSphere bs);

	/**
	 * determines if this bounding volume and a given bounding box are
	 * intersecting.
	 * 
	 * @param bb
	 *            the bounding box to test against.
	 * @return true if this volume intersects the given bounding box.
	 */
  public function intersectsBoundingRect(bb : BoundingRect) : Bool
  {
    return false;
  }

	/**
	 * determines if this bounding volume and a given bounding box are
	 * intersecting.
	 * 
	 * @param bb
	 *            the bounding box to test against.
	 * @return true if this volume intersects the given bounding box.
	 */
	//public abstract boolean intersectsOrientedBoundingBox(OrientedBoundingBox bb);
	
	/**
	 * determins if this bounding volume and a given bounding capsule are
	 * intersecting.
	 * @param bc the bounding capsule to test against.
	 * @return true if this volume instersects the given bounding capsule.
	 */
	//public abstract boolean intersectsCapsule(BoundingCapsule bc);
    
  /**
   * 
   * determines if a given point is contained within this bounding volume.
   * 
   * @param point
   *            the point to check
   * @return true if the point lies within this bounding volume.
   */
  public function contains(point : Vector2f) : Bool
  {
    return false;
  }
  
  public function toString() : String
  {
    return "BoundingArea";
  }
}

