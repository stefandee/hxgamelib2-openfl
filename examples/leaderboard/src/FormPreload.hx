// app
import gamelib2.microvcl.Form;
import gamelib2.microvcl.Control;
import gamelib2.microvcl.DisplayTactics;
import gamelib2.microvcl.Helper;
import gamelib2.i18n.Manager;
import gamelib2.sentry.SentrySprite;
import gamelib2.data.SprLib;
import gamelib2.microvcl.Button;
import gamelib2.leaderboard.Api;

import Data;
import GameDef;

// openfl
import flash.display.MovieClip;
import flash.utils.ByteArray;
import openfl.Assets;

enum PreloadState
{
  PreloadState_CreateUI;
  PreloadState_Load;
  PreloadState_Init;
  PreloadState_Wait;
  PreloadState_Done;
}

class FormPreload extends Form
{ 
  private static var INIT_STEP_COUNT      = 8;
  private static var LOADING_STEP_PERCENT = 0.9;
  
  //private var labelWait : gamelib.microvcl.Label;
  private var initStep : Int;

  private var progress : Float;

  private var state : PreloadState;

  private var app    : GameApp;

#if UseMochiAds
  private var adContainer     : MovieClip;
#end // UseMochiAds

  private var allowPlayButton : Bool;

  public function new(parentControl : Control, name : String, displayTactics : DisplayTactics, autoAdd : Bool, strMgr : Manager)
  {
    app      = GameApp.getApp();
    progress = 0;

    super(parentControl, name, displayTactics, autoAdd, strMgr);

    state    = PreloadState_CreateUI;
  }

  public override function createUI()
  {
  }

#if UseMochiAds
  public function initMochiAds()
  {
    adContainer = new flash.display.MovieClip();
    this.addChild(adContainer);

    // force MochiAd._getRes to use the bounds of the adContainer (we need padding below for the loading bar and play button)
    var bkgShape = new flash.display.Shape();

    bkgShape.graphics.lineStyle(1.0, 0x0000FF, 0.0);
    bkgShape.graphics.beginFill(0x0000FF, 0.0);
    bkgShape.graphics.drawRect(0, 0, 600, 400);
    bkgShape.graphics.endFill();

    adContainer.addChild(bkgShape);

    adContainer.x = GameDef.STAGE_WIDTH  / 2 - adContainer.width / 2;
    adContainer.y = GameDef.STAGE_HEIGHT / 2 - adContainer.height / 2;

    allowPlayButton = false;

    trace(adContainer.getBounds(adContainer.parent));

    var adOptions : Dynamic = {
      id: "",
      //res: "640x480",
      no_bg: true,
      no_progress_bar: true,
      clip: adContainer,
      color: 0x006699,
#if debug
      skip: true,
#end // debug
      background: 0x333333,
      outline: 0xFFFFFF,
      ad_loaded: onAdLoaded,
      ad_started: onAdStarted,
      ad_skipped: onAdSkipped,
      ad_failed: onAdFailed,
      ad_finished: onAdFinished,
    };

    //adContainer.loaderInfo.parameters.mochiad_options = adOptions;

    mochi.as3.MochiAd.showPreGameAd(adOptions);
  }

  private function onAdLoaded(width : Float, height : Float)
  {
    trace("ad loaded with size: " + width + "x" + height);
  }

  private function onAdStarted()
  {
  }

  private function onAdSkipped()
  {
    allowPlayButton = true;

    trace("ad skipped!");
  }

  private function onAdFailed()
  {
    trace("ad failed!");

    allowPlayButton = true;
  }

  private function onAdFinished()
  {
    trace("ad finished!");
    
    allowPlayButton = true;
  }
#end //

  private override function onEnterFrame(e : flash.events.Event)
  {
    switch(state)
    {
      case PreloadState_CreateUI:
      {
        state = PreloadState_Load;
      }
      
      case PreloadState_Load:
      {
        var totalBytes = flash.Lib.current.loaderInfo.bytesTotal;
        var actBytes   = flash.Lib.current.loaderInfo.bytesLoaded;

        progress = LOADING_STEP_PERCENT * actBytes / totalBytes;

        if (actBytes == totalBytes)
        {
          state = PreloadState_Init;

          trace("switch states to init " + flash.Lib.current.loaderInfo.bytesTotal);

          initStep = 0;
        }
      }

      case PreloadState_Init:
      {
        progress = LOADING_STEP_PERCENT + (1.0 - LOADING_STEP_PERCENT) * initStep / INIT_STEP_COUNT;
        
        switch(initStep)
        {
          case 0:
          {
            initData();
          }

          case 1:
          {
          }

          case 2:
          {
          }

          case 3:
          {
            var api = Api.instance;
            
            var formMain = new FormMain(app.root, "FormMain", new DisplayTactics(), false, strMgr);
            formMain.enabled = false;
            app.addForm(formMain);

            api.init(1);
          }

          case 4:
          {
#if UseSWFProfiler
            com.flashdynamix.utils.SWFProfiler.init(this.stage, formPlay);
#end // UseSWFProfiler
          }

          case 5:
          {
          }

          case 6:
          {
          }

          case 7:
          {
          }

          case 8:
          {
#if UseMochiAnalytics
            //mochi.as3.MochiEvents.startSession("Game Play");
            mochi.as3.MochiEvents.trackEvent("Preload", "Loaded");
#end // UseMochiAnalytics

            var app = GameApp.getApp();
            app.changeLanguage(app.strMgr.lang);

            state = PreloadState_Wait;
          }
        }

        initStep++;
      }

      case PreloadState_Wait:
      {        
        var app = GameApp.getApp();

        app.removeForm(this.controlName);        
        app.showForm("FormMain");
        
        state = PreloadState_Done;
      }

      case PreloadState_Done:
      {
      }
    }
  }

  private function initData()
  {
    //
    // init the data
    //
    new Data();

    var app = GameApp.getApp();

    //
    // init the string manager
    //
    app.strMgr.init(Assets.getBytes(Data.Data_Lang));

    //
    // init the sprite lib
    //
    app.sprLib = new SprLib(Assets.getBytes(Data.Data_SprLib));

    app.changeLanguage(app.strMgr.lang);
  }
}