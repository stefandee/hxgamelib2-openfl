package gamelib.sec;

import com.hurlant.crypto.symmetric.XTeaKey;
import com.hurlant.util.ByteArray;
import com.hurlant.util.Hex;

/**
 * Secure int, to prevent from tampering. This made sense in Flash (to avoid cheating using CheatEngine), but not sure 
 * it makes anymore for HTML5/JS, as it's very easy to debug and change values in the browser.
 * 
 * Please note this class has not been yet tested.
 */
class SecureInt
{
  public var value (get, set) : Int;

  private var tea : XTeaKey;

  /**
   * A hex-encoded string containing the encrypted value
   */
  private var internalValue: String;
  
  public function new(?defaultValue : Int = 0)
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

  private function get_value() : Int
  {
    var m = Hex.toArray(internalValue);

    tea.decrypt(m);

    return Std.parseInt(Hex.toString(Hex.fromArray(m)));
  }

  private function set_value(v : Int) : Int
  {
    var m = Hex.toArray(Hex.fromString("" + v));

    tea.encrypt(m);

    internalValue = (Hex.fromArray(m)).toLowerCase();
    
    return v;
  }  
  
}