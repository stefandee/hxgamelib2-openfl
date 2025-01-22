package gamelib2.test;

import haxe.unit.TestCase;

private class Test1 extends TestCase 
{    
  public function testBasic()
  {
    assertEquals("", "");
  }    
}

/*
private class Test1 extends TestCase 
{    
  public function testBasic()
  {
    assertEquals("", "");
  }    
}
*/

class Matrix4Test
{
  public function new()
  {
    var r = new haxe.unit.TestRunner();

    r.add(new Test1());
    /*
    r.add(new Test2());
    r.add(new Test3());
    r.add(new Test4());
    r.add(new Test5());
    r.add(new Test6());
    r.add(new Test7());
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