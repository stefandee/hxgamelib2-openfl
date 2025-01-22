package gamelib2.microvcl;

import gamelib2.microvcl.Button;
import gamelib2.microvcl.Control;
import gamelib2.i18n.Manager;
import openfl.events.Event;

class Form extends Control
{
  @:isVar public var modalResult (get, set) : ModalResult;

  public function new(parentControl : Control, name : String, displayTactics : DisplayTactics, autoAdd : Bool, strMgr : Manager)
  {
    super(parentControl, name, displayTactics, autoAdd, strMgr);

    modalResult = ModalResult_None;
    
    // trace(name);
    // this.stage.addEventListener (Event.RESIZE, stage_onResize);      
  }

	private function stage_onResize (event:Event):Void {
		trace("Form::stage_onResize");
  }
  
  //
  // Members
  //
  private function get_modalResult() : ModalResult
  {
    return modalResult;
  }

  private function set_modalResult(v : ModalResult) : ModalResult
  {
    modalResult = v;

    return modalResult;
  }

  //
  // Methods
  //
  public function showModal()
  {
  }

  // for convenience only :)
  public function show()
  {
    visible = true;
  }

  public function hide()
  {
    visible = false;
  }
  
	public function resize (newWidth:Int, newHeight:Int):Void 
  {
		//scaleX = 1;
		//scaleY = 1;
  
    trace("Form::resize with " + newWidth + ", " + newHeight + " from " + this.width + ", " + this.height);
    
		/*
		var maxWidth = newWidth * 0.90;
		var maxHeight = newHeight * 0.86;
		
		var currentScale: Float = 1.0;
		scaleX = 1;
		scaleY = 1;
		
		var currentWidth = width;
		var currentHeight = height;
    
		if (currentWidth > maxWidth || currentHeight > maxHeight) {
			
			var maxScaleX = maxWidth / currentWidth;
			var maxScaleY = maxHeight / currentHeight;
			
			if (maxScaleX < maxScaleY) {
				
				currentScale = maxScaleX;
				
			} else {
				
				currentScale = maxScaleY;
				
			}
			
			scaleX = currentScale;
			scaleY = currentScale;

      trace("Form::resize final scale is now: " + currentScale);			
		}
		
		x = newWidth / 2 - (currentWidth * currentScale) / 2;
		*/
  }  
}