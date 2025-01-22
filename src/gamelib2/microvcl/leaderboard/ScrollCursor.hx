package gamelib2.microvcl.leaderboard;

// as3
import flash.display.Sprite;
import flash.geom.Rectangle;
import flash.events.MouseEvent;

// gamelib2
import gamelib2.microvcl.Control;
import gamelib2.i18n.Manager;
import gamelib2.microvcl.DisplayTactics;
import gamelib2.microvcl.Helper;

class ScrollCursor extends Control
{
  private var dragBounds : Rectangle;

  public var onDragEvent (default, default) : Void -> Void;
  
  public function new(parentControl : Control, name : String, displayTactics : DisplayTactics, autoAdd : Bool, strMgr : Manager, onDragEvent : Void -> Void)
  {    
    dragBounds = new Rectangle(0, 0, 1, 1);

    this.onDragEvent = onDragEvent;

    super(parentControl, name, displayTactics, autoAdd, strMgr);
  }

  public override function createUI()
  {    
    var bkg = new Sprite();

    Helper.drawBox(bkg.graphics, 0, 0, 16, 24, 0x808080, 0x808080, 0);

    addChild(bkg);

    addEventListener(MouseEvent.MOUSE_DOWN, mouseDown); 
  }

  private function mouseDown(event : MouseEvent)
  {
    startDrag(true, dragBounds);

    stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
    stage.addEventListener(MouseEvent.MOUSE_UP, mouseReleased);
  }

  private function mouseReleased(event : MouseEvent)
  {
    stopDrag();

    if (onDragEvent != null)
    {
      onDragEvent();
    }

    stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveHandler);
    stage.removeEventListener(MouseEvent.MOUSE_UP, mouseReleased);
  }

  private function mouseMoveHandler(event : MouseEvent)
  {
    if (onDragEvent != null)
    {
      onDragEvent();
    }

    event.updateAfterEvent();
  }

  public function notifyScroll(position : Float)
  {
  }

  public function setDragBounds(x : Float, y : Float, width : Float, height : Float)
  {
    dragBounds.x      = x;
    dragBounds.y      = y;
    dragBounds.width  = width;
    dragBounds.height = height;
  }
}