package gamelib2.microvcl.leaderboard;

// gamelib2
import gamelib2.leaderboard.Leaderboard;
import gamelib2.microvcl.Control;
import gamelib2.i18n.Manager;
import gamelib2.microvcl.DisplayTactics;
import gamelib2.leaderboard.Def;

// app
import gamelib2.microvcl.leaderboard.LeaderboardRow;
import gamelib2.microvcl.leaderboard.UIDef;

class LeaderboardTable extends Control
{
  @:isVar public var leaderboard (default, set) : Leaderboard;

  private var rows                                 : Array<LeaderboardRow>;
  private var columnSetup                          : Array<ColumnSetup>;
  private var scrollBar                            : ScrollBar;

  @:isVar private var topRow (default, set)          : Int;
  
  public function new(parentControl : Control, name : String, displayTactics : DisplayTactics, autoAdd : Bool, strMgr : Manager)
  {    
    super(parentControl, name, displayTactics, autoAdd, strMgr);
  }

  public override function createUI()
  {
    rows = new Array();

    scrollBar = new ScrollBar(this, "LeaderboardScrollBar", null, true, strMgr);
    scrollBar.onScrollEvent = onScroll;

    scrollBar.x = UIDef.DEFAULT_TABLE_WIDTH + UIDef.DEFAULT_TABLE_SCROLLBAR_H_SPACING;
    scrollBar.y = 0;
    scrollBar.step = 1;
    scrollBar.size = UIDef.DEFAULT_VISIBLE_ROWS * UIDef.DEFAULT_TABLE_ROW_V_SPACING;
  }

  private function setupColumns(noScroll : Bool)
  {
    if (noScroll)
    {
      columnSetup = new Array();

      // index
      columnSetup.push(new ColumnSetup(32, ColumnHorizontalAlign.Left));

      // flag
      columnSetup.push(new ColumnSetup(32, ColumnHorizontalAlign.Left));

      // player name
      columnSetup.push(new ColumnSetup(Std.int((UIDef.DEFAULT_TABLE_WIDTH_NO_SCROLL - 64) * 0.6), ColumnHorizontalAlign.Left));

      // value
      columnSetup.push(new ColumnSetup(Std.int((UIDef.DEFAULT_TABLE_WIDTH_NO_SCROLL - 64) * 0.4), ColumnHorizontalAlign.Right));
    }
    else
    {
      columnSetup = new Array();

      // index
      columnSetup.push(new ColumnSetup(32, ColumnHorizontalAlign.Left));

      // flag
      columnSetup.push(new ColumnSetup(32, ColumnHorizontalAlign.Left));

      // player name
      columnSetup.push(new ColumnSetup(Std.int((UIDef.DEFAULT_TABLE_WIDTH - 64) * 0.6), ColumnHorizontalAlign.Left));

      // value
      columnSetup.push(new ColumnSetup(Std.int((UIDef.DEFAULT_TABLE_WIDTH - 64) * 0.4), ColumnHorizontalAlign.Right));
    }
  }

  public override function updateUI()
  {
    clear();
    
    if (leaderboard == null)
    {
      return;
    }

    if (leaderboard.state != RemoteDataState.Available)
    {
      return;
    }

    if (leaderboard.entries.length > UIDef.DEFAULT_VISIBLE_ROWS)
    {
      setupColumns(false);

      scrollBar.position    = 0;
      scrollBar.maxPosition = leaderboard.entries.length - UIDef.DEFAULT_VISIBLE_ROWS;
      scrollBar.visible     = true;
    }
    else
    {
      setupColumns(true);

      scrollBar.visible = false;
    }

    // TODO: check if the leaderboard has no entries and display a label with "no scores submitted."

    for(i in 0...leaderboard.entries.length)
    {
      var row = new LeaderboardRow(this, "LeaderboardRow" + i, null, true, strMgr);

      row.index       = i + 1;
      row.countryCode = leaderboard.entries[i].playerCountryCode;
      row.playerName  = leaderboard.entries[i].playerName;
      row.value       = leaderboard.entries[i].value;
      row.timeStamp   = leaderboard.entries[i].timeStamp;
      row.columns     = columnSetup;

      row.updateUI();

      rows.push(row);
    }

    topRow = 0;
  }

  private function clear()
  {
    for(row in rows)
    {
      if (row.parentControl.contains(row))
      {
        row.enabled       = false;        
        row.parentControl.removeChild(row);

        row.parentControl = null;
      }
    }

    rows = new Array();
  }

  private function set_leaderboard(v : Leaderboard) : Leaderboard
  {
    leaderboard = v;

    updateUI();

    return leaderboard;
  }

  private function set_topRow(v : Int) : Int
  {
    topRow = v;

    if (topRow + UIDef.DEFAULT_VISIBLE_ROWS > rows.length && UIDef.DEFAULT_VISIBLE_ROWS < rows.length)
    {
      topRow = rows.length - UIDef.DEFAULT_VISIBLE_ROWS;
    }

    for(i in 0...rows.length)
    {
      if (i >= topRow && i < topRow + UIDef.DEFAULT_VISIBLE_ROWS)
      {
        rows[i].y = (i - topRow) * UIDef.DEFAULT_TABLE_ROW_V_SPACING;        
        rows[i].visible = true;
      }
      else
      {
        rows[i].visible = false;
      }
    }

    return topRow;
  }

  private function onScroll(control : ScrollBar, position : Int)
  {
    topRow = scrollBar.position;
  }
}