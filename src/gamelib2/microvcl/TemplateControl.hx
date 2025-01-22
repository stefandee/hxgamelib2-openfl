package ui;

// as3

// gamelib2
import gamelib2.microvcl.Control;
import gamelib2.microvcl.DisplayTactics;
import gamelib2.i18n.Manager;

// app

// this class is for convenience only
class TemplateControl extends Control
{
  public function new(parentControl : Control, name : String, displayTactics : DisplayTactics, autoAdd : Bool, strMgr : Manager)
  {
    super(parentControl, name, displayTactics, autoAdd, strMgr);
  }

  public override function createUI()
  {
  }

  public override function updateUI()
  {
  }
}