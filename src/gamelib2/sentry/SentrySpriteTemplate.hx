package gamelib2.sentry;

// as3.0
import flash.utils.ByteArray;
import flash.display.BitmapData;

// gamelib
import gamelib2.math.Matrix3f;
import gamelib2.math.Vector2f;
import openfl.utils.Endian;

enum TFLogicItemType
{
  FLogicItemType_Point;
  FLogicItemType_Rect;
}

class SentryModuleTemplate
{
  public var bitmapData : BitmapData;
  public var moduleId : Int;

  public var width  (default, null) : Int;
  public var height (default, null) : Int;

  public function new()
  {
    moduleId = -1;
  }

  public function Init(data : ByteArray) : Bool
  {
    // read the moduleId from the stream
    moduleId = data.readInt();

    // read the width x height
    width  = data.readInt();
    height = data.readInt();

    // read the validity byte
    var valid : Int = data.readByte();

    if (valid == 0)
    {
      bitmapData = new BitmapData(width, height, false, 0xFF000000);

      return false;
    }

    bitmapData = new BitmapData(width, height, true);

    var pixelData : ByteArray = new ByteArray();
    
    // setPixels requires the ByteArray in big endian
    pixelData.endian = Endian.BIG_ENDIAN;

    data.readBytes(pixelData, 0, width * height * 4);

    bitmapData.setPixels(new flash.geom.Rectangle(0, 0, width, height), pixelData);
    
    pixelData.clear();
    pixelData = null;
        
    return true;
  }
  
  public function optimize(): Void
  {
    this.bitmapData.disposeImage();
  }
}

class SentryFModuleTemplate
{
  public var moduleIndex : Int;
  public var pos         : Vector2f;
  public var flags       : Int;

  public var cachedMatrix(default, null) : Matrix3f;

  public function new()
  {
    cachedMatrix = new Matrix3f();
  }

  public function Init(data : ByteArray) : Bool
  {
    moduleIndex = data.readInt();

    pos = new Vector2f(data.readInt(), data.readInt());

    flags = data.readInt();

    //cachedMatrix.identity();
    //cachedMatrix.translate(pos.x, pos.y);

    cachedMatrix.loadIdentity();
    cachedMatrix.setTranslationVector(pos);

    return true;
  }

  public function getMatrix() : Matrix3f
  {
    var matrix = new Matrix3f();

    matrix.loadIdentity();
    matrix.setTranslationVector(pos);

    // TODO: add the flags to the matrix

    return matrix;
  }
}

class SentryFlogicItemTemplate
{
  public var type : TFLogicItemType;
  public var rect : flash.geom.Rectangle;

  public function new()
  {
  }

  public function Init(data : ByteArray) : Bool
  {
    switch(data.readInt())
    {
      case 0:
        type = FLogicItemType_Point;
        rect = new flash.geom.Rectangle(data.readInt(), data.readInt(), 0, 0);

      case 1:
        type = FLogicItemType_Rect;
        rect = new flash.geom.Rectangle(data.readInt(), data.readInt(), data.readInt(), data.readInt());
    }

    return true;
  }
}

class SentryFLogicTemplate
{
  public var items : Array<SentryFlogicItemTemplate>;

  public function new()
  {
  }

  public function Init(data : ByteArray) : Bool
  {
    var itemsCount : Int = data.readInt();
    var itemIndex : Int;

    items = new Array();

    for(itemIndex in 0...itemsCount)
    {
      var fLogicItem : SentryFlogicItemTemplate = new SentryFlogicItemTemplate();

      fLogicItem.Init(data);

      items.push(fLogicItem);
    }

    return true;
  }
}

class SentryFrameTemplate
{
  public var fLogics   : Array<SentryFLogicTemplate>;
  public var fModules  : Array<SentryFModuleTemplate>;
  public var id        : Int;
  public var boundRect : flash.geom.Rectangle;

  public function new()
  {
  }

  public function Init(data : ByteArray) : Bool
  {
    var fModuleIndex : Int;
    var fLogicIndex  : Int;

    id = data.readInt();

    boundRect = new flash.geom.Rectangle(data.readInt(), data.readInt(), data.readInt(), data.readInt());

    //
    // Read the fmodules
    //

    fModules = new Array();

    var fModulesCount : Int = data.readInt();

    for(fModuleIndex in 0...fModulesCount)
    {
      var fModule : SentryFModuleTemplate = new SentryFModuleTemplate();

      fModule.Init(data);

      fModules.push(fModule);
    }

    //
    // read the flogics
    // 

    fLogics = new Array();

    var fLogicCount : Int = data.readInt();

    for(fLogicIndex in 0...fLogicCount)
    {
      var fLogic : SentryFLogicTemplate = new SentryFLogicTemplate();

      fLogic.Init(data);

      fLogics.push(fLogic);
    }

    return true;
  }
}

class SentryAFrameTemplate
{
  public var frameIndex : Int;
  public var pos        : Vector2f;
  public var flags      : Int;
  public var time       : Int; // delay between frames in miliseconds

  public var cachedMatrix(default, null) : Matrix3f;

  public function new()
  {
    cachedMatrix = new Matrix3f();
  }

  public function Init(data : ByteArray) : Bool
  {
    frameIndex = data.readInt();

    pos = new Vector2f(data.readInt(), data.readInt());

    flags = data.readInt();

    time = data.readInt();

    //cachedMatrix.identity();
    //cachedMatrix.translate(pos.x, pos.y);

    cachedMatrix.loadIdentity();
    cachedMatrix.setTranslationVector(pos);

    return true;
  }

  public function getMatrix() : Matrix3f
  {
    var matrix = new Matrix3f();

    matrix.loadIdentity();
    matrix.setTranslationVector(pos);

    // TODO: add the flags to the matrix

    return matrix;
  }
}

class SentryAnimTemplate
{
  public var aFrames : Array<SentryAFrameTemplate>;

  public function new()
  {
  }

  public function Init(data : ByteArray) : Bool
  {
    aFrames = new Array();

    var aFrameCount : Int = data.readInt();
    var aFrameIndex : Int;

    for(aFrameIndex in 0...aFrameCount)
    {
      var aFrame : SentryAFrameTemplate = new SentryAFrameTemplate();

      aFrame.Init(data);

      aFrames.push(aFrame);
    }

    return true;
  }
}

class SentrySpriteTemplate
{
  public var modules : Array<SentryModuleTemplate>;
  public var frames  : Array<SentryFrameTemplate>;
  public var anims   : Array<SentryAnimTemplate>;

  public function new()
  {
    modules = new Array();
    frames  = new Array();
    anims   = new Array();
  }

  public function Init(data : ByteArray) : Bool
  {
    data.endian = flash.utils.Endian.LITTLE_ENDIAN;

    //
    // read the modules
    //
    modules = new Array();

    var moduleCount : Int = data.readInt();

    //trace("modules count: " + moduleCount);

    for(moduleIndex in 0...moduleCount)
    {
      var module : SentryModuleTemplate = new SentryModuleTemplate();

      module.Init(data);

      modules.push(module);
    }

    //
    // read the frames
    //
    frames  = new Array();

    var frameCount : Int = data.readInt();

    //trace("frames count: " + frameCount);

    for(frameIndex in 0...frameCount)
    {
      var frame : SentryFrameTemplate = new SentryFrameTemplate();

      frame.Init(data);

      frames.push(frame);
    }

    //
    // read the anims
    //
    anims   = new Array();

    var animCount : Int = data.readInt();

    //trace("anims count: " + animCount);

    for(animIndex in 0...animCount)
    {
      var anim : SentryAnimTemplate = new SentryAnimTemplate();

      anim.Init(data);

      anims.push(anim);
    }

    return true;
  }
  
  /**
   * Marks the module BitmapData as read-only.
   * 
   * Use this whenever the sprite will only be used for drawing (no collision detection/getPixels)
   */
  public function optimize(): Void
  {
    for (module in this.modules)
    {
      module.optimize();
    }
  }
}
