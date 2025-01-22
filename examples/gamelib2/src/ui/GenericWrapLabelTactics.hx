package ui;

// openfl
import openfl.Assets;

// app
import gamelib2.microvcl.dt.WrapLabelTactics;
import gamelib2.microvcl.StyleSheet;

class GenericWrapLabelTactics extends WrapLabelTactics
{
  private var fontName   : String;
  
  public function new(autoSize : flash.text.TextFieldAutoSize, align : flash.text.TextFormatAlign, w : Int)
  {
    super(autoSize, align, w);

    fontName   = Assets.getFont("fonts/emulator.ttf").fontName;
    embedFonts = true;
  }

  public override function init()
  {
    setupParams();
    
    super.init();
  }

  private override function createStyleSheet() : StyleSheet
  {
    var style = new StyleSheet();

    var content : Dynamic = {
      fontFamily : fontName,
      color : "#FFFFFF",
      fontSize : 10,
      textAlign : "center",
      letterSpacing : 1.0
    };

    style.setStyle(".content", content);

    return style;
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
        fontName   = Assets.getFont("fonts/emulator.ttf").fontName;
        embedFonts = true;
      }
    }    
  }

  public override function changeLanguage()
  {
		trace("GenericLabelTactics is processing language change event!");

    super.changeLanguage();
    
    setupParams();
  }
}