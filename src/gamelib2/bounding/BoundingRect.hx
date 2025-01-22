package gamelib2.bounding;

import gamelib2.math.Vector2f;
import gamelib2.math.Vector3f;
import gamelib2.math.Matrix3f;
import gamelib2.math.Ray;
import gamelib2.math.MathTypes;
import gamelib2.math.Rect;
import gamelib2.intersection.IntersectionRecord;
import gamelib2.bounding.BoundingArea;

/**
 * Axis-Aligned Bounding Rectangle 
 *
 * @author Karg
 */
class BoundingRect extends BoundingArea
{
  public var xExtent : Float;
  public var yExtent : Float;

  /**
   * Default constructor instantiates a new <code>BoundingBox</code>
   * object.
   */
  public function new(?center : Vector2f = null, ?xExtent : Float = 0, ?yExtent : Float = 0) 
  {
    super(center);
    
    type = BoundingAreaType.AABB;

    this.xExtent = xExtent;
    this.yExtent = yExtent;
  }

  /**
   * Contstructor instantiates a new <code>BoundingBox</code> object with
   * given specs.
   */
  public function set(c : Vector2f, x : Float, y : Float) 
  {
    this.center.set(c);
    this.xExtent = x;
    this.yExtent = y;
  }

  public function setRect(r : Rect)
  {
    center.x = (r.left + r.right) / 2;
    center.y = (r.top + r.bottom) / 2;

    xExtent = r.width / 2;
    yExtent = r.height / 2;
  }

  /**
   * <code>computeFromPoints</code> creates a new Bounding Box from a given
   * set of points. It uses the <code>containAABB</code> method as default.
   * 
   * @param points
   *            the points to contain.
   */
  public override function computeFromPoints(points : Array<Vector2f>) : Void
  {
    containAABB(points);
  }

  /**
   * <code>containAABB</code> creates a minimum-volume axis-aligned bounding
   * box of the points, then selects the smallest enclosing sphere of the box
   * with the sphere centered at the boxes center.
   * 
   * @param points
   *            the list of points.
   */
  public function containAABB(points : Array<Vector2f>) : Void
  {
    if (points == null)
    {
      return;
    }

    if (points.length < 1)
    {
      return;
    }

    var minX = points[0].x; 
    var maxX = points[0].x; 

    var minY = points[0].y;
    var maxY = points[0].y;

    for (p in points) 
    {
      if (p.x < minX)
          minX = p.x;
      else if (p.x > maxX)
          maxX = p.x;

      if (p.y < minY)
          minY = p.y;
      else if (p.y > maxY)
          maxY = p.y;
    }

    center.setComp(minX + maxX, minY + maxY);
    center.multScalarLocal(0.5);

    xExtent = maxX - center.x;
    yExtent = maxY - center.y;
  }

  /**
   * <code>transform</code> modifies the center of the box to reflect the
   * change made via a rotation, translation and scale.
   * 
   * @param rotate
   *            the rotation change.
   * @param translate
   *            the translation change.
   * @param scale
   *            the size change.
   * @param store
   *            box to store result in
   */
  public override function transform(rotate : Matrix3f, translate : Vector2f, scale : Vector2f, ?store : BoundingArea = null) : BoundingArea
  {
      var rect : BoundingRect;
      
      if (store == null || !Std.is(store, BoundingRect)) 
      {
        rect = new BoundingRect();
      } 
      else 
      {
        rect = cast store;
      }

      // alias
      var transMatrix = BoundingArea._compMat;

      BoundingArea._compVect3f.set(0, 0, 1);

      //transMatrix.fromAngleNormalAxis(rotate, BoundingArea._compVect3f);
      transMatrix.copy(rotate);
      
      center.mult(scale, rect.center);
      rect.center.transformLocal(transMatrix);
      rect.center.addLocal(translate);

      // Make the rotation matrix all positive to get the maximum x/y/z extent
      transMatrix.m00 = Math.abs(transMatrix.m00);
      transMatrix.m01 = Math.abs(transMatrix.m01);
      //transMatrix.m02 = Math.abs(transMatrix.m02);
      transMatrix.m10 = Math.abs(transMatrix.m10);
      transMatrix.m11 = Math.abs(transMatrix.m11);
      //transMatrix.m12 = Math.abs(transMatrix.m12);
      //transMatrix.m20 = Math.abs(transMatrix.m20);
      //transMatrix.m21 = Math.abs(transMatrix.m21);
      //transMatrix.m22 = Math.abs(transMatrix.m22);

      BoundingArea._compVect1.setComp(xExtent * scale.x, yExtent * scale.y);
      transMatrix.multVector2(BoundingArea._compVect1, BoundingArea._compVect2);

      rect.xExtent = Math.abs(BoundingArea._compVect2.x);
      rect.yExtent = Math.abs(BoundingArea._compVect2.y);


      /*
      center.mult(scale, box.center);
      rotate.mult(box.center, box.center);
      box.center.addLocal(translate);

      Matrix3f transMatrix = _compMat;
      transMatrix.set(rotate);
      // Make the rotation matrix all positive to get the maximum x/y/z extent
      transMatrix.m00 = FastMath.abs(transMatrix.m00);
      transMatrix.m01 = FastMath.abs(transMatrix.m01);
      transMatrix.m02 = FastMath.abs(transMatrix.m02);
      transMatrix.m10 = FastMath.abs(transMatrix.m10);
      transMatrix.m11 = FastMath.abs(transMatrix.m11);
      transMatrix.m12 = FastMath.abs(transMatrix.m12);
      transMatrix.m20 = FastMath.abs(transMatrix.m20);
      transMatrix.m21 = FastMath.abs(transMatrix.m21);
      transMatrix.m22 = FastMath.abs(transMatrix.m22);

      _compVect1.set(xExtent * scale.x, yExtent * scale.y, zExtent * scale.z);
      transMatrix.mult(_compVect1, _compVect2);
      // Assign the biggest rotations after scales.
      box.xExtent = FastMath.abs(_compVect2.x);
      box.yExtent = FastMath.abs(_compVect2.y);
      box.zExtent = FastMath.abs(_compVect2.z);

      return box;
      */

      return rect;
  }

  /**
   * <code>whichSide</code> takes a plane (typically provided by a view
   * frustum) to determine which side this bound is on.
   * 
   * @param plane
   *            the plane to check against.
   */
  public override function whichSide(ray : Ray) : Side
  {
      /*
      float radius = FastMath.abs(xExtent * plane.normal.x)
              + FastMath.abs(yExtent * plane.normal.y)
              + FastMath.abs(zExtent * plane.normal.z);

      float distance = plane.pseudoDistance(center);

      //changed to < and > to prevent floating point precision problems
      if (distance < -radius) { return Side.NEGATIVE; }
      if (distance >  radius) { return Side.POSITIVE; }
      */
      return Side.NONE;
  }

  /**
   * <code>merge</code> combines this sphere with a second bounding sphere.
   * This new sphere contains both bounding spheres and is returned.
   * 
   * @param volume
   *            the sphere to combine with this sphere.
   * @return the new sphere
   */
  public override function merge(area : BoundingArea) : BoundingArea
  {
    if (area == null) 
    {
      return this;
    }

    switch (area.type) 
    {
      case BoundingAreaType.AABB: 
      {
        var vBox : BoundingRect = cast area;
        
        return mergeComp(vBox.center, vBox.xExtent, vBox.yExtent, new BoundingRect(new Vector2f(0, 0), 0, 0));
      }

      /*
      case Sphere: 
      {                
        BoundingSphere vSphere = (BoundingSphere) volume;
        return merge(vSphere.center, vSphere.radius, vSphere.radius,
                vSphere.radius, new BoundingBox(new Vector3f(0, 0, 0),
                        0, 0, 0));
      }
      
      //Treating Capsule like sphere, inefficient
      case Capsule: 
      {
        BoundingCapsule capsule = (BoundingCapsule) volume;
        float totalRadius = capsule.getRadius() + capsule.getLineSegment().getExtent();
        return merge(capsule.center, totalRadius, totalRadius,
                totalRadius, new BoundingBox(new Vector3f(0, 0, 0),
                        0, 0, 0));
      }

      case OBB: 
      {
        OrientedBoundingBox box = (OrientedBoundingBox) volume;
        BoundingBox rVal = (BoundingBox) this.clone(null);
        return rVal.mergeOBB(box);
      }
      */

      default:
      {
        return null;
      }
    }
  }

  /**
   * <code>mergeLocal</code> combines this sphere with a second bounding
   * sphere locally. Altering this sphere to contain both the original and the
   * additional sphere volumes;
   * 
   * @param volume
   *            the sphere to combine with this sphere.
   * @return this
   */
  public override function mergeLocal(area : BoundingArea) : BoundingArea
  {
    if (area == null) 
    {
      return this;
    }

    switch (area.type) 
    {
      case BoundingAreaType.AABB: 
      {
          var vBox : BoundingRect = cast area;
          return mergeComp(vBox.center, vBox.xExtent, vBox.yExtent, this);
      }

      /*
      case Sphere: {
          BoundingSphere vSphere = (BoundingSphere) volume;
          return merge(vSphere.center, vSphere.radius, vSphere.radius,
                  vSphere.radius, this);
      }
      
      //Treating capsule like sphere, inefficient
      case Capsule: {
          BoundingCapsule capsule = (BoundingCapsule) volume;
          float totalRadius = capsule.getRadius() + capsule.getLineSegment().getExtent();
          return merge(capsule.center, totalRadius, totalRadius,
              totalRadius, this);
      }

      case OBB: {
          return mergeOBB((OrientedBoundingBox) volume);
      }
      */

      default:
      {
        return null;
      }
    }
  }

  /**
   * Merges this AABB with the given OBB.
   * 
   * @param volume
   *            the OBB to merge this AABB with.
   * @return This AABB extended to fit the given OBB.
   */
   /*
  private BoundingBox mergeOBB(OrientedBoundingBox volume) {
      if (!volume.correctCorners)
          volume.computeCorners();

      Vector3f min = _compVect1.set(center.x - xExtent, center.y - yExtent,
              center.z - zExtent);
      Vector3f max = _compVect2.set(center.x + xExtent, center.y + yExtent,
              center.z + zExtent);

      for (int i = 1; i < volume.vectorStore.length; i++) {
          Vector3f temp = volume.vectorStore[i];
          if (temp.x < min.x)
              min.x = temp.x;
          else if (temp.x > max.x)
              max.x = temp.x;

          if (temp.y < min.y)
              min.y = temp.y;
          else if (temp.y > max.y)
              max.y = temp.y;

          if (temp.z < min.z)
              min.z = temp.z;
          else if (temp.z > max.z)
              max.z = temp.z;
      }

      center.set(min.addLocal(max));
      center.multLocal(0.5f);

      xExtent = max.x - center.x;
      yExtent = max.y - center.y;
      zExtent = max.z - center.z;
      return this;
  }
  */

  /**
   * <code>merge</code> combines this bounding box with another box which is
   * defined by the center, x, y, z extents.
   * 
   * @param boxCenter
   *            the center of the box to merge with
   * @param boxX
   *            the x extent of the box to merge with.
   * @param boxY
   *            the y extent of the box to merge with.
   * @param boxZ
   *            the z extent of the box to merge with.
   * @param rVal
   *            the resulting merged box.
   * @return the resulting merged box.
   */
  private function mergeComp(boxCenter : Vector2f, boxX : Float, boxY : Float, rVal : BoundingRect) : BoundingRect
  {
      var _compVect1 = BoundingArea._compVect1;
      var _compVect2 = BoundingArea._compVect2;

      _compVect1.x = center.x - xExtent;
      if (_compVect1.x > boxCenter.x - boxX)
          _compVect1.x = boxCenter.x - boxX;
      _compVect1.y = center.y - yExtent;
      if (_compVect1.y > boxCenter.y - boxY)
          _compVect1.y = boxCenter.y - boxY;

      _compVect2.x = center.x + xExtent;
      if (_compVect2.x < boxCenter.x + boxX)
          _compVect2.x = boxCenter.x + boxX;
      _compVect2.y = center.y + yExtent;
      if (_compVect2.y < boxCenter.y + boxY)
          _compVect2.y = boxCenter.y + boxY;

      center.set(_compVect2).addLocal(_compVect1).multScalarLocal(0.5);

      xExtent = _compVect2.x - center.x;
      yExtent = _compVect2.y - center.y;

      return rVal;
  }

  /**
   * <code>clone</code> creates a new BoundingBox object containing the same
   * data as this one.
   * 
   * @param store
   *            where to store the cloned information. if null or wrong class,
   *            a new store is created.
   * @return the new BoundingBox
   */
  public override function clone(?store : BoundingArea = null) : BoundingArea
  {
      if (store == null || !Std.is(store, BoundingRect))
      {
        store = new BoundingRect();
      }

      var tmp : BoundingRect = cast store;
      
      tmp.center.set(center);
      tmp.xExtent    = xExtent;
      tmp.yExtent    = yExtent;
      tmp.checkPlane = checkPlane;
      
      return tmp;        
  }

  /**
   * <code>toString</code> returns the string representation of this object.
   * <p>
   * If you want to display a class name, then use
   * Vector3f.class.getName() or getClass().getName().
   * </p>
   * 
   * @return the string representation of this.
   */
  public override function toString() : String
  {
    //return "BoundingRect[" + (center.x - xExtent) + ", " + (center.y - yExtent) + " - " + (center.x + xExtent) + ", " + (center.y + yExtent) + "]";
    return "center=" + center.toString() + ", extents=("+ xExtent + ", " + yExtent + ')';
  }

  /**
   * intersects determines if this Bounding Box intersects with another given
   * bounding volume. If so, true is returned, otherwise, false is returned.
   * 
   * @see com.jme.bounding.BoundingVolume#intersects(com.jme.bounding.BoundingVolume)
   */
  public override function intersects(bv : BoundingArea) : Bool
  {
    if (bv == null)
    {
      return false;
    }
   
    return bv.intersectsBoundingRect(this);
  }

  /**
   * determines if this bounding box intersects a given bounding sphere.
   * 
   * @see com.jme.bounding.BoundingVolume#intersectsSphere(com.jme.bounding.BoundingSphere)
   */
   /*
  public boolean intersectsSphere(BoundingSphere bs) {
      if (!Vector3f.isValidVector(center) || !Vector3f.isValidVector(bs.center)) return false;

      if (FastMath.abs(center.x - bs.getCenter().x) < bs.getRadius()
              + xExtent
              && FastMath.abs(center.y - bs.getCenter().y) < bs.getRadius()
                      + yExtent
              && FastMath.abs(center.z - bs.getCenter().z) < bs.getRadius()
                      + zExtent)
          return true;

      return false;
  }
  */

  /**
   * determines if this bounding box intersects a given bounding box. If the
   * two boxes intersect in any way, true is returned. Otherwise, false is
   * returned.
   * 
   * @see com.jme.bounding.BoundingVolume#intersectsBoundingBox(com.jme.bounding.BoundingBox)
   */
  public override function intersectsBoundingRect(bb : BoundingRect) : Bool
  {
    if (center.x + xExtent < bb.center.x - bb.xExtent || center.x - xExtent > bb.center.x + bb.xExtent)
    {
      return false;
    }
    else if (center.y + yExtent < bb.center.y - bb.yExtent || center.y - yExtent > bb.center.y + bb.yExtent)
    {
      return false;
    }

    return true;
  }

  /**
   * determines if this bounding box intersects with a given oriented bounding
   * box.
   * 
   * @see com.jme.bounding.BoundingVolume#intersectsOrientedBoundingBox(com.jme.bounding.OrientedBoundingBox)
   */
   /*
  public boolean intersectsOrientedBoundingBox(OrientedBoundingBox obb) {
      return obb.intersectsBoundingBox(this);
  }
  */
  
  /**
   * determines if this bounding box intersects with a given bounding capsule.
   * 
   * @see com.jme.bounding.BoundingVolume#intersectsCapsule(BoundingCapsule)
   */
   /*
  public boolean intersectsCapsule(BoundingCapsule bc) {
    return bc.intersectsBoundingBox(this);
  }
  */

  /**
   * determines if this bounding box intersects with a given ray object. If an
   * intersection has occurred, true is returned, otherwise false is returned.
   * 
   * @see com.jme.bounding.BoundingVolume#intersects(com.jme.math.Ray)
   */
  public override function intersectsRay(ray : Ray) : Bool
  {
    return false;
  }

  /**
   * @see com.jme.bounding.BoundingVolume#intersectsWhere(com.jme.math.Ray)
   */
  public function intersectsWhere(ray : Ray) : IntersectionRecord
  {
    return new IntersectionRecord();        
  }

  public override function contains(point : Vector2f) : Bool
  {
    return Math.abs(center.x - point.x) < xExtent && Math.abs(center.y - point.y) < yExtent;
  }

  public override function distanceToEdge(point : Vector2f) : Float
  {
      /*
      // compute coordinates of point in box coordinate system
      Vector3f closest = point.subtract(center);

      // project test point onto box
      float sqrDistance = 0.0f;
      float delta;

      if (closest.x < -xExtent) {
          delta = closest.x + xExtent;
          sqrDistance += delta * delta;
          closest.x = -xExtent;
      } else if (closest.x > xExtent) {
          delta = closest.x - xExtent;
          sqrDistance += delta * delta;
          closest.x = xExtent;
      }

      if (closest.y < -yExtent) {
          delta = closest.y + yExtent;
          sqrDistance += delta * delta;
          closest.y = -yExtent;
      } else if (closest.y > yExtent) {
          delta = closest.y - yExtent;
          sqrDistance += delta * delta;
          closest.y = yExtent;
      }

      if (closest.z < -zExtent) {
          delta = closest.z + zExtent;
          sqrDistance += delta * delta;
          closest.z = -zExtent;
      } else if (closest.z > zExtent) {
          delta = closest.z - zExtent;
          sqrDistance += delta * delta;
          closest.z = zExtent;
      }

      return FastMath.sqrt(sqrDistance);
      */
      return 0;
  }

  /**
   * <code>clip</code> determines if a line segment intersects the current
   * test plane.
   * 
   * @param denom
   *            the denominator of the line segment.
   * @param numer
   *            the numerator of the line segment.
   * @param t
   *            test values of the plane.
   * @return true if the line segment intersects the plane, false otherwise.
   */
   /*
  private boolean clip(float denom, float numer, float[] t) 
  {
      // Return value is 'true' if line segment intersects the current test
      // plane. Otherwise 'false' is returned in which case the line segment
      // is entirely clipped.
      if (denom > 0.0f) {
          if (numer > denom * t[1])
              return false;
          if (numer > denom * t[0])
              t[0] = numer / denom;
          return true;
      } else if (denom < 0.0f) {
          if (numer > denom * t[0])
              return false;
          if (numer > denom * t[1])
              t[1] = numer / denom;
          return true;
      } else {
          return numer <= 0.0;
      }
  }
  */

  /**
   * Query extent.
   * 
   * @param store
   *            where extent gets stored - null to return a new vector
   * @return store / new vector
   */
  public function getExtent(?store : Vector2f) : Vector2f
  {
    if (store == null) 
    {
      store = new Vector2f();
    }

    store.setComp(xExtent, yExtent);

    return store;
  }
  
  public function measure() : Float
  {
    return (4 * xExtent * yExtent);
  }

  public function getRect(?store : Rect = null) : Rect
  {
    if (store == null)
    {
      store = new Rect();
    }

    store.x      = center.x - xExtent;
    store.y      = center.y - xExtent;
    store.width  = 2 * xExtent;
    store.height = 2 * yExtent;

    return store;
  }

  public function intersection(b : BoundingRect, ?store : Rect = null) : Rect
  {
    if (store == null)
    {
      store = new Rect(0, 0, 0, 0);
    }

    if (intersectsBoundingRect(b))
    {
      var left   = Math.max(center.x - xExtent, b.center.x - b.xExtent);
      var top    = Math.max(center.y - yExtent, b.center.y - b.yExtent);
      var right  = Math.min(center.x + xExtent, b.center.x + b.xExtent);
      var bottom = Math.min(center.y + yExtent, b.center.y + b.yExtent);

      store.x = left;
      store.y = top;
      store.width = right - left;
      store.height = bottom - top;
    }

    return store;
  }
}

