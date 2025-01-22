package gamelib2.microvcl.leaderboard.dt;

// as3.0
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.display.SimpleButton;
import flash.filters.BitmapFilterType;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFieldType;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormatAlign;
import flash.events.Event;

// gamelib2
import gamelib2.microvcl.DisplayTactics;
import gamelib2.sentry.SentrySprite;
import gamelib2.microvcl.Helper;
import gamelib2.microvcl.leaderboard.UIDef;

class ButtonTactics extends DisplayTactics
{
  private var btn          : SimpleButton;
  
  private var onMsg        : TextField;
  private var offMsg       : TextField;
  private var onMsgFormat  : TextFormat;
  private var offMsgFormat : TextFormat;

  private var onGroup      : Sprite;
  private var offGroup     : Sprite;
  private var onBkg        : Sprite;
  private var offBkg       : Sprite;

  private var autoSize         : flash.text.TextFieldAutoSize;
  private var align            : flash.text.TextFormatAlign;

  private var fontName         : String;
  private var originalFontName : String;
  private var embedFonts       : Bool;
  private var textColorOn      : Int;
  private var textColorOff     : Int;
  private var bkgColorOn       : Int;
  private var bkgColorOff      : Int;
  private var fontSize         : Int;
  private var bkgWidth         : Int;
  private var bkgHeight        : Int;

  public function new(fontName : String, fontSize : Int, bkgWidth : Int, bkgHeight : Int, textColorOn : Int, textColorOff : Int, bkgColorOn : Int, bkgColorOff : Int)
  {
    super();

    // default value of the font name to use
    this.fontName         = fontName;
    this.originalFontName = fontName;
    this.textColorOn      = textColorOn;
    this.textColorOff     = textColorOff;
    this.bkgColorOn       = bkgColorOn;
    this.bkgColorOff      = bkgColorOff;
    this.fontSize         = fontSize;
    this.bkgWidth         = bkgWidth;
    this.bkgHeight        = bkgHeight;

    embedFonts = true;
  }

  public override function init()
  {    
    super.init();

    setupParams();
    
    onMsg  = Helper.createTextField(target.caption, embedFonts, TextFieldType.DYNAMIC, flash.text.AntiAliasType.ADVANCED, textColorOn,  TextFieldAutoSize.LEFT, false);
    offMsg = Helper.createTextField(target.caption, embedFonts, TextFieldType.DYNAMIC, flash.text.AntiAliasType.ADVANCED, textColorOff, TextFieldAutoSize.LEFT, false);    

    onMsg.antiAliasType = flash.text.AntiAliasType.ADVANCED;
    offMsg.antiAliasType = flash.text.AntiAliasType.ADVANCED;

    onMsgFormat       = new TextFormat();
    onMsgFormat.color = textColorOn;
    onMsgFormat.bold  = false;
    onMsgFormat.size  = fontSize;
    onMsgFormat.font  = fontName;
    onMsgFormat.align = TextFormatAlign.LEFT;
    onMsgFormat.letterSpacing = 1.0;

    offMsgFormat       = new TextFormat();
    offMsgFormat.color = textColorOff;
    offMsgFormat.bold  = false;
    offMsgFormat.size  = fontSize;
    offMsgFormat.font  = fontName;
    offMsgFormat.align = TextFormatAlign.LEFT;
    offMsgFormat.letterSpacing = 1.0;

    onMsg.setTextFormat(onMsgFormat);
    offMsg.setTextFormat(offMsgFormat);

    //
    // create the "On" container
    //
    onGroup = new Sprite();

    onBkg = Helper.createBox(bkgWidth, bkgHeight, bkgColorOn, bkgColorOn);

    onGroup.addChild(onBkg);
    onGroup.addChild(onMsg);

    onBkg.x = 0;
    onBkg.y = 0;

    //
    // create the "Off" container
    //
    offGroup = new Sprite();

    offBkg = Helper.createBox(bkgWidth, bkgHeight, bkgColorOff, bkgColorOff);
    
    offGroup.addChild(offBkg);
    offGroup.addChild(offMsg);

    offBkg.x = 0;
    offBkg.y = 0;

    offMsg.x = offBkg.width  / 2 - offMsg.width / 2;
    offMsg.y = offBkg.height / 2 - offMsg.height / 2;
    
    onMsg.x = offBkg.width  / 2 - onMsg.width / 2;
    onMsg.y = offBkg.height / 2 - onMsg.height / 2;

    //
    // create the button
    //
    btn = new SimpleButton(onGroup, offGroup, offGroup, onGroup);

    target.addChild(btn);

    btn.x = 0;
    btn.y = 0;
  }

  public override function update()
  {        
    onMsg.text  = target.caption;
    offMsg.text = target.caption;

    //onMsg.autoSize  = this.autoSize;//flash.text.TextFieldAutoSize.LEFT;
    //offMsg.autoSize = this.autoSize;//flash.text.TextFieldAutoSize.LEFT;

    onMsg.embedFonts = embedFonts;
    offMsg.embedFonts = embedFonts;

    onMsgFormat.font = fontName;
    offMsgFormat.font = fontName;

    onMsg.setTextFormat(onMsgFormat);
    offMsg.setTextFormat(offMsgFormat);

    onMsg.x = offBkg.width  / 2 - onMsg.width / 2;
    onMsg.y = offBkg.height / 2 - onMsg.height / 2;

    offMsg.x = offBkg.width  / 2 - offMsg.width / 2;
    offMsg.y = offBkg.height / 2 - offMsg.height / 2;
  }

  public override function changeLanguage()
  {
		trace("ButtonTactics is processing language change event!");

    super.changeLanguage();    

    setupParams();
  }

  private function setupParams()
  {
    if (target.strMgr == null)
    {
      return;
    }

    switch (target.strMgr.lang)
    {
      case "ru-RU":
      {
        fontName   = "Arial";
        embedFonts = false;
      }

      default:
      {
        fontName   = originalFontName;
        embedFonts = true;
      }
    }    
  }
}