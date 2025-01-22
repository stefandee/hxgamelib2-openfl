package gamelib2.scene;

import gamelib2.bounding.BoundingArea;
import gamelib2.math.Vector2f;
import gamelib2.math.Vector3f;
import gamelib2.math.Matrix3f;
import gamelib2.math.MathEx;
import gamelib2.renderer.Renderer;
import gamelib2.intersection.CollisionResults;

/**
 * Base class for the scene graph nodes. Cannot be instantiated, so you need
 * to subclass it for any specific needs.
 */
class Spatial
{
  public static var LOCKED_NONE       : Int = 0;
  public static var LOCKED_BOUNDS     : Int = 1;
  public static var LOCKED_TRANSFORMS : Int = 2;
  public static var LOCKED_BRANCH     : Int = 4;

  /** Bounding volume in World coordinates */
  public var worldBound (default, null)  : BoundingArea;

  /** Draw order */
  public var zOrder                      : Int;

  /**
   * Used to indicate this spatial (and any below it in the case of Node) is
   * locked against certain changes.
   */
  public var lockedMode (default, null)  : Int;

  /** */
  public var name                        : String;

  /** */
  public static var serialNumber         : Int = 0;
  
  /**
   * Defines if this spatial will be used in intersection operations or not.
   * Default is true
   */
  public var collisionBits               : Int;

  /** Spatial's rotation relative to its parent. Value in radians. */
  public var localRotation               : Matrix3f;

  /** Spatial's world absolute rotation. Value in radians. */
  public var worldRotation               : Matrix3f;

  /** Spatial's translation relative to its parent. */
  public var localTranslation            : Vector2f;

  /** Spatial's world absolute translation. */
  public var worldTranslation            : Vector2f;

  /** Spatial's scale relative to its parent. */
  public var localScale                  : Vector2f;

  /** Spatial's world absolute scale. */
  public var worldScale                  : Vector2f;

  /** Spatial's parent, or null if it has none. */
  @:isVar public var parent (default, set) : Node;

  @:isVar public var alpha (default, set)   : Float;

  public var visible                     : Bool;

  public var pickBits                    : Int;
  //public var isPickable (getIsPickable, setIsPickable) : Bool;

  private static var tmpMatrix           : Matrix3f = new Matrix3f(); 
  private static var tmpMatrix2          : Matrix3f = new Matrix3f(); 
  private static var tmpVec1             : Vector2f = new Vector2f();
  private static var tmpVec2             : Vector2f = new Vector2f();

  /** This class cannot be instantiated. */
  private function new()
  {
    collisionBits = 1;
    pickBits = 1;

    alpha = 1.0;

    //localRotation = 0.0;
    //worldRotation = 0.0;
    localRotation = new Matrix3f();
    localRotation.loadIdentity();

    worldRotation = new Matrix3f();
    worldRotation.loadIdentity();
    
    localTranslation = new Vector2f();
    worldTranslation = new Vector2f();

    localScale = new Vector2f(1.0, 1.0);
    worldScale = new Vector2f(1.0, 1.0);

    lockedMode = Spatial.LOCKED_NONE;

    name = "<noname " + Spatial.serialNumber + ">";

    visible = true;

    serialNumber++;
  }

  /*
  private function tempMatrixRot(angle : Float)
  {
    tempMatrix.loadIdentity();
    tempMatrix.fromAngleNormalAxis(worldRotation, Vector3f.UNIT_Z);
  }
  */

  public function draw(r : Renderer) : Void
  {
  }

  /**
   * <code>updateGeometricState</code> updates all the geometry information
   * for the node.
   * 
   * @param time
   *            the frame time.
   * @param initiator
   *            true if this node started the update process.
   */
  public function updateGeometricState(time : Float, initiator : Bool) : Void
  {
    if ((lockedMode & Spatial.LOCKED_BRANCH) != 0)
        return;

    updateWorldData(time);

    if ((lockedMode & Spatial.LOCKED_BOUNDS) == 0) 
    {
      updateWorldBound();

      if (initiator) 
      {
        propagateBoundToRoot();
      }
    }
  }

  /**
   * <code>updateWorldData</code> updates the world transforms from the
   * parent down to the leaf.
   * 
   * @param time
   *            the frame time.
   */
  public function updateWorldData(time : Float) : Void
  {
    updateWorldVectors();
  }

  /**
   * If not locked, updates worldscale, worldrotation and worldtranslation
   * 
   * @param recurse
   *            usually false when updating the tree. Set to true when you
   *            just want to update the world transforms for a branch without
   *            updating geometric state.
   */
  public function updateWorldVectors(?recurse : Bool = false) : Void
  {
    if (((lockedMode & Spatial.LOCKED_TRANSFORMS) == 0)) 
    {
      //trace("updateWorldVectors");
      
      updateWorldScale();
      updateWorldRotation();
      updateWorldTranslation();
    }
  }

  private function updateWorldTranslation() : Void
  {
    if (parent != null) 
    {
      parent.localToWorld(localTranslation, worldTranslation);
    } 
    else 
    {
      worldTranslation.set(localTranslation);
    }
  }

  private function updateWorldRotation() : Void
  {
    if (parent != null) 
    {
      //parent.getWorldRotation().mult(localRotation, worldRotation);
      //worldRotation = parent.worldRotation + localRotation;

      // original code
      parent.worldRotation.multMatrix3Store(localRotation, worldRotation);

      //localRotation.multMatrix3Store(parent.worldRotation, worldRotation);
    } 
    else 
    {
      //worldRotation.set(localRotation);
      //worldRotation = localRotation;
      worldRotation.copy(localRotation);
    }
  }

  private function updateWorldScale() : Void
  {
    if (parent != null) 
    {
      worldScale.set(parent.worldScale).multLocal(localScale);
    } 
    else 
    {
      worldScale.set(localScale);
    }
  }

  /**
   * Convert a vector (in) from this spatials local coordinate space to world
   * coordinate space.
   * 
   * @param in
   *            vector to read from
   * @param store
   *            where to write the result (null to create a new vector, may be
   *            same as in)
   * @return the result (store)
   */
  public function localToWorld(inVector : Vector2f, ?storeVector : Vector2f = null) : Vector2f
  {
    if (storeVector == null)
    {
      storeVector = new Vector2f();
    }

    // multiply with scale first, then rotate, finally translate (cf.
    // Eberly)
    storeVector.set(inVector);
    
    worldRotation.multVector2(storeVector, storeVector);
    storeVector.multLocal(worldScale);

    storeVector.addLocal(worldTranslation);

    //tempMatrixRot(worldRotation);
    
    //return tempMatrix.multVector2(storeVector, storeVector);

    return storeVector;

    /*
    return getWorldRotation().mult(
            store.set(in).multLocal(getWorldScale()), store).addLocal(
            getWorldTranslation());
    */
  }

  /**
   * Convert a vector (in) from world coordinate space to this spatials local
   * coordinate space.
   * 
   * @param in
   *            vector to read from
   * @param store
   *            where to write the result
   * @return the result (store)
   */
  public function worldToLocal(inVector : Vector2f, ?storeVector : Vector2f = null) : Vector2f 
  {
    //in.subtract(getWorldTranslation(), store).divideLocal(getWorldScale());
    //getWorldRotation().inverse().mult(store, store);    

    if (storeVector == null)
    {
      storeVector = new Vector2f();
    }
    
    inVector.subtract(worldTranslation, storeVector);
    storeVector.divideLocal(worldScale);

    worldRotation.invertStore(tmpMatrix);
    tmpMatrix.multVector2(storeVector, storeVector);

    return storeVector;

    /*
    inVector.subtract(worldTranslation, storeVector);

    tmpMatrix.loadIdentity();
    tmpMatrix.m00 = worldScale.x;
    tmpMatrix.m11 = worldScale.y;
    tmpMatrix.invertLocal();

    storeVector = tmpMatrix.multVector2(storeVector);

    worldRotation.invertStore(tmpMatrix);
    storeVector = tmpMatrix.multVector2(storeVector);

    return storeVector;
    */

    //tempMatrixRot(worldRotation);
    //tempMatrix.invertLocal();
    //return tempMatrix.multVector2(storeVector, storeVector);
  }

  /*
  public void lookAt(Vector3f position, Vector3f upVector, boolean takeParentInAccount) {
      compVecA.set(position).subtractLocal(getWorldTranslation());
      getLocalRotation().lookAt(compVecA, upVector);
  if (takeParentInAccount && parent!=null)
    getLocalRotation().multLocal(parent.getWorldRotation().inverse());        
  }
  */

/*
        tmpZaxis.set( direction ).normalizeLocal();
        tmpXaxis.set( up ).crossLocal( direction ).normalizeLocal();
        tmpYaxis.set( direction ).crossLocal( tmpXaxis ).normalizeLocal();
  */

  private static var tmpXAxis : Vector3f = new Vector3f();
  private static var tmpYAxis : Vector3f = new Vector3f();
  private static var tmpZAxis : Vector3f = new Vector3f();

  private static var direction : Vector3f = new Vector3f();
  private static var direction2f : Vector2f = new Vector2f();

  public function lookAtTest(worldPosition : Vector2f, upVector : Vector2f, ?takeParentInAccount : Bool = false) : Void
  {
    direction2f.setComp((worldPosition.x - worldTranslation.x) / worldScale.x, (worldPosition.y - worldTranslation.y) / worldScale.y);
    direction2f.normalizeLocal();

    if (parent != null)
    {
      parent.worldRotation.invertStore(tmpMatrix);
      tmpMatrix.multVector2(direction2f, direction2f);
      direction2f.normalizeLocal();
    }
    else
    {
      worldToLocal(direction2f, direction2f);
    }
    
    localRotation.m00 = direction2f.x;
    localRotation.m01 = -direction2f.y;

    localRotation.m10 = direction2f.y;
    localRotation.m11 = direction2f.x;

    updateWorldRotation();    
  }

  // position: vector in world coordinates
  public function lookAt(worldPosition : Vector2f, upVector : Vector2f, ?takeParentInAccount : Bool = false) : Void
  {
    direction.set((worldPosition.x - worldTranslation.x) / worldScale.x, (worldPosition.y - worldTranslation.y) / worldScale.y, 0);
    direction.normalizeLocal();
    
    tmpZAxis.setFromVector(direction);
    tmpZAxis.normalizeLocal();

    tmpXAxis.set(upVector.x, upVector.y, 0);
    tmpXAxis.crossVectorLocal(direction);
    tmpXAxis.normalizeLocal();

    tmpYAxis.setFromVector(direction);
    tmpYAxis.crossVectorLocal(tmpXAxis);
    tmpYAxis.normalizeLocal();

    localRotation.m00 = tmpYAxis.y;
    localRotation.m01 = tmpYAxis.x;

    localRotation.m10 = tmpZAxis.y;
    localRotation.m11 = tmpZAxis.x;

    //Spatial.hx:352 : yaxis: (0.5667178277746163, -0.8239119514137541, 0)
    //Spatial.hx:353 : zaxis: (-0.8239119514137541, -0.5667178277746163, 0)

    //Spatial.hx:352 : yaxis: (0.5776513899054149, 0.8162835731168075, 0)
    //Spatial.hx:353 : zaxis: (0.8162835731168075, -0.5776513899054149, 0)

    //trace("yaxis: " + tmpYAxis.toString());
    //trace("zaxis: " + tmpZAxis.toString());

    /*
    tmpVec1.set(worldPosition);
    tmpVec1.subtractLocal(worldTranslation);
    tmpVec1.normalizeLocal();

    tmpVec2.setComp(1.0, 0.0);

    localRotation.setRotation(tmpVec2.smallestAngleBetween(tmpVec1));

    if (takeParentInAccount && parent != null)
    {
      tmpMatrix = parent.worldRotation.invertStore(tmpMatrix);

      localRotation.multLocal(tmpMatrix);
    }
    */

    updateWorldRotation();
  }

  private static var tmpVecComp : Vector2f = new Vector2f();

  public function lookAtComp(x : Float, y : Float, upVector : Vector2f, ?takeParentInAccount : Bool = false) : Void
  {
    tmpVecComp.setComp(x, y);

    lookAt(tmpVecComp, upVector, takeParentInAccount);
  }

  /**
   * <code>removeFromParent</code> removes this Spatial from it's parent.
   * 
   * @return true if it has a parent and performed the remove.
   */
  public function removeFromParent() : Bool 
  {
    if (parent != null) 
    {
      parent.detachChild(this);
      return true;
    }

    return false;
  }

  /**
   * determines if the provided Node is the parent, or parent's parent, etc. of this Spatial.
   * 
   * @param ancestor
   *            the ancestor object to look for.
   * @return true if the ancestor is found, false otherwise.
   */
  public function hasAncestor(ancestor : Node) : Bool 
  {
    if (parent == null) 
    {
      return false;
    } 
    //else if (parent.equals(ancestor)) 
    else if (parent == ancestor) 
    {
      return true;
    } 
    else 
    {
      return parent.hasAncestor(ancestor);
    }
  }

  /**
   * <code>setLocalScale</code> sets the local scale of this node.
   * 
   * @param localScale
   *            the new local scale, applied to x, y and z
   */
  public function setLocalScalarScale(localScale : Float) : Void 
  {
      this.localScale.x = localScale;
      this.localScale.y = localScale;
      //this.localScale.z = localScale;
      this.worldScale.set(this.localScale);
  }

  public function setLocalScaleComp(scaleX : Float, scaleY : Float) : Void 
  {
      this.localScale.x = scaleX;
      this.localScale.y = scaleY;
      //this.localScale.z = localScale;
      this.worldScale.set(this.localScale);
  }

  /**
   * <code>setLocalScale</code> sets the local scale of this node.
   * 
   * @param localScale
   *            the new local scale.
   */
  public function setLocalScale(localScale : Vector2f) : Void
  {
    this.localScale = localScale;
    this.worldScale.set(this.localScale);
  }

  /**
   * <code>setLocalTranslation</code> sets the local translation of this
   * node.
   * 
   * @param localTranslation
   *            the local translation of this node.
   */
  public function setLocalTranslationVector(localTranslation : Vector2f) : Void
  {
    this.localTranslation = localTranslation;
    this.worldTranslation.set(this.localTranslation);
  }

  public function setLocalTranslation(x : Float, y : Float) : Void
  {
    localTranslation.setComp(x, y);
    worldTranslation.set(localTranslation);
  }

  public function setLocalRotation(rotation : Float) : Void
  {
    localRotation.loadIdentity();
    
    localRotation.fromAngleNormalAxis(rotation, Vector3f.UNIT_Z);
    //localRotation.setRotation(rotation);

    //trace("localRotation by angle " + rotation + " is " + localRotation.toString());

    worldRotation.copy(localRotation);
  }

  public function getLocalToWorldMatrix(?store : Matrix3f = null) : Matrix3f 
  {
    if (store == null) 
    {
      store = new Matrix3f();
    } 

    store.loadIdentity();

    // multiply with scale first, then rotate, finally translate (cf.
    // Eberly)
    store.setScale(worldScale);
    store.multLocal(worldRotation);

    //tempMatrixRot(worldRotation);
    //store.multLocal(tempMatrix);

    store.setTranslationVector(worldTranslation);

    return store;
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
  public function setZOrder(zOrder : Int, setOnChildren : Bool) : Void 
  {
    this.zOrder = zOrder;
  }

  /**
   * <code>propagateBoundToRoot</code> passes the new world bound up the
   * tree to the root.
   */
  public function propagateBoundToRoot() : Void 
  {
    if (parent != null) 
    {
      parent.updateWorldBound();
      parent.propagateBoundToRoot();
    }
  }

  /**
   * <code>calculateCollisions</code> calls findCollisions to populate the
   * CollisionResults object then processes the collision results.
   * 
   * @param scene the scene to test against.
   * @param results the results object.
   * @param requiredOnBits considered a collision only if these bits are 'on'
   *    in both 'this' and the 'scene' spatial.
   */
  public function calculateCollisions(scene : Spatial, results : CollisionResults, ?requiredOnBits : Int = 1) : Void
  {
    findCollisions(scene, results, requiredOnBits);
    results.processCollisions();
  }

  /**
   * <code>updateBound</code> recalculates the bounding object for this
   * Spatial.
   */
  public function updateModelBound() : Void
  {
  }

  /**
   * <code>setModelBound</code> sets the bounding object for this Spatial.
   * 
   * @param modelBound
   *            the bounding object for this spatial.
   */
  public function setModelBound(modelBound : BoundingArea) : Void
  {
  }

  /**
   * checks this spatial against a second spatial, any collisions are stored
   * in the results object.
   * 
   * @param scene the scene to test against.
   * @param results the results of the collisions.
   * @param requiredOnBits considered a collision only if these bits are 'on'
   *    in both 'this' and the 'scene' spatial.
   */
  public function findCollisions(scene : Spatial, results : CollisionResults, ?requiredOnBits : Int = 1) : Void
  {
  }

  /**
   * Checks this spatial against a second spatial for collisions.
   * 
   * @param scene the scene to test against.
   * @param checkTriangles check for collisions on triangle accuracy level
   * @param requiredOnBits considered a collision only if these bits are 'on'
   *    in both 'this' and the 'scene' spatial.
   * @return true if any collision were found
   */
  public function hasCollision(scene : Spatial, pixelPerfect : Bool, ?requiredOnBits : Int = 1) : Bool
  {
    return false;
  }

  /**
   * Sets if this Spatial is to be used in intersection (collision)
   * calculations. By default this is true.
   *
   * Turns on or off the first (least significant) bit in the collision bit
   * set.
   * 
   * @param isCollidable
   *            true if this Spatial is to be used in intersection
   *            calculations, false otherwise.
   */
  public function setIsCollidable(isCollidable : Bool) : Void
  {
    collisionBits = isCollidable ? (collisionBits | 1) : (collisionBits & (~1));
  }

  /**
   * Defines if this Spatial is to be used in intersection (collision and
   * picking) calculations. By default this is true.
   * 
   * @return true if this Spatial is to be used in intersection calculations,
   *         false otherwise.
   */
  public function isCollidable(?requiredOnBits : Int = 1) : Bool
  {
    return ((requiredOnBits & collisionBits) ^ requiredOnBits) == 0;
  }

  /**
   * Flags this spatial and those below it in the scenegraph to not
   * recalculate world transforms such as translation, rotation and scale on
   * every update. This is useful for efficiency when you have scene items
   * that stay in one place all the time as it avoids needless recalculation
   * of transforms.
   * 
   * @see #unlockTransforms()
   */
  public function lockTransforms() : Void
  {
    updateWorldVectors();
    lockedMode |= LOCKED_TRANSFORMS;
  }

  /**
   * Flags this spatial and those below it to allow for transform updating
   * (the default).
   * 
   * @see #lockTransforms()
   */
  public function unlockTransforms() : Void
  {
    lockedMode &= ~LOCKED_TRANSFORMS;
  }

  /**
   * Calling this method tells the scenegraph that it is not necessary to
   * update bounds from this point in the scenegraph on down to the leaves.
   * This is useful for performance gains where you have scene items that do
   * not move (at all) or change shape and thus do not need constant
   * re-calculation of boundaries. When you call lock, the bounds are first
   * updated to ensure current bounds are accurate.
   * 
   * @see #unlockBounds()
   */
  public function lockBounds() : Void
  {
    updateGeometricState(0, true);
    lockedMode |= LOCKED_BOUNDS;
  }

  /**
   * Flags this spatial and those below it to allow for bounds updating (the
   * default).
   * 
   * @see #lockBounds()
   */
  public function unlockBounds() : Void
  {
    lockedMode &= ~LOCKED_BOUNDS;
  }

  /**
   * Note: Uses the currently set Renderer to generate a display list if
   * LOCKED_MESH_DATA is set.
   * 
   * @param locks
   *            a bitwise combination of the locks to establish on this
   *            Spatial.
   */
  public function setLocks(lockedMode : Int) : Void
  {
    if ((lockedMode & Spatial.LOCKED_BOUNDS) != 0) 
    {
      lockBounds();
    } 
    else 
    {
      unlockBounds();
    }

    if ((lockedMode & Spatial.LOCKED_TRANSFORMS) != 0) 
    {
      lockTransforms();
    } 
    else {
      unlockTransforms();
    }
  }

  /**
   * <code>updateWorldBound</code> updates the bounding volume of the world.
   * Abstract, geometry transforms the bound while node merges the children's
   * bound. In most cases, users will want to call updateModelBound() and let
   * this function be called automatically during updateGeometricState().
   */
  public function updateWorldBound(?recursive : Bool = false) : Void
  {
  } 

  private function set_parent(parent : Node) : Node
  {
    this.parent = parent;

    return this.parent;
  }

  /**
   * Returns the Spatial's name.
   *
   * <p>
   * If you want to display a class name, then use
   * Spatial.class.getName() or getClass().getName().
   * That's that those methods are there for.
   * </p>
   */
  public function toString() : String 
  {
    return (this.name == null) ? "<NONAME>" : this.name;
  }

  private function set_alpha(v : Float) : Float
  {
    alpha = MathEx.fclamp(v, 0.0, 1.0);

    return alpha;
  }

  /**
   * Sets if this Spatial is to be used in picking
   *
   * Turns on or off the first (least significant) bit in the pick bit
   * set.
   * 
   * @param isCollidable
   *            true if this Spatial is to be used in picking
   *            false otherwise.
   */
  public function setIsPickable(isPickable : Bool) : Void
  {
    pickBits = isPickable ? (pickBits | 1) : (pickBits & (~1));
  }

  /**
   * Defines if this Spatial is to be used in picking
   * 
   * @return true if this Spatial is to be used in picking,
   *         false otherwise.
   */
  public function isPickable(?requiredOnBits : Int = 1) : Bool
  {
    return ((requiredOnBits & pickBits) ^ requiredOnBits) == 0;
  }

  public function pickComp(x : Float, y : Float, ?requiredOnBits : Int = 1) : Bool
  {
    return false;
  }

  public function pick(pos : Vector2f, ?requiredOnBits : Int = 1) : Bool
  {
    return pickComp(pos.x, pos.y, requiredOnBits);
  }
}