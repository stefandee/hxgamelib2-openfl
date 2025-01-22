package gamelib2.microvcl;

import gamelib2.microvcl.PageControl;
import gamelib2.microvcl.Control;
import gamelib2.i18n.Manager;

class PageSheet extends Control
{
  public var index(default, default) : Int;
  
  public function new(parentControl : PageControl, controlName : String, displayTactics : DisplayTactics, autoAdd : Bool, strMgr : Manager)
  {
    super(parentControl, name, displayTactics, autoAdd, strMgr);    

    index = 0;
  }

  /*
  private override function setParentControl(control : Control) : Control
  {
    super.setParentControl(control);

    if (parentControl != null)
    {
      var temp : PageControl = cast parentControl;

      index = temp.getPageIndex(this);
    }

    return parentControl;
  }
  */
}
