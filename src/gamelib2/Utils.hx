package gamelib2;

import Math;
import flash.display.StageQuality;
import flash.external.ExternalInterface;
import flash.net.URLRequest;
import gamelib2.math.Matrix3f;

class Utils
{
  public static function ArrayHas<T> (myElem : T, myArray : Array<T>) : Bool
  {
    for(elem in myArray)
    {
      if (elem == myElem)
      {
        return true;
      }
    }

    return false;
  }

  public static function IndexOf<T> (myElem : T, myArray : Array<T>) : Int
  {
    for(index in 0...myArray.length)
    {
      if (myArray[index] == myElem)
      {
        return index;
      }
    }

    return -1;    
  }

  // no valid checks, myArray must not be null and must not be empty
  public static function randomElement<T> (myArray : Array<T>) : T
  {
    return myArray[Std.random(myArray.length)];
  }

  public static function asBool(v : String) : Bool
  {
    if (v.toLowerCase() == "false")
    {
      return false;
    }

    return true;
  }

  public static function getQualityAsString(q : StageQuality) : String
  {
    return ("" + flash.Lib.current.stage.quality).toUpperCase();
  }

  public static function cycleQuality(q : StageQuality) : StageQuality
  {
    // TODO: should extract this code to a lib class
    var quality : StageQuality = StageQuality.LOW;

    switch(q)
    {
      case StageQuality.LOW:
        quality = StageQuality.MEDIUM;

      case StageQuality.MEDIUM:
        quality = StageQuality.HIGH;

      case StageQuality.HIGH:
        quality = StageQuality.BEST;

      case StageQuality.BEST:
        quality = StageQuality.LOW;
    }

    return quality;
  }

  //
  // method for opening a link
  //
  public static  function openLink (url : String) : Void
  {    
    // if browserAgent ends up null, we will use getURL
    var browserAgent : String = null;

    try 
    {
      if (ExternalInterface.available)
      {
        browserAgent = ExternalInterface.call("function getBrowser(){return navigator.userAgent;}");
      }
    } 
    catch (e : Dynamic) 
    {
      browserAgent = null;
    }

    //
    // have to do it this way, because of the way some popup-blockers work
    //
    if (browserAgent != null && 
        ExternalInterface.available && 
        ((browserAgent.indexOf("Firefox") >= 0) || (browserAgent.indexOf("MSIE") >= 0))) 
    {
      trace("window.open");
      ExternalInterface.call("window.open", url);
    } 
    else 
    {  
      trace("navigatetourl");

      flash.Lib.getURL(new URLRequest(url), "_blank");
    }
  }

  public static function parseUri(str : String, strictMode : Bool = false) : Map<String, String>
  {
    var r : EReg = strictMode ? 
      ~/^(?:([^:\/?#]+):)?(?:\/\/((?:(([^:@]*):?([^:@]*))?@)?([^:\/?#]*)(?::(\d*))?))?((((?:[^?#\/]*\/)*)([^?#]*))(?:\?([^#]*))?(?:#(.*))?)/g :
      ~/^(?:(?![^:@]+:[^:@\/]*@)([^:\/?#.]+):)?(?:\/\/)?((?:(([^:@]*):?([^:@]*))?@)?([^:\/?#]*)(?::(\d*))?)(((\/(?:[^?#](?![^?#\/]*\.[^?#\/.]+(?:[?#]|$)))*\/?)?([^?#\/]*))(?:\?([^#]*))?(?:#(.*))?)/g;
    
    var result = r.match(str);

    var uri : Map<String, String> = new Map();
    
  	var key = ["source", "protocol", "authority", "userInfo", "user", "password", "host", "port", "relative", "path", "directory", "file", "query", "anchor"];

    if (result)
    {
      var i : Int = key.length;

      while (i >= 0)
      {
        try
        {
          var m = r.matched(i);
          
          uri.set(key[i], if (m != null) m else "");
        }
        catch(e : Dynamic)
        {
        }

        i--;
      }
    }

    return uri;
  }

  // in-place shuffle of an array with Fisher-Yates algorithm
  public static function shuffle<T> (myArray : Array<T>) : Void
  {
    var i : Int = myArray.length - 1;

    while(i > 1)
    {
      var randomIndex = Std.random(i + 1);

      if (i != randomIndex)
      {
        var tmp = myArray[i];
        myArray[i] = myArray[randomIndex];
        myArray[randomIndex] = tmp;
      }
      
      i--;
    }    
  }

  // extended version of the StringTools.hex that ignores the sign and is able to
  // handle a bit more hexa values
  public static function hex(v : Int) : String
  {
    /*
    var i32 = haxe.Int32.ofInt(v);

    // precompute some constants
    var i32_0 = haxe.Int32.ofInt(0);
    var i32_15 = haxe.Int32.ofInt(15);

    var s = "";
    var hexChars = "0123456789ABCDEF";    

    do {
      var r = haxe.Int32.and(i32, i32_15);
      s = hexChars.charAt(haxe.Int32.toInt(r)) + s;

      i32 = haxe.Int32.ushr(i32, 4);

    } while( haxe.Int32.compare(i32, i32_0) > 0);

    return s;
    */
    return StringTools.hex(v);
  }

  public static function domainMatch(domain : String, host : String) : Bool
  {
    var r : EReg = new EReg(domain + "$", "gi");

    if (r.match(host))
    {
      var strLeft = r.matchedLeft();

      trace(strLeft);

      if (strLeft == "" || StringTools.endsWith(strLeft, "."))
      {
        return true;
      }
    }

    return false;    
  }

  public static function allowApplication(host : String, siteLockList : Array<String>) : Bool
  {
    trace(siteLockList.toString());
    
    // check if this is a site-locked build (siteLock list is not empty)
    // if it's a site-locked build, then check that the host is on any of the domains to allow
    if (siteLockList.length > 0)
    {
      var result : Bool = false;
      
      for(domain in siteLockList)
      {
        result = result || domainMatch(domain, host);
      }

      return result;
    }

    return true;
  }

	/** Reverses <i>x</i>, e.g. Hello -> olleH */
	inline public static function reverse(x:String):String
	{
		var t = '';
		var i = x.length;
		while (i-- >= 0) t += x.charAt(i);
		return t;
	}

	/**
		Count the number of elements in an [Iterable]
	**/
	public static function count<A>( it : Iterable<A> ) {
		var n = 0;
		for( _ in it )
			++n;
		return n;
	}

  public static function matrix3fToFlash(m : Matrix3f, ?store : flash.geom.Matrix = null) : flash.geom.Matrix
  {
    if (store == null)
    {
      store = new flash.geom.Matrix();
    }

    store.identity();

    store.a  = m.m00;
    store.b  = m.m10;
    store.c  = m.m01;
    store.d  = m.m11;
    store.tx = m.m02;
    store.ty = m.m12;

    return store;
  }

  private static var tempRect : flash.geom.Rectangle = new flash.geom.Rectangle();

  public static function drawRect(bmpData : flash.display.BitmapData, color : Int, left : Float, top : Float, right : Float, bottom : Float)
  {
    tempRect.left   = left;
    tempRect.right  = right;
    tempRect.top    = top;
    tempRect.bottom = top + 1;

    bmpData.fillRect(tempRect, color);

    tempRect.left   = left;
    tempRect.right  = right;
    tempRect.top    = bottom - 1;
    tempRect.bottom = bottom;

    bmpData.fillRect(tempRect, color);

    tempRect.left   = left;
    tempRect.right  = left + 1;
    tempRect.top    = top;
    tempRect.bottom = bottom;

    bmpData.fillRect(tempRect, color);

    tempRect.left   = right - 1;
    tempRect.right  = right;
    tempRect.top    = top;
    tempRect.bottom = bottom;

    bmpData.fillRect(tempRect, color);
  }

  public static function parseColor(str : String) : Int
  {
    var r : EReg = ~/^#([0-9A-Fa-f]*)$/i;

    if (r.match(str))
    {
      var hexStr = r.matched(1);      

      //trace("parse color: " + hexStr + " / " + Std.parseInt("0x" + hexStr));

      return Std.parseInt("0x" + hexStr);
    }

    return 0x00000000;
  }

  public static function probability(values : Array<Float>) : Int
  {
    if (values.length == 0)
    {
      return -1;
    }

    if (values.length == 1)
    {
      return 0;
    }
    
    var p = Math.random();

    var start : Float = 0;
    var end : Float = values[0];

    for(i in 0...values.length - 1)
    {
      if (start <= p && p < end)
      {
        return i;
      }

      start = end;
      end = start + values[i + 1];
    }

    return values.length - 1;
  }
}