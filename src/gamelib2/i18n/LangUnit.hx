package gamelib2.i18n;

class LangUnit
{
  // a language tag code (BCP 47 format)
  public var id : String;

  private var strings : Array<String>;

  public var stringCount (get, null) : Int;

  public function new(data : flash.utils.ByteArray)
  {
    data.endian = flash.utils.Endian.LITTLE_ENDIAN;

    strings = new Array();

    // read the lang id
    id = data.readUTFBytes(data.readInt());

    // TODO: validate the id structure :)

    // build the strings from the bytearray coming from the StringTool
    try
    {
      var stringCount : Int = data.readInt();

      for(i in 0...stringCount)
      {
        strings.push(data.readUTFBytes(data.readInt()));
      }
    }
    catch(e : Dynamic)
    {
      trace(e);
    }
  }
  
  public function get(index : Int) : String
  {
    if (index < 0 || index >= strings.length)
    {
      return "<INVALID STR IDX!>";
    }

    return strings[index];
  }

  private function get_stringCount() : Int
  {
    return strings.length;
  }
}
