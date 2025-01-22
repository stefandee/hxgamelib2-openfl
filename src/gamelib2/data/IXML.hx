package gamelib2.data;
import haxe.xml.Fast;

interface IXML
{
  public function fromXMLString(xmlString : String) : Void;
  public function toXMLString() : String;  
  public function fromXML(elem : Fast) : Void;
}