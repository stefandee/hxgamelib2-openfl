package gamelib2;

import gamelib2.math.MathEx;

class Timer
{
  public static var TIMER_INGAME        : Int = 0;
  public static var TIMER_SPRITE        : Int = 1;
  public static var TIMER_GENERIC1      : Int = 2;
  public static var TIMER_GENERIC2      : Int = 3;
  public static var TIMER_GENERIC3      : Int = 4;
  public static var TIMER_GENERIC4      : Int = 5;
  public static var TIMER_GENERIC5      : Int = 6;
  public static var TIMER_GENERIC6      : Int = 7;
  public static var TIMER_GENERIC7      : Int = 8;
  public static var TIMER_UI            : Int = 9;
  public static var TIMER_SCENE         : Int = 10;
  public static var TIMER_INGAME_PLAYER : Int = 11;
  public static var TIMER_PHYSICS       : Int = 12;

  public var time : Float;
  public var paused : Bool;
  @:isVar public var speedMultiplier(default, set) : Float;

  public function new()
  {
    time   = 0;
    paused = false;
    speedMultiplier = 1.0;
  }

  public function update(dt : Float)
  {
    if (!paused)
    {
      time += (dt * speedMultiplier);
    }
  }

  public function reset()
  {
    time   = 0;
    paused = false;
  }

  private function set_speedMultiplier(v : Float) : Float
  {
    if (v < 0)
    {
      v = 0;
    }

    speedMultiplier = v;

    return speedMultiplier;
  }
}

class Clock
{  
  public static var instance                       : Clock;
  
  public var simTime (default, null)               : Float;
  public var realTime (default, null)              : Float;
  public var pauseTime (default, null)             : Float;
  public var elapsedSimTime (default, null)        : Float;
  public var elapsedRealTime (default, null)       : Float;
  @:isVar public var advanceTime (default, set) : Float;
  public var totalAdvanceTime (default, null)      : Float;
  @:isVar public var paused (default, set)           : Bool;

  @:isVar public var speedFactor(default, set)     : Float;

  public var timers                                : Map<Int, Timer>;

  private var timeStamp                            : Float;
  private var timeStampPause                       : Float;
  
  public function new()
  {
    reset();

    initTimers();

    trace("timeStamp: " + timeStamp);
  }

  public function reset()
  {
    simTime          = 0;
    realTime         = 0;
    elapsedSimTime   = 0;
    elapsedRealTime  = 0;
    advanceTime      = 0;
    totalAdvanceTime = 0;
    pauseTime        = 0;
    speedFactor      = 1;

    paused           = false;
    timeStamp        = flash.Lib.getTimer();
  }

  public function update()
  {    
    //trace("blargh: " + flash.Lib.getTimer());
    
    var prevRealTime = realTime;
    var timeDiff     = speedFactor * MathEx.fclamp(flash.Lib.getTimer() - timeStamp, 0, 100);

    realTime += timeDiff;
    timeStamp = flash.Lib.getTimer();

    // update the elapsed real time
    elapsedRealTime = realTime - prevRealTime;

    //trace(elapsedRealTime);

    if (paused)
    {
      pauseTime += timeDiff;
    }

    /*
    if (!paused)
    {
      var oldSimTime = simTime;
      
      simTime = realTime + totalAdvanceTime - pauseTime;

      timer.update(simTime - oldSimTime);

      //trace("real: " + realTime + " - " + "sim: " + simTime + " - " + "pause: " + pauseTime);
    }
    else
    {
      //trace("pause time: " + MathUtils.clamp(timeDiff, 0, 100));
      
      pauseTime += MathUtils.clamp(timeDiff, 0, 100);
    }
    */

    //trace("real: " + realTime + " - " + "sim: " + simTime + " - " + "pause: " + pauseTime);

    // update the elapsed sim time
    var prevSimTime = simTime;
    simTime = realTime + totalAdvanceTime - pauseTime;
    elapsedSimTime = simTime - prevSimTime;

    //timer.update(elapsedSimTime);
    updateTimers(elapsedSimTime);

    /*
    if (paused)
    {
      trace("elapsedSimTime = " + elapsedSimTime);
    }
    */

    // reset the advance time
    totalAdvanceTime += advanceTime;
    advanceTime = 0;

    //trace("update end!");
  }

  private function set_advanceTime(v : Float) : Float
  {
    if (v < 0)
    {
      v = 0;
    }

    advanceTime = v;

    return advanceTime;
  }

  private function set_paused(v : Bool) : Bool
  {
    if (v && !paused)
    {
    }

    if (!v && paused)
    {
    }

    paused = v;

    return paused;
  }

  private function set_speedFactor(v : Float) : Float
  {
    speedFactor = v;

    if (speedFactor < 1)
    {
      speedFactor = 1.0;
    }

    return speedFactor;
  }

  public static function getInstance() : Clock
  {
    if (instance == null)
    {
      var timer : flash.utils.Timer = new flash.utils.Timer(30, 0);
      timer.addEventListener(flash.events.TimerEvent.TIMER, timerHandler);
      timer.start();

      Clock.instance = new Clock();
    }

    return Clock.instance;
  }

  private static function timerHandler(e : flash.events.TimerEvent)
  {
    Clock.instance.update();
  }

  //
  // Internal timers
  //
  private function initTimers()
  {
    timers          = new Map();

    registerTimer(Timer.TIMER_INGAME  );
    registerTimer(Timer.TIMER_SPRITE  );
    registerTimer(Timer.TIMER_GENERIC1);
    registerTimer(Timer.TIMER_GENERIC2);
    registerTimer(Timer.TIMER_GENERIC3);
    registerTimer(Timer.TIMER_GENERIC4);
    registerTimer(Timer.TIMER_GENERIC5);
    registerTimer(Timer.TIMER_GENERIC6);
    registerTimer(Timer.TIMER_GENERIC7);
    registerTimer(Timer.TIMER_UI);
    registerTimer(Timer.TIMER_SCENE);
    registerTimer(Timer.TIMER_INGAME_PLAYER);
    registerTimer(Timer.TIMER_PHYSICS);
  }

  private function updateTimers(elapsedTime : Float)
  {
    for(timer in timers.iterator())
    {
      timer.update(elapsedTime);
    }
  }

  private function registerTimer(timerIndex : Int) : Bool
  {
    if (timers == null)
    {
      return false;
    }

    var timer = timers.get(timerIndex);

    if (timer != null)
    {
      trace("Timer already registered!");
      
      return false;
    }
    
    timer = new Timer();

    timers.set(timerIndex, timer);

    return true;
  }

  public function getTimer(index : Int) : Timer
  {
    return timers.get(index);
  }
}