package gamelib2.microvcl;

import gamelib2.microvcl.Form;

class FormState
{
  public var form                    : Form;
  public var enabled (default, null) : Bool;

  public function new(form : Form)
  {
    this.form = form;

    enabled = form.enabled;
  }
}

