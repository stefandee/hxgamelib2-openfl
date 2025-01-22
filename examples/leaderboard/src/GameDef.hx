enum MenuAction
{
  MA_None;
  MA_Continue;
  MA_Play;
  MA_Options;
  MA_About;
  MA_Help;
  MA_Back;
  MA_Resume;
  MA_Restart;
  MA_Quit;
  MA_Menu;
  MA_Advance;
}

class GameDef
{
  public static var STAGE_WIDTH               : Int   = 640;
  public static var STAGE_HEIGHT              : Int   = 480;

  public static var SIM_DELAY                 : Float = 0.03; // in miliseconds (33 fps)

  public static function getStrId(strId : String) : Int
  {
    if (Reflect.hasField(data.AllStrings, strId))
    {
      // ?!
      return Reflect.field(data.AllStrings, strId);
    }

    return -1;
  }

  public static function timeToStr(v : Float) : String
  {
    if (v < 0)
    {
      return "--:--";
    }

    // convert to seconds
    v = v / 1000;

    var min : Int = Std.int(Std.int(v) / 60);

    /*
    if (min > 99)
    {
      min = 99;
    }
    */

    var sec : Int = Std.int(v) % 60;

    return StringTools.lpad("" + min, "0", 2) + ":" + StringTools.lpad("" + sec, "0", 2);
  }
}