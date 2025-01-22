package gamelib2.test;

import haxe.unit.TestCase;

import gamelib2.math.Vector2f;

private class TestBase extends TestCase
{
  private static function isNearScalar( a : Float, b : Float) : Bool
  {
    return Math.abs(a - b) < 1e-4;
  }

  private static function isNearVector( a : Vector2f, b : Vector2f ) : Bool
  {
    var tmp = a.subtract(b);
    
    return tmp.length() < 1e-4;
  }
    
  public function testBasic()
  {
  }
}

private class Test1 extends TestBase 
{    
  public override function testBasic()
  {
    //assert( isNear( Vector2(2,3), Vector2(0,1)+Vector2(2,2) ) );
    assertTrue(TestBase.isNearVector(new Vector2f(2, 3), (new Vector2f(0, 1)).addLocal(new Vector2f(2, 2))));
  }    
}

private class Test2 extends TestBase 
{    
  public override function testBasic()
  {
	  //assert( isNear( Vector2(0,1), Vector2(2,3)-Vector2(2,2) ) );
    assertTrue(TestBase.isNearVector(new Vector2f(0, 1), new Vector2f(2, 3).subtractLocal(new Vector2f(2, 2))));
  }    
}

private class Test3 extends TestBase
{    
  public override function testBasic()
  {
	  //assert( Vector2(2,3)[1] == 3 );
    assertTrue(new Vector2f(2, 3).y == 3);
  }    
}

private class Test4 extends TestBase
{    
  public override function testBasic()
  {
	  //assert( isNear( Vector2(2,3).dot(Vector2(2,2)), 4+6 ) );
    assertTrue(TestBase.isNearScalar(new Vector2f(2, 3).dot(new Vector2f(2, 2)), 4 + 6));
  }    
}

private class Test5 extends TestBase
{    
  public override function testBasic()
  {
	  //assert( isNear( Vector2(1,2)*2, Vector2(2,4) ) );
    assertTrue(TestBase.isNearVector(new Vector2f(1, 2).multScalarLocal(2), new Vector2f(2, 4)));
  }    
}

private class Test6 extends TestBase
{    
  public override function testBasic()
  {
	  //assert( isNear( Vector2(4,8).normalize(), Vector2(1,2).normalize() ) );
    assertTrue(TestBase.isNearVector(new Vector2f(4, 8).normalizeLocal(), new Vector2f(1, 2).normalizeLocal()));
  }    
}

private class Test7 extends TestBase
{    
  public override function testBasic()
  {
	  //assert( isNear( Vector2(4,0).normalize(), Vector2(1,0) ) );
    assertTrue(TestBase.isNearVector(new Vector2f(1,0), new Vector2f(4,0).normalizeLocal()));
  }    
}

/*
private class Test1 extends TestBase
{    
  public override function testBasic()
  {
    assertTrue();
  }    
}
*/

class Vector2Test
{
  public function new()
  {
    var r = new haxe.unit.TestRunner();

    r.add(new Test1());
    r.add(new Test2());
    r.add(new Test3());
    r.add(new Test4());
    r.add(new Test5());
    r.add(new Test6());
    r.add(new Test7());
    /*
    r.add(new Test8());
    r.add(new Test9());
    r.add(new Test10());
    r.add(new Test11());
    r.add(new Test12());
    r.add(new Test13());
    r.add(new Test14());
    r.add(new Test15());
    r.add(new Test16());
    r.add(new Test17());
    r.add(new Test18());
    r.add(new Test19());
    r.add(new Test20());
    r.add(new Test21());
    r.add(new Test22());
    r.add(new Test23());
    r.add(new Test24());
    r.add(new Test25());
    r.add(new Test26());
    */

    r.run();
  }
}