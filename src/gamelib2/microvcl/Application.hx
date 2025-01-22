package gamelib2.microvcl;

import gamelib2.microvcl.FormModalDialog;
import gamelib2.i18n.Manager;
import openfl.events.Event;

class Application
{
	public static var instance            : Application;

  public var title (default, set)  : String;

	public var root (default, null)       : RootControl;
  private var forms                     : Map<String, Form>;

  // most of the time, strMgr will be available after preloading
  // check langCount to see if it's anything available
  public var strMgr (default, null)     : Manager;

  public function new(title : String)
  {
    this.title = title;

    forms = new Map();

    strMgr = new Manager();

    try
    {
      root = new gamelib2.microvcl.RootControl("ApplicatonRootControl");
    }
    catch(e : Dynamic)
    {
      trace(e);
    }
    
		root.stage.addEventListener (Event.RESIZE, stage_onResize);            
  }

  private function set_title(v : String) : String
  {
    if (v == null || v.length == 0)
    {
      v = "Default Application";
    }
    
    title = v;

    return title;
  }

  public function addForm(form : Form)
  {
    if (form != null)
    {
      forms.set(form.controlName, form);
    }
  }

  public function getForm(formId : String) : Form
  {
    if (formId == null)
    {
      return null;
    }
    
    return forms.get(formId);
  }

  public function showForm(formId : String) : Form
  {
    var form : Form = forms.get(formId);

    if (form == null)
    {
      trace("showForm: " + formId + " doesnt exists!");

      return null;
    }

    if (form.parentControl.contains(form))
    {
      trace("form already exists in list " + formId);
      
      form.enabled = true;

      return form;
    }

    // TODO: check if parentControl is null
    form.parentControl.addChild(form);
    form.enabled = true;
    form.visible = true;
    form.x = 0;
    form.y = 0;
    
    form.resize (root.stage.stageWidth, root.stage.stageHeight);
    
    return form;
  }

  public function hideForm(formId : String) : Form
  {
    var form : Form = forms.get(formId);

    if (form == null)
    {
      trace("hideForm: " + formId + " doesn't exists!");

      return null;
    }

    // TODO: check if parentControl is null

    if (form.parentControl.contains(form))
    {
      trace("form will be removed " + formId);
      form.parentControl.removeChild(form);
    }

    form.enabled = false;

    return form;
  }

  public function removeForm(formId : String) : Bool
  {
    hideForm(formId);
    
    return forms.remove(formId);
  }

  public function moveToFront(formId : String) : Bool
  {
    var form : Form = forms.get(formId);

    if (form == null)
    {
      trace("moveToFront: " + formId + " doesn't exists!");

      return false;
    }

    if (form.parentControl.contains(form))
    {
      trace("form will be moved to front " + formId);

      form.parentControl.setChildIndex(form, 0);

      return true;
    }

    return false;
  }

  public function moveToBack(formId : String) : Bool
  {
    var form : Form = forms.get(formId);
    
    if (form == null)
    {
      trace("moveToBack: " + formId + " doesn't exists!");

      return false;
    }

    trace("numChildren: " + form.parentControl.numChildren);

    if (form.parentControl.contains(form))
    {
      trace("form will be moved to back " + formId);

      form.parentControl.setChildIndex(form, form.parentControl.numChildren - 1);

      return true;
    }

    return false;
  }

#if debug
  public function dumpForms()
  {
    trace("Dumping forms...");

    for(form in forms.iterator())
    {
      trace(form.controlName);
    }

    trace("Dumping forms ended.");
  }

  public function dumpFormDisplayList()
  {
    trace("Dumping forms (DisplayList)...");

    for(index in 0...root.numChildren)
    {
      try
      {
        var control : Control = cast root.getChildAt(index);

        trace(control.controlName);
      }
      catch(e : Dynamic)
      {
      }
    }

    trace("Dumping forms ended.");
  }
#end // debug

  public static function getFormState(_forms : Map<String, Form>) : Array<FormState>
  {
    var temp : Array<FormState> = new Array();
    
    for(form in _forms.iterator())
    {
      var state = new FormState(form);

      temp.push(state);
    }

    return temp;
  }

  public function showDialog(message : String, flags : DialogFlags, displayTactics : DisplayTactics, actionHandler : Dynamic -> Dynamic -> Void) : FormModalDialog
  {
    // mark the state of all forms
    var formState = getFormState(forms);

    // disable all other forms
    for(form in forms.iterator())
    {
      form.enabled = false;
    }
    
    var dialogForm = new FormModalDialog(root, "FormModalDialog", displayTactics, true, strMgr);

    dialogForm.message       = message;
    dialogForm.dialogFlags   = flags;
    dialogForm.actionHandler = actionHandler;
    dialogForm.formState     = formState;

    forms.set("FormModalDialog", dialogForm);

    return dialogForm;
  }

  // triggers all the forms to change the locale
  public function changeLanguage(langTag : String)
  {
    strMgr.lang = langTag;
    
    for(form in forms.iterator())
    {
      form.changeLanguage();
    }
  }

  public function run()
  {
  }
  
	private function stage_onResize (event:Event):Void 
  {
    trace("Application::stage_onResize");
    
    for(form in forms.iterator())
    {
      form.resize (root.stage.stageWidth, root.stage.stageHeight);
    }    
  }    
}