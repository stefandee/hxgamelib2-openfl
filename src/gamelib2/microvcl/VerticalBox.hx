package ui;
import flash.display.Sprite;
import flash.display.Shape;
import flash.text.TextFormatAlign;
import openfl.display.DisplayObjectContainer;
import openfl.display.DisplayObject;

/**
 * ...
 * @author Piron Games
 */
class VerticalBox extends DisplayObjectContainer
{
    private var scaler: Shape;

    @:isVar public var spacing(default, set): Int;
    
    private var horizontalAlign: TextFormatAlign;

    public function new(scalerWidth: Int, scalerHeight: Int, horizontalAlign: TextFormatAlign = TextFormatAlign.CENTER)
    {
        super();

        this.horizontalAlign = horizontalAlign;
        
        scaler = new Shape();
        this.addChild(scaler);
        this.setScalerSize(scalerWidth, scalerHeight);
    }

    override public function addChild (child:DisplayObject):DisplayObject
    {
        var x = super.addChild (child);
        arrange();

        return x;
    }

    override public function addChildAt (child:DisplayObject, index:Int):DisplayObject
    {
        var x = super.addChildAt (child, numChildren);
        arrange();
        return x;
    }

    override public function removeChild (child:DisplayObject):DisplayObject
    {
        var x = super.removeChild(child);
        arrange();
        return x;
    }

    override public function removeChildAt (index:Int):DisplayObject
    {
        var x = super.removeChildAt(index);
        arrange();
        return x;
    }

    override public function removeChildren (beginIndex:Int = 0, endIndex:Int = 0x7FFFFFFF):Void
    {
        super.removeChildren(beginIndex, endIndex);
        arrange();
    }

    public function setScalerSize(width: Int, height: Int): Void
    {
        this.scaler.graphics.clear();
        this.scaler.graphics.beginFill(0x000000, 0.0);
        this.scaler.graphics.drawRect(0, 0, width, height);
        this.scaler.graphics.endFill();
    }

    public function set_spacing(value: Int): Int
    {
        if (this.spacing != value)
        {
            this.spacing = value;
            arrange();
        }

        return this.spacing;
    }

    private function arrange():Void
    {
        // force the scaler to the beginning of the display list
        if (!this.contains(this.scaler))
        {
            this.addChildAt(this.scaler, 0);
        }
        else
        {
            this.setChildIndex(this.scaler, 0);
        }

        var childNo: Int = this.numChildren;

        var currentY : Float = 0;

        for (i in 1...childNo)
        {
            var child = this.getChildAt(i);

            switch(this.horizontalAlign)
            {
              case TextFormatAlign.CENTER:
                child.x = Std.int((this.scaler.width - child.width) / 2);
                
              case TextFormatAlign.RIGHT:
                child.x = this.scaler.width - child.width;
                
              default:
                child.x = 0;                  
            }
            
            child.y = currentY;

            trace(this.scaler.width, child.x, child.y);

            currentY += child.height;
        }
    }

}