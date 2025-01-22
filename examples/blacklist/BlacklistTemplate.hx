import gamelib2.Utils;
import sec.util.Hex;
import com.meychi.ascrypt3.RC4;

class Blacklist
{
  private static var KEY  : String = "%KEY%";
  private static var LIST : Array<String> = [%LIST%];

  public static function block(uri : Hash<String>) : Bool
  {
    if (LIST.length == 0)
    {
      return false;
    }
    
    var host = uri.get("host");

    trace(host);

    if (host == null)
    {
      return false;
    }

    var rc4 = new RC4();
    
    for(portal in LIST)
    {
      //trace(Hex.toString(portal));
      
      var tmp = rc4.decrypt(portal, KEY);

      //trace(tmp);
      
      if (Utils.domainMatch(tmp, host))
      {
        return true;
      }
    }

    return false;
  }
}