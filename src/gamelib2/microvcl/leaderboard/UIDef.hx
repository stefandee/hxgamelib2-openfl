package gamelib2.microvcl.leaderboard;

import gamelib2.leaderboard.SubmitEntry;

//import Data;

enum ColumnWidthType
{
  Value;
  Percent;
}

enum ColumnHorizontalAlign
{
  Left;
  Center;
  Right;
}

class ColumnSetup 
{
  public var width        : Int;
  //public var widthType    : ColumnWidthType;
  public var hAlign       : ColumnHorizontalAlign;

  public function new(width : Int, hAlign : ColumnHorizontalAlign)
  {
    this.width        = width;
    //widthPercent = 0;
    //widthType    = ColumnWidthType.Value;
    this.hAlign       = hAlign;
  }
}

/*
class Submit
{
  public var playerName            : String;
  public var stats (default, null) : Array<SubmitEntry>;
  
  public function new()
  {
    reset();
  }

  public function reset()
  {
    playerName = "Enter your name";
    stats = new Array();
  }

  public function resetStats()
  {
    stats = new Array();
  }

  public function add(statName : String, value : Int)
  {
    stats.push(new SubmitEntry(statName, value));
  }

  public function addEntry(e : SubmitEntry)
  {
    if (e != null)
    {
      stats.push(e);
    }
  }

  public function get(statName : String) : SubmitEntry
  {
    for(stat in stats)
    {
      if (statName == stat.statName)
      {
        return stat;
      }
    }

    return null;
  }
}
*/

class UIDef
{
  public static var DEFAULT_WIDTH  : Int                = 400;
  public static var DEFAULT_HEIGHT : Int                = 300;
  public static var DEFAULT_TABLE_WIDTH : Int           = 370;
  public static var DEFAULT_TABLE_WIDTH_NO_SCROLL : Int = 390;
  public static var DEFAULT_H_BORDER : Int              = 3;
  public static var DEFAULT_V_BORDER : Int              = 3;
  public static var DEFAULT_VISIBLE_ROWS : Int          = 10;
  public static var DEFAULT_TABLE_ROW_V_SPACING : Int   = 20;
  public static var DEFAULT_TABLE_SCROLLBAR_H_SPACING : Int = 2;
  public static var DEFAULT_CURRENT_SCORE_WIDTH : Int   = 394;

  public static var DEFAULT_SUBMIT_WIDTH  : Int          = 260;
  public static var DEFAULT_SUBMIT_HEIGHT : Int          = 200;
  public static var DEFAULT_SUBMIT_HEADER_HEIGHT : Int   = 24;
  public static var DEFAULT_SUBMIT_HEADER2_HEIGHT : Int  = 24;
  public static var DEFAULT_SUBMIT_H_BORDER : Int        = 3;
  public static var DEFAULT_SUBMIT_SCOREBOX_WIDTH : Int  = 240;
  public static var DEFAULT_SUBMIT_SCOREBOX_HEIGHT : Int = 72;
  public static var DEFAULT_SUBMIT_SCOREBOX_INPUT_V_SPACING : Int = 16;
  public static var DEFAULT_SUBMIT_INPUT_DISABLED : Float = 0.5;
  public static var DEFAULT_SUBMIT_INPUTBOX_WIDTH : Int  = 240;
  public static var DEFAULT_SUBMIT_INPUTBOX_HEIGHT : Int  = 32;

  public static var FontGenericName : String = "FontLdrGeneric";

  public static function greyFilter() : flash.filters.ColorMatrixFilter
  {
    var myElements_array = [
            0.10, 0.39, 0.11, 0, 0,
            0.10, 0.39, 0.11, 0, 0,
            0.10, 0.39, 0.11, 0, 0,
            0.00, 0.0,  0.0,  1, 0];    
    
    return new flash.filters.ColorMatrixFilter(myElements_array);
  }
}
