package gamelib2.microvcl;

import gamelib2.microvcl.Control;
import gamelib2.i18n.Manager;
import gamelib2.microvcl.dt.TextInputTactics;

class TextInput extends Control
{
  //
  // Events
  //
  public var onTextInputEvent (default, set) : Dynamic -> Void;
  public var onChangeEvent    (default, set) : Dynamic -> Void;
  public var onFocusInEvent   (default, set) : Dynamic -> Void;
  public var onFocusOutEvent  (default, set) : Dynamic -> Void;

  public function new(parentControl : Control, name : String, displayTactics : TextInputTactics, autoAdd : Bool, strMgr : Manager)
  {
    super(parentControl, name, displayTactics, autoAdd, strMgr);

    onTextInputEvent = null;
    onChangeEvent    = null;
    onFocusInEvent   = null;
    onFocusOutEvent  = null;

    this.tabEnabled  = true;
  }

  private override function set_caption(v : String) : String
  {
    trace("TextInput - setCaption");
    
    caption = v;

    if (displayTactics != null)
    {
      displayTactics.update();
    }

    return caption;
  }

  public function getEditedText() : String
  {
    var dt : TextInputTactics = cast displayTactics;

    return dt.getText();
  }

  /*
  private override function getCaption() : String
  {
    var dt : ui.TextInputTactics = cast(displayTactics, ui.TextInputTactics);

    return dt.getText();
  }
  */

  //
  // Events
  //
  private function set_onTextInputEvent(v : Dynamic -> Void) : Dynamic -> Void
  {
    onTextInputEvent = v;

    return onTextInputEvent;
  }

  private function set_onChangeEvent(v : Dynamic -> Void) : Dynamic -> Void
  {
    onChangeEvent = v;

    return onChangeEvent;
  }

  private function set_onFocusInEvent(v : Dynamic -> Void) : Dynamic -> Void
  {
    onFocusInEvent = v;

    return onFocusInEvent;
  }

  private function set_onFocusOutEvent(v : Dynamic -> Void) : Dynamic -> Void
  {
    onFocusOutEvent = v;

    return onFocusOutEvent;
  }

  public function setFocus()
  {
    var dt : TextInputTactics = cast(displayTactics, TextInputTactics);

    this.stage.focus = dt.textField;    
  }

  public function hasFocus() : Bool
  {
    var dt : TextInputTactics = cast(displayTactics, TextInputTactics);
    
    return (this.stage.focus == dt.textField);
  }
}