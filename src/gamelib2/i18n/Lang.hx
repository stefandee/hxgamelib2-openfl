package gamelib2.i18n;

class Lang
{
  // TODO: modify to take into account a language
  public static function sepColon(langTag : String) : String
  {
    switch(langTag.toLowerCase())
    {
      case "fr-FR":
        return " : ";      

      case "cn":
        return "：";

      default:
        return ": ";
    }
    
    return ": ";
  }

  // TODO: modify to take into account a language
  public static function sepComma(langTag : String) : String
  {
    switch(langTag.toLowerCase())
    {
      case "ja-JP":
        return "、";

      case "cn":
        return "、";

      default:
        return ", ";
    }
    
    return ", ";
  }

  // TODO: modify to take into account a language
  public static function sepSemiColon(langTag : String) : String
  {
    switch(langTag.toLowerCase())
    {
      case "fr-FR":
        return " ; ";

      case "cn":
        return "；";

      default:
        return "; ";
    }
    
    return "; ";
  }

  // interword spacing; JP and CN don't usually use interword spacing
  // TODO: add more languages;
  public static function sepWordSpacing(langTag : String) : String
  {
    switch(langTag.toLowerCase())
    {
      case "ja-JP":
        return "";

      case "cn":
        return "";

      default:
        return " ";
    }
    
    return " ";
  }
}

