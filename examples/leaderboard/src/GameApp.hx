import haxe.ds.StringMap;

import gamelib2.microvcl.Application;
import gamelib2.microvcl.DisplayTactics;
import gamelib2.data.SprLib;
import gamelib2.Utils;

import Data;

class GameApp extends Application
{    
  public var sprLib                     : SprLib;
  public var currentURI(default, null)  : StringMap<String>;

  public function new(title : String)
  { 
    super(title);

    try
    {
      root.stage.scaleMode = flash.display.StageScaleMode.EXACT_FIT;
    }
    catch(e : Dynamic)
    {
      trace(e);
    }
  }

  private function allowApplication() : Bool
  {
    trace("Checking for sitelock...");

    var host = currentURI.get("host");

#if debug
    // don't lock in debug mode
    return true;
#else    
    var domainsLockTo : Array<String> = new Array();
      
#if PironGamesLock
    domainsLockTo = ["pirongames.com"];
#end // release - Piron Games

    return Utils.allowApplication(host, domainsLockTo);
#end // debug
  }

  public override function run()
  {
    // obtain the current URI
    currentURI = Utils.parseUri(root.stage.loaderInfo.url);

    // init the clock
    gamelib2.Clock.getInstance();
	
	FontModel.init();

    if (allowApplication())
    {
      var formPreload: FormPreload = new FormPreload(root, "FormPreload", new DisplayTactics(), true, strMgr);

      addForm(formPreload);
    }
    else
    {
      trace("Locking the game up.");

      var formLock = new FormSiteLock(root, "SiteLock", new DisplayTactics(), true, strMgr);
      addForm(formLock);
    }
  }

  // shortcut function
  public static function getApp() : GameApp
  {
    return cast(Application.instance, GameApp);
  }

  public static function main() 
  {
    trace("main()");
    
    Application.instance = new GameApp(Data.GameName);

    Application.instance.run();
  }
}