package gamelib2.microvcl;

import flash.events.Event;

import gamelib2.microvcl.Button;
import gamelib2.microvcl.Form;
import gamelib2.i18n.Manager;

enum DialogFlags
{
  DialogFlags_Ok;
  DialogFlags_OkCancel;
  DialogFlags_YesNo;
  DialogFlags_YesNoCancel;
}

class FormModalDialog extends Form
{ 
  @:isVar public var message (default, set)    : String;
  public var actionHandler                     : Dynamic -> Dynamic -> Void;
  @:isVar public var dialogFlags(default, set) : DialogFlags;
  public var formState                         : Array<FormState>;
  
  public function new(parentControl : Control, name : String, displayTactics : DisplayTactics, autoAdd : Bool, strMgr : Manager)
  {
    formState = new Array();

    actionHandler = null;

    super(parentControl, name, displayTactics, autoAdd, strMgr);

    message = "";
    dialogFlags = DialogFlags_Ok;
  }

  private function set_message(v : String) : String
  {
    message = v;

    if (displayTactics != null)
    {
      displayTactics.update();
    }

    return message;
  }

  private function set_dialogFlags(v : DialogFlags) : DialogFlags
  {
    dialogFlags = v;

    if (displayTactics != null)
    {
      displayTactics.update();
    }

    return dialogFlags;
  }

  // this method should be called by the tactics instance when the dialog must close (a button has been pressed, for example)
  public function closeDialog(e : Event, modalResult : ModalResult)
  {
    this.modalResult = modalResult;
    
    // TODO: restore form states
    for(state in formState)
    {
      state.form.enabled = state.enabled;
    }

    if (actionHandler != null)
    {
      actionHandler(e, modalResult);
    }

    // TODO: let application instance close this form
    gamelib2.microvcl.Application.instance.removeForm("FormModalDialog");
  }
}