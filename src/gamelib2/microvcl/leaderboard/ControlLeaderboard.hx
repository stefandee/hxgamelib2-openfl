package gamelib2.microvcl.leaderboard;

// app
import gamelib2.microvcl.Form;
import gamelib2.microvcl.Control;
import gamelib2.microvcl.ButtonControl;
import gamelib2.microvcl.ComboBoxControl;
import gamelib2.i18n.Manager;
import gamelib2.microvcl.Button;
import gamelib2.sentry.SentrySprite;
import gamelib2.microvcl.Label;
import haxe.ds.StringMap;

import gamelib2.leaderboard.Api;
import gamelib2.leaderboard.Leaderboard;
import gamelib2.leaderboard.GameInfo;
import gamelib2.leaderboard.StatInfo;
import gamelib2.leaderboard.SubmitEntry;
import gamelib2.leaderboard.Def;
import gamelib2.pattern.observer.IObserver;
import gamelib2.pattern.observer.Observable;
import gamelib2.microvcl.leaderboard.dt.ArrowButtonTactics;
import gamelib2.microvcl.leaderboard.UIDef;
import gamelib2.microvcl.leaderboard.dt.ComboBoxTactics;
import gamelib2.microvcl.leaderboard.dt.GenericLabelTactics;

import data.AllStrings;

class ControlLeaderboard extends Control implements IObserver
{  
  private var api               : Api;
  
  //public var gameId (default, setGameId) : Int;
  public var leaderboards       : StringMap<Leaderboard>;

  //public var timeSpan (default, setTimeSpan) : TimeSpan;
  public var currentStat        : StatInfo;

  public var statFilters        : Array<String>;

  @:isVar public var showLastSubmission (default, set) : Bool;

  //public var submit             (default, setSubmit)         : Submit;

  private var playerName (default, null) : String;
  private var submitEntries (default, null) : Array<SubmitEntry>;

  // ui related
  private var labelGameTitle    : Label;
  private var labelError        : Label;
  private var fx                : WaitFx;
  private var fx2               : WaitFx;
  private var fx3               : WaitFx;
  private var containerStat     : Control;
  //private var containerTable    : Control;
  private var cbTest            : ComboBoxControl;
  private var btnTest           : ButtonControl;
  private var btnTest2          : ButtonControl;
  private var btnTest3          : ButtonControl;
  private var btnTest4          : ButtonControl;
  private var leaderboardTable  : LeaderboardTable;

  private var currentScore      : CurrentScore;

  public function new(parentControl : Control, name : String, displayTactics : DisplayTactics, autoAdd : Bool, strMgr : Manager)
  {
    super(parentControl, name, displayTactics, autoAdd, strMgr);

    api = Api.instance;

    api.gameInfo.attach(this, GameInfo.STATE_EVENT);
    api.gameInfo.attach(this, GameInfo.LOAD_EVENT);
    api.gameInfo.attach(this, GameInfo.ERROR_EVENT);

    leaderboards = new StringMap();    
  }

  public override function createUI()
  {
    //trace(UIDef.codeFlag.get("us"));
    
    labelGameTitle = new Label(
      this, 
      "LabelGameTitle", 
      new GenericLabelTactics(flash.text.TextFieldAutoSize.CENTER, flash.text.TextFormatAlign.CENTER),
      true,
      strMgr
      );     

    labelGameTitle.visible = false;
    labelGameTitle.x = 200;
    labelGameTitle.y = 0;

    fx = new WaitFx(this, "WaitFx", null, true, strMgr);
    fx.setParam(8, 2, -0.2, 8, 2, 0xFFFFFF);

    fx.visible = true;
    fx.x = 200;
    fx.y = 16;

    /*
    var testBtn = new gamelib2.microvcl.ButtonControl(this, "BtnTest", new ArrowButtonTactics(10, 12, ArrowOrientation.Left, 0x808080, 0x000000), true, strMgr);
    testBtn.x = 100;
    testBtn.y = 100;
    */

    fx2 = new WaitFx(this, "WaitFx2", null, true, strMgr);
    fx2.setParam(8, 1, -0.2, 8, 2, 0x000000);

    fx2.visible = true;
    fx2.x = 200;
    fx2.y = 32 + 12;

    cbTest = new ComboBoxControl(this, "ComboboxTest", new ComboBoxTactics(ComboBoxType.Fixed, UIDef.DEFAULT_WIDTH - 10), true, strMgr);
    cbTest.x = 5;
    cbTest.y = 32;
    cbTest.onChangeEvent = onChangeStat;
    cbTest.visible = false;

    leaderboardTable = new LeaderboardTable(this, "LeaderboardTable", null, true, strMgr);
    leaderboardTable.x = 5;
    leaderboardTable.y = 60;
    leaderboardTable.visible = false;

    fx3 = new WaitFx(this, "WaitFx3", null, true, strMgr);
    fx3.setParam(12, 4, -0.12, 20, 2, 0x000000);

    fx3.visible = false;
    fx3.x = 200;
    fx3.y = (32 + 24) + (UIDef.DEFAULT_HEIGHT - (32 + 24)) / 2;

    currentScore = new CurrentScore(this, "CurrentScore", null, true, strMgr);
    currentScore.x = UIDef.DEFAULT_H_BORDER;
    currentScore.y = UIDef.DEFAULT_HEIGHT - 35;

    labelError = new Label(this, "LabelError", new GenericLabelTactics(flash.text.TextFieldAutoSize.CENTER, flash.text.TextFormatAlign.CENTER), true, strMgr);     
    labelError.visible = false;
    labelError.x = UIDef.DEFAULT_WIDTH / 2;
    labelError.y = leaderboardTable.y + UIDef.DEFAULT_VISIBLE_ROWS * UIDef.DEFAULT_TABLE_ROW_V_SPACING / 2;

    showLastSubmission = true;

    //submit = new Submit();
    submitEntries = new Array();

    // TEST CODE
    /*
    playerName = "Karg";
    submitEntries.push(new SubmitEntry("highscore_easy", 120000));

    currentScore.playerName  = playerName;
    currentScore.submitEntry = SubmitEntry.get("highscore_easy", submitEntries);//submit.get("highscore_easy");
    */
    // TEST CODE
  }

  public override function updateUI()
  {
    currentScore.visible = showLastSubmission;

    if (api.gameInfo == null)
    {
      fx.visible = true;
      labelGameTitle.visible = false;

      fx2.visible        = true;
      cbTest.visible     = false;
    }
    else
    {
      switch(api.gameInfo.state)
      {
        case RemoteDataState.Available:
        {
          labelGameTitle.visible = true;
          fx.visible = false;

          fx2.visible        = false;
          cbTest.visible     = true;

          labelGameTitle.caption = "<body>" +
            "<span class=\"gameTitle\">" + api.gameInfo.name + "</span>" +
            "</body>";

          // avoid spills
          var titleMaxWidth = UIDef.DEFAULT_WIDTH - 2 * UIDef.DEFAULT_H_BORDER;
          
          if (labelGameTitle.width > titleMaxWidth)
          {
            labelGameTitle.width = titleMaxWidth;
          }

          cbTest.clearItems();

          if (api.gameInfo.stats.length > 0)
          {          
            for(stat in api.gameInfo.stats)
            {              
              cbTest.addItem(stat.displayName);
            }

            cbTest.itemIndex = 0;

            currentScore.submitEntry = SubmitEntry.get(api.gameInfo.stats[cbTest.itemIndex].name, submitEntries);//submit.get(api.gameInfo.stats[cbTest.itemIndex].name);
          }
          else
          {
            // TODO: localization
            cbTest.addItem("No Stats Available.");
            cbTest.itemIndex = 0;

            currentScore.submitEntry = null;
          }
        }

        default:
        {
          fx.visible             = true;
          labelGameTitle.visible = false;

          fx2.visible        = true;
          cbTest.visible     = false;
        }
      }
    }
  }

  /*
  private function setGameId(id : Int) : Int
  {
    gameId = id;
    
    api.gameInfo.retrieve(gameId);

    return gameId;
  }
  */

	public function update(type : Int, source : Observable, userData : Dynamic) : Void
  {
    trace("event observed: " + source + " / " + type);
    
    if (source == api.gameInfo)
    {
      switch(type)
      {
        case GameInfo.STATE_EVENT:
        {                                        
          updateUI();

          if (api.gameInfo.stats.length > 0)
          {          
            currentStat = api.gameInfo.stats[0];

            retrieveLeaderboard(api.gameInfo.gameId, currentStat.name);
          }
          else
          {
            currentStat = null;
          }
        }
      }      
    }

    if (Std.is(source, Leaderboard))
    {
      cbTest.enabled = true;

      switch(type)
      {
        case Leaderboard.STATE_EVENT:
        {
          // stuff comes already sorted by sql, but making sure anyway :)
          var leaderboard = cast(source, Leaderboard);

          leaderboard.sort(currentStat.higherIsBetter);
          leaderboard.timeStampTTL = Date.now().getTime();
          
          leaderboardTable.leaderboard = leaderboard;

          if (leaderboard.entries.length > 0)
          {
            hideError();
          }
          else
          {
            showError(string(AllStrings.StrLdrId_ErrorEmptyLeaderboard));
          }
          
          //leaderboardTable.visible = true;
          fx3.visible              = false;
          
          //trace("Stat list retrieved.");
        }

        case Leaderboard.ERROR_EVENT:
        {
          leaderboardTable.leaderboard = null;

          showError(string(AllStrings.StrLdrId_ErrorLoadingLeaderboard));
          
          //leaderboardTable.visible = true;
          fx3.visible              = false;
        }

        default:
        {
        }
      }
    }
  }

  private function onChangeStat(e : flash.events.Event)
  {
    trace("combobox change stat!");
    
    cbTest.enabled = false;
    
    currentStat = api.gameInfo.stats[cbTest.itemIndex];
    
    retrieveLeaderboard(api.gameInfo.gameId, currentStat.name);

    currentScore.submitEntry = SubmitEntry.get(api.gameInfo.stats[cbTest.itemIndex].name, submitEntries);//submit.get(api.gameInfo.stats[cbTest.itemIndex].name);
  }

  private function set_showLastSubmission(v : Bool) : Bool
  {
    showLastSubmission = v;

    currentScore.visible = showLastSubmission;

    return showLastSubmission;
  }

  /*
  private function setSubmit(v : Submit) : Submit
  {
    submit = v;

    if (submit != null)
    {
      currentScore.playerName  = submit.playerName;
      currentScore.submitEntry = (submit.stats.length > 0) ? submit.stats[0] : null;
    }
    
    return submit;
  }
  */

  // http://www.preloaders.net/en/rectangular
  // http://stackoverflow.com/questions/73947/what-is-the-best-way-to-stop-people-hacking-the-php-based-highscore-table-of-a-fl

  private function retrieveLeaderboard(gameId : Int, statName : String)
  {
    trace("retrieveLeaderboard(" + gameId + ", " + statName);
    
    var key = leaderboardKey(gameId, statName);

    var leaderboard : Leaderboard = leaderboards.get(key);
    
    // create a leaderboard if none was found
    if (leaderboard == null)
    {
      leaderboard = new Leaderboard();

      leaderboard.attach(this, Leaderboard.STATE_EVENT);
      leaderboard.attach(this, Leaderboard.LOAD_EVENT);
      leaderboard.attach(this, Leaderboard.ERROR_EVENT);    
            
      leaderboards.set(key, leaderboard);

      trace(key + " not found, added to hash!");
    }
    else
    {
      var now = Date.now().getTime();

      trace("delta: " + (now - leaderboard.timeStampTTL));
      
      // only retrieve leaderboards that expired (saves traffic! :)
      if (now - leaderboard.timeStampTTL >= leaderboard.ttl * 1000)
      {
        trace("leaderboard expired, retrieving a new one.");
        
        leaderboard.timeStampTTL = now;
      }
      else
      {
        trace("leaderboard found and still valid!");

        // forcing notify
        leaderboard.notify(Leaderboard.STATE_EVENT, null);
        
        return;
      }
    }
    
    fx3.visible = true;
    leaderboardTable.visible = false;
    cbTest.enabled = false;
    
    leaderboard.retrieve(api.gameInfo.gameId, currentStat.name);
  }

  private function leaderboardKey(gameId : Int, statName : String) : String
  {
    return gameId + "-" + statName;
  }

  public function setLastSubmission(playerName : String, entries : Array<SubmitEntry>)
  {
    this.playerName = playerName;

    this.submitEntries = new Array();

    if (entries != null)
    {      
      for(entry in entries)
      {
        submitEntries.push(new SubmitEntry(entry.statName, entry.value));
      }
    }

    if (submitEntries.length == 0)
    {
      showLastSubmission = false;
    }

    currentScore.playerName  = playerName;

    // expire the leaderboards for the stats just submitted
    for(entry in submitEntries)
    {
      var leaderboard = leaderboards.get(leaderboardKey(api.gameInfo.gameId, entry.statName));

      if (leaderboard != null)
      {
        trace("reseting the leaderboard timestamp.");
        
        leaderboard.timeStampTTL = Date.now().getTime() - (leaderboard.ttl * 1000);
      }
    }

    updateUI();

    // set the current leaderboard to show the first submitted stat
    if (api.gameInfo.stats.length > 0 && submitEntries.length > 0)
    {          
      for(i in 0...api.gameInfo.stats.length)
      {
        if (api.gameInfo.stats[i].name == submitEntries[0].statName)
        {
          trace("current leaderboard is set for: " + submitEntries[0].statName + "(" + i + ")");
          
          cbTest.itemIndex = i;

          currentStat = api.gameInfo.stats[i];

          currentScore.submitEntry = submitEntries[0];

          retrieveLeaderboard(api.gameInfo.gameId, currentStat.name);
          
          break;
        }
      }
    }
  }

  private function showError(error : String)
  {
    labelError.caption = "<body>" + "<span class=\"leaderboardError\">" + error + "</span>" + "</body>";
    labelError.visible = true;
    
    leaderboardTable.visible = false;
  }

  private function hideError()
  {
    labelError.visible = false;
    
    leaderboardTable.visible = true;
  }
}