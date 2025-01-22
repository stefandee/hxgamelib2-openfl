package gamelib2.leaderboard;

import gamelib2.leaderboard.GameInfo;
import gamelib2.leaderboard.Submit;

class Api
{
  public static var instance (get, null) : Api;

  public var gameInfo (default, null)     : GameInfo;
  public var submit   (default, null)     : Submit;
  
  private function new()
  {
    gameInfo = new GameInfo();
    submit = new Submit();
  }

  private static function get_instance() : Api
  {
    if (instance == null)
    {
      instance = new Api();
    }

    return instance;
  }

  public function init(gameId : Int)
  {
    gameInfo.retrieve(gameId);
  }
}