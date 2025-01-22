package gamelib2.microvcl.leaderboard.dt;

// as3
import flash.display.Sprite;
import flash.display.BitmapData;

// gamelib2
import gamelib2.microvcl.Label;
import gamelib2.microvcl.DisplayTactics;
import gamelib2.microvcl.Helper;
import gamelib2.leaderboard.Def;
import gamelib2.microvcl.leaderboard.ControlLeaderboard;

class ControlLeaderboardTactics extends DisplayTactics
{  
  public function new()
  {
    super();
  }

  public override function init()
  {
    var bkg = new Sprite();

    //Helper.drawBox(bkg.graphics, 0, 0, 400, 300, 0x000000, 0x000000, 0);

    bkg.graphics.lineStyle(1.0, 0x000000);
    bkg.graphics.beginBitmapFill(createCarbonTexture(), null, true, false);
    bkg.graphics.drawRect(0, 0, 400, UIDef.DEFAULT_HEIGHT);
    bkg.graphics.endFill();

    Helper.drawBox(bkg.graphics, 3, 32, 400 - 6, UIDef.DEFAULT_HEIGHT - 32 - 3, 0xE0E0E0, 0xE0E0E0, 0);
    Helper.drawBox(bkg.graphics, 3, 56, 400 - 6, UIDef.DEFAULT_HEIGHT - 32 - 24 - 3 - 34, 0xFFFFFF, 0xFFFFFF, 0);
    //Helper.drawBox(bkg.graphics, 3, 78, 400 - 6, ControlLeaderboard.DEFAULT_HEIGHT - 32 - 24 - 22 - 3, 0xFFFFFF, 0xFFFFFF, 0);
    //Helper.drawBox(bkg.graphics, 3, 76, 400 - 6, 300 - 32 - 24 - 20 - 3, 0xFFFFFF, 0xFFFFFF, 0);
    
    target.addChild(bkg);
  }

  public override function update()
  {
    var t = cast(target, ControlLeaderboard);
  }

  public override function changeLanguage()
  {
		trace("ControlLeaderboardTactics is processing language change event!");

    super.changeLanguage();    
  }

  private function createCarbonTexture() : BitmapData
  {
    var bitmapData = new BitmapData(4, 4, false, 0x000000);

    var content = new flash.Vector<UInt>();

    content.push(0x676767);
    content.push(0x676767);
    content.push(0x131313);
    content.push(0x131313);
    content.push(0x595959);
    content.push(0x595959);
    content.push(0x2E2E2E);
    content.push(0x2E2E2E);
    content.push(0x131313);
    content.push(0x131313);
    content.push(0x676767);
    content.push(0x676767);
    content.push(0x2E2E2E);
    content.push(0x2E2E2E);
    content.push(0x595959);
    content.push(0x595959);

    var rect = new flash.geom.Rectangle(0, 0, 4, 4);

    bitmapData.setVector(rect, content);

    return bitmapData;
  }
}