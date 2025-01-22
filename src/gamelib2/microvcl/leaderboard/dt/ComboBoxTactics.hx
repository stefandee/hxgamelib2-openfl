package gamelib2.microvcl.leaderboard.dt;

import gamelib2.microvcl.ButtonControl;
import gamelib2.microvcl.Label;
import gamelib2.microvcl.DisplayTactics;
import gamelib2.microvcl.ComboBoxControl;
import gamelib2.microvcl.leaderboard.dt.ArrowButtonTactics;

class ComboBoxTactics extends DisplayTactics
{
  private var prevBtn   : ButtonControl;
  private var nextBtn   : ButtonControl;
  private var labelItem : Label;

  public var fixedWidth : Int;
  public var type       : ComboBoxType;

  public function new(type : ComboBoxType, ?fixedWidth : Int = 200)
  {
    this.type       = type;
    this.fixedWidth = fixedWidth;

    super();
  }

  public override function init()
  {
    labelItem = new Label(
      target, 
      "ItemLabel", 
      new GenericLabelTactics(flash.text.TextFieldAutoSize.LEFT, flash.text.TextFormatAlign.LEFT),
      true,
      target.strMgr
      );

    labelItem.caption = "<body>" + "<span class='comboBoxItem'>" + "no items" + "</span>" + "</body>";

    prevBtn = new ButtonControl(target, "BtnPrev", new ArrowButtonTactics(13, 16, ArrowOrientation.Left,  0x808080, 0x000000), true, target.strMgr);
    nextBtn = new ButtonControl(target, "BtnNext", new ArrowButtonTactics(13, 16, ArrowOrientation.Right, 0x808080, 0x000000), true, target.strMgr);

    prevBtn.onClickEvent = onChangePrev;
    nextBtn.onClickEvent = onChangeNext;

    prevBtn.visible   = false;
    nextBtn.visible   = false;

    labelItem.x = 0;
    labelItem.y = 0;
  }

  public override function update()
  {
    if (target == null)
    {
      return;
    }
    
    var tempParent : ComboBoxControl = cast target;

    if (tempParent.items == null)
    {
      return;
    }
    
    if (tempParent.items.length > 0 && tempParent.itemIndex >= 0 && tempParent.itemIndex < tempParent.items.length)
    {
      labelItem.caption = "<body>" + "<span class='comboBoxItem'>" + tempParent.items[tempParent.itemIndex].content + "</span>" + "</body>";

      trace(labelItem.caption);
    }
    else
    {
      labelItem.caption = "no items";
    }

    if (tempParent.items.length > 1)
    {
      prevBtn.visible   = true;
      nextBtn.visible   = true;
    }
    else
    {
      prevBtn.visible   = false;
      nextBtn.visible   = false;
    }

    // align the buttons
    // var bounds = labelItem.getBounds(target);

    switch(type)
    {
      case ComboBoxType.Auto:
      {
        prevBtn.x = -prevBtn.width - 5;
        prevBtn.y = labelItem.height / 2 - prevBtn.height / 2;

        nextBtn.x = labelItem.width + 5;
        nextBtn.y = labelItem.height / 2 - nextBtn.height / 2;

        labelItem.x = 0;
        labelItem.y = 0;
      }

      case ComboBoxType.Fixed:
      {
        prevBtn.x = 0;
        prevBtn.y = labelItem.height / 2 - prevBtn.height / 2;

        labelItem.x = Std.int(fixedWidth / 2 - labelItem.width / 2);
        labelItem.y = 0;

        nextBtn.x = fixedWidth - nextBtn.width;
        nextBtn.y = labelItem.height / 2 - nextBtn.height / 2;        
      }
    }

    //trace(prevBtn.x + " " + nextBtn.x + " " + labelItem.width);
  }

  private function onChangeNext(e : flash.events.Event)
  {
    trace("changed!");
    
    if (target == null)
    {
      return;
    }

    var tempParent : ComboBoxControl = cast target;

    var tempIndex = tempParent.itemIndex;

    tempIndex++;

    if (tempIndex >= tempParent.items.length)
    {
      tempIndex = 0;
    }

    tempParent.itemIndex = tempIndex;

    if (tempParent.onChangeEvent != null)
    {
      tempParent.onChangeEvent(e);
    }
  }

  private function onChangePrev(e : flash.events.Event)
  {
    trace("changed!");
    
    if (target == null)
    {
      return;
    }

    var tempParent : ComboBoxControl = cast target;

    var tempIndex = tempParent.itemIndex;

    tempIndex--;

    if (tempIndex < 0)
    {
      tempIndex = tempParent.items.length - 1;
    }

    tempParent.itemIndex = tempIndex;

    if (tempParent.onChangeEvent != null)
    {
      tempParent.onChangeEvent(e);
    }
  }
}