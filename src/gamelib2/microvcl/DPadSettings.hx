package gamelib2.microvcl;

enum DPadState
{
  On;
  Off;
  Auto;
}

class DPadSettings
{
  public var state : DPadState;
  
  public function new()
  {
    state = DPadState.Auto;
  }
  
  public function next() : DPadState
  {
    switch(state)
    {
      case DPadState.Auto:
          state = DPadState.On;
          
      case DPadState.On:
          state = DPadState.Off;
          
      case DPadState.Off:
          state = DPadState.Auto;
    }
    
    return state;
  }
  
  public function toString(): String
  {
    return state.getName();
  }
  
  public function fromString(name: String): Void
  {
    this.state = DPadState.createByName(name);
  }
}