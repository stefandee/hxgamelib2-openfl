import gamelib2.microvcl.Application;
import gamelib2.microvcl.Form;
import gamelib2.microvcl.Control;
import gamelib2.microvcl.DisplayTactics;
import gamelib2.i18n.Manager;
import gamelib2.data.SprLib;

class FormGame extends Form
{ 
  private var app    : GameApp;
  private var sprLib : SprLib;
  
  public function new(parentControl : Control, name : String, displayTactics : DisplayTactics, autoAdd : Bool, strMgr : Manager)
  {
    app    = GameApp.getApp();
    sprLib = app.sprLib;

    super(parentControl, name, displayTactics, autoAdd, strMgr);
  }

  public override function changeLanguage() : Void
  {
    super.changeLanguage();
    
    updateUI();
  }
}
