package gamelib2.scene;

import flash.display.BitmapData;
import flash.geom.ColorTransform;
import flash.geom.Point;
import gamelib2.sentry.SentrySpriteTemplate;
import gamelib2.math.Matrix3f;
import gamelib2.math.Vector2f;
import gamelib2.math.Rect;
import gamelib2.math.MathEx;
import gamelib2.Utils;
import gamelib2.renderer.Renderer;
import gamelib2.bounding.BoundingRect;

class Sentry extends Spatial
{
  // used for frames and anims data
  public var template (default, null)                           : SentrySpriteTemplate;

  // anim data
  @:isVar public var currentAnim   (get, set)     : Int;
  @:isVar public var currentAFrame (get, set) : Int;

  public var loop                                               : Bool;
  public var animFinished                                       : Bool;
  @:isVar public var pause (default, set)                       : Bool;

  private var timeStamp         : Float;

  private static var cachedMatrix      : Matrix3f = new Matrix3f();
  private static var cachedLWMatrix    : Matrix3f = new Matrix3f();
  private static var moduleMatrix      : Matrix3f = new Matrix3f();
  private static var cachedMatrix2     : Matrix3f = new Matrix3f();
  private static var moduleMatrixFlash : flash.geom.Matrix = new flash.geom.Matrix(); 
  private static var cachedPoint       : Vector2f = new Vector2f();
  private static var cachedRect        : Rect     = new Rect();
  private static var cachedFlashRect   : flash.geom.Rectangle = new flash.geom.Rectangle();
  private static var cachedFlashPoint  : flash.geom.Point = new flash.geom.Point();
  private static var tempV1            : Vector2f = new Vector2f();
  private static var tempV2            : Vector2f = new Vector2f();
  private static var tempBound         : BoundingRect = new BoundingRect();

  public var bound              : BoundingRect;

  //public var mirror             : Vector2f;
  //public var rotation           : Float;

  private var colorTransform    : ColorTransform;
  private var defaultColorTransform : Bool;

  public var drawBounds         : Bool;

  public function new(tmpl : SentrySpriteTemplate)
  {
    colorTransform    = new ColorTransform();
    defaultColorTransform = true;

    super();
    
    bound             = new BoundingRect();

    drawBounds = false;

    setTemplate(tmpl);
  }

  public function setTemplate(tmpl : SentrySpriteTemplate)
  {
    template    = tmpl;
    timeStamp   = 0;
    currentAnim = 0;
    loop        = true;
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

    animFinished = false;

    timeStamp = -1;

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

    updateModelBound();
    updateWorldBound(false);

    // wtf is this? :)
    //timeStamp     = Clock.instance.getTimer(Timer.TIMER_SPRITE).time;//Date.now().getTime();
    timeStamp = -1;

    return currentAFrame;
  }

  public function update(time : Float)
  {
    if (pause)
    {
      return;
    }

    if (timeStamp == -1)
    {
      timeStamp = time;
    }
    
    if (time - timeStamp > template.anims[currentAnim].aFrames[currentAFrame].time)
    {
      // to avoid strange problems
      if ((currentAFrame + 1) >= template.anims[currentAnim].aFrames.length)
      {
        if (loop)
        {
          currentAFrame = 0;
        }
        else
        {
          animFinished = true;
        }
      }
      else
      {
        currentAFrame++;
      }

#if (ImprovedAnimFinished)
      if (loop)
      {
        //timeStamp = time;
      }
#else
      //timeStamp = time;
#end

    }
  }

  public function getAnimCount() : Int
  {
    return template.anims.length;
  }

  public function GetAFramesCount(anim : Int) : Int
  {
    if (anim < 0 || anim > template.anims.length)
    {
      return -1;
    }

    return template.anims[anim].aFrames.length;
  }

  public function clone() : Spatial
  {
    var spatial : Sentry = new Sentry(template);

    spatial.loop = this.loop;
    spatial.currentAnim = this.currentAnim;

    return spatial;
  }

  public function set_pause(v : Bool) : Bool
  {
    pause = v;

    return pause;
  }

    /*
  private function getAnimFinished() : Bool
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
    return animFinished;
  }
    */

  public function getFLogicItemCount(animIndex : Int, aFrameIndex : Int, fLogicIndex : Int) : Int
  {
    if (template.anims.length <= animIndex)
    {
      return -1;
    }

    var animTmpl = template.anims[animIndex];

    if (animTmpl.aFrames.length <= aFrameIndex)
    {
      return -1;
    }

    var frameIndex = animTmpl.aFrames[aFrameIndex].frameIndex;
    var frameTmpl = template.frames[frameIndex];

    if (fLogicIndex >= frameTmpl.fLogics.length)
    {
      return -1;
    }

    return frameTmpl.fLogics[fLogicIndex].items.length;
  }

  public function getFLogicItemAsPoint(animIndex : Int, aFrameIndex : Int, fLogicIndex : Int, fLogicItemIndex : Int, ?store : Vector2f = null) : Vector2f
  {
    if (store == null)
    {
      store = new Vector2f();
    }
    
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

        //pos = new flash.geom.Point(fLogicItemTmpl.rect.left, fLogicItemTmpl.rect.top);
        store.setComp(fLogicItemTmpl.rect.left, fLogicItemTmpl.rect.top);
      }
    }

    return store;
  }

  /*
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
  */

  public function computeBounds(animIndex : Int, aframeIndex : Int, ?storeBounds : Rect = null) : Rect
  {
    if (storeBounds == null)
    {
      storeBounds = new Rect();
    }

    storeBounds.x = 0;
    storeBounds.y = 0;
    storeBounds.width = 0;
    storeBounds.height = 0;

    var animTmpl   : SentryAnimTemplate   = template.anims[animIndex];
    var aframeTmpl : SentryAFrameTemplate = animTmpl.aFrames[aframeIndex];

    // TODO: cache this matrix or elimiate it directly?
    var aFrameMatrix : Matrix3f = aframeTmpl.cachedMatrix;//aframeTmpl.GetMatrix();

    //trace("SentryAFrame::Init");
    var tempFrames = template.frames[aframeTmpl.frameIndex];

    if (tempFrames == null)
    {
      return null;
    }

    if (template.frames[aframeTmpl.frameIndex].fModules == null)
    {
      return null;
    }

    for(fModule in template.frames[aframeTmpl.frameIndex].fModules)
    {
      var fModuleMatrix : Matrix3f = fModule.cachedMatrix;//fModule.GetMatrix();

      var moduleTmpl = template.modules[fModule.moduleIndex];
	  
	  if (moduleTmpl == null)
	  {
		trace("null module - probably refering an non-existant module");
		
		continue;
	  }

      //trace("module index: " + fModule.moduleIndex);

      // prepare the matrix
      cachedMatrix.loadIdentity();
      cachedMatrix.multLocal(fModuleMatrix);
      cachedMatrix.multLocal(aFrameMatrix);

      //trace(cachedMatrix.toString());

      // TODO: optimized this
      cachedPoint.x = 0; 
      cachedPoint.y = 0;      
      cachedPoint.transformLocal(cachedMatrix);
      storeBounds.inflateLocal(cachedPoint);
      //trace(cachedPoint.toString());

      cachedPoint.x = moduleTmpl.width; 
      cachedPoint.y = 0;
      cachedPoint.transformLocal(cachedMatrix);
      storeBounds.inflateLocal(cachedPoint);
      //trace(cachedPoint.toString());

      cachedPoint.x = moduleTmpl.width; 
      cachedPoint.y = moduleTmpl.height;
      cachedPoint.transformLocal(cachedMatrix);
      storeBounds.inflateLocal(cachedPoint);
      //trace(cachedPoint.toString());

      cachedPoint.x = 0; 
      cachedPoint.y = moduleTmpl.height;
      cachedPoint.transformLocal(cachedMatrix);
      storeBounds.inflateLocal(cachedPoint);
      //trace(cachedPoint.toString());

      //if (animIndex == 23)
      //{
      //  trace(moduleTmpl.width + "x" + moduleTmpl.height);
      //}
    }

    //if (animIndex == 23)
    //{
    //  trace("bounds for SentrySpriteBuffer: " + storeBounds.toString());
    //}
    
    return storeBounds;
  }

  public function computeCurrentBounds(?storeBounds : Rect = null) : Rect
  {
    return computeBounds(currentAnim, currentAFrame, storeBounds);
  }

  public override function draw(r : Renderer)
  {
    if (!visible || alpha == 0.0)
    {
      //trace("not visible or alpha is 0");
	  
      return;
    }
    
    // clip if outside the viewport
    tempBound.setRect(r.viewport.view);

    if (!worldBound.intersectsBoundingRect(tempBound))
    {
      //trace("outside the viewport! object: " + worldBound.toString() + " vs viewport: " + tempBound.toString());
	  
	  return;
    }

    //trace(cachedMatrix);

    //cachedMatrix.multLocal(r.viewport.cameraMatrix);

    /*
    if (this.name == "HeroAvatar")
    {
      this.getLocalToWorldMatrix(cachedLWMatrix);
      cachedMatrix.copy(r.viewport.cameraMatrix);
      cachedMatrix.multLocal(cachedLWMatrix);
      
      cachedMatrix.multVector2(new Vector2f(-43, -35), tempV1);
      r.buffer.fillRect(new flash.geom.Rectangle(tempV1.x, tempV1.y, 5, 5), 0xFFFFFF);

      cachedMatrix.multVector2(new Vector2f(40, 0), tempV1);
      r.buffer.fillRect(new flash.geom.Rectangle(tempV1.x, tempV1.y, 5, 5), 0xFF0000);

      cachedMatrix.multVector2(new Vector2f(0, 40), tempV1);
      r.buffer.fillRect(new flash.geom.Rectangle(tempV1.x, tempV1.y, 5, 5), 0x0000FF);

      cachedMatrix.multVector2(new Vector2f(0, 0), tempV1);
      r.buffer.fillRect(new flash.geom.Rectangle(tempV1.x, tempV1.y, 5, 5), 0x000000);

      //trace("scale: " + worldScale.toString());
    }
    */

    // draw the worldBound transformed by the camera matrix
    if (drawBounds)
    {
      cachedMatrix.copy(r.viewport.cameraMatrix);
      cachedMatrix.setTranslationComp(0, 0);

      tempV1.setComp(r.viewport.cameraMatrix.m02, r.viewport.cameraMatrix.m12);
      tempV2.setComp(1, 1);

      tempBound = cast worldBound.transform(cachedMatrix, tempV1, tempV2, tempBound);

      Utils.drawRect(
        r.buffer, 
        0xFFFFFFFF, 
        tempBound.center.x - tempBound.xExtent, 
        tempBound.center.y - tempBound.yExtent,
        tempBound.center.x + tempBound.xExtent,
        tempBound.center.y + tempBound.yExtent
      );
    }

    // draw the current frame
    drawAFrame(r.buffer, currentAnim, currentAFrame, r.viewport.cameraMatrix);
  }

  //public function draw(buffer : flash.display.BitmapData, animIndex : Int, aframeIndex : Int, m : Matrix3f)
  public function drawAFrame(buffer : flash.display.BitmapData, animIndex : Int, aframeIndex : Int, cameraMatrix : Matrix3f)
  {
    // prepare the world * camera matrix
    this.getLocalToWorldMatrix(cachedLWMatrix);

    var animTmpl   : SentryAnimTemplate   = template.anims[animIndex];
    var aframeTmpl : SentryAFrameTemplate = animTmpl.aFrames[aframeIndex];

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
	  
	  if (moduleTmpl == null)
	  {
		trace("attempt to draw an non-existant module.");
		
		continue;
	  }

      // prepare the matrix
      moduleMatrix.loadIdentity();
      moduleMatrix.copy(fModuleMatrix);
      moduleMatrix.multLocal(aFrameMatrix);

      // create the local to world matrix; since modules don't have their 
      // own rotations and scales, just use the parent (this) ones
      cachedLWMatrix.loadIdentity();

      // S * R
      cachedLWMatrix.setScale(worldScale);
      cachedLWMatrix.multLocal(worldRotation);

      // R * S
      //cachedLWMatrix.copy(worldRotation);
      //cachedMatrix.loadIdentity();
      //cachedMatrix.setScale(worldScale);
      //cachedLWMatrix.multLocal(cachedMatrix);

      cachedLWMatrix.setTranslationComp(worldTranslation.x, worldTranslation.y);

      // create the final matrix from camera and world matrices
      cachedMatrix.copy(cameraMatrix);      
      cachedMatrix.multLocal(cachedLWMatrix);
      cachedMatrix.multLocal(moduleMatrix);

      if (cachedMatrix.m00 == 1 && cachedMatrix.m11 == 1 && cachedMatrix.m01 == 0 && cachedMatrix.m10 == 0 && alpha == 1.0 && colorTransform.redMultiplier == 1.0)
      {
#if flash        
        cachedFlashRect.x      = 0;
        cachedFlashRect.y      = 0;
        cachedFlashRect.width  = moduleTmpl.width;
        cachedFlashRect.height = moduleTmpl.height;

        cachedFlashPoint.x = cachedMatrix.m02;
        cachedFlashPoint.y = cachedMatrix.m12;                       

        buffer.copyPixels(moduleTmpl.bitmapData, cachedFlashRect, cachedFlashPoint, null, null, true);
#else        
        // draw is way faster in html5 than copyPixels (very weird implementation from openfl...)
        Utils.matrix3fToFlash(cachedMatrix, moduleMatrixFlash);
        buffer.draw(moduleTmpl.bitmapData, moduleMatrixFlash, null, null, null, true);
#end // flash        
        
        //trace("copyPixels!");
      }
      else
      {
        Utils.matrix3fToFlash(cachedMatrix, moduleMatrixFlash);

        // TODO: hack to get the rotation and flipping working together. Must find a decent way to do it
        /*
        if (worldScale.x < 0)
        {
          moduleMatrixFlash.c *= -1;
          moduleMatrixFlash.b *= -1;
        }
        */

        //GL11.glTranslatef(xp,yp,0);
		    //GL11.glScalef(0.35f,0.35f,0.35f);
		    //GL11.glRotatef(ang,0,0,1);

        /*
        moduleMatrixFlash.identity();

        moduleMatrixFlash.a = worldRotation.m00;
        moduleMatrixFlash.b = worldRotation.m10;
        moduleMatrixFlash.c = worldRotation.m01;
        moduleMatrixFlash.d = worldRotation.m11;

        moduleMatrixFlash.scale(worldScale.x, worldScale.y);

        moduleMatrixFlash.translate(tempV2.x + cameraMatrix.m02, tempV2.y + cameraMatrix.m12);
        */

        // trace("colorTransform for " + this.template.modules.length + " " + colorTransform.toString() + " alpha: " + alpha);
        if (defaultColorTransform)
        {
          buffer.draw(moduleTmpl.bitmapData, moduleMatrixFlash, null, null, null, true);
        }
        else
        {
          buffer.draw(moduleTmpl.bitmapData, moduleMatrixFlash, colorTransform, null, null, true);
        }
      }
    }
  }

  /**
   * <code>updateWorldBound</code> updates the bounding volume that contains
   * this geometry. The location of the geometry is based on the location of
   * all this node's parents.
   * 
   * @see com.jme.scene.Spatial#updateWorldBound()
   */
  public override function updateWorldBound(?recursive : Bool = false) : Void
  {
    // updateModelBound?
    // updateModelBound();

    if (bound != null) 
    {
      worldBound = bound.transform(worldRotation, worldTranslation, worldScale, worldBound);
    }
  }

  public override function updateWorldData(time : Float) : Void
  {
    super.updateWorldData(time);

    update(time);
  }

  public override function updateModelBound() : Void
  {
    bound.setRect(computeCurrentBounds(cachedRect));
  }

  private override function set_alpha(v : Float) : Float
  {
    alpha = MathEx.fclamp(v, 0.0, 1.0);

    colorTransform.alphaMultiplier = alpha;

    checkDefaultColorTransform();
    
    return alpha;
  }

  public function setColorTransform(redMultiplier : Float, greenMultiplier : Float, blueMultiplier : Float, redOffset : Float, greenOffset : Float, blueOffset : Float)
  {
    colorTransform.redMultiplier   = redMultiplier;
    colorTransform.greenMultiplier = greenMultiplier;
    colorTransform.blueMultiplier  = blueMultiplier;
    colorTransform.redOffset       = redOffset;
    colorTransform.greenOffset     = greenOffset;
    colorTransform.blueOffset      = blueOffset;    
    
    checkDefaultColorTransform();
  }

  public function resetColorTransform()
  {
    colorTransform.redMultiplier   = 1.0;
    colorTransform.greenMultiplier = 1.0;
    colorTransform.blueMultiplier  = 1.0;
    colorTransform.redOffset       = 0.0;
    colorTransform.greenOffset     = 0.0;
    colorTransform.blueOffset      = 0.0;
    
    checkDefaultColorTransform();
  }
  
  private function checkDefaultColorTransform(): Void
  {
    defaultColorTransform = 
      colorTransform.redMultiplier == 1.0 && colorTransform.greenMultiplier == 1.0 && colorTransform.blueMultiplier == 1.0 && colorTransform.alphaMultiplier == 1.0 &&
      colorTransform.redOffset == 0.0 && colorTransform.greenOffset == 0.0 && colorTransform.blueOffset == 0.0 && colorTransform.alphaOffset == 0.0;
  }

  public override function hasCollision(scene : Spatial, pixelPerfect : Bool, ?requiredOnBits : Int = 1) : Bool
  {
    if ( this == scene || 
         worldBound == null || 
         scene == null ||
         !isCollidable(requiredOnBits) ||
         !scene.isCollidable(requiredOnBits)
         )
    {
      return false;  // No Collision with "self"
    }

    // check if the worldBounds intersect
    if (worldBound.intersects(scene.worldBound)) 
    {
      if (Std.is(scene, Node))
      {
        var parent : Node = cast scene;

        var parentChildren = parent.children;

        for(child in parentChildren)
        {
          if (hasCollision(child, pixelPerfect, requiredOnBits))
          {
            return true;
          }
        }

        return false;
      }
      
      if (!pixelPerfect) 
      {
        return true;
      }

      return hasPixelPerfectCollision(cast scene);
    }

    return false;    
  }

  private static var tmpRect1        : Rect                 = new Rect();  
  private static var tmpRectClear    : flash.geom.Rectangle = new flash.geom.Rectangle();
  private static var tmpCameraMatrix : Matrix3f             = new Matrix3f();

  private static var srcBitmapData   : BitmapData = new flash.display.BitmapData(80, 80, true, 0x00000000);
  private static var dstBitmapData   : BitmapData = new flash.display.BitmapData(80, 80, true, 0x00000000);

  // performs pixel perfect collision between two Sentry spatials
  private function hasPixelPerfectCollision(spatialSentry : Sentry) : Bool
  {
    var colTestResult : Bool = false;
    
    var worldBoundRect1 : BoundingRect = cast worldBound;
    var worldBoundRect2 : BoundingRect = cast spatialSentry.worldBound;

    // obtain the intersection rectangle
    tmpRect1 = worldBoundRect1.intersection(worldBoundRect2, tmpRect1);

    // if empty, no collision occured
    if (Std.int(tmpRect1.width) == 0 || Std.int(tmpRect1.height) == 0)
    {
      return false;
    }

    // TODO: avoid creating BitmapData for each collision. ideas:
    // * create bitmapdata with standard size and resize when necessary; clear them before each test

    // create bitmapdata and fill it
    var srcWidth  : Int = Std.int(tmpRect1.width);
    var srcHeight : Int = Std.int(tmpRect1.height);

    // check if it's resize is required
    if (srcWidth > srcBitmapData.width || srcHeight > srcBitmapData.height)
    {
      srcBitmapData.dispose();
      srcBitmapData = new flash.display.BitmapData(srcWidth, srcHeight, true, 0x00000000);

      trace("collision resize (src): " + srcWidth + "x" + srcHeight);
    }
    else
    {
      // clear
      tmpRectClear.x      = 0;
      tmpRectClear.y      = 0;
      tmpRectClear.width  = srcBitmapData.width;
      tmpRectClear.height = srcBitmapData.height;

      srcBitmapData.fillRect(tmpRectClear, 0x00000000);
    }

    tmpCameraMatrix.loadIdentity();
    tmpCameraMatrix.setTranslationComp(-tmpRect1.x, -tmpRect1.y);

    this.drawAFrame(srcBitmapData, currentAnim, currentAFrame, tmpCameraMatrix);


    //var m1 = this.transform.matrix.clone();
    //m1.translate(-result.x, -result.y);
    //srcBitmapData.draw(this, m1);
    var dstWidth  : Int = Std.int(tmpRect1.width);
    var dstHeight : Int = Std.int(tmpRect1.height);

    if (dstWidth > dstBitmapData.width || dstHeight > dstBitmapData.height)
    {
      dstBitmapData.dispose();
      dstBitmapData = new flash.display.BitmapData(dstWidth, dstHeight, true, 0x00000000);

      trace("collision resize (dst): " + srcWidth + "x" + srcHeight);
    }
    else
    {
      // clear
      tmpRectClear.x      = 0;
      tmpRectClear.y      = 0;
      tmpRectClear.width  = dstBitmapData.width;
      tmpRectClear.height = dstBitmapData.height;

      dstBitmapData.fillRect(tmpRectClear, 0x00000000);
    }

    spatialSentry.drawAFrame(dstBitmapData, spatialSentry.currentAnim, spatialSentry.currentAFrame, tmpCameraMatrix);

    
    //var m2 = obj.transform.matrix.clone();
    //m2.translate(-result.x, -result.y);
    //dstBitmapData.draw(obj, m2);
   
    /*
    //trace("coltest: " + result.toString());
    //trace(m1.toString());

    //dstBitmapData.fillRect(new flash.geom.Rectangle(0, 0, result.width, result.height), 0xFF00FF00);

    // test: visually test the intersection area
    //theMission.colTestBmp1.bitmapData = dstBitmapData;
    //theMission.colTestBmp2.bitmapData = srcBitmapData;
    */

    cachedFlashPoint.x = 0;
    cachedFlashPoint.y = 0;

    if (srcBitmapData.hitTest(cachedFlashPoint, 0xFE, dstBitmapData, cachedFlashPoint, 0xFE))
    {
      //trace("pixel perfect collision detected");

      colTestResult = true;
    }

    // make some cleanup
    //srcBitmapData.dispose();
    //dstBitmapData.dispose();

    return colTestResult;
  }

  private static var pickV1 : Vector2f = new Vector2f();
  private static var pickV2 : Vector2f = new Vector2f();

  public override function pickComp(x : Float, y : Float, ?requiredOnBits : Int = 1) : Bool
  {
    pickV1.x = x;
    pickV1.y = y;

    if (!worldBound.contains(pickV1) && currentAnim == 27)
    {
      trace("pick -> quick check out: " + worldBound.toString() + ", point: " + pickV1.toString());
    }
      
    if (  
         worldBound == null || 
         !isPickable(requiredOnBits) ||
         !worldBound.contains(pickV1)
        )
    {
      return false;
    }

    // pixel perfect picking
    var animTmpl   : SentryAnimTemplate   = template.anims[currentAnim];
    var aframeTmpl : SentryAFrameTemplate = animTmpl.aFrames[currentAFrame];

    var aFrameMatrix : Matrix3f = aframeTmpl.cachedMatrix;//aframeTmpl.GetMatrix();

    //trace("SentryAFrame::Init");
    var tempFrames = template.frames[aframeTmpl.frameIndex];

    if (tempFrames == null)
    {
      return false;
    }

    if (template.frames[aframeTmpl.frameIndex].fModules == null)
    {
      return false;
    }

    worldToLocal(pickV1, pickV1);
    //this.getWorldToLocalMatrix(cachedLWMatrix);

    trace("pickV1: " + pickV1.toString());

    for(fModule in template.frames[aframeTmpl.frameIndex].fModules)
    {
      var fModuleMatrix : Matrix3f = fModule.cachedMatrix;//fModule.GetMatrix();

      var moduleTmpl = template.modules[fModule.moduleIndex];

      // prepare the matrix
      moduleMatrix.loadIdentity();
      moduleMatrix.copy(fModuleMatrix);
      moduleMatrix.multLocal(aFrameMatrix);

      moduleMatrix.invertLocal();

      moduleMatrix.multVector2(pickV1, pickV2);

      trace(pickV2.toString() + "/" + moduleTmpl.bitmapData.width + ", " + moduleTmpl.bitmapData.height);

      if (pickV2.x < 0 || 
          pickV2.x >= moduleTmpl.bitmapData.width ||
          pickV2.y < 0 ||
          pickV2.y >= moduleTmpl.bitmapData.height)
      {
        continue;
      }

      // this only works in flash, since the result is premultiplied (if alpha is 0, RGB is 0 too)
      /*
      var pixelColor = moduleTmpl.bitmapData.getPixel32(Std.int(pickV2.x), Std.int(pickV2.y));
      //trace("pixelColor: " + pixelColor);      
      
      //var alphaComp = (pixelColor >> 24) & 0xFF;
      //trace("alphaComp: " + alphaComp);
      
      // check if the pixel is not fully transparent and if so, we've found pick
      if (pixelColor > 0)
      {
        return true;
      }
      */
      
      var pixel = moduleTmpl.bitmapData.getPixel32(Std.int(pickV2.x), Std.int(pickV2.y));
      
      if ((pixel >> 24) & 0xFF > 0) 
      {
        return true;        
      }
    }

    return false;
  }
}