// as3
import flash.events.Event;
import flash.events.MouseEvent;
import flash.display.MovieClip;

// app
import gamelib2.microvcl.Form;
import gamelib2.microvcl.Control;
import gamelib2.microvcl.ButtonControl;
import gamelib2.microvcl.DisplayTactics;
import gamelib2.microvcl.Helper;
import gamelib2.i18n.Manager;
import gamelib2.sentry.SentrySprite;
import gamelib2.data.SprLib;
import gamelib2.microvcl.Button;
import gamelib2.Utils;
import gamelib2.microvcl.SentrySpriteWrapper;
import gamelib2.leaderboard.Leaderboard;
import gamelib2.leaderboard.SubmitEntry;
import gamelib2.microvcl.leaderboard.ControlLeaderboard;
import gamelib2.microvcl.leaderboard.ControlSubmitScore;
import gamelib2.microvcl.leaderboard.dt.ControlLeaderboardTactics;
import gamelib2.microvcl.leaderboard.dt.ControlSubmitScoreTactics;
import gamelib2.microvcl.leaderboard.dt.ButtonTactics;
import gamelib2.microvcl.leaderboard.UIDef;

import GameDef;
import Data;

class FormMain extends FormGame
{ 
  private var controlLeaderboard : ControlLeaderboard;
  private var controlSubmit      : ControlSubmitScore;
  
  public function new(parentControl : Control, name : String, displayTactics : DisplayTactics, autoAdd : Bool, strMgr : Manager)
  {
    super(parentControl, name, displayTactics, autoAdd, strMgr);

    addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
  }

  public override function createUI()
  {
    var bkg = Helper.createBox(GameDef.STAGE_WIDTH, GameDef.STAGE_HEIGHT, 0x808080, 0x808080, 0);
    addChild(bkg);

    /*
    controlSubmit = new ControlSubmitScore(this, "Submit", new ControlSubmitScoreTactics(), true, strMgr);
    controlSubmit.x = (GameDef.STAGE_WIDTH - controlSubmit.width) / 2;
    controlSubmit.y = (GameDef.STAGE_HEIGHT - controlSubmit.height) / 2;

    controlSubmit.submitEntries = [new SubmitEntry("highscore_normal", 256463), new SubmitEntry("highscore_easy", 95000)];

    controlSubmit.x = (GameDef.STAGE_WIDTH - controlSubmit.width) / 2;
    controlSubmit.onCloseEvent = onCloseSubmit;
    //var btnSend = new ButtonControl(this, "BtnSend", new ButtonTactics(UIDef.FontGenericName, 16, 72, 24, 0xFFFFFF, 0xFFFF00, 0x000000, 0x000000), true, strMgr);
    */
    
    controlLeaderboard = new ControlLeaderboard(this, "Leaderboard", new ControlLeaderboardTactics(), true, strMgr);
    controlLeaderboard.x = (GameDef.STAGE_WIDTH - controlLeaderboard.width) / 2;
    controlLeaderboard.y = (GameDef.STAGE_HEIGHT - controlLeaderboard.height) / 2;
    //controlLeaderboard.visible = false;
  }

  public override function updateUI()
  {
  }

  private override function onEnterFrame(e : Event)
  {
  }

  private function onAddedToStage(e : Event)
  {
  }

  public override function changeLanguage()
  {
    super.changeLanguage();

    updateUI();
  }

  private function onCloseSubmit()
  {
    // hide the submit control
    controlSubmit.visible      = false;

    // setup the leaderboard
    controlLeaderboard.visible = true;

    controlLeaderboard.setLastSubmission(controlSubmit.playerName, controlSubmit.submitEntries);

    controlLeaderboard.showLastSubmission = true;
  }
}