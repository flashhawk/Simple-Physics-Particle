package cn.flashhawk.spp.util
{
	/**
	 * @author flashhawk
	 */
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.system.System;
	
	public class FPS extends Sprite
	{
			
		private var time:Timer;
		private var frames:int;
		private var FpsText:TextField;
		private var frameTime:Number;
		private var tempTime:Number;
		private var fps:Number;
		private var bar:Sprite;
		private var M:Number;
		public function FPS()
		{
			init();
		}
		private function init():void
		{
			initVar();
			initLsn();
		}
		private function initVar():void
		{
			M = 1024 * 1024;
			FpsText = new TextField();
			FpsText.width = 100;
			FpsText.autoSize = "left";
			FpsText.defaultTextFormat = new TextFormat("_sans", 12, 0xffffff);
			time = new Timer(1000);
			frames = 0;
			frameTime = 0;
			tempTime = 0;
			fps = 0;
			bar = new Sprite();
			bar.graphics.beginFill(0x990000, 0.8);
			bar.graphics.drawRect(0, 0, 100, 18);
			addChild(bar);
			addChild(FpsText);
		}
		private function initLsn():void
		{
			addEventListener(Event.ADDED_TO_STAGE, initTimer);
			addEventListener(Event.REMOVED_FROM_STAGE, stopTimer);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			time.addEventListener(TimerEvent.TIMER,displayFPS);
		}
		private function initTimer(e:Event):void
		{
			tempTime = 0;
			time.start();
		}
		private function stopTimer(e:Event):void
		{
			time.stop();
		}
		private function onEnterFrame(e:Event):void
		{
			frames++;
			frameTime = getTimer() - tempTime;
			tempTime = getTimer();
			var totalMemory:Number = Math.round((System.totalMemory / M) * 100)/100 ;
			FpsText.text = fps + "FPS / " + frameTime + "MS  / " + totalMemory + "M used";
			bar.scaleX = bar.scaleX - (bar.scaleX - frameTime * 0.1) * 0.05;
			
		}
	
		private function displayFPS(e:TimerEvent):void
		{
			fps = frames;
			frames = 0;
		}
	}
}