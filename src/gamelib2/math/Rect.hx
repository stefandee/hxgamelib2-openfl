package gamelib2.math;

class Rect
{
  public var x                           : Float;
  public var y                           : Float;

  public var width  (default, set)  : Float;
  public var height (default, set) : Float;

  public var left(get, null)            : Float;
  public var right(get, null)           : Float;
  public var top(get, null)             : Float;
  public var bottom(get, null)          : Float;

  public function new(?x : Float = 0, ?y : Float = 0, ?width : Float = 0, ?height : Float = 0)
  {
    this.x      = x;
    this.y      = y;
    this.width  = width;
    this.height = height;
  }

  private function set_width(v : Float) : Float
  {
    if (v < 0)
    {
      trace("negative width");
      
      v = 0;
    }

    this.width = v;

    return this.width;
  }

  private function set_height(v : Float) : Float
  {
    if (v < 0)
    {
      trace("negative height");

      v = 0;
    }

    this.height = v;

    return this.height;
  }

  private function get_left() : Float
  {
    return x;
  }

  /*
  private function setL(v : Float) : Float
  {
    x = v;

    return x;
  }
  */

  private function get_right() : Float
  {
    return x + width;
  }

  /*
  private function setR(v : Float) : Float
  {
    width = v - x;

    return (x + width);
  }
  */

  private function get_top() : Float
  {
    return y;
  }

  /*
  private function setT(v : Float) : Float
  {
    y = v;

    return y;
  }
  */

  private function get_bottom() : Float
  {
    return y + height;
  }

  /*
  private function setB(v : Float) : Float
  {
    height = v - y;

    return (y + height);
  }
  */

  public function contains(vec : Vector2f) : Bool
  {
    return containsComp(vec.x, vec.y);
  }

  public inline function containsComp(_x : Float, _y : Float) : Bool
  {
    return (x <= _x && _x <= x + width) && (y <= _y && _y <= y + height);
  }

  public function containsRectComp(rx : Float, ry : Float, rwidth : Float, rheight : Float) : Bool
  {
    return 
      (x >= rx && rx + rwidth <= x + width) && 
      (y >= ry && ry + rheight <= y + height);
  }

  public function containsRect(r : Rect) : Bool
  {
    return 
      (x >= r.x && r.x + r.width <= x + width) && 
      (y >= r.y && r.y + r.height <= y + height);
  }

  public function intersects(r : Rect) : Bool
  {
    if ((x + width < r.x) || (y + height < r.y) || (r.y + r.height < y) || (r.x + r.width < x))
    {
      return false;
    }
    
    return true;
  }

  public function intersection(r : Rect, ?store : Rect = null) : Rect
  {
    if (store == null)
    {
      store = new Rect(x, y, width, height);
    }

    var tmpleft   = Math.max(left,   r.left);
    var tmptop    = Math.max(top,    r.top);
    var tmpright  = Math.min(right,  r.right);
    var tmpbottom = Math.min(bottom, r.bottom);

    store.x = tmpleft;
    store.y = tmptop;
    store.width = tmpright - tmpleft;
    store.height = tmpbottom - tmptop;

    return store;
  }

  public function inflateLocal(vec : Vector2f) 
  {
    inflateLocalComp(vec.x, vec.y);
  }

  public function inflateLocalComp(_x : Float, _y : Float) 
  {
    if (_x < left)
    {
      //left = _x;
      width += (left - _x);
      x = _x;
    }
    else if (_x > right)
    {
      width = _x - x;
    }

    if (_y < top)
    {
      //top = _y;
      height += (top - _y);
      y = _y;
    }
    else if (_y > bottom)
    {
      height = _y - y;
      //bottom = _y;
    }
  }

  public function toString() : String
  {
    return "[" + x + ", " + y + ", " + width + ", " + height + "]";
  }
}