package gamelib2.microvcl;

import flash.display.Sprite;
import flash.display.Graphics;
import flash.text.TextField;
import flash.text.TextFieldType;
import flash.text.TextFieldAutoSize;

class Helper
{
  public static function createBox(width : Int, height : Int, color : Int, borderColor : Int, ?borderThickness : Float = 1.0, ?alpha : Float = 1.0) : Sprite
  {
    var tmp = new Sprite();

    tmp.graphics.lineStyle(borderThickness, borderColor);
    tmp.graphics.beginFill(color, alpha);
    tmp.graphics.drawRect(0, 0, width, height);
    tmp.graphics.endFill();

    return tmp;
  }

  public static function drawBox(g : Graphics, x : Int, y : Int, width : Int, height : Int, color : Int, borderColor : Int, ?borderThickness : Float = 1.0, ?alpha : Float = 1.0) : Void
  {
    g.lineStyle(borderThickness, borderColor);
    g.beginFill(color, alpha);
    g.drawRect(x, y, width, height);
    g.endFill();
  }

  public static function createTextField(text : String, embedFonts : Bool, type : TextFieldType, antiAliasType : flash.text.AntiAliasType, textColor : Int, autoSize : TextFieldAutoSize, selectable : Bool) : TextField
  {
    var tf = new TextField();

    tf.text       = text;
    tf.embedFonts = embedFonts;
    tf.type       = type;
    tf.textColor  = textColor;
    tf.autoSize   = autoSize;
    tf.selectable = selectable;

    return tf;
  }

  public static function drawGradientWBox(g : Graphics, boxX : Int, boxY : Int, w : Int, h : Int, colors : Array<UInt>, alphas : Array<Float>, ?reverse : Bool = false, ?direction : Bool = false)
  {
    if (colors.length != alphas.length)
    {
      trace("Warning: colors.length != alphas.length");
    }

    var ratios : Array<Int> = new Array();
    
    for(i in 0...colors.length)
    {
      var ratio : Float = i / (colors.length - 1);
      
      ratios.push(Std.int(0xFF * ratio));
    }

    var matrix = new flash.geom.Matrix();

    matrix.identity();
		
		if (direction)
    {
      matrix.createGradientBox(w, h, reverse ? (-Math.PI / 2) : (Math.PI / 2), 0, 0);
    }
    else
    {
      matrix.createGradientBox(w, h, reverse ? Math.PI : 0.0, 0, 0);
    }
		
    g.clear();
    g.lineStyle(1, 0x000000, 0);
    g.beginGradientFill(flash.display.GradientType.LINEAR, colors, alphas, ratios, matrix);
    g.drawRect(boxX, boxY, w + boxX, h + boxY);
    g.endFill();
  }

  public static function createGradientWBox(boxX : Int, boxY : Int, w : Int, h : Int, colors : Array<UInt>, alphas : Array<Float>, ?reverse : Bool = false, ?direction : Bool = false) : Sprite
  {
    var box = new Sprite();

    drawGradientWBox(box.graphics, boxX, boxY, w, h, colors, alphas, reverse, direction);

    return box;
  }
}