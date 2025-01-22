package gamelib2.renderer;

import gamelib2.math.Rect;
import gamelib2.math.Matrix3f;

class Viewport
{
  public var view    : Rect;
  public var oldView : Rect;
  public var limits  : Rect;

  // matrix to transform a point from world to camera coordinates
  public var cameraMatrix    : Matrix3f;

  // matrix to transform a point from camera to world coordinates
  public var cameraMatrixInv : Matrix3f;

  public function new()
  {
    view    = new Rect(0, 0, 1, 1);
    oldView = new Rect(0, 0, 1, 1);
    limits  = new Rect(0, 0, 1, 1);

    cameraMatrix = new Matrix3f();
    cameraMatrix.loadIdentity();

    cameraMatrixInv = new Matrix3f();
    cameraMatrixInv.loadIdentity();    
  }

  public function setViewExtent(w : Float, h : Float)
  {
    view.width = w;
    view.height = h;

    oldView.width = w;
    oldView.height = h;
  }

  public function setLimitsEx(x : Float, y : Float, w : Float, h : Float)
  {
    limits.x      = x;
    limits.y      = y;
    limits.width  = w;
    limits.height = h;
  }

  // also resets the old view
  public function setViewEx(x : Float, y : Float)
  {
    view.x      = x;
    view.y      = y;
    //view.width  = w;
    //view.height = h;

    checkBounds();
    adjustCameraMatrix();

    oldView.x = view.x;
    oldView.y = view.y;
  }

  public function setViewFocus(x : Float, y : Float)
  {
    setViewEx(x - view.width / 2, y - view.height / 2);
  }

  public function checkBounds()
  {
    // bounds check
    if (view.x + view.width > limits.x + limits.width)
    {
      view.x = limits.x + limits.width - view.width;
    }

    if (view.x < limits.x)
    {
      view.x = limits.x;
    }

    if (view.y + view.height > limits.y + limits.height)
    {
      view.y = limits.y + limits.height - view.height;
    }

    if (view.y < limits.y)
    {
      view.y = limits.y;
    }
  }

  private function adjustCameraMatrix()
  {
    cameraMatrix.loadIdentity();
    cameraMatrix.setTranslationComp(view.x, view.y);

    cameraMatrixInv.copy(cameraMatrix);

    cameraMatrix.invertLocal();
  }

  public function setView(x : Float, y : Float)
  {
    //trace("setView: " + view.x + "..." + x);
    oldView.x = view.x;
    oldView.y = view.y;
      
    view.x = Std.int(x);
    view.y = Std.int(y);

    //trace("view port bounds " + view.x + "..." + (view.x + view.width) + "..." + limits.x + "..." + (limits.x + limits.width));

    //trace(view + " -> " + limits);

    //trace(view + " -> " + limits);

    checkBounds();
    adjustCameraMatrix();
  }  
}