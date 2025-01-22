package gamelib2.leaderboard;

// not used at the moment
enum TimeSpan
{
  Day;
  Week;
  Month;
  AllTime;
}

enum RemoteDataState
{
  Available;
  Unavailable;
  Incomplete;
}

class LeaderboardDef
{
#if LeaderboardLocalhost
  public static var BASE_URL        : String = "http://localhost/pirongames/index.php";
  public static var BASE_CONTROLLER : String = "gamestat";
  public static var CROSSDOMAIN     : String = "http://localhost/pirongames/crossdomain.xml";
#else
  public static var BASE_URL        : String = "http://www.pirongames.com/index.php";
  public static var BASE_CONTROLLER : String = "gamestat";
  public static var CROSSDOMAIN     : String = "http://www.pirongames.com/crossdomain.xml";
#end // LeaderboardLocalhost

  // ttl in seconds
  public static var DEFAULT_LEADERBOARD_TTL : Int = 3600;
}