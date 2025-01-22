package gamelib2.microvcl;

import gamelib2.microvcl.Control;
import gamelib2.i18n.Manager;

// this class is for convenience only
class Label extends Control
{
  public function new(parentControl : Control, name : String, displayTactics : DisplayTactics, autoAdd : Bool, strMgr : Manager)
  {
    super(parentControl, name, displayTactics, autoAdd, strMgr);
  }

  private override function set_caption(v : String) : String
  {
    caption = v;

    if (displayTactics != null)
    {
      displayTactics.update();
    }

    //trace(caption);

    return caption;
  }
}