package gamelib2.scene;

/**
 * Root class of any scene graph. A root doesn't have a parent (always null).
 */
class Root extends Node
{
  public function new()
  {
    super();

    parent = null;
  }

  private override function set_parent(parent : Node) : Node
  {
    this.parent = null;

    return null;
  }
}