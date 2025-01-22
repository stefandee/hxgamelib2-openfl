package gamelib2.microvcl;

import gamelib2.microvcl.Control;
import gamelib2.microvcl.DisplayTactics;

class RootControl extends Control
{
	private var theRoot : flash.display.MovieClip;
  
  public function new(controlName : String)
  {
    super(null, controlName, new DisplayTactics(), false, null);

    // setup the root
    theRoot = flash.Lib.current;

		// setup the stage
    var stage : flash.display.Stage = theRoot.stage;

		stage.scaleMode      = flash.display.StageScaleMode.NO_SCALE;
    stage.stageFocusRect = false;

		//stage.addEventListener(flash.events.Event.ENTER_FRAME, onEnterFrame);

    theRoot.addChild(this);
  }

	/*
  private override function onEnterFrame(e : flash.events.Event) 
  {
  }
  */
}
