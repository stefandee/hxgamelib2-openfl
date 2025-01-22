package gamelib2.leaderboard;

import haxe.xml.Fast;

import gamelib2.data.IXML;

class StatInfo implements IXML
{
  public var name            : String;
  public var id              : Int;
  public var displayName     : String;
  public var higherIsBetter  : Bool;

  public function new()
  {
    //state = RemoteDataState.Unavailable;
  }

  public function fromXMLString(str : String) : Void
  {
    var xml = new Fast(Xml.parse(str));

    fromXML(xml);
  }

  public function toXMLString() : String
  {
    return "<statinfo/>";
  }

  public function fromXML(elem : Fast) : Void
  {
    // trace(elem.toString());
    
    name        = elem.node.stat_name.innerData; // elem.elements("stat_name")[0].toString();
    id          = Std.parseInt(elem.node.stat_id.innerData); // Std.parseInt(elem.elements("stat_id")[0].toString());
    displayName = elem.node.display_name.innerData; // elem.elements("display_name")[0].toString();

    higherIsBetter = (Std.parseInt(elem.node.higher_is_better.innerData) > 0); // (Std.parseInt(elem.elements("higher_is_better")[0].toString()) > 0);

    trace(name + " - " + id + " - " + displayName + " - " + higherIsBetter);
  }
}
