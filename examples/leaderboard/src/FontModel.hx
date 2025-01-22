#if (js)
import openfl.Assets;
#else
import openfl.text.Font;

@:font("assets/fonts/emulator.ttf")
class FontDefault extends Font {}

@:font("assets/fonts/ProggyClean.ttf")
class FontGeneric1 extends Font {}

@:font("assets/fonts/RationalInteger.ttf")
class FontGeneric2 extends Font {}

#end

/**
 * ...
 * @author Piron Games
 */
class FontModel 
{
  public static var FontDefaultName   : String = "";
  public static var FontGeneric1Name  : String = "";
  public static var FontGeneric2Name  : String = "";
	  
	public static function init(): Void
	{
#if js
    FontDefaultName = Assets.getFont("fonts/emulator.ttf").fontName;
    FontGeneric1Name = Assets.getFont("fonts/ProggyClean.ttf").fontName;
    FontGeneric2Name = Assets.getFont("fonts/RationalInteger.ttf").fontName;
#else
    Font.registerFont(FontDefault);
    Font.registerFont(FontGeneric1);
    Font.registerFont(FontGeneric2);
	
    FontDefaultName = (new FontDefault()).fontName;
    FontGeneric1Name = (new FontGeneric1()).fontName;
    FontGeneric2Name = (new FontGeneric2()).fontName;
#end
	}	

    public function new() 
    {        
    }
    
}