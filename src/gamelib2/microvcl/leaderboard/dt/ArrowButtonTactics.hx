package gamelib2.microvcl.leaderboard.dt;

import flash.display.Sprite;
import flash.display.Graphics;

import gamelib2.microvcl.DisplayTactics;

enum ArrowOrientation
{
  Left;
  Right;
  Top;
  Down;
}

class ArrowButtonTactics extends DisplayTactics
{
  private var btn              : flash.display.SimpleButton; 
  private var onBkg            : Sprite;
  private var offBkg           : Sprite;

  private var aWidth           : Int;
  private var aHeight          : Int;
  private var colorNormal      : Int;
  private var colorHL          : Int;
  private var arrowOrientation : ArrowOrientation;

  public function new(aWidth : Int, aHeight : Int, arrowOrientation : ArrowOrientation, colorNormal : Int, colorHL : Int)
  {
    super();

    this.aWidth      = aWidth;
    this.aHeight     = aHeight;
    this.colorNormal = colorNormal;
    this.colorHL     = colorHL;
    this.arrowOrientation = arrowOrientation;
  }

  public override function init()
  {    
    onBkg = new Sprite();
    drawArrow(onBkg.graphics, aWidth, aHeight, colorHL, arrowOrientation);

    offBkg = new Sprite();
    drawArrow(offBkg.graphics, aWidth, aHeight, colorNormal, arrowOrientation);

    //
    // create the button
    //
    btn = new flash.display.SimpleButton(onBkg, offBkg, offBkg, onBkg);

    target.addChild(btn);

    btn.x = 0;
    btn.y = 0;
  }

  public override function update()
  {
  }

  private function drawArrow(g : Graphics, width : Int, height : Int, color : Int, arrowOrientation : ArrowOrientation)
  {
    if (g == null)
    {
      return;
    }
    
    switch(arrowOrientation)
    {
      case ArrowOrientation.Top:
      {
        g.lineStyle(0.0, color);
        g.beginFill(color, 1.0);
        g.moveTo(0, 0);
        g.lineTo(width / 2, height);
        g.lineTo(width, 0);
        g.lineTo(0, 0);
        g.endFill();        
      }

      case ArrowOrientation.Down:
      {
        g.lineStyle(0.0, color);
        g.beginFill(color, 1.0);
        g.moveTo(0, height);
        g.lineTo(width / 2, 0);
        g.lineTo(width, height);
        g.lineTo(0, height);
        g.endFill();        
      }

      case ArrowOrientation.Left:
      {
        g.lineStyle(0.0, color);
        g.beginFill(color, 1.0);
        g.moveTo(0, height / 2);
        g.lineTo(width, height);
        g.lineTo(width, 0);
        g.lineTo(0, height / 2);
        g.endFill();        
      }

      case ArrowOrientation.Right:
      {
        g.lineStyle(0.0, color);
        g.beginFill(color, 1.0);
        g.moveTo(0, 0);
        g.lineTo(0, height);
        g.lineTo(width, height / 2);
        g.lineTo(0, 0);
        g.endFill();        
      }
    }
  }
}