package gamelib2.microvcl.leaderboard.dt;

// as3
import flash.display.Sprite;
import flash.display.BitmapData;

// gamelib2
import gamelib2.microvcl.Label;
import gamelib2.microvcl.DisplayTactics;
import gamelib2.microvcl.Helper;
import gamelib2.leaderboard.Def;

class ControlSubmitScoreTactics extends DisplayTactics
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
    bkg.graphics.drawRect(0, 0, UIDef.DEFAULT_SUBMIT_WIDTH, UIDef.DEFAULT_SUBMIT_HEIGHT);
    bkg.graphics.endFill();

    Helper.drawBox(
      bkg.graphics, 
      UIDef.DEFAULT_SUBMIT_H_BORDER, 
      UIDef.DEFAULT_SUBMIT_HEADER_HEIGHT, 
      UIDef.DEFAULT_SUBMIT_WIDTH - UIDef.DEFAULT_SUBMIT_H_BORDER * 2, 
      UIDef.DEFAULT_SUBMIT_HEIGHT - UIDef.DEFAULT_SUBMIT_HEADER_HEIGHT - UIDef.DEFAULT_SUBMIT_H_BORDER, 
      0xFFFFFF,//0xE0E0E0, 
      0xFFFFFF,//0xE0E0E0, 
      0);

    /*
    Helper.drawBox(
      bkg.graphics, 
      UIDef.DEFAULT_SUBMIT_H_BORDER, 
      UIDef.DEFAULT_SUBMIT_HEADER_HEIGHT + UIDef.DEFAULT_SUBMIT_HEADER2_HEIGHT, 
      UIDef.DEFAULT_SUBMIT_WIDTH - UIDef.DEFAULT_SUBMIT_H_BORDER * 2, 
      UIDef.DEFAULT_SUBMIT_HEIGHT - UIDef.DEFAULT_SUBMIT_HEADER_HEIGHT - UIDef.DEFAULT_SUBMIT_H_BORDER - UIDef.DEFAULT_SUBMIT_HEADER2_HEIGHT, 
      0xFFFFFF, 
      0xFFFFFF, 
      0);
    */
    
    target.addChild(bkg);
  }

  public override function update()
  {
  }

  public override function changeLanguage()
  {
		trace("ControlSubmitScoreTactics is processing language change event!");

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