package gamelib2.data;

// app
import flash.utils.ByteArray;

class DataLibX
{  
  private var onEntryDataRead : Dynamic -> Void;
  
  public function new(data : ByteArray, onEntryDataRead : Dynamic -> Void)
  {
    this.onEntryDataRead = onEntryDataRead;
    
    init(data);
  }

  private function init(data : ByteArray)
  {
    trace(data.bytesAvailable + "/" + data.length);
    
    data.endian = flash.utils.Endian.LITTLE_ENDIAN;

    //
    // read the file id
    //
    var fileId = data.readUTFBytes(7);

    if (fileId != "DATALIB")
    {
      trace("Error reading the datalib file id, aborting.");
      
      return;
    }

    //
    // read the entries count
    //
    var count = data.readInt();

    trace("data entries: " + count);

    
    //
    // read the entries sizes
    //
    var sizes : Array<Int> = new Array();

    for(i in 0...count)
    {
      sizes.push(data.readInt());
    }

    for(size in sizes)
    {
      trace("" + size + " bytes");
    }

    //
    // read the entries data
    //
    for(i in 0...sizes.length)
    {      
      var entryData = new flash.utils.ByteArray();
      
      data.readBytes(entryData, 0, sizes[i]);

      readEntry(entryData);      
    }
  }

  private function readEntry(data : ByteArray)
  {
    if (onEntryDataRead != null)
    {
      onEntryDataRead(data);
    }
  }
}