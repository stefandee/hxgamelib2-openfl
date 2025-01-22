package gamelib2.i18n;

// flash
import flash.utils.ByteArray;

// app
import gamelib2.data.DataLibX;

class Manager
{
  public static var DEFAULT_LANG : String = "en-US";
  
  // a language tag code (BCP 47 format)
  public var lang (default, default) : String;

  public var langCount(get, null) : Int;
  
  private var langUnits : Map<String, LangUnit>;

  // TODO: domain: turn this class into a Domain, then add a Domain Manager in place

  public function new()
  {
    langUnits = new Map();

    lang = DEFAULT_LANG;
  }

  public function init(data : ByteArray)
  {
    trace("initializing the i18n Manager");
    
    trace("bytes: " + data.bytesAvailable + "/" + data.length);

    langUnits = new Map();

    var dataLib = new DataLibX(data, onLangUnitDataRead);

    if (langCount > 0)
    {
      if (langUnits.exists(DEFAULT_LANG))
      {
        lang = DEFAULT_LANG;
      }
      else
      {
        // chose as the default language the first language tag 
        for(key in langUnits.keys())
        {
          lang = key;
          break;
        }
      }
    }
    else
    {
      // no lang units are loaded
      lang = DEFAULT_LANG;
    }

    // TODO: validate the lang units read (should have the same string numbers)
  }

  private function onLangUnitDataRead(data : ByteArray)
  {
    var langUnit = new LangUnit(data);

    trace(langUnit.id);

    langUnits.set(langUnit.id, langUnit);
  }

  public function get(stringIndex : Int) : String
  {
    var langUnit = langUnits.get(lang);

    if (langUnit == null)
    {
      return "<INVALID LANG UNIT!>";
    }

    return langUnit.get(stringIndex);
  }

  private function get_langCount() : Int
  {
    var count : Int = 0;
    
    for(it in langUnits.iterator())
    {
      count++;
    }

    return count;
  }

  // returns a list of the supported language tags
  public function supportedLanguages() : Array<String>
  {
    var tmp : Array<String> = new Array();

    for(key in langUnits.keys())
    {
      tmp.push(key);
    }

    return tmp;
  }

  // langTag in BCP 47 format
  public function isLangSupported(langTag : String) : Bool
  {
    return (langUnits.get(langTag) != null);
  }

  public function displayNativeName(langTag : String) : String
  {
    switch(langTag)
    {
      case "ro-RO":
        return "Româneşte";

      case "sv-SE":
        return "Svenska";

      case "en-US":
        return "English (US)";

      case "en-UK":
        return "English (UK)";
    }

    return "Unknown";
  }
}


