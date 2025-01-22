package gamelib2.scene;

import gamelib2.math.MathEx;

//import haxe.FastList;
import gamelib2.renderer.Renderer;
import gamelib2.intersection.CollisionResults;
import gamelib2.bounding.BoundingArea;

class Node extends Spatial
{
  /** This node's children. */
  @:isVar public var children (get, null): List<Spatial>;

  public function new()
  {
    super();

    children = new List<Spatial>();

    setCollisionMask(-1, false);
  }

  /**
   * 
   * <code>getQuantity</code> returns the number of children this node
   * maintains.
   * 
   * @return the number of children this node maintains.
   */
  public function childrenCount() : Int
  {
    if (children == null) 
    {
      return 0;
    } 

    var count : Int = 0;
        
    //return children.length;
    return gamelib2.Utils.count(children);
  }

	/**
	 * Returns all children to this node.
	 *
	 * @return a list containing all children to this node
	 */
  public function get_children() : List<Spatial>
  {
    return children;
  }

  /**
   * Sets the zOrder of this Spatial and, if setOnChildren is true, all
   * children as well. This value is used in conjunction with the RenderQueue
   * and QUEUE_ORTHO for determining draw order.
   * 
   * @param zOrder
   *            the new zOrder.
   * @param setOnChildren
   *            if true, children will also have their zOrder set to the given
   *            value.
   */
  public override function setZOrder(zOrder : Int, setOnChildren : Bool) : Void 
  {
    super.setZOrder(zOrder, setOnChildren);

    if (setOnChildren) 
    {
      if (children != null) 
      {
        for(child in children.iterator())
        {
          child.setZOrder(zOrder, true);
        }
      }
    }
  }

  /**
   * 
   * <code>attachChild</code> attaches a child to this node. This node
   * becomes the child's parent. The current number of children maintained is
   * returned.
   * <br>
   * If the child already had a parent it is detached from that former parent.
   * 
   * @param child
   *            the child to attach to this node.
   * @return the number of children maintained by this node.
   */
  public function attachChild(child : Spatial) : Int
  {
      if (child != null) 
      {
        if (child.parent != this) 
        {
          if (child.parent != null) 
          {
            child.parent.detachChild(child);
          }

          child.parent = this;

          if (children == null) 
          {
            children = new List<Spatial>();
          }

          children.add(child);

          //trace(gamelib2.Sprintf.format("Child %s attached to this node %s", [child.name, this.name]));
        }
      }
      
      if (children == null) return 0;

      return childrenCount();
  }
    
    /**
     * 
     * <code>attachChildAt</code> attaches a child to this node at an index. This node
     * becomes the child's parent. The current number of children maintained is
     * returned.
     * <br>
     * If the child already had a parent it is detached from that former parent.
     * 
     * @param child
     *            the child to attach to this node.
     * @return the number of children maintained by this node.
     */
     /*
    public int attachChildAt(Spatial child, int index) {
        if (child != null) {
            if (child.getParent() != this) {
                if (child.getParent() != null) {
                    child.getParent().detachChild(child);
                }
                child.setParent(this);
                if(children == null) {
                    children = Collections.synchronizedList(new ArrayList<Spatial>(1));  
                }
                children.add(index, child);
                logger.log(Level.FINE,
                        "Child \"{0}\" attached to this node \"{1}\"", 
                        new String[] {child.getName(), getName()});
            }
        }

        if (children == null) return 0;
        return children.size();
    }
    */

  /**
   * <code>detachChild</code> removes a given child from the node's list.
   * This child will no longer be maintained.
   * 
   * @param child
   *            the child to remove.
   * @return the index the child was at. -1 if the child was not in the list.
   */
  public function detachChild(child : Spatial) : Int
  {
    if(children == null) 
    {
        return -1;
    }

    if (child == null)
        return -1;

    if (child.parent == this) 
    {
      var index = getChildIndex(child);
      
      if (index != -1) 
      {
        detachChildAt(index);
      }

      return index;
    } 
        
    return -1;        
  }

  /**
   * <code>indexOfChild</code> returns the index of the child.
   * 
   * 
   * @param child
   *            the child to find the index for
   * @return the index the child was at. -1 if the child was not in the list.
   */
  public function getChildIndex(child : Spatial) : Int
  {
    if (children == null)
    {
      return -1;
    }

    var index : Int = 0;

    for(c in children.iterator())
    {
      if (c == child)
      {
        return index;
      }

      index++;
    }

    return -1;
  }

  /**
   * <code>detachChild</code> removes a given child from the node's list.
   * This child will no longer be maintained. Only the first child with a
   * matching name is removed.
   * 
   * @param childName
   *            the child to remove.
   * @return the index the child was at. -1 if the child was not in the list.
   */
  public function detachChildNamed(childName : String) : Int
  {
    if (children == null || childName == null) 
    {
      return -1;
    }

    var index : Int = 0;
    
    for (child in children.iterator()) 
    {
      if (childName == child.name) 
      {
        detachChildAt( index );

        return index;
      }

      index++;
    }

    return -1;
  }

  /**
   * 
   * <code>detachChildAt</code> removes a child at a given index. That child
   * is returned for saving purposes.
   * 
   * @param index
   *            the index of the child to be removed.
   * @return the child at the supplied index.
   */
  public function detachChildAt(index : Int) : Spatial
  {
    if (children == null) 
    {
        return null;
    }

    if (index < 0 || index >= childrenCount())
    {
      return null;
    }

    /*
    Spatial child = children.remove(index);

    if ( child != null ) 
    {
        child.setParent( null );
        logger.fine("Child removed.");
    }
    */

    var child : Spatial = null;

    for(c in children.iterator())
    {
      if (index == 0)
      {
        child = c;

        break;
      }
      
      index--;
    }

    if (child != null)
    {
      child.parent = null;
      children.remove(child);

      //trace("Child removed.");
    }

    return child;
  }

  /**
   * 
   * <code>detachAllChildren</code> removes all children attached to this
   * node.
   */
  public function detachAllChildren() : Void
  {
    if (children == null)
    {
      return;
    }
    
    while(childrenCount() > 0)
    {
      var firstChild = children.first();

      firstChild.parent = null;

      children.remove(firstChild);
    }

    trace("All children removed. " + childrenCount());
    
    /*
    if(children != null) {
        for ( int i = children.size() - 1; i >= 0; i-- ) {
            detachChildAt( i );
        }
        logger.fine("All children removed.");
    }
    */
  }

    /*
    public void swapChildren(int index1, int index2) {
        Spatial c2 =  children.get(index2);
        Spatial c1 =  children.remove(index1);
        children.add(index1, c2);
        children.remove(index2);
        children.add(index2, c1);
    }
    */

  /**
   * 
   * <code>getChild</code> returns a child at a given index.
   * 
   * @param index
   *            the index to retrieve the child from.
   * @return the child at a specified index.
   */
  public function getChildAt(index : Int) : Spatial
  {
    if (children == null) 
    {
        return null;
    }

    if (index < 0 || index >= childrenCount())
    {
      return null;
    }

    for(child in children.iterator())
    {
      if (index == 0)
      {
        return child;
      }
      
      index--;
    }

    return null;
  }

  /**
   * <code>getChildByName</code> returns the first child found with exactly the
   * given name (case sensitive.)
   * 
   * @param nameToFind
   *            the name of the child to retrieve. If null, we'll return null.
   * @return the child if found, or null.
   */
  public function getChildByName(nameToFind : String) : Spatial
  {
    if (name == null) return null;

    for(child in children.iterator())
    {
      if (child.name == nameToFind)
      {
        return child;
      }

      if (Std.is(child, Node))
      {
        var recChild = cast(child, Node).getChildByName(nameToFind);

        if (recChild != null)
        {
          return recChild;
        }
      }
    }

    /*
    for (int x = 0, cSize = getQuantity(); x < cSize; x++) {
        Spatial child = children.get(x);
        if (name.equals(child.getName())) {
            return child;
        } else if(child instanceof Node) {
            Spatial out = ((Node)child).getChild(name);
            if(out != null) {
                return out;
            }
        }
    }
    */

    return null;
  }
    
  /**
   * determines if the provided Spatial is contained in the children list of
   * this node.
   * 
   * @param spat
   *            the child object to look for.
   * @return true if the object is contained, false otherwise.
   */
  public function hasChild(s : Spatial) : Bool
  {
    if(children == null) 
    {
      return false;
    }

    for(c in children.iterator())
    {
      if (c == s)
      {
        return true;
      }

      if (Std.is(c, Node))
      {
        if (cast(c, Node).hasChild(s))
        {
          return true;
        }
      }
    }

    return false;
  }

  /**
   * <code>updateWorldData</code> updates all the children maintained by
   * this node.
   * 
   * @param time
   *            the frame time.
   */
  public override function updateWorldData(time : Float) : Void
  {
    super.updateWorldData(time);

    for(child in children.iterator())
    {
      if (child != null)
      {
        child.updateGeometricState(time, false);
      }
    }
  }

  public override function updateWorldVectors(?recurse : Bool = false) : Void
  {
    if (((lockedMode & Spatial.LOCKED_TRANSFORMS) == 0)) 
    {
      updateWorldScale();
      updateWorldRotation();
      updateWorldTranslation();
        
      if (recurse) 
      {
        for(child in children.iterator())
        {
          if (child != null)
          {
            child.updateWorldVectors(true);
          }
        }
      }
    }
  }
    
  public override function lockBounds() : Void
  {
    super.lockBounds();

    for(child in children.iterator())
    {
      if (child != null)
      {
        child.lockBounds();
      }
    }
  }
    
  public override function lockTransforms() : Void
  {
    super.lockTransforms();

    for(child in children.iterator())
    {
      if (child != null)
      {
        child.lockTransforms();
      }
    }
  }

  public override function unlockBounds() : Void
  {
    super.unlockBounds();

    for(child in children.iterator())
    {
      if (child != null)
      {
        child.unlockBounds();
      }
    }
  }
    
    
  public override function unlockTransforms() : Void
  {
    super.unlockTransforms();

    for(child in children.iterator())
    {
      if (child != null)
      {
        child.unlockTransforms();
      }
    }
  }

  /**
   * <code>draw</code> calls the onDraw method for each child maintained by
   * this node.
   * 
   * @see com.jme.scene.Spatial#draw(com.jme.renderer.Renderer)
   * @param r
   *            the renderer to draw to.
   */
  public override function draw(r : Renderer) : Void
  {
    if (children == null || !visible) 
    {
      return;
    }

    var childrenArray = new Array<Spatial>();
    
    for(child in children.iterator())
    {
      childrenArray.push(child);
    }

    //childrenArray.sort(zOrderSortCallback);
    childrenArray = ArraySort.mergesort(childrenArray, zOrderSortCallback);

    for(child in childrenArray)
    {
      //trace(child);
	  child.draw(r);
    }

    // TODO: must sort by Zorder
    /*
    for(child in children.iterator())
    {
      if (child != null)
      {
        child.draw(r);

        // ?
        //child.onDraw(r);
      }
    }
    */
  }

  private inline function zOrderSortCallback(a : Spatial, b : Spatial)
  {
    if (a.zOrder == b.zOrder)
    {
      return 0;
    }

    if (a.zOrder > b.zOrder)
    {
      return 1;
    }
    else
    {
      return -1;
    }
  }

  /**
   * <code>updateWorldBound</code> merges the bounds of all the children
   * maintained by this node. This will allow for faster culling operations.
   * 
   * @param recursive - if true the whole subtree and its spatials are updated first 
   * 
   */
  public override function updateWorldBound(?recursive : Bool = false) : Void
  {
    if ((lockedMode & Spatial.LOCKED_BOUNDS) != 0)
    {
      return;
    }

    if (children == null) 
    {
      return;
    }

    var worldBound : BoundingArea = null;

    for (child in children.iterator()) 
    {
      if (child != null) 
      {
        // first update the whole subtree
        /*
        if (recursive)
        {
          if (Std.is(child, Node))
          {
            (cast(child, Node)).updateWorldBound(true);
          }
          else
          {
            child.updateWorldBound();
          }
        }
        */
        child.updateWorldBound(recursive);
        
        if (worldBound != null) 
        {
          // merge current world bound with child world bound
          worldBound.mergeLocal(child.worldBound);
        } 
        else 
        {
          // set world bound to first non-null child world bound
          if (child.worldBound != null) 
          {
            worldBound = (child.worldBound).clone(this.worldBound);
          }
        }
      }
    }

    this.worldBound = worldBound;
  }

  public override function findCollisions(scene : Spatial, results : CollisionResults, ?requiredOnBits : Int = 1) : Void
  {
    if (worldBound != null && isCollidable(requiredOnBits) && scene.isCollidable(requiredOnBits)) 
    {
      if (worldBound.intersects(scene.worldBound)) 
      {
        // further checking needed.
        for(child in children.iterator())
        {
          child.findCollisions(scene, results, requiredOnBits);
        }
      }
    }
  }

  public override function hasCollision(scene : Spatial, pixelPerfect : Bool, ?requiredOnBits : Int = 1) : Bool
  {
    if (this == scene)
    {
      return false;  // No Collision with "self"
    }

    if (worldBound != null && isCollidable(requiredOnBits) && scene.isCollidable(requiredOnBits)) 
    {
      if (worldBound.intersects(scene.worldBound)) 
      {
        if(children == null && !pixelPerfect) 
        {
          return true;
        }

        // further checking needed.
        for(child in children.iterator())
        {
          if (child.hasCollision(scene, pixelPerfect, requiredOnBits)) 
          {
            return true;
          }
        }
      }
    }

    return false;
  }

  public override function setModelBound(modelBound : BoundingArea) : Void
  {
    if (children != null) 
    {
      for(child in children.iterator())
      {
        child.setModelBound(modelBound != null ? modelBound.clone(null) : null);
      }
    }
  }

  public override function updateModelBound() : Void
  {
    if (children != null) 
    {
      
      for(child in children.iterator())
      {
        child.updateModelBound();
      }
    }
  }

	/**
	 * 
	 * Sets the collision-bits for this node. If excludeChildren is false all the children's collisionbit is also set
	 * 
	 * @param collisionBits
	 * @param includeChildren
	 */
	public function setCollisionMask(collisionBits : Int, ?includeChildren : Bool = true) : Void
  {
		//super.setCollisionMask(collisionBits);
    this.collisionBits = collisionBits;

		if (includeChildren && children != null)
		{
      if (children!=null)
      {
        for (child in children.iterator()) 
        {
          if (Std.is(child, Node))
          {
            (cast(child, Node)).setCollisionMask(collisionBits, includeChildren);
          }
          else
          {
            //child.setCollisionMask(collisionBits);
            child.collisionBits = collisionBits;
          }
        }
      }
		}
	}    

  public override function pickComp(x : Float, y : Float, ?requiredOnBits : Int = 1) : Bool
  {
    var vec1 = Spatial.tmpVec1;
    
    vec1.x = x;
    vec1.y = y;
    
    if (children == null || 
        worldBound == null || 
        !isPickable(requiredOnBits) || 
        !worldBound.contains(vec1))
    {
      return false;
    }

    // further checking needed.
    var result : Bool = false;

    for(child in children.iterator())
    {
      vec1.x = x;
      vec1.y = y;

      result = result || child.pick(vec1, requiredOnBits);
    }

    return result;
  }

	/**
	 * 
	 * Sets the collision-bits for this node. If excludeChildren is false all the children's collisionbit is also set
	 * 
	 * @param pickBits
	 * @param includeChildren
	 */
	public function setPickMask(pickBits : Int, ?includeChildren : Bool = true) : Void
  {
    this.pickBits = pickBits;

		if (includeChildren && children != null)
		{
      if (children != null)
      {
        for (child in children.iterator()) 
        {
          if (Std.is(child, Node))
          {
            (cast(child, Node)).setPickMask(pickBits, includeChildren);
          }
          else
          {
            child.pickBits = pickBits;
          }
        }
      }
		}
	}

  private override function set_alpha(v : Float) : Float
  {
    alpha = MathEx.fclamp(v, 0.0, 1.0);

    if (children != null)
    {
      for (child in children.iterator()) 
      {
        child.alpha = alpha;
      }
    }

    return alpha;
  }
}