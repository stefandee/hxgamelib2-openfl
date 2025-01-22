package gamelib2.sec;

import com.hurlant.crypto.symmetric.XTeaKey;
import com.hurlant.util.ByteArray;
import com.hurlant.util.Hex;

/**
 * Secure float, to prevent from tampering. This made sense in Flash (to avoid cheating using CheatEngine), but not sure 
 * it makes anymore for HTML5/JS, as it's very easy to debug and change values in the browser.
 * 
 * TODO optimize this class to avoid hex - string - bytearray conversions.
 */
class SecureFloat
{
  public var value (get, set) : Float;

  private var tea : XTeaKey;
  
  /**
   * A hex-encoded string containing the encrypted value
   */
  private var internalValue: String;

  public function new(?defaultValue : Float = 0)
  {
    // generate a random key to use with this object
    // maybe we should use the Random class to generate this
    var key : ByteArray = new ByteArray();

    key.writeUnsignedInt(Std.random(0xFFFF));
    key.writeUnsignedInt(Std.random(0xFFFF));
    key.writeUnsignedInt(Std.random(0xFFFF));
    key.writeUnsignedInt(Std.random(0xFFFF));

    tea = new XTeaKey(key);

    value = defaultValue;
  }

  private function get_value() : Float
  {
    var m = Hex.toArray(internalValue);

    tea.decrypt(m);

    return Std.parseFloat(Hex.toString(Hex.fromArray(m)));
  }

  private function set_value(v : Float) : Float
  {
    var m = Hex.toArray(Hex.fromString("" + v));

    tea.encrypt(m);

    internalValue = (Hex.fromArray(m)).toLowerCase();
    
    return v;
  }  
}