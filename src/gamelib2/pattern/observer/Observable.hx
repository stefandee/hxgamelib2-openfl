package gamelib2.pattern.observer;

class ObserverNode
{
  public var mask     (default, default) : Int;
	public var observer (default, null)    : IObserver;

  public function new(observer : IObserver, mask : Int)
  {
    this.observer = observer;
    this.mask     = mask;
  }
}

class Observable implements IObservable
{
	// TODO: make a HashInt<Array<ObserverNode>> to speed lookups during updates
  public var observers (default, null) : Array<ObserverNode>;

  public function new()
  {
    observers = new Array();
  }

  public function contains(o : IObserver) : Bool
  {
    return (getNode(o) != null);
  }
  
  public function attach(o : IObserver, ?mask : Int = 0) : Void
  {
    var node = getNode(o);
    
    if (node == null)
    {
      var node = new ObserverNode(o, mask);

      observers.push(node);
    }
    else
    {
      node.mask |= mask;
    }
  }

	public function detach(o : IObserver) : Void
  {
    var node = getNode(o);

    if (node != null)
    {
      observers.remove(node);
    }
    else
    {
      trace("Observer could not be found in the list.");
    }
  }

	public function notify(type : Int, userData : Dynamic) : Void
  {
    for(node in observers)
    {
      if ((node.mask & type) != 0 && node.observer != null)
      {
        node.observer.update(type, this, userData);
      }
    }
  }

  public function clear()
  {
    // :)
    observers = new Array();
  }

  private function getNode(o : IObserver) : ObserverNode
  {
    for(node in observers)
    {
      if (o == node.observer)
      {
        return node;
      }
    }

    return null;
  }
}
