package gamelib2.leaderboard;

class SubmitEntry
{
  public var statName : String;
  public var value    : Int;

  public function new(statName : String, value : Int)
  {
    this.statName = statName;
    this.value    = value;
  }

  public static function get(statName : String, entries : Array<SubmitEntry>) : SubmitEntry
  {
    for(entry in entries)
    {
      if (entry.statName == statName)
      {
        return entry;
      }
    }
    
    return null;
  }
}
