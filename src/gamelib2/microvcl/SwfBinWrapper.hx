package gamelib2.microvcl;

import flash.utils.ByteArray;
import flash.events.Event;
import flash.display.MovieClip;

import gamelib2.microvcl.Control;
import gamelib2.microvcl.DisplayTactics;
import gamelib2.i18n.Manager;

class SwfBinWrapper extends Control
{    
  public var loader : flash.display.Loader;
  public var loaded : Bool;
  public var onLoaded : Void -> Void;
  private var scaleFactor : Float;
  public var content : flash.display.DisplayObject;
  
  public function new(parentControl : Control, name : String, displayTactics : DisplayTactics, autoAdd : Bool, strMgr : Manager, data : ByteArray, ?onLoaded : Void -> Void = null, ?scaleFactor : Float = 1.0)
  {
    super(parentControl, name, displayTactics, autoAdd, strMgr);

    this.onLoaded = onLoaded;
    this.scaleFactor = scaleFactor;

    load(data);
  }

  private function load(data : ByteArray)
  {
    loaded = false;

    // this is insane
    loader = new flash.display.Loader();

    loader.contentLoaderInfo.addEventListener(Event.INIT, onLoadFinished);
    //loader.contentLoaderInfo.addEventListener(flash.events.Event.UNLOAD, onUnloadFinished);
    loader.loadBytes(data);
  }

  private function onLoadFinished(e : Event)
  {
    if (loader != null && loader.content != null)
    {
      //loader.content.width = loader.content.width * scaleFactor;
      //loader.content.height = loader.content.height * scaleFactor;

      content = loader.content;      
      addChild(content);

      loader.unload();

      loaded = true;

      if (onLoaded != null)
      {
        onLoaded();
      }

      // TODO: not sure it works though
      loader = null;
    }
  }

  public function stop()
  {
    var mcInside : MovieClip = cast (cast(content, MovieClip)).getChildAt(0);

    mcInside.stop();
  }

  /*
  public function makeVisible()
  {
    addChild(loader.content);
  }
  */
}