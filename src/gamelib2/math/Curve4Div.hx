package gamelib2.math;

import gamelib2.math.Vector2f;

class Curve4Div
{
  private static var curve_distance_epsilon        = 1e-30;
  private static var curve_collinearity_epsilon    = 1e-30;
  private static var curve_angle_tolerance_epsilon = 0.01;
  private static var curve_recursion_limit : Int   = 2;

  public var approximationScale       : Float;
  public var distanceToleranceSquare : Float;
  public var angleTolerance           : Float;
  @:isVar public var cuspLimit (default, set) : Float;

  //public var m_count                     : Int;

  public var points : Array<Vector2f>;
        
  public function new(p1 : Vector2f, p2 : Vector2f, p3 : Vector2f, p4 : Vector2f)
  {
    approximationScale = 1.0;
    angleTolerance     = 0.0;
    cuspLimit          = 0.0;
    //m_count               = 0;

    points = new Array();

    init(p1, p2, p3, p4);
  }

  private function set_cuspLimit(v : Float) : Float
  {
    cuspLimit = (v == 0.0) ? 0.0 : Math.PI - v;

    return cuspLimit;
  }

  public function init(p1 : Vector2f, p2 : Vector2f, p3 : Vector2f, p4 : Vector2f)
  {
    points = new Array();

    distanceToleranceSquare = 0.5 / approximationScale;
    distanceToleranceSquare *= distanceToleranceSquare;

    bezier(p1.x, p1.y, p2.x, p2.y, p3.x, p3.y, p4.x, p4.y);

    //m_count = 0;
  }        
  //------------------------------------------------------------------------

  private function recursive_bezier(x1 : Float, y1 : Float, x2 : Float, y2 : Float,  x3 : Float, y3 : Float, x4 : Float, y4 : Float, level : Int)
  {
    if(level > curve_recursion_limit) 
    {
        return;
    }

    // Calculate all the mid-points of the line segments
    //----------------------
    var x12   = (x1 + x2) / 2;
    var y12   = (y1 + y2) / 2;
    var x23   = (x2 + x3) / 2;
    var y23   = (y2 + y3) / 2;
    var x34   = (x3 + x4) / 2;
    var y34   = (y3 + y4) / 2;
    var x123  = (x12 + x23) / 2;
    var y123  = (y12 + y23) / 2;
    var x234  = (x23 + x34) / 2;
    var y234  = (y23 + y34) / 2;
    var x1234 = (x123 + x234) / 2;
    var y1234 = (y123 + y234) / 2;


    // Try to approximate the full cubic curve by a single straight line
    //------------------
    var dx = x4-x1;
    var dy = y4-y1;

    var d2 = Math.abs(((x2 - x4) * dy - (y2 - y4) * dx));
    var d3 = Math.abs(((x3 - x4) * dy - (y3 - y4) * dx));
    var da1 : Float; 
    var da2 : Float;
    var k : Float;
    
    switch((((d2 > curve_collinearity_epsilon) ? 1 : 0) << 1) +
            ((d3 > curve_collinearity_epsilon) ? 1 : 0))
    {
      case 0:
      {
        // All collinear OR p1==p4
        //----------------------
        k = dx*dx + dy*dy;
        if(k == 0)
        {
            d2 = MathEx.computeSqrDist(x1, y1, x2, y2);
            d3 = MathEx.computeSqrDist(x4, y4, x3, y3);
        }
        else
        {
            k   = 1 / k;
            da1 = x2 - x1;
            da2 = y2 - y1;
            d2  = k * (da1*dx + da2*dy);
            da1 = x3 - x1;
            da2 = y3 - y1;
            d3  = k * (da1*dx + da2*dy);
            if(d2 > 0 && d2 < 1 && d3 > 0 && d3 < 1)
            {
                // Simple collinear case, 1---2---3---4
                // We can leave just two endpoints
                return;
            }
                 if(d2 <= 0) d2 = MathEx.computeSqrDist(x2, y2, x1, y1);
            else if(d2 >= 1) d2 = MathEx.computeSqrDist(x2, y2, x4, y4);
            else             d2 = MathEx.computeSqrDist(x2, y2, x1 + d2*dx, y1 + d2*dy);

                 if(d3 <= 0) d3 = MathEx.computeSqrDist(x3, y3, x1, y1);
            else if(d3 >= 1) d3 = MathEx.computeSqrDist(x3, y3, x4, y4);
            else             d3 = MathEx.computeSqrDist(x3, y3, x1 + d3*dx, y1 + d3*dy);
        }
        if(d2 > d3)
        {
            if(d2 < distanceToleranceSquare)
            {
                points.push(new Vector2f(x2, y2));
                return;
            }
        }
        else
        {
            if(d3 < distanceToleranceSquare)
            {
                points.push(new Vector2f(x3, y3));
                return;
            }
        }
      }

      case 1:
      {
        // p1,p2,p4 are collinear, p3 is significant
        //----------------------
        if(d3 * d3 <= distanceToleranceSquare * (dx*dx + dy*dy))
        {
            if(angleTolerance < curve_angle_tolerance_epsilon)
            {
                points.push(new Vector2f(x23, y23));
                return;
            }

            // Angle Condition
            //----------------------
            da1 = Math.abs(Math.atan2(y4 - y3, x4 - x3) - Math.atan2(y3 - y2, x3 - x2));
            if(da1 >= Math.PI) da1 = 2 * Math.PI - da1;

            if(da1 < angleTolerance)
            {
                points.push(new Vector2f(x2, y2));
                points.push(new Vector2f(x3, y3));
                return;
            }

            if(cuspLimit != 0.0)
            {
                if(da1 > cuspLimit)
                {
                    points.push(new Vector2f(x3, y3));
                    return;
                }
            }
        }
      }

      case 2:
      {
        // p1,p3,p4 are collinear, p2 is significant
        //----------------------
        if(d2 * d2 <= distanceToleranceSquare * (dx*dx + dy*dy))
        {
          if(angleTolerance < curve_angle_tolerance_epsilon)
          {
              points.push(new Vector2f(x23, y23));
              return;
          }

          // Angle Condition
          //----------------------
          da1 = Math.abs(Math.atan2(y3 - y2, x3 - x2) - Math.atan2(y2 - y1, x2 - x1));
          if(da1 >= Math.PI) da1 = 2 * Math.PI - da1;

          if(da1 < angleTolerance)
          {
              points.push(new Vector2f(x2, y2));
              points.push(new Vector2f(x3, y3));
              return;
          }

          if(cuspLimit != 0.0)
          {
              if(da1 > cuspLimit)
              {
                  points.push(new Vector2f(x2, y2));
                  return;
              }
          }
        }
      }

      case 3: 
      {
        // Regular case
        //-----------------
        if((d2 + d3)*(d2 + d3) <= distanceToleranceSquare * (dx*dx + dy*dy))
        {
          // If the curvature doesn't exceed the distance_tolerance value
          // we tend to finish subdivisions.
          //----------------------
          if(angleTolerance < curve_angle_tolerance_epsilon)
          {
              points.push(new Vector2f(x23, y23));
              return;
          }

          // Angle & Cusp Condition
          //----------------------
          k   = Math.atan2(y3 - y2, x3 - x2);
          da1 = Math.abs(k - Math.atan2(y2 - y1, x2 - x1));
          da2 = Math.abs(Math.atan2(y4 - y3, x4 - x3) - k);
          if(da1 >= Math.PI) da1 = 2 * Math.PI - da1;
          if(da2 >= Math.PI) da2 = 2 * Math.PI - da2;

          if(da1 + da2 < angleTolerance)
          {
              // Finally we can stop the recursion
              //----------------------
              points.push(new Vector2f(x23, y23));
              return;
          }

          if(cuspLimit != 0.0)
          {
              if(da1 > cuspLimit)
              {
                  points.push(new Vector2f(x2, y2));
                  return;
              }

              if(da2 > cuspLimit)
              {
                  points.push(new Vector2f(x3, y3));
                  return;
              }
          }
        }
      }
    }

    // Continue subdivision
    //----------------------
    recursive_bezier(x1, y1, x12, y12, x123, y123, x1234, y1234, level + 1); 
    recursive_bezier(x1234, y1234, x234, y234, x34, y34, x4, y4, level + 1); 
  }
  //------------------------------------------------------------------------

  private function bezier(x1 : Float, y1 : Float, x2 : Float, y2 : Float, x3 : Float, y3 : Float, x4 : Float, y4 : Float)
  {
    points.push(new Vector2f(x1, y1));

    recursive_bezier(x1, y1, x2, y2, x3, y3, x4, y4, 0);

    points.push(new Vector2f(x4, y4));
  }
}
