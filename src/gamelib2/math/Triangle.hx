package gamelib2.math;

/**
 * <code>Triangle</code> defines a object for containing triangle information.
 * The triangle is defined by a collection of three <code>Vector3f</code>
 * objects.
 * 
 * @author Mark Powell
 * @author Joshua Slack
 */
class Triangle
{
  @:isVar public var center (get, null) : Vector3f;
  @:isVar public var normal (get, null) : Vector3f;
  public var projection               : Float;    
  public var index                    : Int;

  private var pointa : Vector3f;
  private var pointb : Vector3f;
  private var pointc : Vector3f;
          
  /**
   * Constructor instantiates a new <Code>Triangle</code> object with the
   * supplied vectors as the points. It is recommended that the vertices
   * be supplied in a counter clockwise winding to support normals for a
   * right handed coordinate system.
   * @param p1 the first point of the triangle.
   * @param p2 the second point of the triangle.
   * @param p3 the third point of the triangle.
   */
  public function new(p1 : Vector3f, p2 : Vector3f, p3 : Vector3f) 
  {
    pointa = new Vector3f(p1.x, p1.y, p1.z);
    pointb = new Vector3f(p2.x, p2.y, p2.z);
    pointc = new Vector3f(p3.x, p3.x, p3.z);
  }

  /**
   *
   * <code>get</code> retrieves a point on the triangle denoted by the index
   * supplied.
   * @param i the index of the point.
   * @return the point.
   */
  public function get(i : Int) : Vector3f
  {
    switch (i) 
    {
      case 0: return pointa;
      case 1: return pointb;
      case 2: return pointc;
      default: return null;
    }
  }

  /**
   *
   * <code>set</code> sets one of the triangles points to that specified as
   * a parameter.
   * @param i the index to place the point.
   * @param point the point to set.
   */
  public function set(i : Int, point : Vector3f) : Void
  {
    switch (i) 
    {
      case 0: pointa.setFromVector(point);
      case 1: pointb.setFromVector(point);
      case 2: pointc.setFromVector(point);
    }
  }
  
  /**
   * calculateCenter finds the average point of the triangle. 
   *
   */
  public function calculateCenter() : Void
  {
    if (center == null)
    {
      center = new Vector3f();
    }

    center.setFromVector(pointa);

    center.addVectorLocal(pointb).addVectorLocal(pointc).multScalarLocal(1/3);
  }
  
  /**
   * calculateNormal finds the normal vector of this triangle.    
   *
   */
  public function calculateNormal() : Void
  {
    if (normal == null)
    {
      normal = new Vector3f();
    }

    normal.setFromVector(pointb);

    normal.subtractVectorLocal(pointa).crossLocal(pointc.x-pointa.x, pointc.y-pointa.y, pointc.z-pointa.z);
    normal.normalizeLocal();
  }
  
  /**
   * obtains the center point of this triangle (average of the three triangles)
   * @return the center point.
   */
  public function get_center() : Vector3f
  {
    if (center == null) 
    {
      calculateCenter();
    }

    return center;
  }
      
  /**
   * obtains the unit length normal vector of this triangle, if set or
   * calculated
   * 
   * @return the normal vector
   */
  public function get_normal() : Vector3f
  {
    if (normal == null) 
    {
      calculateNormal();
    }

    return normal;
  }
  
  public function clone() : Triangle
  {
    var t = new Triangle(pointa.clone(), pointb.clone(), pointc.clone());

    return t;
  }
}
