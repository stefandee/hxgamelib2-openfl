package gamelib2.leaderboard;

// haxe
import haxe.xml.Fast;

// as3.0
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

class GameInfo extends Observable implements IXML
{
  public static var STATE_EVENT (default, never) : Int = 1;
  public static var LOAD_EVENT  (default, never) : Int = 2;
  public static var ERROR_EVENT (default, never) : Int = 4;

  public var name     (default, null) : String;
  public var tagline  (default, null) : String;
  public var gameId   (default, null) : Int;
  public var stats    (default, null) : Array<StatInfo>;

  public var submitToken (default, null) : Int;

  @:isVar public var state   (default, set) : RemoteDataState;

  private var requestor : URLLoader;

  public function new()
  {
    super();

    submitToken = -1;

    state = RemoteDataState.Unavailable;

    stats = new Array();
  }

  public function fromXMLString(str : String) : Void
  {
    var xml = new Fast(Xml.parse(str));

    fromXML(xml);
  }

  public function toXMLString() : String
  {
    return "<gameinfo/>";
  }

  public function fromXML(elem : Fast) : Void
  {
    state = RemoteDataState.Unavailable;

    var item =  elem.node.gameinfo.node.item; // elem.elementsNamed("gameinfo")[0].elementsNamed("item")[0];

    name    =  item.node.name.innerData; // item.elementsNamed("name")[0].toString();
    tagline =  item.node.tagline.innerData; // item.elementsNamed("tagline")[0].toString();

    stats = new Array();
    
    var statItems =  elem.node.stats.nodes.item; // elem.elements("stats")[0].elements("item");

    for(statItem in statItems)
    {
      var statInfo = new StatInfo();

      statInfo.fromXML(statItem);

      stats.push(statInfo);
    }

    submitToken =  Std.parseInt(elem.node.submitToken.innerData); // Std.parseInt(elem.elements("submitToken")[0].toString());

    state = RemoteDataState.Available;

    notify(GameInfo.STATE_EVENT, null);

    trace(name + " - " + tagline + ", submitToken: " + submitToken);
  }

  private function set_state(v : RemoteDataState) : RemoteDataState
  {
    state = v;

    return state;
  }

  public function retrieve(gameId : Int)
  {
    state = RemoteDataState.Unavailable;

    this.gameId = gameId;

    //Create the HTTP request object 
    var request:URLRequest = new URLRequest(LeaderboardDef.BASE_URL + "/" + LeaderboardDef.BASE_CONTROLLER + "/" + "info/game_id/" + gameId + "/format/xml" ); 
    request.method = URLRequestMethod.GET; 

    //Initiate the transaction 
    requestor = new URLLoader(); 
    requestor.addEventListener( Event.COMPLETE, requestComplete ); 
    requestor.addEventListener( IOErrorEvent.IO_ERROR, requestError ); 
    requestor.addEventListener( SecurityErrorEvent.SECURITY_ERROR, requestError ); 
    requestor.load( request ); 
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

  public function getStatByName(name : String) : StatInfo
  {
    for(stat in stats)
    {
      if (stat.name == name)
      {
        return stat;
      }
    }

    return null;
  }
}

