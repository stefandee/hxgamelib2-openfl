package ui;

// as3
import flash.display.Bitmap;
import flash.display.SimpleButton;

class ImgButtonTactics extends DisplayTactics
{
  private var btn    : SimpleButton; 
  private var imgOn  : Bitmap;
  private var imgOff : Bitmap;

  public function new(imgOn : Bitmap, imgOff : Bitmap)
  {
    this.imgOn  = imgOn;
    this.imgOff = imgOff;

    super();
  }

  public override function init()
  {    
    //
    // create the button
    //
    btn = new flash.display.SimpleButton(imgOn, imgOff, imgOff, imgOn);

    target.addChild(btn);

    btn.x = 0;
    btn.y = 0;
  }

  public override function update()
  {
  }
}