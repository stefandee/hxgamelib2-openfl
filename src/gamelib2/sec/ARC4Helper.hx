package gamelib2.sec;
import com.hurlant.crypto.prng.ARC4;
import com.hurlant.util.Hex;

/**
 * Convenience methods to encrypt/decrypt using ARC4 cypher
 * 
 * @author Piron Games
 */
class ARC4Helper 
{
  public static function encrypt(message: String, key: String): String
  {
    var k = Hex.toArray(Hex.fromString(key));
    var m = Hex.toArray(Hex.fromString(message));

    var rc = new ARC4(k);

    rc.encrypt(m);

    return (Hex.fromArray(m)).toLowerCase();
  }
    
  public static function decrypt(message: String, key: String): String
  {
    var k = Hex.toArray(Hex.fromString(key));
    var m = Hex.toArray(message);

    var rc = new ARC4(k);
    
    rc.decrypt(m);

    return Hex.toString(Hex.fromArray(m));
  }  
}