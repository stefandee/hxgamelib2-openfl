package gamelib2.microvcl.leaderboard;

// as3
import flash.display.Sprite;
import gamelib2.leaderboard.Submit;

// gamelib2
import gamelib2.math.MathEx;
import gamelib2.microvcl.Control;
import gamelib2.microvcl.ButtonControl;
import gamelib2.microvcl.Label;
import gamelib2.microvcl.TextInput;
import gamelib2.microvcl.dt.TextInputTactics;
import gamelib2.microvcl.Helper;
import gamelib2.microvcl.SentrySpriteWrapper;
import gamelib2.i18n.Manager;
import gamelib2.sentry.SentrySprite;
import gamelib2.microvcl.DisplayTactics;
import gamelib2.leaderboard.Api;
import gamelib2.leaderboard.SubmitEntry;
import gamelib2.leaderboard.GameInfo;
import gamelib2.microvcl.ComboBoxControl;
import gamelib2.pattern.observer.IObserver;
import gamelib2.pattern.observer.Observable;
import gamelib2.microvcl.leaderboard.ControlLeaderboard;
import gamelib2.microvcl.leaderboard.WaitFx;
import gamelib2.microvcl.leaderboard.UIDef;
import gamelib2.microvcl.leaderboard.dt.GenericLabelTactics;
import gamelib2.microvcl.leaderboard.dt.ComboBoxTactics;
import gamelib2.microvcl.leaderboard.dt.ButtonTactics;

// app
import data.AllStrings;

class ControlSubmitScore extends Control implements IObserver
{  
  @:isVar public var playerName (default, set)       : String;
  @:isVar public var submitEntries (default, set) : Array<SubmitEntry>;

  //public var submit (default, null) : Submit;
  
  private var labelTitle  : Label;
  private var labelScore  : Label;
  private var labelError  : Label;
  private var cbStats     : ComboBoxControl;
  private var btnSubmit   : ButtonControl;
  private var fxSubmit    : WaitFx;
  private var bkgScore    : Sprite;
  private var bkgInput    : Sprite;
  private var inputName   : TextInput;
  private var btnSend     : ButtonControl;
  //private var btnContinue : ButtonControl;
  private var fx          : WaitFx;

  private var api         : Api;

  public var onCloseEvent (default, default) : Void -> Void;
  
  public function new(parentControl : Control, name : String, displayTactics : DisplayTactics, autoAdd : Bool, strMgr : Manager)
  {    
    //submit = new Submit();
    api = Api.instance;

    api.gameInfo.attach(this, GameInfo.STATE_EVENT);
    api.gameInfo.attach(this, GameInfo.LOAD_EVENT);
    api.gameInfo.attach(this, GameInfo.ERROR_EVENT);

    api.submit.attach(this, gamelib2.leaderboard.Submit.SUCCESS_EVENT);
    api.submit.attach(this, gamelib2.leaderboard.Submit.ERROR_EVENT);

    super(parentControl, name, displayTactics, autoAdd, strMgr);

    submitEntries = new Array();
  }

  public override function createUI()
  {
    labelTitle = new Label(
      this, 
      "LabelTitle", 
      new GenericLabelTactics(flash.text.TextFieldAutoSize.CENTER, flash.text.TextFormatAlign.CENTER),
      true,
      strMgr
      );

    labelTitle.x = UIDef.DEFAULT_SUBMIT_WIDTH / 2;

    bkgScore = new Sprite();

    Helper.drawGradientWBox(bkgScore.graphics, 0, 0, UIDef.DEFAULT_SUBMIT_SCOREBOX_WIDTH, UIDef.DEFAULT_SUBMIT_SCOREBOX_HEIGHT, [0xFFC000, 0xFFFFFF], [1.0, 1.0], false, true);

    addChild(bkgScore);

    bkgScore.x = UIDef.DEFAULT_SUBMIT_WIDTH / 2 - bkgScore.width / 2;
    bkgScore.y = UIDef.DEFAULT_SUBMIT_HEADER_HEIGHT + 5;
    
    labelScore = new Label(
      this, 
      "LabelScore", 
      new GenericLabelTactics(flash.text.TextFieldAutoSize.CENTER, flash.text.TextFormatAlign.CENTER),
      true,
      strMgr
      );

    //labelScore.x = UIDef.DEFAULT_SUBMIT_WIDTH / 2;

    cbStats = new ComboBoxControl(this, "ComboboxStats", new ComboBoxTactics(ComboBoxType.Fixed, UIDef.DEFAULT_SUBMIT_SCOREBOX_WIDTH - 6), true, strMgr);
    //cbStats.x = 4;
    cbStats.onChangeEvent = onChangeStat;
    cbStats.visible = true;

            /*
            var fontSize : Int = 36;

            var format:ElementFormat = new ElementFormat();        
            format.fontDescription = new FontDescription("Adobe Hebrew");
            format.fontSize = fontSize;
            var y : Float = 100;
            var leading : Float = fontSize * 0.2;
            var text:String = "abc" + String.fromCharCode(0x05D0) + String.fromCharCode(0x05D1) + String.fromCharCode(0x05D2);

            var textBlock:TextBlock = new TextBlock();
            textBlock.content = new TextElement(text, format);
                        
            // bidiLevel even
            textBlock.bidiLevel = 0;
            var textLine = textBlock.createTextLine(null, 400);
            y += leading + textLine.ascent;
            textLine.y = y;
            y += textLine.descent;
            addChild(textLine);      
            
            // bidiLevel odd
            textBlock.content = new TextElement(text, format);
            textBlock.bidiLevel = 1;
            textLine = textBlock.createTextLine(null, 400);
            y += leading + textLine.ascent;          
            textLine.y = y;
            addChild(textLine);
            */

    bkgInput = new Sprite();

    var boxWidth = UIDef.DEFAULT_SUBMIT_INPUTBOX_WIDTH;

    Helper.drawGradientWBox(bkgInput.graphics, 0, 0, boxWidth, 32, [0xC0C0C0, 0xF0F0F0], [1.0, 1.0], false, true);

    bkgInput.graphics.lineStyle(3, 0xA0A0A0);
    bkgInput.graphics.moveTo(0, 0);
    bkgInput.graphics.lineTo(boxWidth, 0);

    bkgInput.x = UIDef.DEFAULT_SUBMIT_WIDTH / 2 - bkgInput.width / 2;

    addChild(bkgInput);

    inputName = new TextInput(this, "TextInput", new TextInputTactics(UIDef.FontGenericName, 24, UIDef.DEFAULT_SUBMIT_INPUTBOX_WIDTH, UIDef.DEFAULT_SUBMIT_INPUTBOX_HEIGHT, flash.text.TextFieldAutoSize.NONE, flash.text.TextFormatAlign.LEFT, 0x404040, 32), true, strMgr);
    inputName.x = UIDef.DEFAULT_SUBMIT_WIDTH / 2;//5;
    inputName.caption = string(AllStrings.StrLdrId_DefaultSubmitName);
    inputName.alpha = UIDef.DEFAULT_SUBMIT_INPUT_DISABLED;

    inputName.onFocusInEvent   = onTextFocusIn;
    inputName.onFocusOutEvent  = onTextFocusOut;

    btnSend = new ButtonControl(this, "BtnSend", new ButtonTactics(UIDef.FontGenericName, 18, 120, 24, 0xFFFFFF, 0xFFFFC0, 0x000000, 0x000000), true, strMgr);
    btnSend.onClickEvent = onClickSend;

    //btnContinue = new ButtonControl(this, "BtnContinue", new ButtonTactics(UIDef.FontGenericName, 18, 120, 24, 0xFFFFFF, 0xFFFFC0, 0x000000, 0x000000), true, strMgr);
    //btnContinue.onClickEvent = onClickContinue;

    fx = new WaitFx(this, "WaitFx", null, true, strMgr);
    fx.setParam(8, 2, -0.2, 10, 2, 0x000000);
    fx.visible = false;

    submitEntries = new Array();
  }

  public override function updateUI()
  {
    labelTitle.caption = "<body>" +
      "<span class=\"submitTitle\">" + string(AllStrings.StrLdrId_NewScore) + "</span>" +
      "</body>";

    labelTitle.y = UIDef.DEFAULT_SUBMIT_HEADER_HEIGHT / 2 - labelTitle.height / 2;

    
    //if (cbStats.items.length == 0)
    if (submitEntries.length == 0)
    {
      labelScore.caption = "<body>" +
        "<span class=\"submitScore\">" + string(AllStrings.StrLdrId_NoScore) + "</span>" +
        "</body>";
    }
    else
    {
      trace(submitEntries);
      trace(cbStats);
      trace(cbStats.itemIndex);
      
      labelScore.caption = "<body>" +
        "<span class=\"submitScore\">" + ((submitEntries != null) ? ("" + submitEntries[cbStats.itemIndex].value) : "0") + "</span>" +
        "</body>";
    }

    //
    // config the combobox
    //
          cbStats.clearItems();

          //if (api.gameInfo.stats != null)
          //{
          for(submitEntry in submitEntries)
          {
            var statInfo = api.gameInfo.getStatByName(submitEntry.statName);

            if (statInfo == null)
            {
              cbStats.addItem(submitEntry.statName);

              trace(submitEntry.statName);
            }
            else
            {
              cbStats.addItem(statInfo.displayName);

              trace(statInfo.displayName);
            }        
          }
          //}

          if (cbStats.items.length == 0)
          {
            cbStats.addItem(string(AllStrings.StrLdrId_NoStats));
          }

          cbStats.itemIndex = 0;


    //
    // more config
    //

    labelScore.x = bkgScore.x + bkgScore.width / 2;// - labelScore.width / 2;

    //cbStats.y = UIDef.DEFAULT_SUBMIT_HEADER_HEIGHT + UIDef.DEFAULT_SUBMIT_HEADER2_HEIGHT / 2 - cbStats.height / 2;

    cbStats.x = bkgScore.x + bkgScore.width / 2 - cbStats.width / 2;
    cbStats.y = bkgScore.y + 5;

    labelScore.y = cbStats.y + cbStats.height;//UIDef.DEFAULT_SUBMIT_HEADER_HEIGHT + UIDef.DEFAULT_SUBMIT_HEADER2_HEIGHT;

    inputName.x = bkgInput.x + 3;
    inputName.y = bkgScore.y + bkgScore.height + UIDef.DEFAULT_SUBMIT_SCOREBOX_INPUT_V_SPACING;
    bkgInput.y = bkgScore.y + bkgScore.height + UIDef.DEFAULT_SUBMIT_SCOREBOX_INPUT_V_SPACING;

    btnSend.caption = string(AllStrings.StrLdrId_Submit);
    btnSend.x = UIDef.DEFAULT_SUBMIT_WIDTH / 2 - btnSend.width / 2;
    btnSend.y = UIDef.DEFAULT_SUBMIT_HEIGHT - btnSend.height - 6;
    //btnSend.visible = true;

    fx.x = btnSend.x + btnSend.width / 2;
    fx.y = btnSend.y + btnSend.height / 2;

    //btnContinue.caption = string(AllStrings.StrLdrId_SubmitContinue);
    //btnContinue.x = UIDef.DEFAULT_SUBMIT_WIDTH / 2 - btnContinue.width / 2;
    //btnContinue.y = UIDef.DEFAULT_SUBMIT_HEIGHT - btnContinue.height - 6;
    //btnContinue.visible = false;    
    //btnContinue.onClickEvent = onClickContinue;
  }

  /*
  public function setArray(stats : Array<SubmitEntry>)
  {
    submit.resetStats();

    if (stats != null)
    {
      for(stat in stats)
      {
        submit.addEntry(stat);
      }
    }

    updateUI();
  }
  */

  public override function changeLanguage()
  {
    super.changeLanguage();

    updateUI();
  }

	public function update(type : Int, source : Observable, userData : Dynamic) : Void
  {
    trace("event observed: " + source + " / " + type);
    
    if (source == api.gameInfo)
    {
      switch(type)
      {
        case GameInfo.STATE_EVENT:
        {                                        
          trace("GameInfo updated!");
    
          updateUI();
        }
      }      
    }

    if (source == api.submit)
    {
      btnSend.visible = true;
      fx.visible = false;
      
      if (onCloseEvent != null)
      {
        onCloseEvent();
      }

      switch(type)
      {
        case Submit.SUCCESS_EVENT:
        {
        }

        case Submit.ERROR_EVENT:
        {
        }
      }
    }    
  }

  private function onChangeStat(e : flash.events.Event)
  {
    trace(cbStats.itemIndex + "/" + submitEntries.length);
    
    if (cbStats.itemIndex >= 0 && cbStats.itemIndex < submitEntries.length)
    {    
      labelScore.caption = "<body>" +
        "<span class=\"submitScore\">" + submitEntries[cbStats.itemIndex].value + "</span>" +
        "</body>";
     }

    // cbStats.itemIndex
  }

  private function onTextFocusIn(e : flash.events.Event)
  {
    trace("focus in!");

    if (inputName.getEditedText() == string(AllStrings.StrLdrId_DefaultSubmitName))
    {
      inputName.caption = "";
      playerName = "";
      inputName.alpha = 1.0;
    }
  }

  private function onTextFocusOut(e : flash.events.Event)
  {
    var editedText = StringTools.trim(inputName.getEditedText());
    
    if (editedText == string(AllStrings.StrLdrId_DefaultSubmitName) ||
        editedText == "")
    {
      inputName.caption = string(AllStrings.StrLdrId_DefaultSubmitName);
      inputName.alpha = UIDef.DEFAULT_SUBMIT_INPUT_DISABLED;
      playerName = inputName.caption;
    }
    else
    {
      bkgInput.filters = null;

      playerName = editedText;
    }
  }

  private function onClickSend(e : flash.events.Event)
  {
    var editedText = StringTools.trim(inputName.getEditedText());
    
    if (editedText == string(AllStrings.StrLdrId_DefaultSubmitName) ||
        editedText == "")
    {
      bkgInput.filters = [new flash.filters.GlowFilter(0xFF0000, 0.5, 8, 8)];
      
      return;
    }

    btnSend.visible = false;
    fx.visible = true;

    trace("will now send stuff!");

    api.submit.massSubmit(api.gameInfo.gameId, this.playerName, submitEntries, api.gameInfo.submitToken);
  }

  private function set_playerName(v : String) : String
  {
    var temp = StringTools.trim(v);

    if (temp != "")
    {
      playerName        = temp;
      inputName.caption = temp;
    }
    
    return playerName;
  }

  private function set_submitEntries(v : Array<SubmitEntry>)
  {
    if (v != null)
    {
      submitEntries = new Array();

      trace("to submit entries: " + v.length);

      for(entry in v)
      {
        trace("to submit: " + entry.statName);
        
        submitEntries.push(new SubmitEntry(entry.statName, entry.value));
      }

      updateUI();
    }
       
    return submitEntries;
  }

  public function set(statName : String, value : Int)
  {
    submitEntries = new Array();

    submitEntries.push(new SubmitEntry(statName, value));

    updateUI();
  }
}