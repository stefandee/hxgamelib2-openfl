import gamelib2.microvcl.Application;
import gamelib2.microvcl.DisplayTactics;
import gamelib2.data.SprLib;
import openfl.Assets;

class GameLib2Test extends gamelib2.microvcl.Application
{      
  public var sprLib : SprLib;
  
  public function new(title : String)
  { 
    super(title);

	try
    {
      this.root.stage.scaleMode = flash.display.StageScaleMode.EXACT_FIT;
    }
    catch(e : Dynamic)
    {
      trace(e);
    }
  }

  public override function run()
  {
    trace("running the application!");

    //this.root.opaqueBackground = 0xA00000;

    // feed the strMgr with data
    strMgr.init(Assets.getBytes("Data_Lang"));

    // init the sprite library
    sprLib = new SprLib(Assets.getBytes("Data_SprLib"));

    gamelib2.Clock.getInstance();

    // create a form
    var formTest = new FormTest(root, "FormTest", new DisplayTactics(), true, strMgr);
    addForm(formTest);
    
    formTest.enabled = true;
    formTest.x = 0;
    formTest.y = 0;	
    //formTest.width = 640;
    //formTest.height = 480;	
	
#if debug	
    dumpForms();
#end // debug	
    
    //changeLanguage("nl-NL");
  }
  
  static function main()
  {    
#if FirebugTraces
    if(haxe.Firebug.detect())
    {       
      haxe.Firebug.redirectTraces();
    }		
#end // FirebugTraces

    Application.instance = new GameLib2Test("GameLib2 Test Application");

    Application.instance.run();
  }
}