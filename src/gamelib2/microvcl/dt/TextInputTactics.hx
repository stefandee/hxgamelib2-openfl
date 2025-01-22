package gamelib2.microvcl.dt;

import gamelib2.microvcl.DisplayTactics;
import gamelib2.microvcl.TextInput;

// as3.0
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFieldType;
import flash.events.Event;

class TextInputTactics extends DisplayTactics
{
  public var textField         : TextField;
  private var textFieldFormat  : TextFormat;

  private var fontName         : String;
  private var fontNameOriginal : String;
  private var fontSize         : Int;
  private var autoSize         : flash.text.TextFieldAutoSize;
  private var align            : flash.text.TextFormatAlign;
  private var color            : Int;
  private var maxChars         : Int;
  private var textFieldWidth   : Int;
  private var textFieldHeight  : Int;
  private var embedFonts       : Bool;
  private var border           : Bool;

  public function new(fontName : String, fontSize : Int, textFieldWidth : Int, textFieldHeight : Int, autoSize : flash.text.TextFieldAutoSize, align : flash.text.TextFormatAlign, color : Int, ?maxChars : Int = 32, ?border : Bool = false)
  {
    super();

    this.fontName   = fontName;
    this.fontNameOriginal = fontName;
    this.fontSize   = fontSize;
    this.autoSize   = autoSize;
    this.align      = align;
    this.color      = color;
    this.maxChars   = maxChars;
    this.textFieldWidth = textFieldWidth;
    this.textFieldHeight = textFieldHeight;
    this.border       = border;

    //this.tabEnabled = true;

    embedFonts = true;
  }

  public override function init()
  {
    textField             = new TextField();
    textField.text        = target.caption;
    textField.embedFonts  = embedFonts;
    textField.type        = TextFieldType.INPUT;
    textField.textColor   = this.color;
    textField.autoSize    = this.autoSize;
    textField.selectable  = true;
    textField.border      = border;
    textField.borderColor = this.color;
    textField.maxChars    = maxChars;
    
#if flash    
    textField.alwaysShowSelection = true;
#end

    //textField.background  = true;
    //textField.backgroundColor = 0xF0F0F0;
    textField.width       = textFieldWidth;
    textField.height      = textFieldHeight;
    //textField.multiline   = multiline;


    textFieldFormat               = new TextFormat();
    textFieldFormat.color         = this.color;
    textFieldFormat.bold          = false;
    textFieldFormat.size          = this.fontSize;
    textFieldFormat.font          = fontName;
    textFieldFormat.align         = this.align;
    //textFieldFormat.letterSpacing = 2.0;

    textField.setTextFormat(textFieldFormat);

    textField.defaultTextFormat = textFieldFormat;

    textField.addEventListener(flash.events.TextEvent.TEXT_INPUT, textInputHandler);
    textField.addEventListener(flash.events.Event.CHANGE, changeHandler);
    textField.addEventListener(flash.events.FocusEvent.FOCUS_IN, focusInHandler);
    textField.addEventListener(flash.events.FocusEvent.FOCUS_OUT, focusOutHandler);

    //textField.width = 256;

    target.addChild(textField);
  }

  public override function update()
  {
    textField.embedFonts = this.embedFonts;
    textFieldFormat.font = fontName;    

    textField.text = target.caption;
    textField.width       = textFieldWidth;
    textField.height      = textFieldHeight;
  }

  public function getText() : String
  {
    return textField.text;
  }

  public function textInputHandler(e : flash.events.TextEvent) : Void
  {
    var tmpTarget : TextInput = cast target;

    if (tmpTarget != null)
    {
      if (tmpTarget.onTextInputEvent != null)
      {
        tmpTarget.onTextInputEvent(e.text);
      }
    }
  }

  private function changeHandler(e : flash.events.Event) : Void
  {
    var tmpTarget : TextInput = cast target;

    if (tmpTarget != null)
    {
      if (tmpTarget.onChangeEvent != null)
      {
        tmpTarget.onChangeEvent(textField.text);
      }
    }
  }

  private function focusInHandler(e : flash.events.Event) : Void
  {
    var tmpTarget : TextInput = cast target;

    if (tmpTarget != null)
    {
      if (tmpTarget.onFocusInEvent != null)
      {
        tmpTarget.onFocusInEvent(e);
      }
    }
  }

  private function focusOutHandler(e : flash.events.Event) : Void
  {
    var tmpTarget : TextInput = cast target;

    if (tmpTarget != null)
    {
      if (tmpTarget.onFocusOutEvent != null)
      {
        tmpTarget.onFocusOutEvent(e);
      }
    }
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
        fontName   = fontNameOriginal;
        embedFonts = true;
      }
    }    
  }

  public override function changeLanguage()
  {
		trace("TextInputTactics is processing language change event!");

    super.changeLanguage();
    
    setupParams();
  }
}