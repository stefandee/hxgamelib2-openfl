package gamelib2.leaderboard;

// haxe
import haxe.xml.Fast;

// openfl
import flash.events.Event; 
import flash.events.ErrorEvent; 
import flash.events.IOErrorEvent; 
import flash.events.SecurityErrorEvent; 
import flash.net.URLLoader; 
import flash.net.URLRequest; 
import flash.net.URLRequestMethod; 
import flash.net.URLVariables; 

import gamelib2.data.IXML;
import gamelib2.data.XMLHelper;
import gamelib2.leaderboard.Def;
import gamelib2.pattern.observer.Observable;

class LeaderboardEntry implements IXML
{
  public var playerName        : String;
  public var playerCountryCode : String;
  public var value             : Int;
  public var timeStamp         : Int;

  public function new()
  {
  }

  public function fromXMLString(str : String) : Void
  {
    var xml = new Fast(Xml.parse(str));

    fromXML(xml);
  }

  public function toXMLString() : String
  {
    return "<leaderboardentry/>";
  }

  public function fromXML(elem : Fast) : Void
  {
    // TODO: defence: check if attribues exists    
    playerName        = elem.node.player_name.innerData; // elem.elements("player_name")[0].toString();
    playerCountryCode = elem.node.code.innerData; // elem.elements("code")[0].toString();
    value             = Std.parseInt(elem.node.value.innerData); // Std.parseInt(elem.elements("value")[0].toString());
    timeStamp         = Std.parseInt(elem.node.timestamp.innerData); // Std.parseInt(elem.elements("timestamp")[0].toString());
  }
}

class Leaderboard extends Observable implements IXML
{
  public static var STATE_EVENT (default, never) : Int = 1;
  public static var LOAD_EVENT  (default, never) : Int = 2;
  public static var ERROR_EVENT (default, never) : Int = 4;

  public var entries                  : Array<LeaderboardEntry>;
  public var state                    : RemoteDataState;

  public var gameId   (default, null) : Int;
  public var statName (default, null) : String;

  // time-to-live (seconds)
  public var ttl                      : Int;
  public var timeStampTTL             : Float;

  private var requestor               : URLLoader;

  public function new()
  {
    super();

    // default ttl is one hour
    ttl = LeaderboardDef.DEFAULT_LEADERBOARD_TTL;

    state = RemoteDataState.Unavailable;
  }

  public function fromXMLString(str : String) : Void
  {
    var xml = new Fast(Xml.parse(str));

    fromXML(xml);
  }

  public function toXMLString() : String
  {
    return "<leaderboard/>";
  }

  public function fromXML(elem : Fast) : Void
  {
    entries = new Array();
    
    state = RemoteDataState.Unavailable;

    var items = elem.nodes.item; // elem.elements("item");

    for(itemEntry in items)
    {
      var entry = new LeaderboardEntry();

      entry.fromXML(itemEntry);

      entries.push(entry);
    }

    state = RemoteDataState.Available;

    notify(STATE_EVENT, null);
  }

  public function retrieve(gameId : Int, statName : String, ?timeStamp : Int = 0)
  {
    this.gameId   = gameId;
    this.statName = statName;
    
    state = RemoteDataState.Unavailable;

    entries  = new Array();    

    //Create the HTTP request object 
    var request:URLRequest = new URLRequest(LeaderboardDef.BASE_URL + "/" + LeaderboardDef.BASE_CONTROLLER + "/" + "leaderboard/game_id/" + gameId + "/stat_name/" + statName + "/timestamp/" + timeStamp + "/format/xml" ); 
    request.method = URLRequestMethod.GET; 

    //Initiate the transaction 
    requestor = new URLLoader(); 
    requestor.addEventListener( Event.COMPLETE, requestComplete ); 
    requestor.addEventListener( IOErrorEvent.IO_ERROR, requestError ); 
    requestor.addEventListener( SecurityErrorEvent.SECURITY_ERROR, requestError ); 
    requestor.load( request );
    
    timeStampTTL = Date.now().getTime();
  }

  private function requestComplete(event : Event) : Void
  { 
    trace( event.target.data );
    
    // parse the xml received
    fromXMLString(event.target.data);
  } 
   
  private function requestError(error : ErrorEvent) : Void
  { 
    trace("An error occured: " + error.text);
    notify(ERROR_EVENT, null);
  }

  public function sort(higher_is_better : Bool)
  {
    if (higher_is_better)
    {
      entries.sort(ascendingSortCallback);
    }
    else
    {
      entries.sort(descendingSortCallback);
    }
  }

  private function ascendingSortCallback(a : LeaderboardEntry, b : LeaderboardEntry)
  {
    if (a.value == b.value)
    {
      return 0;
    }

    if (a.value < b.value)
    {
      return 1;
    }
    else
    {
      return -1;
    }
  }

  private function descendingSortCallback(a : LeaderboardEntry, b : LeaderboardEntry)
  {
    if (a.value == b.value)
    {
      return 0;
    }

    if (a.value > b.value)
    {
      return 1;
    }
    else
    {
      return -1;
    }
  }
}
