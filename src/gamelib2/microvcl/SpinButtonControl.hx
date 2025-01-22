package gamelib2.microvcl;

import gamelib2.microvcl.Control;
import gamelib2.microvcl.DisplayTactics;
import gamelib2.i18n.Manager;

class SpinButtonControl extends ButtonControl
{
  public var onClickUpEvent(default, default)   : Dynamic -> Void;
  public var onClickDownEvent(default, default) : Dynamic -> Void;

  public function new(parentControl : Control, name : String, displayTactics : DisplayTactics, autoAdd : Bool, strMgr : Manager)
  {
    super(parentControl, name, displayTactics, autoAdd, strMgr);
  }
}
  