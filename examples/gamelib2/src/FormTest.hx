import openfl.Assets;

import gamelib2.microvcl.Application;
import gamelib2.microvcl.Control;
import gamelib2.microvcl.DisplayTactics;
import gamelib2.microvcl.Form;
import gamelib2.microvcl.Label;
import gamelib2.microvcl.Helper;
import gamelib2.microvcl.dt.LabelTactics;

import gamelib2.microvcl.SentrySpriteWrapper;
import gamelib2.i18n.Manager;
import gamelib2.Clock;

import data.AllStrings;
import ui.GenericLabelTactics;
import data.SprId;

class FormTest extends Form
{ 
  private var labelMsg     : Label;
  private var labelSimTime : Label;
  private var labelTimer1  : Label;
  private var labelTimer2  : Label;
  private var labelTest    : Label;

  private var sprLib       : gamelib2.data.SprLib;
  
  private var fontDefaultName : String;
  
  public function new(parentControl : Control, name : String, displayTactics : DisplayTactics, autoAdd : Bool, strMgr : Manager)
  {
    var testApp : GameLib2Test = cast Application.instance;
    sprLib = testApp.sprLib;

    super(parentControl, name, displayTactics, autoAdd, strMgr);
  }

  public override function createUI()
  {  
    addChild(Helper.createBox(640, 480, 0x909090, 0x909090, 1));

    var spr = new SentrySpriteWrapper(this, "SpriteContainer", null, true, strMgr, sprLib.getSprite(SprId.SPR_CHAR_AMAZON), 1);
    spr.x = 280;
    spr.y = 64;
	
    var spr2 = new SentrySpriteWrapper(this, "SpriteContainer", null, true, strMgr, sprLib.getSprite(SprId.SPR_CHAR_WRAITH), 1);
    spr2.x = 360;
    spr2.y = 80;
   
    fontDefaultName = Assets.getFont("fonts/emulator.ttf").fontName;
	
	trace(fontDefaultName);

    //labelMsg = new Label(this, "LabelMsg", new ui.GenericLabelTactics(flash.text.TextFieldAutoSize.LEFT, flash.text.TextFormatAlign.LEFT), true, strMgr);
    labelMsg = new Label(this, "LabelMsg", new ui.GenericWrapLabelTactics(flash.text.TextFieldAutoSize.LEFT, flash.text.TextFormatAlign.LEFT, 320), true, strMgr);    

    labelSimTime = new Label(this, "LabelSimTime", new ui.GenericLabelTactics(flash.text.TextFieldAutoSize.LEFT, flash.text.TextFormatAlign.LEFT), true, strMgr);
    labelTimer1 = new Label(this, "LabelTimer1", new ui.GenericLabelTactics(flash.text.TextFieldAutoSize.LEFT, flash.text.TextFormatAlign.LEFT), true, strMgr);
    labelTimer2 = new Label(this, "LabelTimer2", new ui.GenericLabelTactics(flash.text.TextFieldAutoSize.LEFT, flash.text.TextFormatAlign.LEFT), true, strMgr);

    Clock.instance.getTimer(Timer.TIMER_INGAME).speedMultiplier = 0.5;
    Clock.instance.getTimer(Timer.TIMER_SPRITE).speedMultiplier = 3.0;

    labelTest = new Label(this, "LabelTest", new LabelTactics(fontDefaultName, true, 10, flash.text.TextFieldAutoSize.LEFT, flash.text.TextFormatAlign.LEFT, 0xA00000), true, strMgr);

	var mc = Assets.getMovieClip("Swf_GameLogoText:");
    addChild(mc);

    //mc.stop();

    mc.x = 0;
    mc.y = 240;

    //var snd : flash.media.Sound = cast Type.createInstance(Type.resolveClass("Snd_Laser"), []);
    //snd.play(0, 2);

    updateUI();
  }

  public override function changeLanguage()
  {
    super.changeLanguage();
    
    trace("FormTest is processing the language change!");    

    updateUI();
  }

  public override function updateUI()
  {
    labelMsg.caption = "<body>" + "<span class='content'>" + string(AllStrings.kStringID_IngameHelp1) + "</span>" + "</body>";
    labelMsg.x = (640 - labelMsg.width) / 2;
    labelMsg.y = 120 - labelMsg.height / 2;

    labelSimTime.caption = "<body>" + "<span class='content'>" + "sim: " + Clock.instance.simTime + "</span>" + "</body>";
    labelSimTime.x = 160 - labelSimTime.width / 2;
    labelSimTime.y = 180 - labelSimTime.height / 2;

    labelTimer1.caption = "<body>" + "<span class='content'>" + "timer 1: " + Clock.instance.getTimer(Timer.TIMER_INGAME).time + "</span>" + "</body>";
    labelTimer1.x = 320 - labelTimer1.width / 2;
    labelTimer1.y = 180 - labelTimer1.height / 2;

    labelTimer2.caption = "<body>" + "<span class='content'>" + "timer 2: " + Clock.instance.getTimer(Timer.TIMER_SPRITE).time + "</span>" + "</body>";
    labelTimer2.x = 480 - labelTimer2.width / 2;
    labelTimer2.y = 180 - labelTimer2.height / 2;

    labelTest.caption = string(AllStrings.kStringID_IngameHelp2);
    labelTest.x = 320 - labelTest.width / 2;
    labelTest.y = 200;
  }

  private override function onEnterFrame(e : flash.events.Event)
  {
    labelSimTime.caption = "<body>" + "<span class='content'>" + "sim: " + Clock.instance.simTime + "</span>" + "</body>";
    labelTimer1.caption = "<body>" + "<span class='content'>" + "timer 1: " + Clock.instance.getTimer(Timer.TIMER_INGAME).time + "</span>" + "</body>";
    labelTimer2.caption = "<body>" + "<span class='content'>" + "timer 2: " + Clock.instance.getTimer(Timer.TIMER_SPRITE).time + "</span>" + "</body>";
  }
}