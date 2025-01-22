package gamelib2.box2d;

import box2D.collision.shapes.B2Shape;
import box2D.dynamics.B2Body;

/**
 * ...
 * @author Piron Games
 */
class B2BodyUtils
{

  public function new()
  {

  }

  public static function flipHorizontal(body : B2Body, ?xcoord : Float = 0)
  {
    var fixture = body.getFixtureList();

    while (fixture != null)
    {
      shapeFlipHorizontal(fixture.m_shape, xcoord);
      fixture = fixture.m_next;
    }

    // is this the best way to do this?
    body.synchronizeFixtures();
  }

  public static function shapeFlipHorizontal(shape : B2Shape, ?xcoord : Float = 0)
  {
    // TODO
    shape.flipHorizontal(xcoord);
  }

}