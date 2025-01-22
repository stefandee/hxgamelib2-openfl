package gamelib2.math;

class Interval
{
  public var a (default, null) : Float;
  public var b (default, null) : Float;
  public var extent (get, null) : Float;
  
  public function new(a : Float, b : Float)
  {
    this.a = Math.min(a, b);
    this.b = Math.max(a, b);
  }

  public function get_extent() : Float
  {
    return b - a;
  }

  public function getMiddle() : Float
  {
    return (a + b) / 2;
  }

  public function getRandom() : Float
  {
    return a + (b - a) * Math.random();
  }

  public function interp(i : Float, n : Float) : Float
  {
    return a + ((b - a) * i) / n;
  }

  public function inRange(v : Float, ?strict : Bool = false) : Bool
  {
    if (strict)
    {
      return v > a && v < b;
    }

    return v >= a && v <= b;
  }

  public function clone() : Interval
  {
    return new Interval(a, b);
  }

  public function toString() : String
  {
    return "[" + a + "..." + b + "]";
  }
}