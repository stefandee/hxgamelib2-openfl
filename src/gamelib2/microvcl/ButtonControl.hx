package gamelib2.microvcl;

import gamelib2.i18n.Manager;

class ButtonControl extends Control
{
  @:isVar public var checked (get, set)        : Bool;
  @:isVar public var clicksDisabled (get, set) : Bool;

  public var onChangeEvent (default, default) : Dynamic -> Void;

  public function new(parentControl : Control, name : String, displayTactics : DisplayTactics, autoAdd : Bool, strMgr : Manager)
  {
    super(parentControl, name, displayTactics, autoAdd, strMgr);

    checked = false;
    clicksDisabled = false;

    //mouseChildren = false;
  }

  private function get_checked() : Bool
  {
    return checked;
  }

  private function set_checked(v : Bool) : Bool
  {
    var prevValue = checked;
    
    checked = v;

    if (displayTactics != null)
    {
      displayTactics.update();
    }

    if (onChangeEvent != null && enabled)// && prevValue != checked)
    {
      onChangeEvent(this);
    }

    return checked;
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

  private function get_clicksDisabled() : Bool
  {
    return clicksDisabled;
  }

  private function set_clicksDisabled(v : Bool) : Bool
  {
    clicksDisabled = v;

    return clicksDisabled;
  }
}