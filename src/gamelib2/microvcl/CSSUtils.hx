package gamelib2.microvcl;

/**
 * CSS related utils
 * 
 * @author Piron Games
 */
class CSSUtils 
{
  /**
   * Very simple regexp to replace some common html tags (<span>, <h1>, <body>) with <font> tag,
   * to retain some functionality of using css in html text fields.
   * 
   * Consider using a proper library to parse html DOM and replace in the resulted tree
   * 
   * @param msg html string
   * @param styleSheet
   * @return a html string with the above tags replaced with font tag
   */
  public static function translate(msg : String, styleSheet : StyleSheet) : String
  {
    //trace("translateCSS (original) " + msg);
    
    var result : String;
    
    var bodyRegEx = new EReg("^<body>(.*)</body>$", "gm");
    
    if (bodyRegEx.match(msg))
    {
      result = bodyRegEx.matched(1);
    }
    else
    {
      result = msg;
    }
    
    // (.*?) - non-greedy matching for class with ''
    var spanRegEx = new EReg("<span class='([a-zA-Z0-9_]*?)'>(.*?)</span>", "gm");
    
    result = spanRegEx.map(result, function(r) {
        var style1 = styleSheet.getStyle("." + r.matched(1));
        
        if (style1 != null)
        {
          return "<font " + fontTagParamsFromStyle(style1) + ">" + r.matched(2) + "</font>";
        }
        
        return "0xDEADBEEF";
    });    

    // (.*?) - non-greedy matching for class with ""
    var spanRegEx = new EReg("<span class=\"([a-zA-Z0-9_]*?)\">(.*?)</span>", "gm");
    
    result = spanRegEx.map(result, function(r) {
        var style1 = styleSheet.getStyle("." + r.matched(1));
        
        if (style1 != null)
        {
          return "<font " + fontTagParamsFromStyle(style1) + ">" + r.matched(2) + "</font>";
        }
        
        return "0xDEADBEEF";
    });    
    
    var h1RegEx = new EReg("<h1>(.*?)</h1>", "gm");
    
    result = h1RegEx.map(result, function(r) {
        var style = styleSheet.getStyle("h1");
        
        if (style != null)
        {
          return "<font " + fontTagParamsFromStyle(style) + ">" + r.matched(1) + "</font><br>";
        }
        
        return "0xDEADBEEF";
    });    
            
    var body : Dynamic = styleSheet.getStyle("body");
    
    if (body != null)
    {
      result = "<font " + fontTagParamsFromStyle(body) + ">" + result + "</font>";
    }
    
    //trace("translateCSS " + result);
    
    return result;
  }
  
  private static function fontTagParamsFromStyle(style : Dynamic) : String
  {
    var result : String = "";
    
    if (style.fontFamily != null)
    {
      result += "face='" + style.fontFamily + "' ";
    }
    
    if (style.color != null)
    {
      result += "color='" + style.color + "' ";
    }
    
    if (style.fontSize != null)
    {
      result += "size='" + style.fontSize + "' ";
    }
    
    //trace("fontTagParamsFromStyle " + result);
    
    return result;
  }    
    
}