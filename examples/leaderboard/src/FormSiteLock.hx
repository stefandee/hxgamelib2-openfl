// app
import gamelib2.microvcl.Form;
import gamelib2.microvcl.Control;
import gamelib2.microvcl.DisplayTactics;
import gamelib2.microvcl.Helper;
import gamelib2.microvcl.Label;
import gamelib2.microvcl.dt.LabelTactics;
import gamelib2.i18n.Manager;
import gamelib2.Sprintf;
import gamelib2.Utils;

import Data;

// as3.0
//import flash.text.TextField;
//import flash.text.TextFormat;

class FormSiteLock extends Form
{ 
  public function new(parentControl : Control, name : String, displayTactics : DisplayTactics, autoAdd : Bool, strMgr : Manager)
  {
    super(parentControl, name, displayTactics, autoAdd, strMgr);
  }

  public override function createUI()
  {
    trace("createUI");

    // add a black background
    addChild(Helper.createBox(GameDef.STAGE_WIDTH, GameDef.STAGE_HEIGHT, 0x000000, 0x000000));

    var labelMsg = new Label(
      this, 
      "LabelMsg", 
      new ui.dt.SiteLockLabelTactics(flash.text.TextFieldAutoSize.CENTER, flash.text.TextFormatAlign.CENTER, 512),
      true,
      strMgr
      );

    labelMsg.caption = "<body>" + "<span class='content'>" + 
      Sprintf.format("%s MAY BE USED ONLY ON %s!", [Data.GameName, Data.PortalName]) + 
      "</span>" + "</body>";

    labelMsg.x = Std.int((GameDef.STAGE_WIDTH - labelMsg.width) / 2);
    labelMsg.y = Std.int(GameDef.STAGE_HEIGHT / 2 - labelMsg.height / 2);

    this.buttonMode    = true;
    this.mouseChildren = false;
    this.onClickEvent  = onClickForm;
  }

  private function onClickForm(e : flash.events.Event)
  {
#if UseMochiAnalytics
    mochi.as3.MochiEvents.trackEvent("FormSiteLock", "Click");
#end // UseMochiAnalytics

    Utils.openLink(Data.PortalLink);    
  }
}