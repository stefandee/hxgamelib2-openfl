package ui;

// as3
import flash.display.SimpleButton;
import gamelib2.sentry.SentrySprite;

class BitmapButtonTactics extends DisplayTactics
{
  public var sprOn  (default, null) : SentrySprite;
  public var sprOff (default, null) : SentrySprite;

  private var btn                   : SimpleButton; 

  public function new(sprOn : SentrySprite, sprOff : SentrySprite, animIndexOn : Int, animIndexOff : Int)
  {
    this.sprOn  = sprOn;
    this.sprOff = sprOff;

    this.sprOn.currentAnim  = animIndexOn;
    this.sprOff.currentAnim = animIndexOff;
    
    super();
  }

  public override function init()
  {    
    //
    // create the button
    //
    btn = new flash.display.SimpleButton(sprOn, sprOff, sprOff, sprOn);

    target.addChild(btn);

    btn.x = 0;
    btn.y = 0;
  }

  public override function update()
  {
  }
}