package gamelib2.microvcl.dt;

import flash.text.TextField;
import flash.text.TextFormat;
import gamelib2.microvcl.DisplayTactics;
import gamelib2.microvcl.StyleSheet;

class CssLabelTactics extends DisplayTactics
{
  private var msg      : TextField;

  private var autoSize : flash.text.TextFieldAutoSize;
  private var align    : flash.text.TextFormatAlign;

  private var embedFonts      : Bool;
  private var antiAliasType   : flash.text.AntiAliasType;

  private function new(autoSize : flash.text.TextFieldAutoSize, align : flash.text.TextFormatAlign)
  {
    super();

    this.autoSize = autoSize;
    this.align    = align;

    antiAliasType = flash.text.AntiAliasType.ADVANCED;
    embedFonts    = true;
  }

  public override function init()
  {
    msg = createTextField(target.caption, 0, 0, createStyleSheet(), this.autoSize);

    target.addChild(msg);
  }

  private function createStyleSheet() : StyleSheet
  {
    return new StyleSheet();
  }

  private function createTextField(str : String, x : Int, y : Int, cssStyle : StyleSheet, textAutoSize : flash.text.TextFieldAutoSize)
  {
    var textField : flash.text.TextField;

    textField = new flash.text.TextField();
    textField.autoSize   = textAutoSize;
    textField.antiAliasType = antiAliasType;
#if flash  
    textField.styleSheet = cssStyle;
#end  
    textField.multiline  = true;
    textField.wordWrap   = false;
    textField.embedFonts = embedFonts;
    textField.type       = flash.text.TextFieldType.DYNAMIC;
    textField.textColor  = 0xFFFFFF;
    textField.x          = x;
    textField.y          = y;
    textField.selectable = false;
    textField.htmlText   = str;

    //textField.cacheAsBitmap = true;
    // openfl specific
#if !flash    
    var format = new TextFormat();
    format.align = this.align;
    
    textField.defaultTextFormat = format;
    textField.setTextFormat(format);    
#end        

    return textField;
  }

  public override function update()
  {
    //trace(target.caption);
    msg.embedFonts = this.embedFonts;
    
    var styleSheet = this.createStyleSheet();
    
#if flash    
    msg.styleSheet = styleSheet;    
#end    

    msg.htmlText = CSSUtils.translate(target.caption, styleSheet);
  }
}