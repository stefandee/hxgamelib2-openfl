package ui.dt;

// as3.0

// app
import gamelib2.microvcl.dt.WrapLabelTactics;
import gamelib2.microvcl.StyleSheet;
import Data;

class SiteLockLabelTactics extends WrapLabelTactics
{
  public function new(autoSize : flash.text.TextFieldAutoSize, align : flash.text.TextFormatAlign, w : Int)
  {
    super(autoSize, align, w);
    embedFonts = true;
  }

  private override function createStyleSheet() : StyleSheet
  {
    var style = new StyleSheet();

    var content : Dynamic = {
      fontFamily : FontModel.FontDefaultName,
      color : "#FFFFFF",
      fontSize : 10,
      textAlign : "center",
      leading : 10,
      letterSpacing : 1.0
      //textDecoration: "underline"
    };

    style.setStyle(".content", content);

    return style;
  }
}