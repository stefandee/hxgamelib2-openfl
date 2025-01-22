package gamelib2.microvcl.leaderboard.dt;

// as3.0

// app
import gamelib2.microvcl.dt.CssLabelTactics;
//import Data;

class GenericLabelTactics extends CssLabelTactics
{
  private var fontName   : String;
  
  public function new(autoSize : flash.text.TextFieldAutoSize, align : flash.text.TextFormatAlign)
  {
    super(autoSize, align);

    fontName   = UIDef.FontGenericName;
    embedFonts = true;
  }

  public override function init()
  {
    setupParams();
    
    super.init();
  }

#if flash  
  private override function createStyleSheet() : flash.text.StyleSheet
  {
    var style = new flash.text.StyleSheet();

    var gameTitle : Dynamic = {
      fontFamily : fontName,
      color : "#FFFFFF",
      fontSize : 24,
      textAlign : "center",
      letterSpacing : 1.0
    };

    var gameInfo : Dynamic = {
      fontFamily : fontName,
      color : "#FFFFFF",
      fontSize : 14,
      textAlign : "left",
      letterSpacing : 1.0
    };

    var tabTitle : Dynamic = {
      fontFamily : fontName,
      color : "#FFFFFF",
      fontSize : 14,
      textAlign : "left",
      letterSpacing : 1.0
    };

    var statTitle : Dynamic = {
      fontFamily : fontName,
      color : "#FFFFFF",
      fontSize : 16,
      textAlign : "center",
      letterSpacing : 1.0
    };

    var buttonLabel : Dynamic = {
      fontFamily : fontName,
      color : "#FFFFFF",
      fontSize : 14,
      textAlign : "center",
      letterSpacing : 1.0
    };

    var comboBoxItem : Dynamic = {
      fontFamily : fontName,
      color : "#000000",
      fontSize : 18,
      textAlign : "left",
      letterSpacing : 1.0
    };

    var timeSpanOff : Dynamic = {
      fontFamily : fontName,
      color : "#000000",
      fontSize : 14,
      textAlign : "left",
      letterSpacing : 1.0
    };

    var timeSpanOn : Dynamic = {
      fontFamily : fontName,
      color : "#0000A0",
      fontSize : 14,
      textAlign : "left",
      letterSpacing : 1.0
    };

    var leaderboard : Dynamic = {
      fontFamily : fontName,
      color : "#404040",
      fontSize : 16,
      textAlign : "left",
      letterSpacing : 1.0
    };

    var currentScoreName : Dynamic = {
      fontFamily : fontName,
      color : "#404040",
      fontSize : 16,
      textAlign : "left",
      letterSpacing : 1.0
    };    

    var currentScoreValue : Dynamic = {
      fontFamily : fontName,
      color : "#404090",
      fontSize : 16,
      textAlign : "left",
      letterSpacing : 1.0
    };    

    var submitTitle : Dynamic = {
      fontFamily : fontName,
      color : "#FFFFFF",
      fontSize : 20,
      textAlign : "center",
      letterSpacing : 1.0
    };

    var submitScore : Dynamic = {
      fontFamily : fontName,
      color : "#303060",
      fontSize : 32,
      textAlign : "center",
      //bold : true,
      letterSpacing : 1.0
    };

    var leaderboardError : Dynamic = {
      fontFamily : fontName,
      color : "#404040",
      fontSize : 14,
      textAlign : "center",
      //bold : true,
      letterSpacing : 1.0
    };

    style.setStyle(".gameTitle",         gameTitle);
    style.setStyle(".gameInfo",          gameInfo);
    style.setStyle(".tabTitle",          tabTitle);
    style.setStyle(".statTitle",         statTitle);
    style.setStyle(".buttonLabel",       buttonLabel);
    style.setStyle(".comboBoxItem",      comboBoxItem);    
    style.setStyle(".timeSpanOn",        timeSpanOn);    
    style.setStyle(".timeSpanOff",       timeSpanOff);    
    style.setStyle(".leaderboard",       leaderboard);
    style.setStyle(".currentScoreName",  currentScoreName);
    style.setStyle(".currentScoreValue", currentScoreValue);
    style.setStyle(".submitTitle",       submitTitle);    
    style.setStyle(".submitScore",       submitScore);    
    style.setStyle(".leaderboardError",  leaderboardError);        

    return style;
  }
#end  

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
        fontName   = UIDef.FontGenericName;
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