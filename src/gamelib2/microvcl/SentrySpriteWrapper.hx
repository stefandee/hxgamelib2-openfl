package gamelib2.microvcl;

import gamelib2.microvcl.Control;
import gamelib2.microvcl.DisplayTactics;
import gamelib2.i18n.Manager;
import gamelib2.sentry.SentrySprite;

class SentrySpriteWrapper extends Control
{      
  public var anim (get, set)		: Int;
  public var aFrame (get, set)	: Int;
  @:isVar public var pause	(default, set)		: Bool;
  
  public var sprite (default, null)			: SentrySprite;
  
  public function new(parentControl : Control, name : String, displayTactics : DisplayTactics, autoAdd : Bool, strMgr : Manager, sprite : SentrySprite, ?anim : Int = 0)
  {
    super(parentControl, name, displayTactics, autoAdd, strMgr);

    this.sprite = sprite;

    if (sprite != null)
    {      
      addChild(sprite);

      sprite.currentAnim = anim;
    }
  }

  private function get_anim() : Int
  {
    return sprite.currentAnim;
  }

  private function set_anim(v : Int) : Int
  {
    sprite.currentAnim = v;

    return sprite.currentAnim;
  }

  private function get_aFrame() : Int
  {
    return sprite.currentAFrame;
  }

  private function set_aFrame(v : Int) : Int
  {
    sprite.currentAFrame = v;

    return sprite.currentAFrame;
  }

  private function set_pause(v : Bool) : Bool
  {
	  pause = v;
	  
	  sprite.pause = v;
	  	  
	  return pause;
  }
  
  private override function onEnterFrame(e : flash.events.Event)
  {
    if (sprite != null)
    {
      sprite.update();
    }
  }
}
