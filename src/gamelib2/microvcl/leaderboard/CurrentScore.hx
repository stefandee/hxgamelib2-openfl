package gamelib2.microvcl.leaderboard;

import gamelib2.microvcl.Control;
import gamelib2.microvcl.Label;
import gamelib2.microvcl.SentrySpriteWrapper;
import gamelib2.i18n.Manager;
import gamelib2.microvcl.DisplayTactics;
import gamelib2.leaderboard.Api;
import gamelib2.leaderboard.SubmitEntry;
import gamelib2.microvcl.leaderboard.UIDef;
import gamelib2.microvcl.leaderboard.dt.GenericLabelTactics;

import data.AllStrings;

class CurrentScore extends Control
{  
  @:isVar public var playerName (default, set)   : String;
  @:isVar public var submitEntry (default, set) : SubmitEntry;

  private var btnTwitter                           : SentrySpriteWrapper;
  private var btnFacebook                          : SentrySpriteWrapper;
  private var labelInfo                            : Label;
  
  public function new(parentControl : Control, name : String, displayTactics : DisplayTactics, autoAdd : Bool, strMgr : Manager)
  {    
    super(parentControl, name, displayTactics, autoAdd, strMgr);
  }

  public override function createUI()
  {
    labelInfo = new Label(
      this, 
      "LabelInfo", 
      new GenericLabelTactics(flash.text.TextFieldAutoSize.LEFT, flash.text.TextFormatAlign.LEFT),
      true,
      strMgr
      );

    var app = GameApp.getApp();    

    btnFacebook = new SentrySpriteWrapper(this, "BtnFacebook", null, true, strMgr, app.sprLib.getSprite(data.SprId.SPR_SOCIAL_ICONS), 0);
    btnFacebook.buttonMode = true;
    btnFacebook.onClickEvent = onClickFb;
    btnFacebook.visible = false;

    btnTwitter  = new SentrySpriteWrapper(this, "BtnTwitter", null, true, strMgr, app.sprLib.getSprite(data.SprId.SPR_SOCIAL_ICONS), 1);    
    btnTwitter.buttonMode = true;
    btnTwitter.onClickEvent = onClickTwitter;
    btnTwitter.visible  = false;

    btnFacebook.x = UIDef.DEFAULT_CURRENT_SCORE_WIDTH - btnFacebook.width;
    btnFacebook.y = 0;
    
    btnTwitter.x = btnFacebook.x - 2 - btnTwitter.width;
    btnTwitter.y = 0;

    labelInfo.x = 0;
    labelInfo.y = btnFacebook.y + btnFacebook.height - labelInfo.height;
  }

  public override function updateUI()
  {
    if (submitEntry == null || playerName == null || playerName == "")
    {
      btnTwitter.visible  = false;
      btnFacebook.visible = false;
      //labelInfo.visible   = false;

      labelInfo.caption = "<body>" +
        "<span class=\"currentScoreName\">" + string(AllStrings.StrLdrId_CurrentScoreEmpty) + "</span>" +
        "</body>";

      labelInfo.y = btnFacebook.y + btnFacebook.height - labelInfo.height;
      
      return;
    }

    btnTwitter.visible  = true;
    btnFacebook.visible = true;
    //labelInfo.visible   = true;

    labelInfo.caption = "<body>" +
      "<span class=\"currentScoreName\">" + playerName + ": " + "</span>" +
      "<span class=\"currentScoreValue\">" + submitEntry.value + "</span>" +
      "</body>";

    labelInfo.y = btnFacebook.y + btnFacebook.height - labelInfo.height;
  }

  private function set_playerName(v : String) : String
  {
    playerName = v;

    updateUI();
    
    return playerName;
  }

  private function set_submitEntry(v : SubmitEntry) : SubmitEntry
  {
    submitEntry = v;

    updateUI();

    return submitEntry;
  }

  private function onClickTwitter(e : flash.events.Event) : Void
  {
    var link : String = "http://twitter.com/home?status=" + StringTools.urlEncode(getCurrentLink());

    trace(link);

    gamelib2.Utils.openLink(link);    
  }

  private function onClickFb(e : flash.events.Event) : Void
  {
    var link : String = "http://www.facebook.com/share.php?u=" + StringTools.urlEncode(getCurrentLink());
    
    trace(link);

    gamelib2.Utils.openLink(link);
  }

  private function getCurrentLink() : String
  {
    var statInfo = Api.instance.gameInfo.getStatByName(submitEntry.statName);

    if (statInfo == null)
    {
      trace("Unknown stat: " + submitEntry.statName);
      
      return "";
    }
    
    return "Just scored " + submitEntry.value + " in " + Api.instance.gameInfo.name + " - http://www.pirongames.com/index.php/arcade/play/" + Api.instance.gameInfo.gameId + " !";
  }
}