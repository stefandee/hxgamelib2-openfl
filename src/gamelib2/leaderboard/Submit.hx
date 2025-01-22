package gamelib2.leaderboard;

// as3
import flash.events.Event; 
import flash.events.ErrorEvent; 
import flash.events.IOErrorEvent; 
import flash.events.SecurityErrorEvent; 
import flash.net.URLLoader; 
import flash.net.URLRequest; 
import flash.net.URLRequestMethod; 
import flash.net.URLVariables; 

import gamelib2.leaderboard.Def;
import gamelib2.pattern.observer.Observable;

class Submit extends Observable
{
  public static var SUCCESS_EVENT (default, never) : Int = 1;
  public static var ERROR_EVENT(default, never)  : Int = 2;

  private var ready : Bool;

  private var requestor : URLLoader;

  public function new()
  {
    super();
    
    ready = true;
  }

  public function submit(gameId : Int, playerName : String, statName : String, value : Int, submitToken : Int)
  {
    massSubmit(gameId, playerName, [new SubmitEntry(statName, value)], submitToken);
  }

  public function massSubmit(gameId : Int, playerName : String, entries : Array<SubmitEntry>, submitToken : Int)
  {
    if (entries.length == 0)
    {
      notify(ERROR_EVENT, null);
      return;
    }

    if (!ready)
    {
      notify(ERROR_EVENT, null);
      return;
    }
    
    // build the request url
    /*
    var url : String = LeaderboardDef.BASE_URL + "/" + LeaderboardDef.BASE_CONTROLLER + "/" + "submit/game_id/" + gameId + "/player_name/" + StringTools.htmlEscape(playerName);
    //var url : String = LeaderboardDef.BASE_URL + "/" + LeaderboardDef.BASE_CONTROLLER + "/" + "submit/game_id/" + gameId;

    // add the stats
    for(i in 0...entries.length)
    {
      url += "/" + "stat_name" + i + "/" + entries[i].statName + "/value" + i + "/" + entries[i].value;
    }

    url += "/submitToken/" + submitToken;
    url += "/format/xml";

    trace(url);
    trace(StringTools.urlEncode(url));
    */

    // request vars
    var requestVars : URLVariables = new URLVariables();

    requestVars.game_id     = gameId;
    requestVars.player_name = playerName;
    requestVars.submitToken = submitToken;

    for(i in 0...entries.length)
    {
      requestVars.decode("stat_name" + i + "=" + entries[i].statName + "&" + "value" + i + "=" + entries[i].value);      
    }

    trace(requestVars.toString());

    //Create the HTTP request object 
    var request:URLRequest = new URLRequest(LeaderboardDef.BASE_URL + "/" + LeaderboardDef.BASE_CONTROLLER + "/" + "submit"); 
    request.method = URLRequestMethod.POST; 
    request.data = requestVars;

    //Initiate the transaction 
    requestor = new URLLoader(); 
    requestor.addEventListener( Event.COMPLETE, requestComplete ); 
    requestor.addEventListener( IOErrorEvent.IO_ERROR, requestError ); 
    requestor.addEventListener( SecurityErrorEvent.SECURITY_ERROR, requestError ); 
    requestor.load( request ); 

    ready = false;
  }

  private function requestComplete(event : Event) : Void
  { 
    ready = true;

    trace( event.target.data );

    notify(SUCCESS_EVENT, null);
  } 
   
  private function requestError(error : ErrorEvent) : Void
  { 
    trace("An error occured: " + error.text);

    ready = true;

    notify(ERROR_EVENT, null);
  }

  /*

function visitSite(e:MouseEvent):void {
var url:String = "http://api.flickr.com/services/rest/";
var request:URLRequest = new URLRequest(url);
var requestVars:URLVariables = new URLVariables();
requestVars.api_key = "3c84c0ca7f9ae17842a370a3fbc90b63";
requestVars.method = "flickr.test.echo";
requestVars.format = "rest";
requestVars.foo = "bar";
requestVars.sessionTime = new Date().getTime();
request.data = requestVars;
request.method = URLRequestMethod.POST;
 

var urlLoader:URLLoader = new URLLoader();
urlLoader = new URLLoader();
urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
urlLoader.addEventListener(Event.COMPLETE, loaderCompleteHandler, false, 0, true);
urlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler, false, 0, true);
urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler, false, 0, true);
urlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler, false, 0, true);
for (var prop:String in requestVars) {

//trace("Sent: " + prop + " is: " + requestVars[prop]);

}

try {

urlLoader.load(request);

} catch (e:Error) {

trace(e);

}

}  
*/
}