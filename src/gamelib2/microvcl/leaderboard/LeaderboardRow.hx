package gamelib2.microvcl.leaderboard;

// gamelib2
import gamelib2.microvcl.DisplayTactics;
import gamelib2.microvcl.Control;
import gamelib2.microvcl.Label;
import gamelib2.microvcl.Helper;
import gamelib2.i18n.Manager;
import gamelib2.data.CountryCodes;
import gamelib2.sentry.SentrySprite;
import gamelib2.microvcl.leaderboard.UIDef;
import gamelib2.microvcl.leaderboard.dt.GenericLabelTactics;

// as3
import flash.display.DisplayObject;
import flash.display.Sprite;

class LeaderboardRow extends Control
{
  public var index (default, default)       : Int;
  public var countryCode (default, default) : String;
  public var playerName (default, default)  : String;
  public var value (default, default)       : Int;
  public var timeStamp (default, default)   : Float;
  public var columns (default, default)     : Array<ColumnSetup>;

  //private var bkg                           : Sprite;
  private var sprFlags                      : SentrySprite;
  private var labelIndex                    : Label;
  private var labelName                     : Label;
  private var labelValue                    : Label;
  private var bkg                           : Sprite;
  
  public function new(parentControl : Control, name : String, displayTactics : DisplayTactics, autoAdd : Bool, strMgr : Manager)
  {
    super(parentControl, name, displayTactics, autoAdd, strMgr);
  }

  public override function createUI()
  {
    bkg = new Sprite();
    addChild(bkg);
    
    labelIndex = new Label(
      this, 
      "LabelIndex", 
      new GenericLabelTactics(flash.text.TextFieldAutoSize.LEFT, flash.text.TextFormatAlign.LEFT),
      true,
      strMgr
      );     

    var app = GameApp.getApp();    
    sprFlags = app.sprLib.getSprite(data.SprId.SPR_FLAGS);
    addChild(sprFlags);

    labelName = new Label(
      this, 
      "LabelName", 
      new GenericLabelTactics(flash.text.TextFieldAutoSize.LEFT, flash.text.TextFormatAlign.LEFT),
      true,
      strMgr
      );

    labelValue = new Label(
      this, 
      "LabelValue", 
      new GenericLabelTactics(flash.text.TextFieldAutoSize.LEFT, flash.text.TextFormatAlign.LEFT),
      true,
      strMgr
      );     
  }

  public override function updateUI()
  {
    labelIndex.caption = "<body>" + "<span class=\"leaderboard\">" + index      + "</span>" + "</body>";
    labelName.caption  = "<body>" + "<span class=\"leaderboard\">" + playerName + "</span>" + "</body>";
    labelValue.caption = "<body>" + "<span class=\"leaderboard\">" + value      + "</span>" + "</body>";

    var flagAnimIndex = CountryCodes.codeFlag.get(countryCode);

    if (flagAnimIndex != null)
    {
      sprFlags.currentAnim = flagAnimIndex;
    }
    else
    {
      sprFlags.visible = false;
    }

    bkg.graphics.clear();

    var color = ((index % 2) == 1) ? 0xF0F0F0 : 0xFAFAFA;

    Helper.drawBox(bkg.graphics, 0, 0, getWidth(), UIDef.DEFAULT_TABLE_ROW_V_SPACING, color, color, 0);

    setup();

    labelIndex.y = UIDef.DEFAULT_TABLE_ROW_V_SPACING / 2 - labelIndex.height / 2;
    labelName.y  = UIDef.DEFAULT_TABLE_ROW_V_SPACING / 2 - labelName.height / 2;
    labelValue.y = UIDef.DEFAULT_TABLE_ROW_V_SPACING / 2 - labelValue.height / 2;
  }

  public function getWidth() : Int
  {
    var width : Int = 0;

    for(column in columns)
    {
      width += column.width;
    }

    return width;
  }

  public function setup()
  {        
    var x : Int = 0;

    align(labelIndex, x, columns[0]);
    x += columns[0].width;

    align(sprFlags, x, columns[1]);
    x += columns[1].width;

    align(labelName, x, columns[2]);
    x += columns[2].width;

    align(labelValue, x, columns[3]);
    x += columns[3].width;

    //align(labelTime, x, columns[4]);
    //x += columns[3].width;
  }

  private function align(d : DisplayObject, x : Int, columnSetup : ColumnSetup)
  {
    switch(columnSetup.hAlign)
    {
      case Left:
      {
        d.x = x;
      }

      case Center:
      {
        d.x = x + Std.int(columnSetup.width / 2 - d.width / 2);
      }

      case Right:
      {
        d.x = x + Std.int(columnSetup.width - d.width);
      }
    }
  }
}