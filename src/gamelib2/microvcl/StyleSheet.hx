package gamelib2.microvcl;
import haxe.ds.StringMap;

/**
 * Emulation of the as3 StyleSheet class
 * 
 * @author Piron Games
 */
class StyleSheet 
{
  private var styles : StringMap<Dynamic>;
  
    public function new() 
    {
      this.clear();
    }    
    
    public function clear(): Void
    {
        this.styles = new StringMap();      
    }
    
    public function setStyle(styleName: String, styleObject: Dynamic) : Void
    {
      if (styleName != null && styleObject != null)
      {
        this.styles.set(styleName, styleObject);
      }
    }
    
    public function getStyle(styleName: String) : Dynamic
    {
      return this.styles.get(styleName);
    }
}