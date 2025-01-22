package gamelib2.intersection;

import haxe.ds.GenericStack;

import gamelib2.math.Vector3f;

/**
 * IntersectionRecord stores needed information for a interesection query between
 * two objects. This includes all points that were intersected, and the
 * distances between these points. Therefore, a 1 to 1 ratio between the distance
 * array and the point array is enforced.
 *
 */
class IntersectionRecord 
{
  private var distances (default, null) : GenericStack<Float>;
  private var points    (default, null) : GenericStack<Vector3f>;

  /**
   * Instantiates a new IntersectionRecord defining the distances and points. 
   * If the size of the distance and point arrays do not match, an exception
   * is thrown.
   * @param distances the distances of this intersection.
   * @param points the points of this intersection.
   */
  public function new(?distances : GenericStack<Float> = null, ?points : GenericStack<Vector3f> = null) 
  {
    if (distances == null || points == null)
    {
      distances = new GenericStack<Float>();
      points    = new GenericStack<Vector3f>();
    }
    
    if (gamelib2.Utils.count(distances) != gamelib2.Utils.count(points))
    {
      throw ("The distances and points variables must have an equal number of elements.");
    }

    this.distances = distances;
    this.points = points;
  }

  /**
   * Returns the number of intersections that occured.
   * @return the number of intersections that occured.
   */
  public function getQuantity() : Int
  {
    if (points == null)
    {
      return 0;
    }

    var count : Int = 0;

    for(point in points.iterator())
    {
      count++;
    }

    return count;
  }

  /**
   * Returns an intersection point at a provided index.
   * @param index the index of the point to obtain.
   * @return the point at the index of the array.
   */
  public function getIntersectionPoint(index : Int) : Vector3f
  {
    for(point in points.iterator())
    {
      if (index == 0)
      {
        return point;
      }
    }

    throw ("Index of out bounds: " + index);      
  }

  /**
   * Returns an intersection distance at a provided index.
   * @param index the index of the distance to obtain.
   * @return the distance at the index of the array.
   */
  public function getIntersectionDistance(index : Int) : Float
  {
    for(distance in distances.iterator())
    {
      if (index == 0)
      {
        return distance;
      }
    }

    throw ("Index of out bounds: " + index);      
  }

  /**
   * Returns the smallest distance in the distance array.
   * @return the smallest distance in the distance array.
   */
  public function getClosestDistance() : Float
  {
    var min = Math.POSITIVE_INFINITY;
    if (distances != null) 
    {
      for (val in distances.iterator()) 
      {
        if (val < min) 
        {
          min = val;
        }
      }
    }
    return min;
  }

  /**
   * Returns the point that has the smallest associated distance value.
   * @return the point that has the smallest associated distance value.
   */
  public function getClosestPoint() : Int
  {
    var min = Math.POSITIVE_INFINITY;
    var point : Int = 0;

    if (distances != null) 
    {
      //for (int i = distances.length; --i >= 0;) 
      var i : Int = 0;

      for(val in distances.iterator())
      {
        if (val < min) 
        {
          min = val;
          point = i;
        }

        i++;
      }
    }

    return point;
  }

  /**
   * Returns the point that has the largest associated distance value.
   * @return the point that has the largest associated distance value.
   */
  public function getFarthestPoint() : Int
  {
    var max = Math.POSITIVE_INFINITY;
    var point : Int = 0;

    if (distances != null) 
    {
      //for (int i = distances.length; --i >= 0;) 
      var i : Int = 0;

      for(val in distances.iterator())
      {
        if (val > max) 
        {
          max = val;
          point = i;
        }

        i++;
      }
    }

    return point;
  }
}
