package gamelib2.microvcl.dt;

// as3.0
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFieldType;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormatAlign;

// app
import gamelib2.microvcl.DisplayTactics;
import gamelib2.microvcl.Helper;

class LabelTactics extends DisplayTactics
{
  private var Msg       : TextField;
  private var MsgFormat : TextFormat;

  private var fontName      : String;
  private var embedFonts    : Bool;
  private var fontSize      : Int;
  private var autoSize      : TextFieldAutoSize;
  private var align         : TextFormatAlign;
  private var color         : Int;
  private var letterSpacing : Float;

  public function new(fontName : String, embedFonts : Bool, fontSize : Int, autoSize : TextFieldAutoSize, align : TextFormatAlign, color : Int, ?letterSpacing : Float = 1.0)
  {
    super();

    this.fontName      = new String(fontName);
    this.embedFonts    = embedFonts;
    this.fontSize      = fontSize;
    this.autoSize      = autoSize;
    this.align         = align;
    this.color         = color;
    this.letterSpacing = letterSpacing;
  }

  public override function init()
  {
    Msg = Helper.createTextField(target.caption, embedFonts, TextFieldType.DYNAMIC, flash.text.AntiAliasType.ADVANCED, this.color, this.autoSize, false);
    
    MsgFormat       = new TextFormat();
    MsgFormat.color = this.color;
    MsgFormat.bold  = false;
    MsgFormat.size  = this.fontSize;
    MsgFormat.font  = this.fontName;
    MsgFormat.align = this.align;
    MsgFormat.letterSpacing = this.letterSpacing;

    Msg.setTextFormat(MsgFormat);

    // check for target != null?
    target.addChild(Msg);
  }

  public override function update()
  {
    Msg.text = target.caption;
    Msg.autoSize  = this.autoSize;

    Msg.setTextFormat(MsgFormat);
  }
}