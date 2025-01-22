package gamelib2.microvcl;

import gamelib2.i18n.Manager;
import gamelib2.math.MathEx;

enum ComboBoxCharCase
{
  ComboBoxCharCase_Default;
  ComboBoxCharCase_Upper;
  ComboBoxCharCase_Lower;
}

enum ComboBoxType
{
  Fixed;
  Auto;
}

class ComboBoxItem
{
  public var content  : String;
  public var userData : Dynamic;
  
  public function new(content : String, ?userData : Dynamic = null)
  {
    this.content  = content;
    this.userData = userData;
  }
}

class ComboBoxControl extends Control
{
  public var items (default, null)     : Array<ComboBoxItem>;
  public var sorted (default, set)     : Bool;
  public var itemIndex (default, set)  : Int;
  public var charCase (default, set)   : ComboBoxCharCase;

  public var onChangeEvent (default, default) : Dynamic -> Void;
  
  public function new(parentControl : Control, name : String, displayTactics : DisplayTactics, autoAdd : Bool, strMgr : Manager)
  {
    super(parentControl, name, displayTactics, autoAdd, strMgr);

    items         = new Array();
    sorted        = false;
    itemIndex     = 0;
    charCase      = ComboBoxCharCase_Default;

    onChangeEvent = null;
  }

  public function addItem(content : String, ?userData : Dynamic = null)
  {
    if (content != null)
    {
      var item = new ComboBoxItem(content, userData);
      
      if (sorted)
      {
        var index = -1;

        for(i in 0...items.length)
        {
          if (item.content < items[i].content)
          {
            index = i;

            break;
          }
        }

        if (index == -1)
        {
          items.push(item);
        }
        else
        {
          items.insert(index, item);
        }
      }
      else
      {
        trace("item pushed: " + content);
        items.push(item);
      }

      // update the display
      if (displayTactics != null)
      {
        displayTactics.update();
      }
    }
  }

  public function clearItems()
  {
    items = new Array();

    itemIndex = -1;
  }

  public function removeItem(index : Int)
  {
    if (index < 0 || index >= items.length)
    {
      return;
    }
    
    items.splice(index, 1);

    if (items.length == 0)
    {
      itemIndex = -1;
    }
    else if (itemIndex >= items.length)
    {
      itemIndex = items.length - 1;
    }
  }

  public function set_itemIndex(v : Int) : Int
  {
    // TODO: add custom box type (fixed, default, etc) and set the itemindex accordingly
    itemIndex = Std.int(MathEx.fclamp(v, -1, items.length));

    if (displayTactics != null)
    {
      displayTactics.update();
    }

    return itemIndex;
  }

  public function set_charCase(v : ComboBoxCharCase) : ComboBoxCharCase
  {
    charCase = v;

    if (displayTactics != null)
    {
      displayTactics.update();
    }

    return charCase;
  }

  public function set_sorted(v : Bool) : Bool
  {
    if (sorted)
    {
      items.sort(itemsSortCallback);
    }

    if (displayTactics != null)
    {
      displayTactics.update();
    }
    
    return sorted;
  }

  private function itemsSortCallback(a : ComboBoxItem, b : ComboBoxItem)
  {
    if (a.content == b.content)
    {
      return 0;
    }
    else if (a.content > b.content)
    {
      return 1;
    }
    else
    {
      return -1;
    }
  }

  public function searchItem(v : String) : Int
  {
    for(i in 0...items.length)
    {
      if (items[i].content == v)
      {
        //trace("search item " + v + " found at " + i);
        return i;
      }
    }

    //trace("search item " + v + " not found!");
    return -1;
  }
}