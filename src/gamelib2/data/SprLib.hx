package gamelib2.data;

// app
import gamelib2.sentry.SentrySpriteTemplate;
import gamelib2.sentry.SentrySprite;
import gamelib2.scene.Sentry;
//import gamelib2.sentry.SentrySpriteBuffer;

import flash.utils.ByteArray;

class SprLib extends DataLib
{  
  private var sprites : Map<Int, SentrySpriteTemplate>;

  public function new(data : ByteArray)
  {
    sprites = new Map();

    super(data);
  }

  private override function readEntry(index : Int, data : ByteArray)
  {
    sprites.set(index, getSpriteTemplate(data));
  }

  private function getSpriteTemplate(sprData : ByteArray) : SentrySpriteTemplate
  {
    var spriteTmpl = new SentrySpriteTemplate();
    
    spriteTmpl.Init(sprData);

    return spriteTmpl;
  }

  public function getTemplate(id : Int) : SentrySpriteTemplate
  {
    return sprites.get(id);
  }

  public function getSprite(id : Int) : SentrySprite
  {
    return new SentrySprite(sprites.get(id));
  }

  public function getSpriteSpatial(id : Int, ?anim : Int = 0, ?name : String = "SentrySpatial") : Sentry
  {
    var template = sprites.get(id);
    
    if (template != null)
    {
      var sentry = new Sentry(template);

      sentry.currentAnim = anim;
      sentry.name = name;
      
      return sentry;
    }

    return null;
  }
}