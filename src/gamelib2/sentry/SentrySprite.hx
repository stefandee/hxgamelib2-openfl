package gamelib2.sentry;

// as3.0
import flash.display.MovieClip;
import flash.display.Bitmap;
import flash.display.DisplayObjectContainer;
import flash.events.Event;
import haxe.ds.Vector;

// app
import gamelib2.sentry.SentrySpriteTemplate;
import gamelib2.Clock;
import gamelib2.math.Matrix3f;
import gamelib2.Utils;

class SentryModule extends Bitmap
{
  private var moduleTemplate : SentryModuleTemplate;

  public function new(moduleTemplate : SentryModuleTemplate)
  {
    super();

    this.moduleTemplate = moduleTemplate;

    this.bitmapData = moduleTemplate.bitmapData;

    //trace("SentryModule::new");
  }
}

class SentryAFrame extends flash.display.Sprite
{
  var modules : Array<SentryModule>;

  public function new()
  {
    super();

    modules = new Array();
  }

  public function Init(template : SentrySpriteTemplate, templateAFrame : SentryAFrameTemplate)
  {
    //trace("SentryAFrame::init");

    // clear the display list
    while(numChildren > 0)
    {
      removeChild(getChildAt(0));
    }

    modules = new Array();

    var aFrameMatrix : Matrix3f = templateAFrame.getMatrix();

    //trace("SentryAFrame::Init");
    var tempFrames = template.frames[templateAFrame.frameIndex];

    if (tempFrames == null)
    {
      trace("tempFrames is null! " + templateAFrame.frameIndex + "/" + template.frames.length);
      return;
    }

    if (template.frames[templateAFrame.frameIndex].fModules == null)
    {
      trace("TEMPLATE BLAH IS NULL!");
      return;
    }

    var moduleMatrix : Matrix3f = new Matrix3f();

    for(fModule in template.frames[templateAFrame.frameIndex].fModules)
    {
      var fModuleMatrix : Matrix3f = fModule.getMatrix();

      var module : SentryModule = new SentryModule(template.modules[fModule.moduleIndex]);

      //trace("module index: " + fModule.moduleIndex);

      moduleMatrix.loadIdentity();
      moduleMatrix.multLocal(fModuleMatrix);
      moduleMatrix.multLocal(aFrameMatrix);

      addChild(module);

      module.transform.matrix = Utils.matrix3fToFlash(moduleMatrix);

      //module.x = 0;
      //module.y = 0;

      modules.push(module);
    }
  }
}

class SentryAnim
{
  public var aFrames : Array<SentryAFrame>;

  public function new()
  {
    aFrames = new Array();
  }

  public function Init(template : SentrySpriteTemplate, templateAnim : SentryAnimTemplate)
  {
    aFrames = new Array();

    for(aFrameTemplate in templateAnim.aFrames)
    {
      var aFrame : SentryAFrame = new SentryAFrame();

      aFrame.Init(template, aFrameTemplate);

      aFrames.push(aFrame);
    }
  }
}

// 
// This is a flash friendly SentrySprite
//
// All visual data (bitmapdata) is shared through a template (so that we wont duplicate data
// and fill memory)
//
class SentrySprite extends flash.display.Sprite
{
  // used to have the same BitmapData contained in a ModuleTemplate for all sprites,
  // but in a flash-friendly form - that can be operated by a flash DisplayObjectContainer
  public var anims : Vector<SentryAnim>;

  // used for frames and anims data
  public var template : SentrySpriteTemplate;

  // anim data
  @:isVar public var currentAnim   (get, set)     : Int;
  @:isVar public var currentAFrame (get, set) : Int;

  public var loop  : Bool;
  public var animFinished (get, null) : Bool;
  @:isVar public var pause (default, set) : Bool;

  private var timeStamp : Float;

  public function new(tmpl : SentrySpriteTemplate)
  {
    //trace("SentrySprite::new");

    super();

    this.template = tmpl;

    anims = new Vector(template.anims.length);

    /*
    for(animTemplate in template.anims)
    {
      var anim : SentryAnim = new SentryAnim();

      anim.Init(template, animTemplate);

      anims.push(anim);
    }
    */

    currentAnim = 0;

    loop = true;

    timeStamp = Clock.instance.getTimer(Timer.TIMER_SPRITE).time;
  }

  private function get_currentAnim() : Int
  {
    return currentAnim;
  }

  private function set_currentAnim(anim : Int) : Int
  {
    if (anim < 0 || anim > template.anims.length)
    {
      return currentAnim;
    }

    currentAnim   = anim;
    currentAFrame = 0;

    return currentAnim;
  }

  private function get_currentAFrame() : Int
  {
    return currentAFrame;
  }

  private function set_currentAFrame(aFrameIndex : Int) : Int
  {
    //trace("SetCurrentAFrame: " + aFrameIndex);

    // TODO: alias the template.anims[CurrentAnim] here or in setter for anim
    if (aFrameIndex < 0 || aFrameIndex >= template.anims[currentAnim].aFrames.length)
    {
      //trace("invalid aframe!");
      return currentAFrame;
    }

    currentAFrame = aFrameIndex;
    timeStamp     = Clock.instance.getTimer(Timer.TIMER_SPRITE).time;//Date.now().getTime();

    // TODO: rebuild the display list

    // first, clear the display list
    while(numChildren > 0)
    {
      removeChild(getChildAt(0));
    }

    // initialize the anim data on demand
    if (anims[currentAnim] == null)
    {
      var tmpAnim = new SentryAnim();
      tmpAnim.Init(template, template.anims[currentAnim]);      
      anims[currentAnim] = tmpAnim;
    }
    
    // build the new display list
    // dont even bother to ask about the redirections :)
    addChild(anims[currentAnim].aFrames[currentAFrame]);

    return currentAFrame;
  }

  public function update()
  {
    if (pause)
    {
      return;
    }
    
    if (Clock.instance.getTimer(Timer.TIMER_SPRITE).time/*Date.now().getTime()*/ - timeStamp > template.anims[currentAnim].aFrames[currentAFrame].time)
    {
      // to avoid strange problems
      if ((currentAFrame + 1) >= template.anims[currentAnim].aFrames.length)
      {
        if (loop)
        {
          currentAFrame = 0;
        }
      }
      else
      {
        currentAFrame++;
      }

#if (ImprovedAnimFinished)
      if (loop)
      {
        timeStamp = Clock.instance.getTimer(Timer.TIMER_SPRITE).time;//Date.now().getTime();
      }
#else
        timeStamp = Clock.instance.getTimer(Timer.TIMER_SPRITE).time;//Date.now().getTime();
#end

    }
  }

  public function GetAFramesCount(anim : Int) : Int
  {
    if (anim < 0 || anim > template.anims.length)
    {
      return -1;
    }

    return template.anims[anim].aFrames.length;
  }

  public function clone() : SentrySprite
  {
    var sprite : SentrySprite = new SentrySprite(template);

    sprite.loop = this.loop;
    sprite.currentAnim = this.currentAnim;

    return sprite;
  }

  public function set_pause(v : Bool) : Bool
  {
    //trace("SentrySprite::pause - not implemented!");

    pause = v;

    // TODO: set a timeStampPause, so that we keep the timing difference
    if (!pause)
    {
      timeStamp = Clock.instance.getTimer(Timer.TIMER_SPRITE).time;
    }

    return pause;
  }

  private function get_animFinished() : Bool
  {
    if (loop)
    {
      return false;
    }

#if (ImprovedAnimFinished)
    return ((currentAFrame + 1) >= template.anims[currentAnim].aFrames.length) && (Clock.instance.getTimer(Timer.TIMER_SPRITE).time - timeStamp > template.anims[currentAnim].aFrames[currentAFrame].time);
#else
    return ((currentAFrame + 1) >= template.anims[currentAnim].aFrames.length);
#end
  }

  public function getFLogicItemAsPoint(animIndex : Int, aFrameIndex : Int, fLogicIndex : Int, fLogicItemIndex : Int) : flash.geom.Point
  {
    if (template == null)
    {
      trace("getFLogicItemAsPoint - template is null.");
      return null;
    }

    if (template.anims.length <= animIndex)
    {
      return null;
    }

    var animTmpl = template.anims[animIndex];

    if (animTmpl.aFrames.length <= aFrameIndex)
    {
      return null;
    }

    var pos : flash.geom.Point = null;
    var frameIndex = animTmpl.aFrames[aFrameIndex].frameIndex;
    var frameTmpl = template.frames[frameIndex];

    if (frameTmpl.fLogics.length > fLogicIndex)
    {
      if (frameTmpl.fLogics[fLogicIndex].items.length > fLogicItemIndex)
      {
        var fLogicItemTmpl = frameTmpl.fLogics[fLogicIndex].items[fLogicItemIndex];

        pos = new flash.geom.Point(fLogicItemTmpl.rect.left, fLogicItemTmpl.rect.top);
      }
    }

    return pos;
  }

  public function getFLogicItemAsRect(animIndex : Int, aFrameIndex : Int, fLogicIndex : Int, fLogicItemIndex : Int) : flash.geom.Rectangle
  {
    if (template == null)
    {
      trace("getFLogicItemAsRe - template is null.");
      return null;
    }

    if (template.anims.length <= animIndex)
    {
      return null;
    }

    var animTmpl = template.anims[animIndex];

    if (animTmpl.aFrames.length <= aFrameIndex)
    {
      return null;
    }

    var rect : flash.geom.Rectangle = null;
    var frameIndex = animTmpl.aFrames[aFrameIndex].frameIndex;
    var frameTmpl = template.frames[frameIndex];

    if (frameTmpl.fLogics.length > fLogicIndex)
    {
      if (frameTmpl.fLogics[fLogicIndex].items.length > fLogicItemIndex)
      {
        var fLogicItemTmpl = frameTmpl.fLogics[fLogicIndex].items[fLogicItemIndex];

        rect = new flash.geom.Rectangle();
        
        rect.left   = fLogicItemTmpl.rect.left;
        rect.top    = fLogicItemTmpl.rect.top;
        rect.right  = fLogicItemTmpl.rect.right;
        rect.bottom = fLogicItemTmpl.rect.bottom;
      }
    }

    return rect;
  }

  public function computeBounds() : flash.geom.Rectangle
  {
    var bounds = new flash.geom.Rectangle();

    bounds.width = 1;
    bounds.height = 1;
    
    for(i in 0...numChildren)
    {
      //trace(getChildAt(i).getBounds(this));

      var childBounds = getChildAt(i).getBounds(this);

      if (childBounds.left < bounds.left)
      {
        bounds.left = childBounds.left;
      }

      if (childBounds.right > bounds.right)
      {
        bounds.right = childBounds.right;
      }

      if (childBounds.top < bounds.top)
      {
        bounds.top = childBounds.top;
      }

      if (childBounds.bottom > bounds.bottom)
      {
        bounds.bottom = childBounds.bottom;
      }

      //bounds.union();
    }

    return bounds;
  }

  private static var cachedMatrix : Matrix3f = new Matrix3f();
  private static var moduleMatrix : Matrix3f = new Matrix3f();
  private static var moduleMatrixFlash : flash.geom.Matrix = new flash.geom.Matrix();

  public function draw(buffer : flash.display.BitmapData, animIndex : Int, aframeIndex : Int, m : Matrix3f)
  {

    var animTmpl   : SentryAnimTemplate   = template.anims[animIndex];
    var aframeTmpl : SentryAFrameTemplate = animTmpl.aFrames[aframeIndex];

    //cachedMatrix.loadIdentity();
    //cachedMatrix.copy(m);

    /*
    cachedMatrix.a  = m.m00;
    cachedMatrix.b  = m.m01;
    cachedMatrix.c  = m.m10;
    cachedMatrix.d  = m.m11;
    cachedMatrix.tx = m.m02;
    cachedMatrix.ty = m.m12;
    */

    /*
    cachedMatrix.tx = posX;
    cachedMatrix.ty = posY;
    cachedMatrix.a  = scaleX;
    cachedMatrix.d  = scaleY;
    */


    // TODO: cache this matrix or elimiate it directly?
    var aFrameMatrix : Matrix3f = aframeTmpl.cachedMatrix;//aframeTmpl.GetMatrix();

    //trace("SentryAFrame::Init");
    var tempFrames = template.frames[aframeTmpl.frameIndex];

    if (tempFrames == null)
    {
      return;
    }

    if (template.frames[aframeTmpl.frameIndex].fModules == null)
    {
      return;
    }

    for(fModule in template.frames[aframeTmpl.frameIndex].fModules)
    {
      var fModuleMatrix : Matrix3f = fModule.cachedMatrix;//fModule.GetMatrix();

      var moduleTmpl = template.modules[fModule.moduleIndex];

      //trace("module index: " + fModule.moduleIndex);

      // prepare the matrix
      moduleMatrix.loadIdentity();
      
      moduleMatrix.multLocal(fModuleMatrix);
      //trace("fmodulematrix: " + moduleMatrix.toString());
      
      moduleMatrix.multLocal(aFrameMatrix);
      //trace("aframematrix" + moduleMatrix.toString());

      moduleMatrix.multLocal(m);
      //trace("final matrix: " + moduleMatrix.toString());

      // do the actual draw
      buffer.draw(moduleTmpl.bitmapData, Utils.matrix3fToFlash(moduleMatrix, moduleMatrixFlash));
    }
  }
}