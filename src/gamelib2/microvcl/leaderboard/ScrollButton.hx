package gamelib2.microvcl.leaderboard;

import gamelib2.microvcl.Control;
import gamelib2.microvcl.Button;
import gamelib2.i18n.Manager;
import gamelib2.microvcl.DisplayTactics;

class ScrollButton extends Button
{
  // in miliseconds
  public static var SCROLL_DELAY : Int = 80;
  
  private var mouseDown : Bool;

  private var timeStamp : Float;

  public function new(parentControl : Control, name : String, displayTactics : DisplayTactics, autoAdd : Bool, strMgr : Manager)
  {
    super(parentControl, name, displayTactics, autoAdd, strMgr);

    mouseDown = false;

    addEventListener(flash.events.MouseEvent.MOUSE_DOWN,  onMouseDown);
    addEventListener(flash.events.MouseEvent.MOUSE_UP,    onMouseUp);
    addEventListener(flash.events.MouseEvent.MOUSE_OUT,   onMouseOut);

    timeStamp = Date.now().getTime();
  }

  private override function onEnterFrame(e : flash.events.Event)
  {
    // check for time/date outside modifications
    if (Date.now().getTime() < timeStamp)
    {
      timeStamp = Date.now().getTime();
    }
    
    if (mouseDown && onChangeEvent != null && (Date.now().getTime() - timeStamp >= SCROLL_DELAY))
    {
      timeStamp = Date.now().getTime();

      onChangeEvent(this);
    }
  }

  private function onMouseDown(e : flash.events.MouseEvent)
  {
    mouseDown = true;

    // force scroll first time we press the button
    timeStamp = Date.now().getTime() - SCROLL_DELAY;
  }

  private function onMouseUp(e : flash.events.MouseEvent)
  {
    mouseDown = false;
  }

  private function onMouseOut(e : flash.events.MouseEvent)
  {
    mouseDown = false;
  }
}

