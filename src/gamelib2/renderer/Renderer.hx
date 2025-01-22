package gamelib2.renderer;

import flash.display.BitmapData;

class Renderer
{
  public var viewport : Viewport;

  public var buffer   : BitmapData;

  public function new()
  {
    viewport = new Viewport();
    buffer   = null;
  }

  public function isReady() : Bool
  {
    return (buffer != null);
  }

  public function setExtent(w : Float, h : Float, ?transparent : Bool = false)
  {
    if (buffer != null)
    {
      buffer.dispose();
      buffer = null;
    }
    
    buffer = new BitmapData(Std.int(w), Std.int(h), transparent, 0x000000);

    viewport.setViewExtent(w, h);
  }
}