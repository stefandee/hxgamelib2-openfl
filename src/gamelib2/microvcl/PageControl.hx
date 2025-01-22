package gamelib2.microvcl;

import gamelib2.microvcl.Control;
import gamelib2.microvcl.PageSheet;
import gamelib2.i18n.Manager;
import gamelib2.i18n.Lang;

class PageControl extends Control
{
  @:isVar public var activePage(default, set)   : PageSheet;
  public var pages(default, null)               : Array<PageSheet>;
  public var pageCount(get, null)               : Int;
  //public var onChangeActivePage                 : Dynamic -> Void;

  public function new(parentControl : Control, controlName : String, displayTactics : PageControlTactics, autoAdd : Bool, strMgr : Manager)
  {
    super(parentControl, name, displayTactics, autoAdd, strMgr);

    //onChangeActivePage = null;
    pages      = new Array();
    activePage = null;
  }

  public function addPage(page : PageSheet)
  {
    page.index = pages.length;

    pages.push(page);

    if (!contains(page))
    {
      this.addChild(page);
    }

    if (displayTactics != null)
    {
      var temp : PageControlTactics = cast displayTactics;

      temp.notifyAddPage(page);
    }

    if (pages.length == 1)
    {
      activePage = page;

      page.visible = true;
      page.enabled = true;
    }
    else
    {
      page.visible = false;
      page.enabled = false;
    }
  }

  private function get_pageCount() : Int
  {
    if (pages != null)
    {
      return pages.length;
    }

    return 0;
  }

  public function getPageIndex(page : PageSheet) : Int
  {
    for(i in 0...pages.length)
    {
      if (page == pages[i])
      {
        return i;
      }
    }

    return -1;
  }

  private function set_activePage(page : PageSheet) : PageSheet
  {
    if (page == activePage)
    {
      return activePage;
    }

    for(temp in pages)
    {
      if (temp == page)
      {
        if (activePage != null)
        {
          activePage.visible = false;
          activePage.enabled = false;
        }
        
        activePage = page;

        activePage.visible = true;
        activePage.enabled = true;

        if (displayTactics != null)
        {
          var tempTactics : PageControlTactics = cast displayTactics;

          tempTactics.notifyActivePage(page);
          break;
        }
      }
    }

    return activePage;
  }
}