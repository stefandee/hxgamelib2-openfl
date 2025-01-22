package gamelib2.microvcl.leaderboard;

// gamelib2
import gamelib2.microvcl.Form;
import gamelib2.microvcl.Control;
import gamelib2.i18n.Manager;
import gamelib2.microvcl.Button;
import gamelib2.sentry.SentrySprite;
import gamelib2.microvcl.Label;

// as3
import flash.display.Sprite;
import flash.events.Event;

class WaitFx extends Control
{
  public static var DEFAULT_BUBBLE_COUNT            : Int   = 8;
  public static var DEFAULT_BUBBLE_SIZE             : Int   = 2;
  public static var DEFAULT_ALPHA_DECAY             : Float = -0.2;
  public static var DEFAULT_RADIUS                  : Int   = 10;
  public static var DEFAULT_FRAME_TICK              : Int   = 2;
  public static var DEFAULT_BUBBLE_COLOR            : Int   = 0x000000;
  
  private var bubbleCount                           : Int;
  private var bubbleSize                            : Int;
  private var alphaDecay                            : Float;
  private var radius                                : Int;
  private var frameTick                             : Int;
  private var bubbleColor                           : Int;

  private var bubbles                               : Array<Sprite>;
  private var bubbleIndex                           : Int;
  private var frameCount                            : Int;
  
  public function new(parentControl : Control, name : String, displayTactics : DisplayTactics, autoAdd : Bool, strMgr : Manager)
  {
    super(parentControl, name, displayTactics, autoAdd, strMgr);

    bubbleIndex = 0;

    bubbleCount = DEFAULT_BUBBLE_COUNT;
    bubbleSize  = DEFAULT_BUBBLE_SIZE;
    alphaDecay  = DEFAULT_ALPHA_DECAY;
    radius      = DEFAULT_RADIUS;
    frameTick   = DEFAULT_FRAME_TICK;
    bubbleColor = DEFAULT_BUBBLE_COLOR;

    frameCount = 0;
  }

  public override function createUI()
  {
  }

  public override function updateUI()
  {
  }

  private override function onEnterFrame(e : Event)
  {
    if (!enabled)
    {
      return;
    }

    frameCount = (frameCount + 1) % frameTick;

    if (frameCount > 0)
    {
      return;
    }
    
    for(i in 0...bubbleCount)
    {
      if (bubbles[i].alpha > 0)
      {
        bubbles[i].alpha += alphaDecay;

        if (bubbles[i].alpha < 0)
        {
          bubbles[i].alpha = 0;
        }
      }
    }
    
    bubbleIndex = (bubbleIndex + 1) % bubbleCount;
    bubbles[bubbleIndex].alpha = 1.0;
  }

  private function createBubbles()
  {
    if (bubbles != null)
    {
      for(bubble in bubbles)
      {
        removeChild(bubble);
      }
    }

    bubbles = new Array();

    var angle     : Float = 0;
    var angleDiff : Float = 2 * Math.PI / bubbleCount;

    for(i in 0...bubbleCount)
    {
      var bubble = createBubble();

      bubble.x = radius * Math.cos(angle);
      bubble.y = radius * Math.sin(angle);
      bubble.alpha = 0;

      angle += angleDiff;

      addChild(bubble);

      bubbles.push(bubble);
    }
  }

  private function createBubble() : Sprite
  {
    var sprite = new Sprite();
    
    sprite.graphics.lineStyle(0.0, bubbleColor);
    sprite.graphics.beginFill(bubbleColor, 1.0);
    sprite.graphics.drawCircle(0, 0, bubbleSize);
    sprite.graphics.endFill();

    return sprite;
  }

  public function setParam(bubbleCount : Int, bubbleSize : Int, alphaDecay : Float, radius : Int, tick : Int, bubbleColor : Int)
  {
    this.bubbleCount = (bubbleCount > 0) ? bubbleCount : DEFAULT_BUBBLE_COUNT;
    this.bubbleSize  = (bubbleSize > 0) ? bubbleSize : DEFAULT_BUBBLE_SIZE;
    this.alphaDecay  = alphaDecay;
    this.radius      = radius;
    this.frameTick   = (frameTick > 0) ? frameTick : DEFAULT_FRAME_TICK;
    this.bubbleColor = bubbleColor;

    createBubbles();
  }
}
