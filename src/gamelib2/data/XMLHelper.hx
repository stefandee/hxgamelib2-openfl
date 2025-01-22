package gamelib2.data;

import gamelib2.Utils;
import gamelib2.math.Vector2f;
import gamelib2.math.Interval;
import haxe.xml.Fast;

class XMLHelper
{
  private function new()
  {
  }

  public static inline function hasAtt(a : String, elem : Fast) : Bool
  {
    return elem.has.resolve(a);    
    // return (elem.attribute(a).length() > 0);
  }

  public static function attInt(a : String, elem : Fast) : Int
  {
    return Std.parseInt(elem.att.resolve(a));
    // return Std.parseInt(elem.attribute(a).toString());
  }

  public static function attBool(a : String, elem : Fast) : Bool
  {
    return Utils.asBool(elem.att.resolve(a));
    // return Utils.asBool(elem.attribute(a).toString());
  }

  public static function attFloat(a : String, elem : Fast) : Float
  {
    return Std.parseFloat(elem.att.resolve(a));
    // return Std.parseFloat(elem.attribute(a).toString());
  }

  public static inline function att(a : String, elem : Fast) : String
  {
    return elem.att.resolve(a);
    // return elem.attribute(a).toString();
  }

  public static function attInterval(a : String, elem : Fast) : Interval
  {
    var tmp = att(a, elem).split("...");

    if (tmp.length == 2)
    {
      return new Interval(Std.parseInt(tmp[0]), Std.parseInt(tmp[1]));
    }
    else
    {
      // create an interval out of a single value
      var v : Int = Std.parseInt(att(a, elem));
      
      return new Interval(v, v);
    }

    trace("Wrong number of params for interval.");

    return null;
  }

  public static function attFInterval(a : String, elem : Fast) : Interval
  {
    var tmp = att(a, elem).split("...");

    if (tmp.length == 2)
    {
      return new Interval(Std.parseFloat(tmp[0]), Std.parseFloat(tmp[1]));
    }
    else
    {
      // create an interval out of a single value
      var v : Float = Std.parseFloat(att(a, elem));
      
      return new Interval(v, v);
    }

    trace("Wrong number of params for interval.");

    return null;
  }

  public static function attPoint(a : String, elem : Fast) : Vector2f
  {
    var tmp = att(a, elem).split(",");

    if (tmp.length == 2)
    {
      return new Vector2f(Std.parseInt(tmp[0]), Std.parseInt(tmp[1]));
    }

    trace("Wrong number of params for point.");

    return null;
  }
  
  public static function attColor(a : String, elem : Fast) : Int
  {
    return Utils.parseColor(elem.att.resolve(a));
  }  
  
}
