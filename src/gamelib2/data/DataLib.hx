package gamelib2.data;

// app
import flash.utils.ByteArray;

class DataLib
{  
  private function new(data : ByteArray)
  {
    init(data);
  }

  public function init(data : ByteArray)
  {
    data.endian = flash.utils.Endian.LITTLE_ENDIAN;

    //
    // read the file id
    //
    var fileId = data.readUTFBytes(7);

    if (fileId != "DATALIB")
    {
      trace("Error reading the datalib file id, aborting (" + fileId + ")");
      
      return;
    }

    //
    // read the entries count
    //
    var count = data.readInt();

    trace("sprite entries: " + count);

    
    //
    // read the entries sizes
    //
    var sizes : Array<Int> = new Array();

    for(i in 0...count)
    {
      sizes.push(data.readInt());
    }

    /*
    for(size in sizes)
    {
      trace("" + size + " bytes");
    }
    */

    //
    // read the entries data
    //
    for(i in 0...sizes.length)
    {      
      var entryData = new flash.utils.ByteArray();
      
      data.readBytes(entryData, 0, sizes[i]);

      readEntry(i, entryData);      
      
      entryData.clear();
    }
  }

  private function readEntry(index : Int, data : ByteArray)
  {
    // implement in child classes
  }
}