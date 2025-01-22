package gamelib2.microvcl.leaderboard;

import gamelib2.math.MathEx;
import gamelib2.microvcl.Control;
import gamelib2.microvcl.Helper;
import gamelib2.i18n.Manager;
import gamelib2.microvcl.DisplayTactics;

import gamelib2.microvcl.leaderboard.dt.ArrowButtonTactics;

import flash.display.Sprite;

class ScrollBar extends Control
{
  public static var DEFAULT_SPACING : Int = 4;
  
  @:isVar public var position    (default, set)    : Int;
  @:isVar public var maxPosition (default, set) : Int;
  @:isVar public var step        (default, set)        : Int;
  @:isVar public var size        (default, set)        : Int;

  private var updateScrollCursorPos                : Bool;
  private var scrollCursor                         : ScrollCursor;
  private var upBtn                                : ScrollButton;
  private var downBtn                              : ScrollButton;
  private var bkg                                  : Sprite;  

  public var onScrollEvent (default, default) : Dynamic -> Dynamic -> Void;
  
  public function new(parentControl : Control, name : String, displayTactics : DisplayTactics, autoAdd : Bool, strMgr : Manager)
  {    
    super(parentControl, name, displayTactics, autoAdd, strMgr);

    updateScrollCursorPos = true;
    position      = 0;
    maxPosition   = 100;
    onScrollEvent = null;
  }

  private function set_position(pos : Int)
  {
    //if (maxPosition == null)
    //{
    //  position = Std.int(MathEx.fclamp(pos, 0, 100));
    //}
    //else
    //{
      position = Std.int(MathEx.fclamp(pos, 0, maxPosition));
    //}
            
    if (onScrollEvent != null)
    {
      onScrollEvent(this, position);
    }

    if (scrollCursor != null && updateScrollCursorPos)
    {
      //scrollCursor.notifyScroll(position);
      scrollCursor.y = upBtn.height + DEFAULT_SPACING + Std.int((bkg.height - scrollCursor.height) * position / maxPosition);
    }

    return position;
  }

  private function set_maxPosition(pos : Int)
  {
    if (pos < 0)
    {
      pos = 0;
    }

    maxPosition = pos;

    //if (position != null)
    //{
      var tmp = position;
      position = tmp;
    //}

    return maxPosition;
  }

  private function set_step(v : Int) : Int
  {
    if (v < 0)
    {
      v = 0;
    }

    step = v;

    return step;
  }

  public override function createUI()
  {
    // create the scroll background
    bkg = new Sprite();

    Helper.drawBox(bkg.graphics, 0, 0, 16, 100, 0xE0E0E0, 0xE0E0E0, 0);

    addChild(bkg);

    bkg.x = 0;
    bkg.y = 13 + DEFAULT_SPACING;

    upBtn = new ScrollButton(this, "BtnUp", new ArrowButtonTactics(16, 13, ArrowOrientation.Down,  0x808080, 0x000000), true, strMgr);
    upBtn.onChangeEvent = onChangeUp;
    upBtn.x = 0;
    upBtn.y = 0;

    downBtn = new ScrollButton(this, "BtnDown", new ArrowButtonTactics(16, 13, ArrowOrientation.Top,  0x808080, 0x000000), true, strMgr);
    downBtn.onChangeEvent = onChangeDown;
    downBtn.x = 0;
    downBtn.y = 100 + 13 + 2 * DEFAULT_SPACING;

    // create the scroll cursor
    scrollCursor = new ScrollCursor(this, "ScrollCursor", null, true, strMgr, onDrag);

    scrollCursor.x = 0;
    scrollCursor.y = 13 + DEFAULT_SPACING;
  }

  public function onDrag()
  {
    // lacking a better solution...
    updateScrollCursorPos = false;

    position = Std.int(maxPosition * (scrollCursor.y - (upBtn.height + DEFAULT_SPACING)) / Std.int(bkg.height - scrollCursor.height));

    updateScrollCursorPos = true;

    //trace(scrollCursor.y + "/" + (upBtn.height + DEFAULT_SPACING));
  }

  public function onChangeUp(control : Control)
  {
    position -= step;    

    trace("change up: " + position);
  }

  public function onChangeDown(control : Control)
  {
    position += step;    

    trace("change down: " + position);
  }

  private function set_size(v : Int) : Int
  {
    var minSize = Std.int(upBtn.height + downBtn.height + DEFAULT_SPACING + scrollCursor.height);

    if (v < minSize)
    {
      v = minSize;
    }
    
    size = v;

    upBtn.x = 0;
    upBtn.y = 0;

    downBtn.x = 0;
    downBtn.y = size - downBtn.height;

    bkg.x = 0;
    bkg.y = upBtn.height + DEFAULT_SPACING;
    bkg.height = size - 2 * DEFAULT_SPACING - upBtn.height - downBtn.height;

    scrollCursor.setDragBounds(0, upBtn.height + DEFAULT_SPACING, 0, Std.int(bkg.height - scrollCursor.height));

    return size;
  }
}